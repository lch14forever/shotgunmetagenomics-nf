// kraken2
params.outdir = './kraken2_out'

process KRAKEN2 {
    tag "${prefix}"
    publishDir "$params.outdir/kraken2_out", mode: 'copy'

    input:
    file index_path
    tuple prefix, file(reads1), file(reads2)

    output:
    tuple prefix, file("${prefix}.kraken2.report")
    tuple prefix, file("${prefix}.kraken2.tax")
    file "${prefix}.kraken2.out"

    script:
    """
    kraken2 \\
    --db $index_path \\
    --paired \\
    --threads $task.cpus \\
    --output ${prefix}.kraken2.out \\
    --report ${prefix}.kraken2.tax \\
    $reads1 $reads2 \\
    --use-mpa-style \\

    ### run again for bracken
    kraken2 \\
    --db $index_path \\
    --paired \\
    --threads $task.cpus \\
    --report ${prefix}.kraken2.report \\
    $reads1 $reads2 \\
    --output -
    """
}

process BRACKEN {
    tag "${prefix}"
    publishDir "${params.outdir}/braken_out", mode: 'copy'

    input:
    file index_path  // This must have the bracken database
    tuple prefix, file(kraken2_report)
    each tax

    output:
    file "${prefix}*.tsv"
    
    script:
    """
    TAX=$tax; \\
    
    bracken -d $index_path \\
    -i $kraken2_report \\
    -o ${prefix}.bracken.${tax} \\
    -l \${TAX^^}; \\
    
    sed 's/ /_/g' ${prefix}.bracken.${tax} | \\
    tail -n+2 | \\
    cut -f 1,7 > ${prefix}.bracken.${tax}.tsv
    """
}