#!/usr/bin/env nextflow

process ISOSEQ_REFINE{
    conda "envs/isoseq_env.yml"
    label "process_medium"
    publishDir params.outdir

    input:
    tuple path(bam), path(adapter)

    output:
    path("${bam.baseName}.flnc.bam")

    shell:
    """
    isoseq refine $bam $adapter ${bam.baseName}.flnc.bam
    """
}