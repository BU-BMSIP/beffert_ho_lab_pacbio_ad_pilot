#!/usr/bin/env nextflow

workflow{

    Channel.fromPath(params.samplesheet)
        | splitCsv( header: true )
        | map{ row -> file(row.path) }
        | flatten()
        | toList()
        | set{ bam_ch }


    
}