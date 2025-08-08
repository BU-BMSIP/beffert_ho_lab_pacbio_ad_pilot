#!/usr/bin/env nextflow

process GFFCOMPARE {
    label "process_high"
    conda "envs/gffcompare_env.yml"
    publishDir "${params.outdir}/gffcompare"

    input:
    path(stringtie_gtf)
    path(ref_gtf)

    output:
    path("*")

    shell:
    """
    gffcompare -r $ref_gtf -V $stringtie_gtf
    awk 'BEGIN {print "metric\tvalue"};
     /Base level/{print "base_sensitivity\t"$4 "\n" "base_precision\t"$6};
     /Exon level/{print "exon_sensitivity\t"$4 "\n" "exon_precision\t"$6};
     /Transcript level/{print "transcript_sensitivity\t"$4 "\n" "transcript_precision\t"$6}' \
     gffcmp.stats > gffcompare_metrics.tsv
    """
}