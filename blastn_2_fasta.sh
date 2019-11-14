#!/bin/bash

'''
Script to perform blast, using only one gene as input and several genomes and then parse blast alignments into multifasta

Usage example: ./blastn_to_fasta.sh -gene gene.fasta -genomes_file genome_list.txt -threads 1 -min_qc 60 -min_ident 70

NB: current release have a _bug_ with "min_qc" argument. For convinience, it is set to 0.  
'''

while [ -n "$1" ]; do # while loop starts

    case "$1" in
 
    -gene) 
	GENE="$2"
	echo "Input gene is $GENE" 
	shift ;;
 
    -genomes_file)
        GENOMES="$2"
         echo "File with paths to genomes is $GENOMES"
         shift
        ;;
 
    -threads)
	threads="$2"	
	echo "Will use $threads threads" 
	shift
	;;

   -min_qc)
	min_qc="$2"	
	echo "Minimum query coverage per High-scoring Segment Pair is $min_qc%" 
	shift
	;;

   -min_ident)
	min_ident="$2"	
	echo "Minimum identity is $min_ident%" 
	shift
	;; 
 
    --)
        shift # The double dash makes them parameters
 
        break
        ;;
 
    *) echo "Option $1 not recognized" ;;
 
    esac
 
    shift
 

done
echo ".............Preparing database"
makeblastdb -dbtype nucl -in $GENE
echo ".............Database is ready.."
while read INPUT;  do echo "... Running blast on ${INPUT%".fasta"}";
	for file in $INPUT;
	do fname="${file##*/}"
        awk '/>/{sub(">","&"FILENAME"_strain_");sub(/\.fasta/,x)}1' "$file" > temp; done
	echo "renamed headers" 
	blastn -db $GENE -qcov_hsp_perc 0 -perc_identity $min_ident -query temp -outfmt 6 -num_threads $threads > "${GENE%".fasta"}"_"${INPUT%".fasta"}"_blast_tab;
	awk '{print $1"\t"$7-1"\t"$8"\t"$2}' "${GENE%".fasta"}"_"${INPUT%".fasta"}"_blast_tab > "${GENE%".fasta"}"_"${INPUT%".fasta"}".bed;
	samtools faidx temp;
	bedtools getfasta -s -fi temp -bed "${GENE%".fasta"}"_"${INPUT%".fasta"}".bed -fo "${GENE%".fasta"}"_"${INPUT%".fasta"}".fasta
	rm temp; done  < $GENOMES
	cat "${GENE%".fasta"}"_*.fasta > ${GENE%".fasta"}_blastn.fasta

echo ".............Removing temp files"
rm *.fai
rm *_tab
rm *.nhr
rm *.nin
rm *.nsq
rm *.bed
echo "Done"
echo "Results in ${GENE%".fasta"}_blastn.fasta
