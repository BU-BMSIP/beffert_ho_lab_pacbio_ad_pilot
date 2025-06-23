#!/usr/bin/env nextflow

process LIMA_CDNA_DEMULTIPLEX {
    conda "envs/lima_env.yml"
    label "process_medium"
    publishDir params.outdir

    input:
    path(segmented)
    path(cdna_adapters)

    output:
    path("${segmented.baseName}.fl.bam"), emit: fl
    path("*")

    shell:
    """
    lima $segmented $cdna_adapters ${segmented.baseName}.fl.bam -j $task.cpus --isoseq --peek-guess --overwrite-biosample-names
    """
}