#!/usr/bin/env nextflow

// align to human reference genome
process PBMM2_ALIGN {
    conda "envs/pbmm2_env.yml"
    label "process_very_high"
    publishDir "${params.outdir}/aligned_reads"

    input:
    tuple val(name), path(bam_merged)
    path(indexed_genome)

    output:
    tuple val(name), path("${name}.aligned.bam"), path("${name}.aligned.bam.bai"), emit: aligned
    path("${name}.pbmm2.log")

    shell:
    """
    pbmm2 align -j 20 -J 20 --preset ISOSEQ --sort $bam_merged $indexed_genome "${name}.aligned.bam" --log-level INFO > ${name}.pbmm2.log 2>&1
    """
}