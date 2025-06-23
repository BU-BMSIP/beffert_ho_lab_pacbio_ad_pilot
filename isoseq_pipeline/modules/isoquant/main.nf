#!/usr/bin/env nextflow

process ISOQUANT{
    conda "envs/isoquant_env.yml"
    label "process_medium"
    publishDir params.outdir

    input:
    path(fasta)
    path(gtf)
    path(genome)

    output:
    path("*")

    script:
    """
    isoquant.py -d pacbio_ccs --fastq ${fasta.join(" ")} --genedb $gtf -r $genome --count_exons --output params.outdir/isoquant --threads $task.cpus
    """

}