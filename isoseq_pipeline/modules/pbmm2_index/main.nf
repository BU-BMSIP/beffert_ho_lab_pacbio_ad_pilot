#!/usr/bin/env nextflow

process PBMM2_INDEX {
    conda "envs/pbmm2_env.yml"
    label "process_high"
    publishDir "${params.outdir}/aligned_reads"

    input:
    path(genome)

    output:
    path("${genome.baseName}.mmi"), emit: indexed_genome

    shell:
    """
    pbmm2 index --preset ISOSEQ -j 8 $genome ${genome.baseName}.mmi
    """
}