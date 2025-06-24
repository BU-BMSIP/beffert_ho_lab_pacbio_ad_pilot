#!/usr/bin/env nextflow

process TALON{
    conda "envs/talon_env.yml"
    label "process_high"
    publishDir "${params.outdir}/talon"

    input:
    path(sam)
    path(genome)
    path(gtf)
    path()


    output:
    path("*")

    script:
    """
    talon_label_reads --f <SAM file> --g $genome --t 8
    talon_initialize_database --f $gtf --g hg38 --a <annot name>
    talon --f <config file> --cb --db --build hg38 -t 8
    talon_fetch_reads --db --build hg38 --datasets
    talon_abundance --db --annot --whitelist -b hg38 -d
    talon_filter_transcripts --db --anot --datasets --includeAnnot
    talon_create_GTF --db -b hg38 -a 
    talon_create_adata --db -a -b hg38 --gene -d
    talon_create_adata --db -a -b hg38 -d
    """
}