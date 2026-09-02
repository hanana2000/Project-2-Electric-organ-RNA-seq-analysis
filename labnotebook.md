
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


