#!/usr/bin/env nextflow

process ISOQUANT{
    conda "envs/isoquant_env.yml"
    label "process_very_high"
    publishDir "${params.outdir}/isoquant"

    input:
    val(name)
    path(bam_sorted)
    path(bai)
    path(gtf)
    path(genome)

    output:
    path("*")

    script:
    """
    isoquant.py -d pacbio_ccs --fl_data --bam ${bam_sorted.join(" ")} --genedb $gtf --complete_genedb -r $genome --count_exons --output ${params.outdir} --threads $task.cpus -p isoquant --check_canonical --labels ${name.join(" ")}
    """
}