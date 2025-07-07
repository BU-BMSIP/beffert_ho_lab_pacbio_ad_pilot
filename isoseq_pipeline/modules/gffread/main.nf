#!/usr/bin/env nextflow

process GFFREAD {
    conda "envs/gffread_env.yml"
    publishDir "${params.outdir}/transcriptome"

    input:
    path(isoquant_gtf)
    path(genome)
    

    output:
    path("transcriptome.fa")

    shell:
    """
    gffread -w transcriptome.fa -g $genome $isoquant_gtf
    """
}