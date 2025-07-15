#!/usr/bin/env nextflow

process KALLISTO_BUS{
    conda "envs/kallisto_env.yml"
    label "process_high"
    publishDir "${params.outdir}/kallisto"

    input:
    tuple val(name), path(fastq)
    path(transcript_idx)

    output:
    tuple val(name), path("${name}/output.bus"), emit: output_bus
    path("${name}/transcripts.txt"), emit: transcripts_txt
    path("${name}/matrix.ec"), emit: matrix_ec
    path("${name}/flens.txt"), emit: flens_txt


    shell:
    """
    kallisto bus -t $task.cpus --long --threshold 0.8 -x bulk -i $transcript_idx -o ${name}/ $fastq
    """
}