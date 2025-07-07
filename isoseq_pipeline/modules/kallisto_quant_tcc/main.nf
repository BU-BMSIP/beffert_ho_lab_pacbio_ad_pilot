#!/usr/bin/env nextflow

process KALLISTO_QUANT_TCC{
    conda "envs/kallisto_env.yml"
    label "process_very_high"
    publishDir "${params.outdir}/kallisto"

    input:
    path(counts_mtx)
    path(indexed_transcriptome)
    path(counts_ec)
    path(flens)
    path(t2g)
    
    output:
    path("abundance.tsv")
   
   
    shell:
    """
    kallisto quant-tcc -t $task.cpus --long -P PacBio -f $flens $counts_mtx -i $indexed_transcriptome -e $counts_ec -o . -g $t2g
    """
}