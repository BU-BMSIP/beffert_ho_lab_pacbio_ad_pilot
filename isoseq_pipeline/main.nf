#!/usr/bin/env nextflow
include { LIMA_DEMULTIPLEX } from './modules/lima_demultiplex'
include { ISOSEQ_REFINE } from './modules/isoseq_refine'

workflow{

    Channel.fromPath(params.samplesheet)
        | splitCsv( header: true )
        | map{ row -> file(row.bam_path) }
        | flatten()
        | set{ bam_ch }

    bam_ch.combine(Channel.of(params.adapters))
        |set{ bam_adapter_ch }

    // need to undo demultiplexing first
    //LIMA_DEMULTIPLEX(bam_adapter_ch)

    ISOSEQ_REFINE(bam_adapter_ch)
}