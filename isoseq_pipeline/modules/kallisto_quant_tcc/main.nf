#!/usr/bin/env nextflow

process KALLISTO_QUANT_TCC{
    conda "envs/kallisto_env.yml"
    label "process_high"
    publishDir "${params.outdir}/kallisto"

    input:
    tuple val(name), path(counts_mtx)
    path(transcript_idx)
    path(counts_ec)
    path(flens)
    path(gtf)
    
    output:
    path("${name}/${name}_*")
   
   
    shell:
    """
    kallisto quant-tcc -t $task.cpus --long -P PacBio -f $flens $counts_mtx -i $transcript_idx -e $counts_ec --matrix-to-directories -G $gtf -o . 
    """
}