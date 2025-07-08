#!/usr/bin/env nextflow

process KALLISTO_INDEX{
    conda "envs/kallisto_env.yml"
    label "process_very_high"
    publishDir "${params.outdir}/kallisto"

    input:
    path(transcriptome_fasta)

    output:
    path("transcriptome.idx")

    //must run with 8 cores otherwise get weird cpu error
    shell:
    """
    kallisto index -i transcriptome.idx -k 63 -t 8 $transcriptome_fasta
    """
}