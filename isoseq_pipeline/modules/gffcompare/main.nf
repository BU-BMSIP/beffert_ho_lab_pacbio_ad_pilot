#!/usr/bin/env nextflow

process GFFCOMPARE {
    label "process_high"
    conda "envs/gffcompare_env.yml"
    publishDir "${params.outdir}/gffcompare"

    input:
    path(ref_gtf)
    path(isoquant_gtf)
    path(stringtie_gtf)

    output:
    path("isoquant.*"), emit: isoquant_gffcompare
    path("stringtie.*"), emit: stringtie_gffcompare

    shell:
    """
    gffcompare -r $ref_gtf -V -o isoquant $isoquant_gtf
    gffcompare -r $ref_gtf -V -o stringtie $stringtie_gtf
    """
}