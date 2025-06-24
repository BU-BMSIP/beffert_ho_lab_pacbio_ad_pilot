#!/usr/bin/env nextflow

process ISOSEQ_REFINE{
    conda "envs/isoseq_env.yml"
    label "process_high"
    publishDir "${params.outdir}/flnc_reads"

    input:
    tuple val(name), path(bam_fl)
    path(cdna_adapters)

    output:
    tuple val(name), path("${name}.flnc.bam"), emit: flnc
    path("${name}.flnc.transcriptset.xml")

    shell:
    """
    isoseq refine $bam_fl $cdna_adapters ${name}.flnc.bam -j 10
    """
}