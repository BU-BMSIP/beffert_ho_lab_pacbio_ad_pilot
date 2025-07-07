#!/usr/bin/env nextflow

process BUSTOOLS_COUNT {
    conda "envs/bustools_env.yml"
    label "process_very_high"
    publishDir "${params.outdir}/kallisto"
    
    input: 
    path(sorted_bus)
    path(transcripts_txt)
    path(matrix_ec)
    path(t2g)    

    output:
    path("counts.mtx"), emit: counts_mtx
    path("counts.genes.txt")
    path("counts.ec.txt"), emit: counts_ec

    shell:
    """
    bustools count $sorted_bus -t $transcripts_txt -e $matrix_ec -o counts --cm -m -g $t2g
    """
}