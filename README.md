## Riddikulus
Helpful bioinformatics scripts


### blastn_to_fasta.sh

Script to perform blastn, using only one gene as input and several genomes and then parse blast alignments into multifasta

 Usage example: 

```
./blastn_to_fasta.sh -gene gene.fasta -genomes_file genome_list.txt -threads 1 -min_qc 60 -min_ident 70
```

 Options: 

```
./blastn_to_fasta.sh
 -gene gene.fasta                - query fasta file with single sequence
 -genomes_file genome_list.txt   - list of path to genomes' files in fasta format. One path per line.  
 -threads 1                      - integer number of threads to use
 -min_qc 60                      - minimum query coverage per high-scoring segment pair (float value)
 -min_ident 70                   - minimum percent of identity of BLAST hits (float value)
```
Output: 

```
*_tab - tab-formatted BLASTn output
*.bed - bed-files with alignment' coordinates
*.fasta - fasta with sequences, extracted according to coordinates 
*_blastn.fasta - resulting multifasta with all hits in all genomes
```

Tested with:
```
BLAST 2.9.0
bedtools v2.27.1
samtools v1.7
```
