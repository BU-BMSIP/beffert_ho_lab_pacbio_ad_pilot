#!/usr/bin/env nextflow

process PBMM2_ALIGN {
    conda "envs/pbmm2_env.yml"
    label "process_medium"
    publishDir params.outdir

    input:
    path(bam_clustered)
    path(indexed_genome)

    output:
    path("${bam_clustered.baseName}.aligned.bam"), emit: aligned

    shell:
    """
    pbmm2 align -j $task.cpus -J $task.cpus --preset ISOSEQ --sort $bam_clustered $indexed_genome ${bam_clustered.baseName}.aligned.bam 
    """
}