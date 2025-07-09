#!/usr/bin/env nextflow

include { LIMA_SMARTBELL_DEMULTIPLEX } from './modules/lima_smartbell_demultiplex'
include { SKERA } from './modules/skera'
include { LIMA_CDNA_DEMULTIPLEX } from './modules/lima_cdna_demultiplex'
include { ISOSEQ_REFINE } from './modules/isoseq_refine'
include { ISOQUANT } from './modules/isoquant'
include { PBMM2_INDEX } from './modules/pbmm2_index'
include { PBMM2_ALIGN } from './modules/pbmm2_align'
include { ISOSEQ_COLLAPSE } from './modules/isoseq_collapse'
include { SAMTOOLS_MERGE } from './modules/samtools_merge'
include { SAMTOOLS_FASTQ } from './modules/samtools_fastq'
include { GFFREAD } from './modules/gffread'
include { STRINGTIE } from './modules/stringtie'
include { STRINGTIE_MERGE } from './modules/stringtie_merge'
include { STRINGTIE_ABUNDANCE } from './modules/stringtie_abundance'
include { GFFCOMPARE } from './modules/gffcompare'

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

    // remove concatemers and keep polyA tails
    ISOSEQ_REFINE(bam_cdna_demux_ch, params.cdna_adapters)

    // merge smrtcell technical replicates
    ISOSEQ_REFINE.out.flnc
        | map { bam ->
            def file = bam[1]
            def filename = file.getName()
            def matcher = (filename =~ /IsoSeqX_(bc\d+)_5p--IsoSeqX_3p\.flnc\.bam/)
            def bc = matcher.find() ? matcher.group(1) : 'unknown'
            tuple(bc, file)
        }
        | groupTuple()
        | set{ tech_rep_merge_ch }
    SAMTOOLS_MERGE(tech_rep_merge_ch) // sort first?

    // map to reference genome
    PBMM2_INDEX(params.genome)
    PBMM2_ALIGN(SAMTOOLS_MERGE.out, PBMM2_INDEX.out.indexed_genome)

    // isoform discovery and counts matrix generation [annotated gene, isoform, exon and intron quantification]
    // def alignedList = PBMM2_ALIGN.out.aligned
    // def names  = alignedList.map{ it[0] }.collect()
    // def bams = alignedList.map{ it[1] }.collect()
    // def bais = alignedList.map{ it[2] }.collect() 
    // ISOQUANT(names, bams, bais, params.gtf, params.genome)

    // isoquant transcriptome GTF to FASTA
    //GFFREAD(ISOQUANT.out.combined_gtf, params.genome)
    //GFFREAD(params.isoquant_gtf, params.genome)

    // generate fastq
    SAMTOOLS_FASTQ(PBMM2_ALIGN.out.aligned)

    // stringtie 
    STRINGTIE(PBMM2_ALIGN.out.aligned, params.gtf)
    STRINGTIE_MERGE(STRINGTIE.out.stringtie_gtf.collect(), params.gtf)
    STRINGTIE_ABUNDANCE(PBMM2_ALIGN.out.aligned, STRINGTIE_MERGE.out.merged_gtf)

    // gffcompare?
    //GFFCOMPARE(params.gtf, ISOQUANT.out.combined_gtf, STRINGTIE_MERGE.out.merged_gtf)

    // salmon

    // more analyses
    // isoformswitchanalyzer, deseq2, drimseq, dexseq, pbfusion

    // viz
    // swan or ggtranscript or itv
}

//Duration: 5h 11m 32s from start to PBMM2_ALIGN
//Isoquant takes HOURS
//StringTie steps take ~30mins