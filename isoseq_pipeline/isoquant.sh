#!/bin/bash
#$ -P ubah
#$ -N isoquant_resume
#$ -pe omp 32
#$ -l mem_per_core=8G
#$ -o isoquant_resume.out
#$ -e isoquant_resume.err

isoquant.py \
  --resume \
  --output /restricted/projectnb/ubah/rbozadjian/beffert_ho_lab_pacbio_ad_pilot/isoseq_pipeline/results/ \
  --threads 32 \
  --high_memory
