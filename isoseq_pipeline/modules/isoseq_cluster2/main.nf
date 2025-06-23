#!/usr/bin/env nextflow

process ISOSEQ_CLUSTER2{
    conda "envs/isoseq_env.yml"
    label "process_medium"
    publishDir params.outdir/clustered_bam

    input:
    path(bam_fofn)

    output:
    path("${bam_fofn.baseName}.clustered.bam"), emit: clustered_bam
    path("*")

    shell:
    """
    mkdir -p clustered_bam
    isoseq cluster2 $bam_fofn clustered.bam
    """
}