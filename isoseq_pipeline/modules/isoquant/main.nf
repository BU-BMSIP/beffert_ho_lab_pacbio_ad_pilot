#!/usr/bin/env nextflow

process ISOQUANT{
    conda "envs/isoquant_env.yml"
    label "process_very_high"
    publishDir "${params.outdir}/isoquant"

    input:
    tuple val(name), path(bam_aligned), path(bam_index)
    path(gtf)
    path(genome)

    output:
    path("*")

    script:
    """
    isoquant.py -d pacbio_ccs --fl_data --bam ${bam_aligned.join(" ")} --genedb $gtf --complete_genedb -r $genome --count_exons --output ${params.outdir} --threads $task.cpus -p isoquant --check_canonical --bam_tags RG,SM,PU,ID --read_group tag:SM
    """
}