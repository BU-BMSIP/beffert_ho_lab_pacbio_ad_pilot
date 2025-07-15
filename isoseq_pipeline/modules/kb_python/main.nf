#!/usr/bin/env nextflow

process KB_PYTHON{
    conda "envs/kb_python_env.yml"
    label "process_high"
    publishDir "${params.outdir}/kallisto"

    input:
    
    output:
    path("human_k-63.idx"), emit: transcript_idx
    path("human.t2g"), emit: t2g
   
    shell:
    """
    kb ref -k 63 -t $task.cpus --verbose -d human -i human_k-63.idx -g human.t2g
    """
}