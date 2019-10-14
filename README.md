## Riddikulus
Helpful bioinformatics scripts


### blastn_to_fasta.sh
Script to perform blastn, using only one gene as input and several genomes and then parse blast alignments into multifasta

Usage example: 
./blastn_to_fasta.sh -gene gene.fasta -genomes_file genome_list.txt -threads 1 -min_qc 60 -min_ident 70

Tested with:
BLAST 2.9.0
bedtools v2.27.1
samtools v1.7
