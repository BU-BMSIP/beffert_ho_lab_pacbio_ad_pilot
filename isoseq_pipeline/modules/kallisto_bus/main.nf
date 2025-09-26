#!/usr/bin/env nextflow

process KALLISTO_BUS{
    //conda "envs/kallisto_env.yml"
    conda "/restricted/projectnb/ubah/rbozadjian/.conda/envs/kb_env"
    label "process_high"
    publishDir "${params.outdir}/lr-kallisto"

    input:
    tuple val(name), path(fastq)
    path(transcript_idx)
    path(t2g)
    path(gtf)

    output:
    tuple val(name), path("${name}/output.bus"), emit: output_bus
    tuple val(name), path("${name}/sorted.bus"), emit: sorted_bus
    tuple val(name), path("${name}/counts.mtx"), emit: counts_mtx
    path("${name}/transcripts.txt"), emit: transcripts_txt
    path("${name}/matrix.ec"), emit: matrix_ec
    path("${name}/flens.txt"), emit: flens_txt
    path("${name}/counts.genes.txt")
    path("${name}/counts.ec.txt"), emit: counts_ec
    path("${name}/*")

    // need to use kallisto_optoff_k64 binary
    shell:
    """
    kallisto bus -t $task.cpus --verbose --long --threshold 0.8 -x bulk -i $transcript_idx -o ${name}/ $fastq
    bustools sort -t $task.cpus ${name}/output.bus -o ${name}/sorted.bus
    bustools count ${name}/sorted.bus -t ${name}/transcripts.txt -e ${name}/matrix.ec -o ${name}/counts --cm -m -g $t2g
    kallisto quant-tcc -t $task.cpus --long -P PacBio -f ${name}/flens.txt ${name}/counts.mtx -i $transcript_idx -e ${name}/matrix.ec --matrix-to-directories -G $gtf -o . > lrkallisto_stdout.log 2>&1
    """
}