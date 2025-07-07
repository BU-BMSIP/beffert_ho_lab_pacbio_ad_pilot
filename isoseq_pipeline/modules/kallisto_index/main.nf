#!/usr/bin/env nextflow

process KALLISTO_INDEX{
    conda "envs/kallisto_env.yml"
    label "process_very_high"
    publishDir "${params.outdir}/kallisto"

    input:
    path(transcriptome_fasta)

    output:
    path("transcriptome.idx")

    shell:
    """
    kallisto index -i transcriptome.idx -k 63 $transcriptome_fasta
    """
}