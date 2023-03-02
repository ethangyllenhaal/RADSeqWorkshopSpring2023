#!/bin/bash

#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=1:00:00
#SBATCH --job-name=count
#SBATCH --output=stacks_count_out_%j
#SBATCH --error=stacks_count_error_%j
#SBATCH --partition=debug
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=egyllenhaal@unm.edu

cd $SLURM_SUBMIT_DIR

> read_count.out

while read sample; do 
    echo ${sample}XXX >> read_count.out
    echo $(zcat raw_reads/$sample.fq.gz|wc -l)/4|bc >> read_count.out
done < sample_list_final

sed -zie 's/XXX\n/\t/g' read_count.out
