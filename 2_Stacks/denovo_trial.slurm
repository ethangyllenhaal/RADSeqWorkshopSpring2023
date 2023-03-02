#!/bin/bash

#SBATCH --ntasks=8
#SBATCH --time=10:00:00
#SBATCH --job-name=denovo
#SBATCH --output=stacks_denovo_out_%j
#SBATCH --error=stacks_denovo_error_%j
#SBATCH --partition=general
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=egyllenhaal@unm.edu

module load miniconda3
source activate test-stacks

src=$SLURM_SUBMIT_DIR
denovo_map.pl -T 8 -o $src/stacks_trial/ \
	     -m 10 -M 5 -n 5 \
             --popmap $src/popmap_trial \
             --samples $src/demultiplex_trial1/


# full popmap vcf
populations -P $src/stacks_trial -M $src/popmap_trial -O $src/pop_trial --vcf -R .75 --write-random-snp -t 8
mv $src/pop_trial/populations.snps.vcf $src/pop_trial/outputs/trial_denovo_75.vcf

