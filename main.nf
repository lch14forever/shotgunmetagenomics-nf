#!/usr/bin/env nextflow

// DSL 2 syntax
nextflow.preview.dsl=2

// help message
params.help = false
def helpMessage() {
    log.info"""
    ###############################################################################

          +++++++++++++++++'++++
          ++++++++++++++++''+'''
          ++++++++++++++'''''''+
          ++++++++++++++''+'++++
          ++++++++++++++''''++++
          +++++++++++++'++''++++
          ++++++++++++++++++++++       ++++++++:,   +++   ++++++++
          +++++++++++++, +++++++     +++.  .'+++;  +++  :+++   '++
          ++++++ ``'+`  ++++++++   +++'        ';  +++  +++      +
          ++++`   +++  +++++++++  +++              +++  +++:
          ++,  ,+++`  ++++++++++  ++;              +++    ++++
          +, ;+++  + .++++++++++  +++     .++++++  +++       ++++
          + `++;  ++  +++++;;+++  +++         +++  +++          '++,
          + :;   +++, ;++; ;++++  ;++;        +++  +++           +++
          +: ,+++++++;,;++++++++   `+++;      +++  +++  +.      ;++,
          ++++++++++++++++++++++      ++++++++++   +++   ++++++++.
    ===============================================================================
        CSB5 Shotgun Metagenomics Pipeline [version ${params.pipelineVersion}]

    Usage:
    The typical command for running the pipeline is as follows:
      nextflow run ${workflow.projectDir}/main.nf  --read_path PATH_TO_READS
    Input arguments:
      --read_path               Path to a folder containing all input fastq files (this will be recursively searched for *fastq.gz/*fq.gz/*fq/*fastq files) [Default: ${workflow.projectDir}/data]
    Output arguments:
      --outdir                  Output directory [Default: ./pipeline_output/]
    Decontamination arguments:
      --decont_ref_path         Path to the host reference database
      --decont_index            BWA index prefix for the host
    Kraken2 arguments:
      --kraken2_index           Path to the kraken2 database
    ###############################################################################
    """.stripIndent()
}
if (params.help){
    helpMessage()
    exit 0
}

if( ! nextflow.version.matches(">= $params.nf_required_version") ){
   log.error "[Assertion error] Nextflow version $params.nf_required_version required! You are running v$workflow.nextflow.version!\n" 
}

// *Decont specific (remove if you don't need decont)* //
if (!params.containsKey('decont_refpath') | !params.containsKey('decont_index')){
   exit 1, "[Assertion error] Please provide the BWA index path for the host using `--decont_refpath` and `--decont_index`!\n"
}
if (!file("${params.decont_refpath}/${params.decont_index}").exists()){
   exit 1, "[Assertion error] Cannot find the BWA index in the ${params.decont_refpath}"
}
ch_bwa_idx = file(params.decont_refpath)

// *Kraken2 specific (remove if you don't need kraken2)* //
if (!params.containsKey('kraken2_index')){
   exit 1, "[Assertion error] Please provide the Kraken2 index path using `--kraken2_index`!\n"
}
if (!file("${params.decont_refpath}/${params.decont_index}").exists()){
   exit 1, "[Assertion error] Cannot find the BWA index in the ${params.decont_refpath}"
}
ch_kraken_idx = file(params.kraken2_index)

// *MetaPhlAn2 specific (remove if you don't need MetaPhlAn2)* //
// TODO

// *HUMAnN2 specific (remove if you don't need HUMAnN2)* //
// TODO

ch_reads = Channel
    .fromFilePairs(params.read_path + '/**{1,2}.f*q*', flat: true, checkIfExists: true)

// import modules
include './modules/decont' params(index: "$params.decont_index", outdir: "$params.outdir")
include './modules/profilers_kraken2_bracken' params(outdir: "$params.outdir")
include './modules/split_tax_profile' params(outdir: "$params.outdir")


// processes
workflow{
    DECONT(ch_bwa_idx, ch_reads)
    KRAKEN2(ch_kraken_idx, DECONT.out[0])
    BRACKEN(ch_kraken_idx, KRAKEN2.out[0], Channel.from('s', 'g'))
    SPLIT_PROFILE(KRAKEN2.out[1], 'kraken2')
}
