#!/usr/bin/env nextflow

process LIMA_SMARTBELL_DEMULTIPLEX {
    conda "envs/lima_env.yml"
    label "process_high"
    publishDir "${params.outdir}/smartbell_demux_reads"

    input:
    tuple val(name), path(bam)
    path(kinnex_smartbell_adapters)

    output:
    tuple val(name), path("${name}.demux.bam"), emit: bam_demux
    path("${name}.demux*")

    // --guess selects only barcode pairs with a mean score ≥ 75
    // --guess-min-count 20 selects only barcode pairs with at ≥ 20 ZMWs
    shell:
    """
    lima $bam $kinnex_smartbell_adapters ${name}.demux.bam --hifi-preset SYMMETRIC -j 8 --guess 75 --guess-min-count 20
    """
}