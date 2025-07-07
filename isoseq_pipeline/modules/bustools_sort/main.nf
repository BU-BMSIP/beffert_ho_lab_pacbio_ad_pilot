#!/usr/bin/env nextflow

process BUSTOOLS_SORT {
    conda "envs/bustools_env.yml"
    label "process_very_high"
    publishDir "${params.outdir}/kallisto"
    
    input:
    path(bus)

    output:
    path("sorted.bus")

    shell:
    """
    bustools sort -t $task.cpus $bus -o sorted.bus
    """
}