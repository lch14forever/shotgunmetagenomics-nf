// kraken2
params.outdir = './kraken2_out'

process KRAKEN2 {
    tag "${prefix}"
    cpus 8
    publishDir params.outdir, mode: 'copy'

    input:
    file index_path
    tuple prefix, file(reads1), file(reads2)

    output:
    file("${prefix}*")

    script:
    """
    kraken2 \\
    --db $index_path \\
    --paired \\
    --threads $task.cpus \\
    --output ${prefix}.kraken2.out \\
    --report ${prefix}.kraken2.tsv \\
    $reads1 $reads2 \\
    --use-mpa-style
    """
}