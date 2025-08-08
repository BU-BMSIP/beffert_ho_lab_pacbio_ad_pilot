#!/usr/bin/env nextflow

process STRINGTIE_MERGE{
    conda "envs/stringtie_env.yml"
    label "process_high"
    publishDir "${params.outdir}/stringtie_merge"

    input:
    path(stringtie_gtf)
    path(ref_gtf)

    output:
    path("stringtie_merged.gtf"), emit: merged_gtf
    path("*")

    shell:
    """
    stringtie -o stringtie_merged.gtf --merge -L -G $ref_gtf -p $task.cpus ${stringtie_gtf.join(" ")}
    """
}