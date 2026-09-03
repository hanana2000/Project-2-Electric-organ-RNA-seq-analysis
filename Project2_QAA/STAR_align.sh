#!/bin/bash
#SBATCH --account=bgmp                    # REQUIRED: which account to use
#SBATCH --partition=bgmp                  # REQUIRED: which partition to use
#SBATCH --cpus-per-task=8                 # optional: number of cpus, default is 1
#SBATCH --job-name=spades_k77             # optional: job name
#SBATCH --time=1:00:00                    # optional: time before timesout 

# scancel <jobid>
# sbatch 
# squeue -u hankap
# history | tail -10
# sbatch starbash.sh

# nano ~/.bashrc
# source ~/.bashrc
# add 'alias <desired command alias>='squeue (or whatever command it is) <flags and options>'

genomedir=/projects/bgmp/hankap/bioinfo/Bi623/Project-2-Electric-organ-RNA-seq-analysis/Project2_QAA/campyDB.STAR.2.7.11b
gtffile=/projects/bgmp/hankap/bioinfo/Bi623/Project-2-Electric-organ-RNA-seq-analysis/Project2_Part3/campylomormyrus.gtf
fafile=/projects/bgmp/hankap/bioinfo/Bi623/Project-2-Electric-organ-RNA-seq-analysis/Project2_Part3/campylomormyrus.fasta

file1=/projects/bgmp/hankap/bioinfo/Bi623/Project-2-Electric-organ-RNA-seq-analysis/Project2_Part2/SRR25630305_cut_fpair.fq.gz
file2=/projects/bgmp/hankap/bioinfo/Bi623/Project-2-Electric-organ-RNA-seq-analysis/Project2_Part2/SRR25630305_cut_rpair.fq.gz

file3=/projects/bgmp/hankap/bioinfo/Bi623/Project-2-Electric-organ-RNA-seq-analysis/Project2_Part2/SRR25630397_cut_fpair.fq.gz
file4=/projects/bgmp/hankap/bioinfo/Bi623/Project-2-Electric-organ-RNA-seq-analysis/Project2_Part2/SRR25630397_cut_rpair.fq.gz


# /usr/bin/time -v pixi run STAR \
#  --runThreadN 8 \
#  --runMode genomeGenerate \
#  --genomeDir $genomedir \
#  --genomeFastaFiles $fafile \
#  --sjdbGTFfile $gtffile

/usr/bin/time -v pixi run STAR \
 --runThreadN 8 \
 --runMode alignReads \
 --outFilterMultimapNmax 3 \
 --outSAMunmapped Within KeepPairs \
 --alignIntronMax 1000000 --alignMatesGapMax 1000000 \
 --readFilesCommand zcat \
 --readFilesIn $file1 $file2 \
 --genomeDir $genomedir \
 --outFileNamePrefix yayay_

 /usr/bin/time -v pixi run STAR \
 --runThreadN 8 \
 --runMode alignReads \
 --outFilterMultimapNmax 3 \
 --outSAMunmapped Within KeepPairs \
 --alignIntronMax 1000000 --alignMatesGapMax 1000000 \
 --readFilesCommand zcat \
 --readFilesIn $file3 $file4 \
 --genomeDir $genomedir \
 --outFileNamePrefix yayay_