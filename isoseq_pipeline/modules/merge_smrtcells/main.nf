#!/usr/bin/env nextflow

process MERGE_SMRTCELLS {
    label "process_low"
    publishDir "${params.outdir}/flnc_reads"

    input:
    tuple val(name), path(bam_flnc)

    output:
    path("flnc.fofn"), emit: fofn

    script:
    """
    ls ${bam_flnc.collect { it }.join(' ')} > flnc.fofn
    """
}
