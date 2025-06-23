#!/usr/bin/env nextflow

process ISOSEQ_REFINE{
    conda "envs/isoseq_env.yml"
    label "process_medium"
    publishDir params.outdir

    input:
    path(bam_fl)
    path(cdna_adapters)

    output:
    path("${bam_fl.baseName}.flnc.bam"), emit: flnc
    path("${bam_fl.baseName}.flnc.transcriptset.xml")

    shell:
    """
    isoseq refine $bam_fl $cdna_adapters ${bam_fl.baseName}.flnc.bam -j $task.cpus
    """
}