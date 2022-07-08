#!/usr/bin/python3
import pandas as pd
import sys, ast

# Args input
names = ast.literal_eval(sys.argv[1])
sample_name = sys.argv[2]
input_file = sys.argv[3]
output_file = sys.argv[4]

# Data input 
data = pd.read_csv(input_file, sep="\t", header=None)
data.columns=['sequence', 'seq_length', 'mapped_reads', 'unmapped_reads']

# Open output file
file = open(output_file, "w")

# Variables
total_reads_aligned=data['mapped_reads'].sum()
sample = sample_name

# Creation of table
def table_creator():
    for genome, species in names.items():
        species_df = data[data['sequence'].str.contains(species)]
        sum=species_df['mapped_reads'].sum()
        result="{}\t{}\t{}\t{}\n".format(genome, str(sum/total_reads_aligned), sample, species)
        file.writelines(result)

    # Close open file
    file.close()

if __name__ == "__main__":
    table_creator()