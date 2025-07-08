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
    gunzip -c $genome > genome.fa
    gffread $isoquant_gtf -g genome.fa -w transcriptome.fa
    """
}