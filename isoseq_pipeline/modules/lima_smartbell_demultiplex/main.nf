#!/usr/bin/env nextflow

process LIMA_SMARTBELL_DEMULTIPLEX {
    conda "envs/lima_env.yml"
    label "process_medium"
    publishDir params.outdir

    input:
    path(bam)
    path(kinnex_smartbell_adapters)

    output:
    path("${bam.baseName}.demux.bam"), emit: bam_demux
    path("*")

    // --guess selects only barcode pairs with a mean score ≥ 75
    // --guess-min-count 20 selects only barcode pairs with at ≥ 20 ZMWs
    shell:
    """
    lima $bam $kinnex_smartbell_adapters ${bam.baseName}.demux.bam -j $task.cpus --hifi-preset SYMMETRIC --guess 75 --guess-min-count 20
    """
}