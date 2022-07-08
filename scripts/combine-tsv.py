#!/usr/bin/python3
import pandas as pd
import sys, glob

# Args input
output_file = sys.argv[1]

# Data input
all_car_tsv_files = glob.glob("results/*.tsv", recursive=True)

# Creation of result dataframe and open output file

def merge_tables():
    result = pd.DataFrame()
    for tsvfile in all_car_tsv_files:
        data=pd.read_csv(tsvfile, sep = "\t", header=None)
        result = result.append(data, ignore_index=True)
        
    result.columns=['Genome', 'Relative Abundance', 'sample_id', 'species_name']
    result.to_csv(output_file, sep="\t", index=False)

if __name__ == "__main__":
    merge_tables()