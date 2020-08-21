// kraken2
params.outdir = './kraken2_out'

process KRAKEN2 {
    tag "${prefix}"
    publishDir "$params.outdir/kraken2_out", mode: 'copy'

    input:
    file index_path
    tuple prefix, file(reads1), file(reads2)

    output:
    tuple prefix, file("${prefix}.kraken2.tax")
    tuple prefix, file("${prefix}.kraken2.report")
    // file "${prefix}.kraken2.out.gz" // This is not necessary...

    script:
    """
    kraken2 \\
    --db $index_path \\
    --paired \\
    --threads $task.cpus \\
    --output ${prefix}.kraken2.out \\
    --report ${prefix}.kraken2.report \\
    $reads1 $reads2 

    ### Convert kraken report to mpa file
    kreport2mpa.py \\
     -r ${prefix}.kraken2.report \\
     -o ${prefix}.kraken2.tax \\
     --no-intermediate-ranks

    ### gzip ${prefix}.kraken2.out
    rm ${prefix}.kraken2.out
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
    TAX=$tax
    
    bracken -d $index_path \\
    -i $kraken2_report \\
    -o ${prefix}.bracken.${tax} \\
    -l \${TAX^^}
    
    sed 's/ /_/g' ${prefix}.bracken.${tax} | \\
    tail -n+2 | \\
    cut -f 1,7 > ${prefix}.bracken.${tax}.tsv
    """
}