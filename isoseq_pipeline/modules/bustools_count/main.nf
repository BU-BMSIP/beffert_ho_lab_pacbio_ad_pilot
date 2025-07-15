#!/usr/bin/env nextflow

process BUSTOOLS_COUNT {
    conda "envs/bustools_env.yml"
    label "process_high"
    publishDir "${params.outdir}/kallisto"
    
    input: 
    tuple val(name), path(sorted_bus)
    path(transcripts_txt)
    path(matrix_ec)
    path(t2g)    

    output:
    tuple val(name), path("${name}/counts.mtx"), emit: counts_mtx
    path("${name}/counts.genes.txt")
    path("${name}/counts.ec.txt"), emit: counts_ec

    shell:
    """
    bustools count $sorted_bus -t $transcripts_txt -e $matrix_ec -o counts --cm -m -g $t2g
    """
}