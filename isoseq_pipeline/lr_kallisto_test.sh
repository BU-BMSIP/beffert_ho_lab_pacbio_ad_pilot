#!/bin/bash
#$ -P ubah
#$ -N lr_kallisto_test
#$ -pe omp 16
#$ -o lr_kallisto_test.out
#$ -e lr_kallisto_test.err

# high level
kb ref -k 63 -t 16 --verbose -d human -i human_k-63.idx -g human.t2g
kb count --verbose -i human_k-63.idx -g human.t2g -o . -t 16 -k 63 --tcc --long --threshold 0.8 --platform PacBio -x bulk --parity single --matrix-to-directories ../fastq/bc01.fastq.gz


# low level
kb ref -k 63 -t 16 --verbose -d human -i human_k-63.idx -g human.t2g
kallisto bus -t 16 --long --threshold 0.8 -x bulk -i human_k-63.idx -o . ../fastq/bc01.fastq.gz
bustools sort -t 16 output.bus -o sorted.bus
bustools count sorted.bus -t transcripts.txt -e matrix.ec -o count --cm -m -g human.t2g
kallisto quant-tcc -t 16 --long -P PacBio -f flens.txt count.mtx -i human_k-63.idx -e count.ec.txt --matrix-to-directories -G ../../refs/gencode.v48.annotation.gtf -o .