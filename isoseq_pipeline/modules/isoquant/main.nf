#!/usr/bin/env nextflow

process ISOQUANT{
    conda "envs/isoquant_env.yml"
    label "process_medium"
    publishDir params.outdir

    input:
    path(bam)
    path(gtf)
    path(genome)

    output:
    path("*")

    script:
    """
    mkdir results
    isoquant.py -d pacbio_ccs --bam ${bam.join(" ")} --genedb $gtf -r $genome --count_exons --output params.outdir
    """

}