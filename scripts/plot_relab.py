#!/usr/bin/python3
import pandas as pd
from matplotlib import pyplot as plt
import seaborn as sns
import sys

# Args input
input_file = sys.argv[1]
output_file = sys.argv[2]

# Data input
data = pd.read_csv(input_file, sep="\t")

# Plot 
sns.set(style='white')

plot = sns.histplot(data, x='sample_id', hue='species_name', weights='Relative Abundance', multiple='stack')
plot.set_ylabel("Relative abundance")
plot.set_xlabel("Sample ID")
legend = plot.get_legend()
legend.set_title("Species name")
legend.set_bbox_to_anchor((1, 1))
plt.tight_layout()
plt.savefig(output_file)