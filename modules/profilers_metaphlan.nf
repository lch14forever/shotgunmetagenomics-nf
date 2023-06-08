params.outdir = './metaphlan_out'
params.pkl    = 'mpa_v20_m200.pkl'

process METAPHLAN {
    tag "${prefix}"
    publishDir "$params.outdir/metaphlan_out", mode: 'copy'

    input:
    file index_path
    tuple val(prefix), file(reads1), file(reads2)

    output:
    tuple val(prefix), file("${prefix}.metaphlan.tax")
    tuple val(prefix), file("${prefix}.metaphlan.sam.bz2") 
    
    script:
    """
    metaphlan ${reads1},${reads2} \\
    --bowtie2db ${index_path} \\
    --bowtie2out ${prefix}.metaphlan.bt2.bz2 \\
    -s ${prefix}.metaphlan.sam.bz2 \\
    --nproc $task.cpus \\
    --input_type fastq \\
    > ${prefix}.metaphlan.tax 
    """
}

process SAMPLE2MARKER {
    tag "${prefix}"
    publishDir "$params.outdir/strainphlan_out", mode: 'copy'

    input:
    tuple val(prefix), file(metaphlan_sam)

    output:
    file "${prefix}.metaphlan.markers"

    script:
    """
    sample2markers.py \\
    --ifn_samples $metaphlan_sam \\
    --input_type sam \\
    --output_dir .
    """    
}

process STRAINPHLAN {
    tag ""
    publishDir "$params.outdir/strainphlan_out", mode: 'copy'

    input:
    file index_path
    file(metaphlan_markers)

    output:
    file "results"

    script:
    """
    strainphlan.py \\
    --ifn_samples ${metaphlan_markers} \\
    --output_dir results \\
    --nprocs_main $task.cpus \\
    --mpa_pkl ${index_path}/${params.pkl} \\
    --relaxed_parameters3
    """    
    
}