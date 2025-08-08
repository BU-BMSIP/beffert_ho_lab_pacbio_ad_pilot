#!usr/bin/env nextflow

process MULTIQC {
    conda "./envs/multiqc_env.yml"
    label "process_low"
    publishDir params.outdir

    input:
    path("*")

    output:
    path("*html")

    shell:
    """
    multiqc -f .
    """
}