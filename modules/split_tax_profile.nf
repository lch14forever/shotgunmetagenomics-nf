params.outdir = './'
params.profiler = 'metaphlan2'

process SPLIT_PROFILE {
    tag "${params.profiler}|${prefix}"
    publishDir "${params.outdir}/split_${params.profiler}_out", mode: 'copy'

    input:
    tuple val(prefix), file(profile)
    output:
    tuple val(prefix), file("${prefix}*.tsv")

    shell:
    '''
    grep -v '^#' !{profile}   \\
      | sed -E 's/.*\\|//'  \\
      | awk -v prefix=!{prefix} '{var=substr($0, 1,1); print >prefix"."var".tsv"} '
    '''
}