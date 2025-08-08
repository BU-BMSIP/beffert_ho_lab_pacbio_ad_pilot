#!/usr/bin/env nextflow

// generates 63-mer index for quantification
process KB_PYTHON{
    // use specific kallisto_optoff_k64 binary 
    conda "/restricted/projectnb/ubah/rbozadjian/.conda/envs/kb_env"
    label "process_medium"
    publishDir "${params.refdir}"

    input:
    path(genome)
    path(gtf)
    path(transcriptome)
    
    output:
    path("human_k-63.idx"), emit: transcript_idx
    path("human.t2g"), emit: t2g
   
    // --opt-off runs without cpu performance optimizations which causes error
    // need to use kallisto_optoff_k64 binary
    shell:
    """
    kb ref --verbose -i human_k-63.idx -g human.t2g -f1 $transcriptome -k 63 -t $task.cpus --opt-off $genome $gtf
    """
}