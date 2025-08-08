#!/usr/bin/env nextflow

process STRINGTIE{
    conda "envs/stringtie_env.yml"
    label "process_high"
    publishDir "${params.outdir}/stringtie"

    input:
    tuple val(name), path(aligned_bam), path(bai)
    path(gtf)

    output:
    path("${name}.output.gtf"), emit: stringtie_gtf
    path("${name}.gene_abund.tab")
    path("*")

    shell:
    """
    stringtie -o ${name}.output.gtf -L -v -G $gtf -p $task.cpus -A ${name}.gene_abund.tab $aligned_bam
    """
}