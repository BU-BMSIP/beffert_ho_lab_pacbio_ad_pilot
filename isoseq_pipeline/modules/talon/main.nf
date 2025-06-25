#!/usr/bin/env nextflow

process TALON{
    conda "envs/talon_env.yml"
    label "process_high"
    publishDir "${params.outdir}/talon"

    input:
    path(sam)
    path(genome)
    path(gtf)
    path(config)

    output:
    path("*")

    // talon_label_reads records the fraction of As in the n-sized window immediately following each read alignment (default window 20bp)
    // talon_filter_transcripts--minCount=MIN_COUNT  Number of minimum occurrences required for a novel transcript PER dataset. Default = 5
    script:
    """
    talon_initialize_database --f $gtf --g hg38 --a pacbio_ad --o pacbio_ad
    talon_label_reads --f $sam --g $genome --t $tasks.cpus
    talon --f $config --db pacbio_ad.db --build hg38 -t $tasks.cpus
    talon_abundance --db pacbio_ad.db --annot pacbio_ad -b hg38 --o gene_level
    talon_filter_transcripts --db pacbio_ad.db --anot pacbio_ad --o filtered_transcripts
    talon_abundance --db pacbio_ad.db --annot pacbio_ad -b hg38 --whitelist filtered_transcripts.csv --o isoform_level
    talon_create_GTF --db pacbio_ad.db --annot pacbio_ad -b hg38 --whitelist filtered_transcripts.csv --o pacbio_ad
    """
}