params.outdir = './metaphlan2_out'
params.pkl    = 'mpa_v20_m200.pkl'

process METAPHLAN2 {
    tag "${prefix}"
    publishDir "$params.outdir/metaphlan2_out", mode: 'copy'

    input:
    file index_path
    tuple prefix, file(reads1), file(reads2)

    output:
    tuple prefix, file("${prefix}.metaphlan2.tax")
    tuple prefix, file("${prefix}.metaphlan2.sam.bz2") 
    
    script:
    """
    metaphlan2.py ${reads1},${reads2} \\
    --bowtie2db ${index_path} \\
    --bowtie2out ${prefix}.metaphlan2.bt2.bz2 \\
    -s ${prefix}.metaphlan2.sam.bz2 \\
    --nproc $task.cpus \\
    --input_type multifastq \\
    > ${prefix}.metaphlan2.tax 
    """
}

process SAMPLE2MARKER {
    tag "${prefix}"
    publishDir "$params.outdir/strainphlan_out", mode: 'copy'

    input:
    tuple prefix, file(metaphlan2_sam)

    output:
    file "${prefix}.metaphlan2.markers"

    script:
    """
    sample2markers.py \\
    --ifn_samples $metaphlan2_sam \\
    --input_type sam \\
    --output_dir .
    """    
}

process STRAINPHLAN {
    tag ""
    publishDir "$params.outdir/strainphlan_out", mode: 'copy'

    input:
    file index_path
    file(metaphlan2_markers)

    output:
    file "results"

    script:
    """
    strainphlan.py \\
    --ifn_samples ${metaphlan2_markers} \\
    --output_dir results \\
    --nprocs_main $task.cpus \\
    --mpa_pkl ${index_path}/${params.pkl} \\
    --relaxed_parameters3
    """    
    
}