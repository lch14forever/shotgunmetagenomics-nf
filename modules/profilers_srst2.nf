params.outdir = './srst2_out'

process SRST2 {
    tag "${prefix}"
    publishDir "$params.outdir/srst2_out", mode: 'copy'

    input:
    file ref
    tuple prefix, file(reads1), file(reads2)

    output:
    tuple prefix, file("${prefix}.srst2*")
    
    script:
    """
    srst2 --input_pe ${reads1} ${reads2} \\
    --threads $task.cpus \\
    --log \\
    --gene_db ${ref} \\
    --read_type q \\
    --min_coverage 90 \\
    --output ${prefix}.srst2
    """
}
