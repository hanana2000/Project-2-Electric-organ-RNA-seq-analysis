#!/bin/bash
#SBATCH --account=bgmp                    # REQUIRED: which account to use
#SBATCH --partition=bgmp                  # REQUIRED: which partition to use
#SBATCH --cpus-per-task=8                 # optional: number of cpus, default is 1
#SBATCH --job-name=htseq             # optional: job name
#SBATCH --time=1:00:00                    # optional: time before timesout 


features_file=/projects/bgmp/hankap/bioinfo/Bi623/Project-2-Electric-organ-RNA-seq-analysis/Project2_Part3/campylomormyrus.gff
sam1=/projects/bgmp/hankap/bioinfo/Bi623/Project-2-Electric-organ-RNA-seq-analysis/Project2_QAA/SRR25630305Aligned.out.sam
sam2=/projects/bgmp/hankap/bioinfo/Bi623/Project-2-Electric-organ-RNA-seq-analysis/Project2_QAA/SRR25630397Aligned.out.sam

/usr/bin/time -v pixi run htseq-count --stranded=yes -i Parent $sam1 $features_file > SRR25630305_str.txt
/usr/bin/time -v pixi run htseq-count --stranded=reverse -i Parent $sam1 $features_file > SRR25630305_rev.txt

/usr/bin/time -v pixi run htseq-count --stranded=yes -i Parent $sam2 $features_file > SRR25630397_str.txt
/usr/bin/time -v pixi run htseq-count --stranded=reverse -i Parent $sam2 $features_file > SRR25630397_rev.txt

