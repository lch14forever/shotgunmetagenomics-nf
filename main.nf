#!/usr/bin/env nextflow

// DSL 2 syntax
nextflow.preview.dsl=2

// import modules
include './modules/decont'


// reads
params.path = '/data/reads/'

// data channels
ch_index = file('/data/nucleotide/')

ch_reads = Channel
    .fromFilePairs(params.path + '/**{1,2}.f*q*', flat: true)


// processes
workflow{
    DECONT(ch_index, ch_reads).view()
}