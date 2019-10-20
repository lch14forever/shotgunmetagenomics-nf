params.outdir = './metaphlan2_out'
params.index  = 'mpa_v20_m200'
params.pkl    = 'mpa_v20_m200.pkl'

process METAPHLAN2 {
    tag "${prefix}"
    publishDir "$params.outdir/metaphlan2_out", mode: 'copy'

    input:
    file index_path
    tuple prefix, file(reads1), file(reads2)

    output:
    tuple prefix, file("${prefix}.metaphlan2.tax")
    // tuple prefix, file("${prefix}.metaphlan2.sam.bz2") // might be needed for strainphlan in the future
    
    script:
    """
    metaphlan2.py ${reads1},${reads2} \\
    --mpa_pkl ${index_path}/${params.pkl} \\
    --bowtie2db ${index_path}/${params.index} \\
    --bowtie2out ${prefix}.metaphlan2.bt2.bz2 \\
    -s ${prefix}.metaphlan2.sam.bz2 \\
    --nproc $task.cpus \\
    --input_type multifastq \\
    > ${prefix}.metaphlan2.tax 
    """
}
