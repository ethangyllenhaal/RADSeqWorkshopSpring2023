#!/bin/bash

#SBATCH --ntasks=8
#SBATCH --time=10:00:00
#SBATCH --job-name=radtags
#SBATCH --output=radtags_out_%j
#SBATCH --error=radtags_error_%j
#SBATCH --partition=normal
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=egyllenhaal@unm.edu

cd $SLURM_SUBMIT_DIR

# need to load miniconda3, parallel, and environment
# environment created like: conda create -n stacks-env -c conda-forge -c bioconda stacks

module load miniconda3
module load parallel
source activate stacks-env

# Process radtags for paired end data that only has one barcode
# Assumes all partially demultiplexed reads are subdirectories in a month-specific directory
## Here raw_data/*2020_Raw
# Also assumes a barcode directory named by month and i# or letter
## (for Jan and Nov respectively)
## e.g. jan_i8, nov_A
# importantly has a step trimming reads to a consistent length, which stacks needs
## --len-limit discards reads below 138 bp; -t truncates reads to 138 bp

# runs process_radtags in parallel with parallel input of i# or letter corresponding to read names

parallel -j 8 \
'process_radtags -P -p raw_data/Jan2020_Raw/*-{}_* \
    -b barcodes/jan_{}.tsv \
    -o demultiplex_Jan2020 \
    -i gzfastq \
    --len-limit 138 -t 138 \
    --renz-1 sbfI --renz-2 mspI \
    -c -q -r -E phred33' \
    ::: i1 i3 i4 i5 i6 i7 i8 i12

parallel -j 8 \
'process_radtags -P -p raw_data/Nov2020_Raw/*LNB-{}_* \
    -b barcodes/nov_{}.tsv \
    -o demultiplex_Nov2020 \
    -i gzfastq \
    --len-limit 138 -t 138 \
    --renz-1 sbfI --renz-2 mspI \
    -c -q -r -E phred33' \
    ::: A B C D E F G H
