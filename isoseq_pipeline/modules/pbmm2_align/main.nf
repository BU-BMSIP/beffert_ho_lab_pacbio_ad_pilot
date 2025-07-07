#!/usr/bin/env nextflow

process PBMM2_ALIGN {
    conda "envs/pbmm2_env.yml"
    label "process_very_high"
    publishDir "${params.outdir}/aligned_reads"

    input:
    tuple val(name), path(bam_merged)
    path(indexed_genome)

    output:
    tuple val(name), path("${name}.aligned.bam"), path("${name}.aligned.bam.bai"), emit: aligned

    // change to .sorted
    shell:
    """
    pbmm2 align -j 11 -J 11 --preset ISOSEQ --sort $bam_merged $indexed_genome "${name}.aligned.bam" 
    """
}