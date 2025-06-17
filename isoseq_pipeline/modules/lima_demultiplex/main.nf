#!/usr/bin/env nextflow

process LIMA_DEMULTIPLEX {
    conda "envs/lima_env.yml"
    label "process_medium"
    publishDir params.outdir

    input:
    tuple path(bam), path(adapter)

    output:
    path("*")

    shell:
    """
    lima $bam $adapter output.bam --isoseq --peek-guess --overwrite-biosample-names
    """

}