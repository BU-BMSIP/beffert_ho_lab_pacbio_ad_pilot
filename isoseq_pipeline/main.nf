#!/usr/bin/env nextflow

include { LIMA_SMARTBELL_DEMULTIPLEX } from './modules/lima_smartbell_demultiplex'
include { SKERA } from './modules/skera'
include { LIMA_CDNA_DEMULTIPLEX } from './modules/lima_cdna_demultiplex'
include { ISOSEQ_REFINE } from './modules/isoseq_refine'
include { ISOSEQ_CLUSTER2 } from './modules/isoseq_cluster2'
include { PBTK } from './modules/pbtk'
include { ISOQUANT } from './modules/isoquant'
include { PBMM2_INDEX } from './modules/pbmm2_index'
include { PBMM2_ALIGN } from './modules/pbmm2_align'
include { ISOSEQ_COLLAPSE } from './modules/isoseq_collapse'
include { MERGE_SMRTCELLS } from './modules/merge_smrtcells'

workflow{

Channel.fromPath(params.reads)
    | map { bam ->
        def base = bam.baseName
        def matcher = (base =~ /^(.*?)(?:\.hifi_reads.*)?$/)
        def shortName = matcher.matches() ? matcher[0][1] : base
        return tuple(shortName, bam)
    }
    | set{ bam_ch }

    // demultiplex kinnex smartbell adapters
    LIMA_SMARTBELL_DEMULTIPLEX(bam_ch, params.kinnex_smartbell_adapters)

    // create segmented reads
    SKERA(LIMA_SMARTBELL_DEMULTIPLEX.out.bam_demux, params.kinnex_segmentation_adapters)

    // demultiplex cDNA adapters
    LIMA_CDNA_DEMULTIPLEX(SKERA.out.segmented, params.cdna_adapters)
    LIMA_CDNA_DEMULTIPLEX.out.fl.flatMap{ id, files -> files.collect { file -> [id, file] } }.set{ bam_cdna_demux_ch }

    // remove concatemers and keep polyA tails
    ISOSEQ_REFINE(bam_cdna_demux_ch, params.cdna_adapters)

    // merge SMRT cells
    //MERGE_SMRTCELLS(ISOSEQ_REFINE.out.flnc)
    //ISOSEQ_REFINE.out.flnc.view()

    ISOSEQ_REFINE.out.flnc
        | collect()
        | flatten()
        | map { it instanceof Tuple ? it[1].toString() : it.toString() }
        | filter { it.endsWith('.bam') || it.startsWith('/') }
        | collectFile(name: 'flnc.fofn') { it }
        | set_ch{ fofn_ch }

    // cluster
    ISOSEQ_CLUSTER2(fofn_ch)

    // convert bam to fasta --> I don't think I need this
    //PBTK(ISOSEQ_CLUSTER2.out.clustered_bam)

    // map to reference genome
    PBMM2_INDEX(params.genome)
    //PBMM2_ALIGN(ISOSEQ_CLUSTER2.out.clustered_bam, PBMM2_INDEX.out.indexed_genome)

    // isoform discovery: annotated gene, isoform, exon and intron quantification
    //ISOQUANT(PBMM2_ALIGN.out.aligned, params.gtf, params.genome)

    // collapse into unique isoforms --> can skip this and use Isoquant?
    //ISOSEQ_COLLAPSE(PBMM2_ALIGN.out.aligned, ISOSEQ_CLUSTER2.out.clustered_bam)

    // counts matrix generation
    // TALON(PBMM2_ALIGN.out.aligned, params.genome, params.gtf, params.talon_config)

    // more analyses
    // isoformanalyzer, deseq2, drimseq, dexseq, pbfusion
}