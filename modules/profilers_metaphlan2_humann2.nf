params.outdir = './humann2_out'

process HUMANN2 {
    tag "${prefix}"
    publishDir "$params.outdir/humann2_out", mode: 'copy'

    input:
    file humann2_nucleotide
    file humann2_protein
    tuple prefix, file(reads1), file(reads2)

    output:
    tuple prefix, file("${prefix}.humann2_genefamilies.tsv")
    tuple prefix, file("${prefix}.humann2_genefamilies.relab.tsv")
    tuple prefix, file("${prefix}.humann2_pathabundance.tsv")
    tuple prefix, file("${prefix}.humann2_pathabundance.relab.tsv")
    tuple prefix, file("${prefix}.humann2_pathcoverage.tsv")

    script:
    """
    cat $reads1 $reads2 > reads.fastq.gz

    humann2 -i reads.fastq.gz \\
    --output-basename ${prefix}.humann2 \\
    --remove-temp-output \\
    --nucleotide-database $humann2_nucleotide \\
    --protein-database $humann2_protein \\
    --threads $task.cpu; \\

    humann2_renorm_table --input ${prefix}.humann2_genefamilies.tsv \\
    --output ${prefix}.humann2_genefamilies.relab.tsv \\
    --units relab; \\

    humann2_renorm_table --input ${prefix}.humann2_pathabundance.tsv \\
    --output ${prefix}.humann2_pathabundance.relab.tsv \\
    --units relab 
    """
}
