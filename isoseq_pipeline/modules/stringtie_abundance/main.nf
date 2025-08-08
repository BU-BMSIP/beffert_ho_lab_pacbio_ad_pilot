#!/usr/bin/env nextflow

process STRINGTIE_ABUNDANCE{
    conda "envs/stringtie_env.yml"
    label "process_high"
    publishDir "${params.outdir}/stringtie_abundance"

    input:
    tuple val(name), path(aligned_bam), path(bai)
    path(stringtie_gtf)

    output:
    path("${name}/${name}.output.gtf")
    path("${name}/${name}.gene_abund.tab")
    path("${name}/")

    shell:
    """
    mkdir ${name}
    stringtie -o ${name}/${name}.output.gtf -L -e -v -G $stringtie_gtf -p $task.cpus -A ${name}/${name}.gene_abund.tab -B $aligned_bam
    """
}