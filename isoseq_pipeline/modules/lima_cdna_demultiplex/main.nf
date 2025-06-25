#!/usr/bin/env nextflow

process LIMA_CDNA_DEMULTIPLEX {
    conda "envs/lima_env.yml"
    label "process_high"
    publishDir "${params.outdir}/cdna_demux_reads"

    input:
    tuple val(name), path(segmented)
    path(cdna_adapters)

    output:
    tuple val(name), path("${name}.bam"), emit: fl
    path("*")

    shell:
    """
    lima $segmented $cdna_adapters ${name}.bam --isoseq -j 8 --peek-guess --overwrite-biosample-names
    """
}