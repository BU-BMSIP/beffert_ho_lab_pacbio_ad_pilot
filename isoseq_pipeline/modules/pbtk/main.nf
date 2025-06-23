#!/usr/bin/env nextflow

process PBTK {
    conda "envs/pbtk_env.yml"
    label "process_medium"
    publishDir params.outdir

    input:
    path(bam_clustered)

    output:
    path("${bam_clustered.baseName}.fasta.gz")

    shell:
    """
    bam2fasta -o ${bam_clustered.baseName}.fasta.gz $bam_clustered
    """
}