#!/usr/bin/env nextflow

process BUSPARSE {
    conda "envs/busparse_env.yml"
    label "process_high"
    publishDir "${params.outdir}/kallisto"
    
    input:
    path(transcriptome_fasta)

    output:
    path("*.t2g")

    script:
    """
    Rscript -e '
        library(BUSpaRse)
        tr2g_fasta(
            file = "${transcriptome_fasta}",
            out_path = ".",
            write_tr2g = TRUE,
            save_filtered = FALSE
        )
    '
    """
}