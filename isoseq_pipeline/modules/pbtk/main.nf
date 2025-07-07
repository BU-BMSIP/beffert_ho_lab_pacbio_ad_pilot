#!/usr/bin/env nextflow

process PBTK {
    conda "envs/pbtk_env.yml"
    label "process_high"
    publishDir "${params.outdir}/fastq"

    input:
    path(aligned_bam)

    output:
    path("${aligned_bam.baseName}.fastq.gz")

    shell:
    """
    bam2fastq -o ${aligned_bam.baseName}.fasta.gz $aligned_bam -j 10
    """
}