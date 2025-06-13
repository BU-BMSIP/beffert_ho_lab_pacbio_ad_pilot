#!/usr/bin/env nextflow

process LIMA {
    conda "envs/lima_env.yml"
    label "process_medium"
    publishDir params.outdir

    input:


    output:

    script:
    """
    """

}