#!/bin/bash
#$ -P bioinfo-ms                   
#$ -N lr_kallisto_optoff  
#$ -cwd  
#$ -pe omp 24                                
#$ -o lr_kallisto_optoff.out  
#$ -e lr_kallisto_optoff.err  

# # high level
# kb ref \
#   --kallisto /restricted/projectnb/ubah/rbozadjian/.conda/envs/kb_env/lib/python3.10/site-packages/kb_python/bins/linux/kallisto/kallisto_optoff_k64 \
#   -k 63 \
#   -d human \
#   -i human_k-63.idx \
#   -g human.t2g

# kb count \
#   --kallisto /restricted/projectnb/ubah/rbozadjian/.conda/envs/kb_env/lib/python3.10/site-packages/kb_python/bins/linux/kallisto/kallisto_optoff_k64 \
#   -k 63 \
#   -t 2 \
#   --long \
#   --threshold 0.8 \
#   -i human_k-63.idx \
#   -g human.t2g \
#   --tcc \
#   --matrix-to-directories \
#   -o output \
#   --parity single \
#   -x BULK \
#   --verbose \
#   ./results/fastq/bc02.fastq.gz

# low level
# kb ref \
#   --kallisto /restricted/projectnb/ubah/rbozadjian/.conda/envs/kb_env/lib/python3.10/site-packages/kb_python/bins/linux/kallisto/kallisto_optoff_k64 \
#   -k 63 \
#   --verbose \
#   -d human \
#   -i human_k-63.idx \
#   -g human.t2g

# kallisto bus -t 2 --verbose --long --threshold 0.8 -x bulk -i human_k-63.idx -o output ../results/fastq/bc02.fastq.gz

# bustools sort output.bus -o sorted.bus

# bustools count sorted.bus -t transcripts.txt -e matrix.ec -o count --cm -m -g human.t2g

# kallisto quant-tcc -t 2 --long -P PacBio -f flens.txt count.mtx -i human_k-63.idx -e count.ec.txt --matrix-to-directories -G ../refs/gencode.v48.annotation.gtf -o .

# To perform long-read pseudoalignment, first add -k 63 to kb ref and, second, add the --long flag to the kb count commands.

# you can use --tcc --matrix-to-directories to with kb count to also produce transcript-level matrices.


##### need to use kallisto_optoff_k64 binary #####

# kb-python has flag: --opt-off             Disable performance optimizations

# generate own index and t2g
# kb ref --verbose --kallisto  /restricted/projectnb/ubah/rbozadjian/.conda/envs/kb_env/lib/python3.10/site-packages/kb_python/bins/linux/kallisto/kallisto_optoff_k64 -k 63 -i human_k-63.idx -g human.t2g -f1 ../../refs/gencode.v48.transcripts.fa.gz ../../refs/GRCh38.primary_a
# ssembly.genome.fa.gz ../../refs/gencode.v48.annotation.gtf

kallisto bus -t 16 --verbose --long --threshold 0.8 -x bulk -i human_k-63.idx -o output_bc01 ../results/fastq/bc01.fastq.gz

bustools sort output.bus -o sorted.bus

bustools count sorted.bus -t transcripts.txt -e matrix.ec -o count --cm -m -g human.t2g

kallisto quant-tcc -t 24 --long -P PacBio -f flens.txt count.mtx -i human_k-63.idx -e count.ec.txt --matrix-to-directories -G ../refs/gencode.v48.annotation.gtf -o .


# kb ref —verbose —kallisto /restricted/projectnb/ubah/rbozadjian/.conda/envs/kb_env/lib/python3.10/site-packages/kb_python/bins/linux/kallisto/kallisto_optoff_k64 -k 63 -d human -i human_k-63.idx -g human.t2g
# kb count —kallisto /restricted/projectnb/ubah/rbozadjian/.conda/envs/kb_env/lib/python3.10/site-packages/kb_python/bins/linux/kallisto/kallisto_optoff_k64 -k 63 --long --threshold 0.8 -i human_k-63.idx -g human.t2g -o output -x bulk —parity single —verbose ../results/fastq/bc01.fastq.gz


# kb ref -k 63 -t 16 --verbose -d human -i human_k-63.idx -g human.t2g
# kb count --verbose -i human_k-63.idx -g human.t2g -o . -t 16 -k 63 --tcc --long --threshold 0.8 --platform PacBio -x bulk --parity single --matrix-to-directories  ../fastq/bc01.fastq.gz
