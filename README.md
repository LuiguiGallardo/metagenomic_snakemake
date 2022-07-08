# Tiny Health Interview Task

This task is designed to test your skills for developing a workflow to assess microbial metagenomic data.

In the provided directory, you will find paired Illumina reads for two different samples: `PWG269` & `ZQV658` - `*_1.fastq.gz` denote the forward reads and `*_2.fastq.gz` denote the reverse reads.

The task:

* Map the sample reads onto the three genomes provided in the subdirectory `genomes/`

* Provide an estimated relative abundance of the genomes in the two samples

  * Relative abundance = no. of reads mapping to a genome / total reads in metagenome

* Provide a output TSV file called `consolidated_data.tsv` that combines the results for both samples with the following header format:

  ```
  Genome  Relative Abundance      sample_id       species_name
  ```

  * where 'Genome' matches the values in the list `genomes` or the keys of the dictionary `names` as decribed in `mapping-workflow.smk`
  * 'sample_id' consists of either `PWG269` & `ZQV658`
  * 'species_name' consists of the values in the dictionary `names` as decribed in `mapping-workflow.smk`

* You are free to use whichever tools you feel most comfortable with and as many tools as you feel are required

  * There is a correct answer, but we assume that values may differ by method, so variations +/- 5% will be accepted

We estimate that this task itself should be direct and straightforward and take approximately less than 1hr to code using a `bash` or `Python` wrapper script. 

#### **However, we would like you create a `Snakemake` workflow that performs this task.** 

We have provided a starting point `mapping-workflow.smk`, but as Snakemake is new to you, we estimate that this task may take ~5 hours, but should not exceed 10 hours.

* We have provided a bare skeleton for a Snakemake workflow in: `mapping-workflow.smk`
  * We have also offered some "hints" as to how a solution for this workflow was made, that includes a standalone rule called `rules/mapping.smk` & a Python consolidation script called `scripts/combine-tsv.py`
  * You do not have to use these files specifically but can if you'd like
* If Snakemake is proving to beyond the scope of time required, we will accept a Python wrapper script that performs these same actions, as long as the output TSV is in the required format.

**Please be prepared to discuss how long this task took, your development strategy, and why you selected the tools and steps that you did**


## Results

To run the script:
```bash
snakemake --snakefile mapping-workflow.smk
```

This is the workflow created with Snakemake:
![workflow_diagram](workflow_diagram.svg)

Mapping results:

| **Genome**                  | **Relative Abundance** | **sample_id** | **species_name**       |
| --------------------------- | ---------------------- | ------------- | ---------------------- |
| **AEKH01.1_genomic**        | 0.001661396554378590   | PWG269        | Lactobacillus iners    |
| **CAAKNZ01.1_genomic**      | 0.6488379529293530     | PWG269        | Bifidobacterium breve  |
| **GCF_902381625.1_genomic** | 0.349500650516268      | PWG269        | Bifidobacterium longum |
| **AEKH01.1_genomic**        | 0.00240733861268147    | ZQV658        | Lactobacillus iners    |
| **CAAKNZ01.1_genomic**      | 0.24584830640326300    | ZQV658        | Bifidobacterium breve  |
| **GCF_902381625.1_genomic** | 0.7517443549840550     | ZQV658        | Bifidobacterium longum |

![plot_final_result](results/plot_final_result.svg)



