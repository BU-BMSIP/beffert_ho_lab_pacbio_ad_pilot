#!/usr/bin/env nextflow

process ISOSEQ_CLUSTER2{
    conda "envs/isoseq_env.yml"
    label "process_high"
    publishDir "${params.outdir}/clustered_bam"

    input:
    path(bam_fofn)

    output:
    path("clustered.bam"), emit: clustered_bam
    path("*")

    shell:
    """
    isoseq cluster2 $bam_fofn clustered.bam -j 8
    """
}