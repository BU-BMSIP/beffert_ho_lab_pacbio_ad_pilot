#!/usr/bin/env nextflow

process ISOSEQ_REFINE{
    conda "envs/isoseq_env.yml"
    label "process_high"
    publishDir "${params.outdir}/flnc_reads"

    input:
    tuple val(name), path(bam_fl)
    path(cdna_adapters)

    output:
    tuple val(name), path("${bam_fl.baseName}.flnc.bam"), emit: flnc
    path("*")

    shell:
    """
    isoseq refine $bam_fl $cdna_adapters ${bam_fl.baseName}.flnc.bam -j 10
    """
}