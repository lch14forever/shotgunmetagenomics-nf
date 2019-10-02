#!/usr/bin/env nextflow

// DSL 2 syntax
nextflow.preview.dsl=2


// parameters inputs
params.help           = false
params.read_path      = "${workflow.projectDir}/data"

// parameters outputs
params.outdir         = './pipeline_output'

// parameters decont
params.decont_refpath = '/data/nucleotide/'
params.decont_index   = 'hg19.fa'

// parameters kraken2
params.kraken2_index  = '/data/minikraken2_v2_8GB_201904_UPDATE/'

// import modules
include './modules/decont' params(index: "$params.decont_index", outdir: "$params.outdir")
include './modules/profilers_kraken2' params(outdir: "$params.outdir")


// help message
def helpMessage() {
    log.info"""
    =========================================================================================================================================
    Usage:
    The typical command for running the pipeline is as follows:
      nextflow run ${workflow.projectDir}/main.nf  --read_path PATH_TO_READS
    Input arguments:
      --read_path               Path to a folder containing all input fastq files (this will be recursively searched for *fastq.gz/*fq.gz/*fq/*fastq files) [Default: ${workflow.projectDir}]
    Output arguments:
      --outdir                  Output directory [Default: ./pipeline_output/]
    Decontamination arguments:
      --decont_ref_path         Path to the host reference database
      --decont_index            BWA index prefix for the host
    Kraken2 arguments:
      --kraken2_index           Path to the kraken2 database
    =========================================================================================================================================
    """.stripIndent()
}
if (params.help){
    helpMessage()
    exit 0
}

// data channels
ch_bwa_idx = file(params.decont_refpath)
ch_reads = Channel
    .fromFilePairs(params.read_path + '/**{1,2}.f*q*', flat: true)

ch_kraken_idx = file(params.kraken2_index)

// processes
workflow{
    DECONT(ch_bwa_idx, ch_reads)
    KRAKEN2(ch_kraken_idx, DECONT.out[0])
    BRAKEN(ch_kraken_idx, KRAKEN2.out[0], Channel.from('s', 'g'))
}