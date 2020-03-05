/* Computing alpha/beta diversity based on minmum metadata
This is an independent module (workflow) computing the diversity of samples. It automatically generate a report (rmarkdown + rendered html) for the alpha and beta diversity computed from a list of samples.
*/

nextflow.preview.dsl = 2
params.outdir = './'
params.profiler = 'metaphlan2'
params.project  = 'shotgunmetagenomics-nf'

// input data
params.metadata = false  // The sample metadata file (csv or tsv). Contains sample IDs and at least one column of metadata information.
params.sampleid = '1' //  Specify the column number for the sample IDs. Default is 1.
params.tax_profiles = false
params.template = false 

process REPORT_DIVERSITY {
    tag "${params.profiler}"
    publishDir "${params.outdir}/report_diversity_${params.profiler}_out", mode: 'copy'
    stageInMode "copy"
    
    // beforeScript = { ". /mnt/software/unstowable/miniconda3-4.6.14/etc/profile.d/conda.sh; conda activate shotgunMetagenomics_r_v3.6.0 " }
    input:
    file(profiles)
    file(metadata)
    file(template)
    
    output:
    file("${params.project}.html")

    script:
    """
    Rscript -e \'rmarkdown::render(\"$template\", \
    params = list( profile_list = \"$profiles\", metadata = \"$metadata\"),\
    output_file = \"${params.project}.html\")\'
    """
}

workflow report {
    ch_tax = Channel
        .fromPath("${params.tax_profiles}/*g.tsv", checkIfExists: true)
	.map {x -> x.path}
	.collectFile(name: "${params.profiler}.output.txt", newLine: true)
    ch_template = Channel.fromPath("$params.template", checkIfExists: true)
    ch_metadata = Channel.fromPath("$params.metadata", checkIfExists: true)
    REPORT_DIVERSITY(ch_tax, ch_metadata, ch_template)
}
