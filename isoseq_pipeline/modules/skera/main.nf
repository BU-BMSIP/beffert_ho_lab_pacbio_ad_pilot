#!/usr/bin/env nextflow

// desegment reads
process SKERA {
    conda "envs/skera_env.yml"
    label "process_high"
    publishDir "${params.outdir}/segmented_reads"

    input:
    tuple val(name), path(bam_demux)
    path(kinnex_segmentation_adapters)

    output:
    tuple val(name), path("${name}.segmented.bam"), emit: segmented
    path("${name}.segmented*")

    shell:
    """
    skera split $bam_demux $kinnex_segmentation_adapters ${name}.segmented.bam -j 8
    """
}