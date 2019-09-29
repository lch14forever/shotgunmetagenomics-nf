#!/usr/bin/env nextflow

// DSL 2 syntax
nextflow.preview.dsl=2


// parameters
params.help       = false
params.read_path  = "${workflow.projectDir}/data"
params.ref_path   = '/data/nucleotide/'
params.bwa_index  = 'hg19.fa'
params.outdir     = './pipeline_output'

// import modules
include './modules/decont' params(index: "$params.bwa_index", outdir: "$params.outdir")


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
      --outdir                  Output directory [Default: ./pipeline_output]
    Decontamination arguments:
      --ref_path                Path to the host reference database
      --bwa_index               BWA index prefix for the host
      =========================================================================================================================================
    """.stripIndent()
}
if (params.help){
    helpMessage()
    exit 0
}

// data channels
ch_index = file(params.ref_path)
ch_reads = Channel
    .fromFilePairs(params.read_path + '/**{1,2}.f*q*', flat: true)

// processes
workflow{
    DECONT(ch_index, ch_reads).view()
}