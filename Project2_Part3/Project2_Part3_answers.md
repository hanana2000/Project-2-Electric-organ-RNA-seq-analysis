## Part 3 Alignment and strand-specificity, DUE 9/3

Create a folder called Project2_Part3 on your git repo. **Upload all of your answers and bash code from this section to Project2_Part3/Project2_Part3_answers.txt.**

10. Install additional software for alignment and counting of RNA-seq reads. In your Project2_QAA environment, use PIXI to install:
    - Star
    - Samtools
    - NumPy
    - Matplotlib
    - HTSeq

[Record details on how you installed these packages and what version they are to your lab notebook]

all commands and script info is located at [Lab Notebook](../labnotebook.md)

11. Download the publicly available *Campylomormyrus compressirostris* genome fasta and gff file from [Dryad](https://datadryad.org/dataset/doi:10.5061/dryad.c59zw3rcj) and generate an alignment database from it. If the download fails, the files are available here: `/projects/bgmp/shared/Bi623/Project2/campylomormyrus.fasta`, `/projects/bgmp/shared/Bi623/Project2/campylomormyrus.gff`. Align the reads to your *C. compressirostris* database using a splice-aware aligner. Use the settings specified in PS8 from Bi621.

> [!IMPORTANT] You will need to use gene models to perform splice-aware alignment, see PS8 from Bi621 to remind yourself. You may need to convert the gff file into a gtf file for this to work successfully.

[STAR bash script](../Project2_QAA/STAR_align.sh)

13. Using your script from PS8 in Bi621, report the number of mapped and unmapped reads from each of your 2 SAM files. Make sure that your script is looking at the bitwise flag to determine if reads are primary or secondary mapping (update/fix your script if necessary).

```bash
[hankap@n0097 Project2_Part3]$ ./countmapped.py 
for SRR25630305Aligned.out.sam
there were 8317614 total reads in the file (including repeats)
7681825 reads were mapped (not including repeats)
635789 reads were unmapped (not including repeats)
for SRR25630397Aligned.out.sam
there were 19450210 total reads in the file (including repeats)
10627292 reads were mapped (not including repeats)
505304 reads were unmapped (not including repeats)
```

14. Count reads that map to features using `htseq-count`. You should run htseq-count twice: once with `--stranded=yes` and again with `--stranded=reverse`. Use default parameters otherwise. You may need to use the `-i` parameter for this run.

[htseq bash](../Project2_QAA/htseq.sh)


15. Demonstrate convincingly whether or not the data are from "strand-specific" RNA-Seq libraries **and** which `stranded=` parameter should you use for counting your reads for a future differential gene expression analyses. Include any commands/scripts used. Briefly describe your evidence, using quantitative statements (e.g. "I propose that these data are/are not strand-specific, because X% of the reads are y, as opposed to z."). This [kit](https://www.revvity.com/product/nex-rapid-dir-rna-seq-kit-2-0-8rxn-nova-5198-01) was used during library preparation. This [paper](https://academic.oup.com/bfg/article/19/5-6/339/5837822) may provide helpful information.

> [!TIP] Recall ICA4 from Bi621.

[Describe whether your reads are "strand-specific", why you think they are, any evidence, and which stranded parameter is appropriate and why]

to compare the outputs: 

```bash 
diff -y <(sort SRR25630305_str.txt) <(sort SRR25630305_rev.txt) > diff_SRR25630305_str_rev.txt
diff -y <(sort SRR25630397_str.txt) <(sort SRR25630397_rev.txt) > diff_SRR25630397_str_rev.txt
```
because it output a diff at all (a non 0 length diff file), that means that the stranded=yes and stranded=reverse runs gave different results. 

sum all the mapped reads (col2): 

```bash
awk '$1!~"__" {s+=$2} {sum+=$2} END {print s/sum}' SRR25630305_str.txt
0.0256097
awk '$1!~"__" {s+=$2} {sum+=$2} END {print s/sum}' SRR25630305_rev.txt
0.436462

awk '$1!~"__" {s+=$2} {sum+=$2} END {print s/sum}' SRR25630397_str.txt
0.0299547
awk '$1!~"__" {s+=$2} {sum+=$2} END {print s/sum}' SRR25630397_rev.txt
0.553113

```

for SRR25630305, the stranded run mapped 2.56% of reads, while the reverse run mapped 43.65% of reads. 
for SRR25630397, the stranded run mapped 2.10% of reads, while the reverse run mapped 55.31% of reads.

for both samples I would run the reverse stranded command, as there are significantly more reads mapped. 


16. BONUS - Turn your commands from this assignment into a script with a loop going through your two SRA files



