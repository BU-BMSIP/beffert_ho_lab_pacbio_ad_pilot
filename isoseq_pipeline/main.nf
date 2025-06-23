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

workflow{

    Channel.fromPath(params.samplesheet)
        | splitCsv( header: true )
        | map{ row -> file(row.bam_path) }
        | flatten()
        | set{ bam_ch }

    // demultiplex kinnex smartbell adapters
    LIMA_SMARTBELL_DEMULTIPLEX(bam_ch, params.kinnex_smartbell_adapters)

    // create segmented reads
    SKERA(LIMA_SMARTBELL_DEMULTIPLEX.out.bam_demux, params.kinnex_segmentation_adapters)

    // demultiplex cDNA adapters
    LIMA_CDNA_DEMULTIPLEX(SKERA.out.segmented, params.cdna_adapters)

    // remove concatemers and keep polyA tails
    ISOSEQ_REFINE(LIMA_CDNA_DEMULTIPLEX.out.fl, params.cdna_adapters)

    // merge SMRT cells

    // cluster
    //ISOSEQ_CLUSTER2(?)

    // convert bam to fasta
    //PBTK(ISOSEQ_CLUSTER2.out.clustered_bam)

    // isoquant: annotated gene, isoform, exon and intron quantification
    //ISOQUANT(PBTK.out)

    // map to reference genome
    //PBMM2_INDEX(params.genome)
    //PBMM2_ALIGN(ISOSEQ_CLUSTER2.out.clustered_bam, PBMM2_INDEX.out.indexed_genome)

    // collapse into unique isoforms
    //ISOSEQ_COLLAPSE(PBMM2_ALIGN.out.aligned, ISOSEQ_CLUSTER2.out.clustered_bam)

    // classify isoforms

}