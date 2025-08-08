#!/usr/bin/env nextflow

process SAMTOOLS_MERGE {
    conda "envs/samtools_env.yml"
    label "process_high"
    publishDir "${params.outdir}/merged_replicates"

    input:
    tuple val(name), path(flnc_bam)

    output:
    tuple val(name), path("${name}.merged.bam")

    script:
    def header_bam = flnc_bam[0]
    """
    samtools merge -h ${header_bam} -c -p -@ $task.cpus -o ${name}.merged.bam ${flnc_bam.join(' ')}
    """
}