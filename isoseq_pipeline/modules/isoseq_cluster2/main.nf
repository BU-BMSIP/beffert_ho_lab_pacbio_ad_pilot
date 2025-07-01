#!/usr/bin/env nextflow

process ISOSEQ_CLUSTER2{
    conda "envs/isoseq_env.yml"
    label "process_cluster2"
    publishDir "${params.outdir}/clustered_reads"

    input:
    path(bam_fofn)

    output:
    path("clustered.bam"), emit: clustered_bam
    path("*")

    shell:
    """
    isoseq cluster2 $bam_fofn clustered.bam -j 24 --log-level INFO
    """
}