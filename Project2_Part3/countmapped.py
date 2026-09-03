#!/usr/bin/env python


# srun --account=bgmp --partition=bgmp --cpus-per-task=8 --time=1:00:00 --pty bash  

# ./alignedreads.py 
# there were 24953202 total reads in the file (including repeats)
# 10928151 reads were mapped (not including repeats)
# 825523 reads were unmapped (not including repeats)

samfile1 = "/projects/bgmp/hankap/bioinfo/Bi623/Project-2-Electric-organ-RNA-seq-analysis/Project2_QAA/SRR25630305Aligned.out.sam"
samfile2 = "/projects/bgmp/hankap/bioinfo/Bi623/Project-2-Electric-organ-RNA-seq-analysis/Project2_QAA/SRR25630397Aligned.out.sam"
# need to get how many reads are mapped, while NOT counting repeats 
# use sets to not include duplicates 
mappedreads, unmapped = [],[]

with open(samfile1, 'r') as sam1, open(samfile2, 'r') as sam2:
    count=0
    for sam in [sam1, sam2]: 
        for line in sam:
            if line[0] == '@': continue # skip the header lines
            if((int(line.split('\t')[1]) & 256) == 256): continue # skip secondary alignments
            if((int(line.split('\t')[1]) & 4) != 4): # if the flag has the mapped bit turned off
                mappedreads.append(line.split('\t')[0]) # is is mapped 
            else: unmapped.append(line.split('\t')[0]) # otherwise it is not mapped 
            count+=1 # only increment the read lines
        print(f"for {sam.name.split('/')[-1]}")
        print(f"there were {count} total reads in the file (including repeats)")
        print(f"{len(mappedreads)} reads were mapped (not including repeats)")
        print(f"{len(unmapped)} reads were unmapped (not including repeats)")
        mappedreads, unmapped = [],[]
