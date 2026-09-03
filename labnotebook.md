
# Project2_Part1

clone the forked repo onto talapas: 
```bash
git clone https://github.com/hanana2000/Project-2-Electric-organ-RNA-seq-analysis.git
```

to create the pixi environment: 
```bash
pixi init Project2_QAA
cd Project2_QAA
pixi add fastqc cutadapt trimmomatic
pixi add sra-tools
```

see which accessions have been assigned: 
```bash 
cat /projects/bgmp/shared/Bi623/Project2/Project2_part1_3_data_assignments.txt
```
```
SRR25630305 SRR25630397
```

to get the SRR data: 
```bash
pixi run prefetch SRR25630305
pixi run prefetch SRR25630397
pixi run fasterq-dump SRR25630305
pixi run fasterq-dump SRR25630397
```

to run fastqc: 
```bash
pixi run fastqc *.fastq -o /projects/bgmp/hankap/bioinfo/Bi623/
```

# Project2_Part2

checking cutadapt and trimmomatic versions: 
```bash 
[hankap@login3 Project2_QAA]$ pixi run cutadapt --version
 WARN cache for Repodata at /home/hankap/.cache/rattler/cache/repodata is on a network/parallel filesystem (NFS/SMB/FUSE/BeeGFS/Lustre/GPFS/CephFS), redirected to /tmp/pixi-cache-hankap/repodata for this run. Set [cache.repodata] in config.toml or PIXI_CACHE_DIR to override, or [cache.netfs-redirect] = "never" to keep the original path.
5.2
[hankap@login3 Project2_QAA]$ pixi run trimmomatic -version
 WARN cache for Repodata at /home/hankap/.cache/rattler/cache/repodata is on a network/parallel filesystem (NFS/SMB/FUSE/BeeGFS/Lustre/GPFS/CephFS), redirected to /tmp/pixi-cache-hankap/repodata for this run. Set [cache.repodata] in config.toml or PIXI_CACHE_DIR to override, or [cache.netfs-redirect] = "never" to keep the original path.
0.41
```

checking that the R1 adapters are in the 1 files and the R2 adapters are in the 2 files: 
```bash 
grep "AGATCGGAAGAGCACACGTCTGAACTCCAGTCA" ../SRR25630305_1.fastq | head
grep "AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT" ../SRR25630305_2.fastq | head 
grep "AGATCGGAAGAGCACACGTCTGAACTCCAGTCA" ../SRR25630397_1.fastq | head
grep "AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT" ../SRR25630397_2.fastq | head 

```

running cutadapt: 
```bash
# R1 files: 
pixi run cutadapt -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA -o SRR25630305_1_cut.fastq ../SRR25630305_1.fastq
pixi run cutadapt -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA -o SRR25630397_1_cut.fastq ../SRR25630397_1.fastq

# R2 files: 
pixi run cutadapt -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA -o SRR25630305_2_cut.fastq ../SRR25630305_2.fastq
pixi run cutadapt -a AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT -o SRR25630397_2_cut.fastq ../SRR25630397_2.fastq

```

running trimmomatic: 
```bash 
pixi run trimmomatic PE ../Project2_QAA/SRR25630305_1_cut.fastq ../Project2_QAA/SRR25630305_2_cut.fastq cut_trimmed/SRR25630305_cut_fpair.fq.gz cut_trimmed/SRR25630305_1_cut_funpair.fq.gz cut_trimmed/SRR25630305_cut_rpair.fq.gz cut_trimmed/SRR25630305_cut_runpair.fq.gz ILLUMINACLIP:TruSeq3-PE.fa:2:30:10:2:True LEADING:3 TRAILING:3 SLIDINGWINDOW:5:15 MINLEN:35

pixi run trimmomatic PE ../Project2_QAA/SRR25630397_1_cut.fastq ../Project2_QAA/SRR25630397_2_cut.fastq cut_trimmed/SRR25630397_cut_fpair.fq.gz cut_trimmed/SRR25630397_1_cut_funpair.fq.gz cut_trimmed/SRR25630397_cut_rpair.fq.gz cut_trimmed/SRR25630397_cut_runpair.fq.gz ILLUMINACLIP:TruSeq3-PE.fa:2:30:10:2:True LEADING:3 TRAILING:3 SLIDINGWINDOW:5:15 MINLEN:35

```

get the distribution of lengths: 
```bash
zcat cut_trimmed/SRR25630305_cut_fpair.fq.gz | sed -n '2~4p' | awk '{print length($0)}'| sort -n | uniq -c | sort -n > len_dists/dist_SRR25630305_cut_fpair.txt
zcat cut_trimmed/SRR25630305_cut_rpair.fq.gz | sed -n '2~4p' | awk '{print length($0)}'| sort -n | uniq -c | sort -n > len_dists/dist_SRR25630305_cut_rpair.txt

zcat cut_trimmed/SRR25630397_cut_fpair.fq.gz | sed -n '2~4p' | awk '{print length($0)}'| sort -n | uniq -c | sort -n > len_dists/dist_SRR25630397_cut_fpair.txt
zcat cut_trimmed/SRR25630397_cut_rpair.fq.gz | sed -n '2~4p' | awk '{print length($0)}'| sort -n | uniq -c | sort -n > len_dists/dist_SRR25630397_cut_rpair.txt

```

# Project2_Part3

```bash 
cd Project2_QAA/
pixi add Star
pixi add Samtools
pixi add NumPy
pixi add Matplotlib
pixi add HTSeq
```


# Project2_Part3

from PS8 Bi621, copy pasted STAR bash script. 

downloaded gff and fasta files from [Dryad](https://datadryad.org/dataset/doi:10.5061/dryad.c59zw3rcj), and then used scp to copy the zip file to talapas: 
```bash 
scp .\doi_10_5061_dryad_c59zw3rcj__v20230125.zip hankap@login2.talapas.uoregon.edu:/projects/bgmp/hankap/bioinfo/Bi623/Project-2-Electric-organ-RNA-seq-analysis/Project2_Part3
```

then on talapas, unzipped the file: 
```bash 
unzip doi_10_5061_dryad_c59zw3rcj__v20230125.zip
```

need to convert gff to gtf: 
```bash 
[hankap@login3 Project2_Part3]$ cd ../Project2_QAA/
[hankap@login3 Project2_QAA]$ pixi add agat 

[hankap@login3 Project2_Part3] pixi run agat_convert_sp_gff2gtf.pl --gff ../Project2_Part3/campylomormyrus.gff -o ../Project2_Part3/campylomormyrus.gtf
```

output to terminal: 
```bash 
[hankap@n0097 Project2_QAA]$ pixi run agat_convert_sp_gff2gtf.pl --gff ../Project2_Part3/campylomormyrus.gff -o ../Project2_Part3/campylomormyrus.gtf
 WARN cache for Repodata at /home/hankap/.cache/rattler/cache/repodata is on a network/parallel filesystem (NFS/SMB/FUSE/BeeGFS/Lustre/GPFS/CephFS), redirected to /tmp/pixi-cache-hankap/repodata for this run. Set [cache.repodata] in config.toml or PIXI_CACHE_DIR to override, or [cache.netfs-redirect] = "never" to keep the original path.

 ------------------------------------------------------------------------------
|   Another GFF Analysis Toolkit (AGAT) - Version: v1.7.0                      |
|   https://github.com/NBISweden/AGAT                                          |
|   National Bioinformatics Infrastructure Sweden (NBIS) - www.nbis.se         |
 ------------------------------------------------------------------------------
Using standard /gpfs/projects/bgmp/hankap/bioinfo/Bi623/Project-2-Electric-organ-RNA-seq-analysis/Project2_QAA/.pixi/envs/default/lib/perl5/site_perl/auto/share/dist/AGAT/feature_levels.yaml file
GTF version relax selected from the agat config file.
File ../Project2_Part3/campylomormyrus.gtf already exist.
[hankap@n0097 Project2_QAA]$ pixi run agat_convert_sp_gff2gtf.pl --gff ../Project2_Part3/campylomormyrus.gff -o ../Project2_Part3/campylomormyrus.gtf
 WARN cache for Repodata at /home/hankap/.cache/rattler/cache/repodata is on a network/parallel filesystem (NFS/SMB/FUSE/BeeGFS/Lustre/GPFS/CephFS), redirected to /tmp/pixi-cache-hankap/repodata for this run. Set [cache.repodata] in config.toml or PIXI_CACHE_DIR to override, or [cache.netfs-redirect] = "never" to keep the original path.

 ------------------------------------------------------------------------------
|   Another GFF Analysis Toolkit (AGAT) - Version: v1.7.0                      |
|   https://github.com/NBISweden/AGAT                                          |
|   National Bioinformatics Infrastructure Sweden (NBIS) - www.nbis.se         |
 ------------------------------------------------------------------------------
Using standard /gpfs/projects/bgmp/hankap/bioinfo/Bi623/Project-2-Electric-organ-RNA-seq-analysis/Project2_QAA/.pixi/envs/default/lib/perl5/site_perl/auto/share/dist/AGAT/feature_levels.yaml file
GTF version relax selected from the agat config file.
=> Output format will be GTFrelax.
                                        
                                       
                          ------ Start parsing ------                           
-------------------------- parse options and metadata --------------------------
Accessing the feature_levels YAML file
=> Attribute used to group features when no Parent/ID relationship exists (i.e common tag):
        * locus_tag
        * gene_id
=> merge_loci option activated
=> FASTA within the file will be thrown away!
=> Machine information:
        This script is being run by perl v5.32.1
        Bioperl location being used: /gpfs/projects/bgmp/hankap/bioinfo/Bi623/Project-2-Electric-organ-RNA-seq-analysis/Project2_QAA/.pixi/envs/default/lib/perl5/site_perl/Bio/
        Operating system being used: linux 
=> Accessing Ontology
        No ontology accessible from the gff file header!
        We use the SOFA ontology distributed with AGAT:
                /gpfs/projects/bgmp/hankap/bioinfo/Bi623/Project-2-Electric-organ-RNA-seq-analysis/Project2_QAA/.pixi/envs/default/lib/perl5/site_perl/auto/share/dist/AGAT/so.obo
        Read ontology /gpfs/projects/bgmp/hankap/bioinfo/Bi623/Project-2-Electric-organ-RNA-seq-analysis/Project2_QAA/.pixi/envs/default/lib/perl5/site_perl/auto/share/dist/AGAT/so.obo:
                4 root terms, and 2596 total terms, and 1516 leaf terms
        Filtering ontology:
                We found 1861 terms that are sequence_feature or is_a child of it.
--------------------- collecting general data information ----------------------
Parsing file ../Project2_Part3/campylomormyrus.gff
=> Number of line in file: 8054450
=> Number of comment lines: 16433
=> Number of empty lines: 0
=> Fasta included: No
=> Number of features lines: 8038017
=> Number of feature lines with 1 fields (while 9 expected): 16433
=> Number of feature type (3rd column): 11
        * Level1: 5 => contig expressed_sequence_match gene match protein_match
        * level2: 2 => mRNA match_part
        * level3: 4 => CDS exon five_prime_UTR three_prime_UTR
        * unknown: 0 => 
=> Version of the GFF parser selected by AGAT: 3

-------- Start of in-depth analysis (file by chunck 1 CPU - 73 chuncks) --------
Parsing: 100% [======================================================]D 0h10m44s
Parsing (done in 644 seconds )
---------------------------- Merging parallel tasks ----------------------------
Merging: 100% [======================================================]D 0h01m21s
Merging (done in 81 seconds )
................................................................................
.                           Total time: 740 seconds                            .
.                          Total memory: 22166.04 Mo                           .
................................................................................
                            ------ END parsing ------                           
converting to GTFrelax
Formating output to GTFrelax

--------------------------- Job done in 1092 seconds ---------------------------
command : /gpfs/projects/bgmp/hankap/bioinfo/Bi623/Project-2-Electric-organ-RNA-seq-analysis/Project2_QAA/.pixi/envs/default/bin/agat_convert_sp_gff2gtf.pl --gff ../Project2_Part3/campylomormyrus.gff -o ../Project2_Part3/campylomormyrus.gtf
date : 09/02/2026 at 16h40m27s
Job done! Bye Bye!

```

run the STAR_align.sh script twice, once with the genome generate command uncommented out, then with the alignment commands uncommented:

[STAR_align.sh](Project2_QAA/STAR_align.sh)

```bash
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

```

```bash 
[hankap@login3 Project2_QAA]$ chmod 755 STAR_align.sh 
[hankap@login3 Project2_QAA]$ sbatch STAR_align.sh 
```

slurm output for genome db generation: 
```bash 
Command being timed: "pixi run STAR --runThreadN 8 --runMode genomeGenerate --genomeDir /projects/bgmp/hankap/bioinfo/Bi623/Project-2-Electric-organ-RNA-seq-analysis/Project2_Part3/campyDB.STAR.2.7.11b --genomeFastaFiles /projects/bgmp/hankap/bioinfo/Bi623/Project-2-Electric-organ-RNA-seq-analysis/Project2_Part3/campylomormyrus.fasta --sjdbGTFfile /projects/bgmp/hankap/bioinfo/Bi623/Project-2-Electric-organ-RNA-seq-analysis/Project2_Part3/campylomormyrus.gtf"
	User time (seconds): 1225.23
	System time (seconds): 7.08
	Percent of CPU this job got: 358%
	Elapsed (wall clock) time (h:mm:ss or m:ss): 5:44.03
	Maximum resident set size (kbytes): 23057984

```
the genome generation took about 6 minutes and used 23MB memory



