#!/usr/bin/env nextflow

process KALLISTO_QUANT{
    conda "envs/kallisto_env.yml"
    label "process_very_high"
    publishDir "${params.outdir}/kallisto"

    input:
    path(fastq)
    path(transcriptome_index)

    output:
    path("*")

    shell:
    """
    kallisto quant -i $transcriptome_index -o kallisto --single -t $task.cpus --verbose ${fastq.join(" ")} 
    """
}