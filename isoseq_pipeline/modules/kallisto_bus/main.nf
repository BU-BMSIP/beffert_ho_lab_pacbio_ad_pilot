#!/usr/bin/env nextflow

process KALLISTO_BUS{
    conda "envs/kallisto_env.yml"
    label "process_very_high"
    publishDir "${params.outdir}/kallisto"

    input:
    path(fastq)
    path(indexed_transcriptome)

    output:
    path("sorted.bus"), emit: bus
    path("transcripts.txt"), emit: transcripts_txt
    path("matrix.ec"), emit: matrix_ec
    path("flens.txt"), emit: flens_txt

    shell:
    """
    kallisto bus -t $task.cpus --long --threshold 0.8 -x bulk -i $indexed_transcriptome -o kallisto ${fastq.join(" ")}
    """
}