#!/usr/bin/env nextflow

process PBMM2_ALIGN {
    conda "envs/pbmm2_env.yml"
    label "process_high"
    publishDir "${params.outdir}/aligned_reads"

    input:
    path(bam_clustered)
    path(indexed_genome)

    output:
    path("aligned.bam"), emit: aligned

    shell:
    """
    pbmm2 align -j $task.cpus -J $task.cpus --preset ISOSEQ --sort $bam_clustered $indexed_genome aligned.bam 
    """
}