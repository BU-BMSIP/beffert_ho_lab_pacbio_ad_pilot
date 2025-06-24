#!/usr/bin/env nextflow

process ISOSEQ_COLLAPSE{
    conda "envs/isoseq_env.yml"
    label "process_high"
    publishDir "${params.outdir}/collapsed"

    input:
    path(bam_aligned)
    path(clustered_bam)

    output:
    path()

    shell:
    """
    isoseq collapse --do-not-collapse-extra-5exons $bam_aligned $clustered_bam <collapsed.gff> -j 8
    """
}