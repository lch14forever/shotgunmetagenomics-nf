params.outdir = './'

process SPLIT_PROFILE {
    tag "${profiler}|${prefix}"
    publishDir "${params.outdir}/split_${profiler}_out", mode: 'copy'

    input:
    tuple prefix, file(profile)
    val profiler
    output:
    tuple prefix, file("${prefix}*.tsv")

    script:
    """
    grep -v '^#' $profile   \\
      | sed -E 's/.*\\|//'  \\
      | awk -v prefix=$prefix '{var=substr(\$0, 0,1); print >prefix"."var".tsv"} '
    """
}