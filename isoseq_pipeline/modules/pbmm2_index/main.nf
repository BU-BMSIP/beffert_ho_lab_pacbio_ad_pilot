#!/usr/bin/env nextflow

process PBMM2_INDEX {
    conda "envs/pbmm2_env.yml"
    label "process_high"
    publishDir params.outdir

    input:
    path(genome)

    output:
    path("${genome.baseName}.mmi"), emit: indexed_genome

    shell:
    """
    pbmm2 index --preset ISOSEQ -j $task.cpus $genome ${genome.baseName}.mmi
    """
}