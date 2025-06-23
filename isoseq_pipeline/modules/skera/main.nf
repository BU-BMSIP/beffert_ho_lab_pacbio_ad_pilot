#!/usr/bin/env nextflow

process SKERA {
    conda "envs/skera_env.yml"
    label "process_medium"
    publishDir params.outdir

    input:
    path(bam_demux)
    path(kinnex_segmentation_adapters)

    output:
    path("${bam_demux.baseName}.segmented.bam"), emit: segmented
    path("*")

    shell:
    """
    skera split $bam_demux $kinnex_segmentation_adapters ${bam_demux.baseName}.segmented.bam
    """
}