#!/usr/bin/env nextflow

process LIMA_CDNA_DEMULTIPLEX {
    conda "envs/lima_env.yml"
    label "process_high"
    publishDir "${params.outdir}/cdna_demux_reads"

    input:
    tuple val(name), path(segmented)
    path(cdna_adapters)

    output:
    tuple val(name), path("${name}.fl.*.bam"), emit: fl
    path("${name}.fl*")

    shell:
    """
    lima $segmented $cdna_adapters ${name}.fl --isoseq -j 10 --peek-guess --overwrite-biosample-names
    """
}