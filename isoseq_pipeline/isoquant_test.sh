#!/bin/bash
#$ -pe omp 16
#$ -p ubah

# Define variables with your provided paths
BAM_ALIGNED="./results/aligned_reads/m84147_241217_202841_s1.IsoSeqX_bc02_5p--IsoSeqX_3p.flnc.aligned.bam"
GTF="./refs/gencode.v48.annotation_nochr.gtf"
GENOME="./refs/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz"
OUTDIR="results"
CPUS=${NSLOTS:-16}

# Run IsoQuant (all arguments on one line)
isoquant.py \
  -d pacbio_ccs \
  --fl_data \
  --bam "$BAM_ALIGNED" \
  --genedb "$GTF" \
  -r "$GENOME" \
  --count_exons \
  --output "$OUTDIR" \
  --threads "$CPUS" \
  --complete_genedb \
  --check_canonical \
  --bam_tags RG,PU,ID \
  --read_group tag:SM \
  -p isoquant_test