// kraken2
params.outdir = './kraken2_out'

process KRAKEN2 {
    tag "${prefix}"
    cpus 8
    publishDir "$params.outdir/kraken2_out", mode: 'copy'

    input:
    file index_path
    tuple prefix, file(reads1), file(reads2)

    output:
    tuple prefix, file("${prefix}.kraken2.report")
    tuple file("${prefix}.kraken2.out"), file("${prefix}.kraken2.tsv")

    script:
    """
    kraken2 \\
    --db $index_path \\
    --paired \\
    --threads $task.cpus \\
    --output ${prefix}.kraken2.out \\
    --report ${prefix}.kraken2.tsv \\
    $reads1 $reads2 \\
    --use-mpa-style \\

    ### run again for bracken
    kraken2 \\
    --db $index_path \\
    --paired \\
    --threads $task.cpu \\
    --report ${prefix}.kraken2.report \\
    $reads1 $reads2 \\
    --output -
    """
}

process BRACKEN {
    tag "${prefix}"
    cpus 1
    publishDir "${params.outdir}/braken_out", mode: 'copy'

    input:
    file index_path  // This must have the bracken database
    tuple prefix, file(kraken2_report)
    each tax

    output:
    tuple file("${prefix}*.tsv")
    
    script:
    """
    TAX=$tax; \\
    
    bracken -d $index_path \\
    -i $kraken2_report \\
    -o ${prefix}.bracken.${tax} \\
    -l \${TAX^^}; \\
    
    sed 's/ /_/g' ${prefix}.bracken.${tax} | \\
    tail -n+2 | \\
    cut -f 1,7 > ${prefix}.${tax}.tsv
    """
}