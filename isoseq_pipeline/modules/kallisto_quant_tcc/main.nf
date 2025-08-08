#!/usr/bin/env nextflow

process KALLISTO_QUANT_TCC{
    conda "/restricted/projectnb/ubah/rbozadjian/.conda/envs/kb_env"
    label "process_high"
    publishDir "${params.outdir}/lr-kallisto"

    input:
    tuple val(name), path(counts_mtx)
    path(transcript_idx)
    path(counts_ec)
    path(flens)
    path(gtf)
    
    output:
    path("${name}/*")
   
   // need to use kallisto_optoff_k64 binary
    shell:
    """
    kallisto quant-tcc -t $task.cpus --long -P PacBio -f $flens $counts_mtx -i $transcript_idx -e $counts_ec --matrix-to-directories -G $gtf -o . > lrkallisto_stdout.log 2>&1
    """
}