
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