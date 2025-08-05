#!/usr/bin/env nextflow

process PFAM_SCAN {
    conda "envs/pfam_env.yml"
    label "process_medium"
    publishDir "${params.outdir}/pfam"

    input:
    path(isoform_aa)

    output:
    path("*")

    shell:
    """
    pfam_scan.pl $isoform_aa -dir $pfam_files -outfile pfam_output -cpu $task.cpus
    """
}