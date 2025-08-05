#!/usr/bin/env nextflow

include { LIMA_SMARTBELL_DEMULTIPLEX } from './modules/lima_smartbell_demultiplex'
include { SKERA } from './modules/skera'
include { LIMA_CDNA_DEMULTIPLEX } from './modules/lima_cdna_demultiplex'
include { ISOSEQ_REFINE } from './modules/isoseq_refine'
include { PBMM2_INDEX } from './modules/pbmm2_index'
include { PBMM2_ALIGN } from './modules/pbmm2_align'
include { SAMTOOLS_FASTQ } from './modules/samtools_fastq'
include { KB_PYTHON } from './modules/kb_python'
include { KALLISTO_BUS } from './modules/kallisto_bus'
include { KALLISTO_QUANT_TCC } from './modules/kallisto_quant_tcc'
include { BUSTOOLS_COUNT } from './modules/bustools_count'
include { BUSTOOLS_SORT } from './modules/bustools_sort'

workflow{
    // format .bam files
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

    // map to reference genome
    // align and sort
    PBMM2_INDEX(params.genome)
    PBMM2_ALIGN(SAMTOOLS_MERGE.out, PBMM2_INDEX.out.indexed_genome)

    // lr-kallisto
    SAMTOOLS_FASTQ.out
        | map{
            fastq ->
            def name = fastq.baseName
            return tuple(name, fastq) }
        | set{ fastq_ch }

    //KB_PYTHON() // use stringtie generated .gtf??
    //KALLISTO_BUS(fastq_ch, params.kallisto_idx)
    //BUSTOOLS_SORT(KALLISTO_BUS.out.output_bus)
    //BUSTOOLS_COUNT(BUSTOOLS_SORT.out, KALLISTO_BUS.out.transcripts_txt, KALLISTO_BUS.out.matrix_ec, KB_PYTHON.out.t2g)
    //KALLISTO_QUANT_TCC(KALLISTO_BUS.out.transcripts_txt, BUSTOOLS_COUNT.out.counts_mtx, BUSTOOLS_COUNT.out.counts_ec, KALLISTO_BUS.out.flens_txt, params.gtf)

    // isoformswitchanalyzer
    // need module for generating fastas using R script
}