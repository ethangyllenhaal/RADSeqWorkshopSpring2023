#!/bin/bash

#SBATCH --ntasks=2
#SBATCH --cpus-per-task=8
#SBATCH --time=2:00:00
#SBATCH --job-name=ref
#SBATCH --output=_stacks_ref_out_%j
#SBATCH --error=_stacks_ref_error_%j
#SBATCH --partition=debug
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=egyllenhaal@unm.edu

# activate conda
module load miniconda3
eval "$(conda shell.bash hook)"
conda activate stacks-env

# change to working dir, make shortcut for working dir path
ssd=$SLURM_SUBMIT_DIR
cd $SLURM_SUBMIT_DIR

# load and set up parallel
module load parallel
source $(which env_parallel.bash)
scontrol show hostname > ./node_list_${SLURM_JOB_ID}
export LANG=C

# path to the reference
refpath=$ssd/NewCalCrow_reference

# index reference
bwa index -p ${refpath} ${refpath}.fna

# running bwa in parallel
cat sample_list_trial | env_parallel -j 1 --sshloginfile ./node_list_${SLURM_JOB_ID} \
    'echo {}
     bwa mem -t 8 -M $refpath \
         $ssd/raw_reads/{}.fq.gz \
         | samtools view -b -F 4 \
         | samtools sort -o $ssd/bams/{}.bam'

# running stacks
gstacks -I $ssd/bams -M popmaps/popmap_trial -O stacks_out/trial/
