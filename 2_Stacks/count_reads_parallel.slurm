#!/bin/bash

#SBATCH --ntasks=2
#SBATCH --cpus-per-task=8
#SBATCH --time=1:00:00
#SBATCH --job-name=parallel_count
#SBATCH --output=stacks_count_out_%j
#SBATCH --error=stacks_count_error_%j
#SBATCH --partition=debug
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=egyllenhaal@unm.edu

cd $SLURM_SUBMIT_DIR
module load parallel
source $(which env_parallel.bash)
scontrol show hostname > ./node_list_${SLURM_JOB_ID}
export LANG=C

> read_count.out

cat sample_list_final | env_parallel -j 8 --sshloginfile ./node_list_${SLURM_JOB_ID} \
    'paste <(echo {}) <(echo $(zcat ./raw_reads/{}.fq.gz|wc -l)/4|bc) >> ./read_count.out'
