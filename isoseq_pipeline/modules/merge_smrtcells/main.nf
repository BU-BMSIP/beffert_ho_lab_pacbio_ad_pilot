#!/usr/bin/env nextflow

process MERGE_SMRTCELLS {
    label "process_low"
    publishDir "${params.outdir}/flnc_reads"

    input:
    path(bam_flnc)

    output:
    path("flnc.fofn"), emit: fofn

    script:
    """
    realpath ${bam_flnc.join(' ')} > flnc.fofn
    """
}
