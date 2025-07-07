#!/usr/bin/env nextflow

process GFFREAD {
    conda "envs/gffread_env.yml"
    publishDir "${params.outdir}/transcriptome"

    input:
    path(genome)
    path(gtf)

    output:
    path("transcriptome.fa")

    shell:
    """
    gffread -w transcriptome.fa -g ${genome} ${gtf}
    """
}