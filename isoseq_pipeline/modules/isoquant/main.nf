#!/usr/bin/env nextflow

process ISOQUANT{
    conda "envs/isoquant_env.yml"
    label "process_high"
    publishDir "${params.outdir}/isoquant"

    input:
    path(bam_aligned)
    path(gtf)
    path(genome)

    output:
    path("*")

    script:
    """
    isoquant.py -d pacbio_ccs --fl_data --bam ${bam_aligned.join(" ")} --genedb $gtf -r $genome --count_exons --output ${params.outdir}/isoquant --threads 8
    """
}