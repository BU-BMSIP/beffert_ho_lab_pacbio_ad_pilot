#!/usr/bin/env nextflow

process GFFCOMPARE {
    label "process_high"
    conda "envs/gffcompare_env.yml"
    publishDir "${params.outdir}/gffcompare"

    input:
    path(stringtie_gtf)
    path(ref_gtf)

    output:
    path("*")

    shell:
    """
    gffcompare -r $ref_gtf -V $stringtie_gtf
    """
}