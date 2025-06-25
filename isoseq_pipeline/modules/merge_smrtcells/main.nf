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
    ls ${bam_flnc.collect { it.getName() }.join(' ')} > flnc.fofn
    """
}
