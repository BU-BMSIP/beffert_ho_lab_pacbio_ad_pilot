#!/usr/bin/env nextflow

include { LIMA_SMARTBELL_DEMULTIPLEX } from './modules/lima_smartbell_demultiplex'
include { SKERA } from './modules/skera'
include { LIMA_CDNA_DEMULTIPLEX } from './modules/lima_cdna_demultiplex'
include { ISOSEQ_REFINE } from './modules/isoseq_refine'
include { PBMM2_INDEX } from './modules/pbmm2_index'
include { PBMM2_ALIGN } from './modules/pbmm2_align'
include { SAMTOOLS_MERGE } from './modules/samtools_merge'
include { SAMTOOLS_FASTQ } from './modules/samtools_fastq'
include { STRINGTIE } from './modules/stringtie'
include { STRINGTIE_MERGE } from './modules/stringtie_merge'
include { STRINGTIE_ABUNDANCE } from './modules/stringtie_abundance'
include { GFFCOMPARE } from './modules/gffcompare'
include { KB_PYTHON } from './modules/kb_python'
include { KALLISTO_BUS } from './modules/kallisto_bus'
include { BUSTOOLS_SORT } from './modules/bustools_sort'
include { BUSTOOLS_COUNT } from './modules/bustools_count'
include { KALLISTO_QUANT_TCC } from './modules/kallisto_quant_tcc'
include { MULTIQC } from './modules/multiqc'

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

    // merge technical replicates
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
    SAMTOOLS_MERGE(tech_rep_merge_ch)

    // map to reference genome
    // align and sort
    PBMM2_INDEX(params.genome)
    PBMM2_ALIGN(SAMTOOLS_MERGE.out, PBMM2_INDEX.out.indexed_genome)

    // generate fastq files for lr-kallisto
    SAMTOOLS_FASTQ(PBMM2_ALIGN.out.aligned)
    SAMTOOLS_FASTQ.out
        | map{
            fastq ->
            def name = fastq.baseName
            return tuple(name, fastq) }
        | set{ fastq_ch }

    // stringtie for novel transcript discovery and transcriptome annotated gtf creation
    STRINGTIE(PBMM2_ALIGN.out.aligned, params.gtf)
    STRINGTIE_MERGE(STRINGTIE.out.stringtie_gtf.collect(), params.gtf)
    STRINGTIE_ABUNDANCE(PBMM2_ALIGN.out.aligned, STRINGTIE_MERGE.out.merged_gtf)

    // run gffcompare on stringtie gtf file
    GFFCOMPARE(params.gtf, STRINGTIE_MERGE.out.merged_gtf)

    // lr-kallisto for isoform quantification
    // need to use kallisto_optoff_k64 binary
    KB_PYTHON(params.genome, params.gtf, params.transcriptome)
    KALLISTO_BUS(fastq_ch, params.kallisto_idx)
    BUSTOOLS_SORT(KALLISTO_BUS.out.output_bus)
    BUSTOOLS_COUNT(BUSTOOLS_SORT.out, KALLISTO_BUS.out.transcripts_txt, KALLISTO_BUS.out.matrix_ec, params.kallisto_t2g)
    KALLISTO_QUANT_TCC(KALLISTO_BUS.out.transcripts_txt, BUSTOOLS_COUNT.out.counts_mtx, BUSTOOLS_COUNT.out.counts_ec, KALLISTO_BUS.out.flens_txt, params.gtf)

}
