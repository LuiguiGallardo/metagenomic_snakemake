SAMPLE = ['PWG269', 'ZQV658']
genome_dir = "genomes/"
genomes = ['AEKH01.1', 'CAAKNZ01.1', 'GCF_902381625.1']
names = {"AEKH01.1_genomic": 'Lactobacillus iners', 'CAAKNZ01.1_genomic': 'Bifidobacterium breve', 'GCF_902381625.1_genomic': 'Bifidobacterium longum'}

run_complete = "run.done"

include: "rules/mapping.smk"

rule all:
    input:
        "fastqc/",
        "results/plot_final_result.svg"

# Quality check with fastqc
rule fastqc:
    conda:
        "enviroment.yml"
    input:
        samples_r1 = expand("{sample}_1.fastq.gz", sample = SAMPLE),
        samples_r2 = expand("{sample}_2.fastq.gz", sample = SAMPLE)
    output:
        "fastqc/"
    threads:
        8
    shell:
        "mkdir {output} ; fastqc {input} -t {threads} -o {output}"

# Quality control with trim_galore
rule trim_galore:
    conda:
        "enviroment.yml"
    input:
        "{sample}_1.fastq.gz",
        "{sample}_2.fastq.gz"
    output:
        "trim_galore/{sample}_1_val_1.fq.gz",
        "trim_galore/{sample}_2_val_2.fq.gz"
    threads:
        8
    params:
        "--no_report_file",
        "--suppress_warn",
        "-q 20",
        "--paired",
        "-o trim_galore",
        "--fastqc",
        "--fastqc_args \"--outdir fastqc\""
    shell:
        "trim_galore -j {threads} {params} {input}"

# Creation of bwa index with metagenome
rule bwa_index:
    conda:
        "enviroment.yml"
    input:
        genomes_fna = expand("{genome_dir}{genomes}_genomic.fna", genome_dir=genome_dir, genomes=genomes)
    output:
        genome_dir + "metagenomic_index_bwa.fna"
    shell:
        "cat {input} | sed 's/ /_/g' > {output}; bwa index {output}"

# BWA MEM mapping per sample
rule bwa_map:
    conda:
        "enviroment.yml"
    input:
        genome_dir + "metagenomic_index_bwa.fna",
        "trim_galore/{sample}_1_val_1.fq.gz",
        "trim_galore/{sample}_2_val_2.fq.gz"
    output:
        "bwa_map/{sample}.bam"
    threads:
        8
    shell:
        "bwa mem -t {threads} {input} | samtools view -S -b > {output}"

# Filter only map files
rule samtools_mapped:
    conda:
        "enviroment.yml"
    input:
        "bwa_map/{sample}.bam"
    output:
        "bwa_map/{sample}_mapped.bam"
    threads:
        8
    shell:
        "samtools view -b -F 4 -@ {threads} {input} > {output}"

# Sort bam file
rule samtools_sort:
    conda:
        "enviroment.yml"
    input:
        "bwa_map/{sample}_mapped.bam"
    output:
        "bwa_map/{sample}_sorted.bam"
    threads:
        8
    shell:
        "samtools sort -@ {threads} {input} -o {output}"

# Stats from sorted bam
rule samtools_idxstats:
    conda:
        "enviroment.yml"
    input:
        "bwa_map/{sample}_sorted.bam"
    output:
        "bwa_map/{sample}_sorted_idxstats.txt"
    threads:
        8
    shell:
        "samtools idxstats -@ {threads} {input} | sed 's/_/ /g' > {output}"

# Create table with relative abundance per sample
rule readcount_sample:
    conda:
        "enviroment.yml"
    input:
        "bwa_map/{sample}_sorted_idxstats.txt"
    output:
        "results/{sample}_readcount.tsv"
    params:
        "{sample}"
    shell:
        "python scripts/create_tsv.py \"{names}\" {params} {input} {output}"

# Combine tables
rule merge_results:
    conda:
        "enviroment.yml"
    input:
        results = expand("results/{sample}_readcount.tsv", sample = SAMPLE)
    output:
        "consolidated_data.tsv"
    shell:
        "python scripts/combine-tsv.py {output}"

# Plot final results with relative abundance per sample
rule plot_results:
    conda:
        "enviroment.yml"
    input:
        "consolidated_data.tsv"
    output:
        "results/plot_final_result.svg"
    shell:
        "python scripts/plot_relab.py {input} {output}"
