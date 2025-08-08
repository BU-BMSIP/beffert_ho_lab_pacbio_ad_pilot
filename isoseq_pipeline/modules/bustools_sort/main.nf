#!/usr/bin/env nextflow

process BUSTOOLS_SORT {
    conda "envs/bustools_env.yml"
    label "process_medium"
    publishDir "${params.outdir}/lr-kallisto"
    
    input:
    tuple val(name), path(bus)

    output:
    tuple val(name), path("${name}/sorted.bus")

    shell:
    """
    bustools sort -t $task.cpus $bus -o ${name}/sorted.bus
    """
}