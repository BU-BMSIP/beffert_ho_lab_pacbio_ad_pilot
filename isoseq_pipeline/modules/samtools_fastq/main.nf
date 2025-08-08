#!/usr/bin/env nextflow

// .bam to .fastq files
process SAMTOOLS_FASTQ {
    conda "envs/samtools_env.yml"
    label "process_high"
    publishDir "${params.outdir}/fastq"

    input:
    tuple val(name), path(aligned_bam), path(bai)

    output:
    path("${name}.fastq.gz")

    shell:
    """
    samtools fastq -@ $task.cpus $aligned_bam | gzip > ${name}.fastq.gz
    """
}