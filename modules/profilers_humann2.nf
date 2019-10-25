params.outdir = './humann2_out'
params.presence_threshold = '0.01'
params.humann2db_version = 'v0.1.1'

process HUMANN2_INDEX {
    tag "${prefix}"

    input:
    file humann2_nucleotide
    tuple prefix, file(metaphlan2_tax)

    output:
    tuple prefix, file("index")

    script:
    """
    touch customized.ffn; \\
    mkdir index; \\

    for i in `awk -v threshold=${params.presence_threshold} ' \$2>threshold {print \$1}' $metaphlan2_tax | \\
        grep -o "g__.*s__.*" |  \\
        grep -v "t__" | \\
        grep -v "unclassified" | \\
        sed 's/|/./' `; \\
    do \\
        FILE=${humann2_nucleotide}/\${i}.centroids.${params.humann2db_version}.ffn.gz
        if [ -f "\$FILE" ]; then
           zcat  \$FILE >> customized.ffn; \\
        fi
    done ; \\

    bowtie2-build customized.ffn index/customized.ffn; \\

    rm  customized.ffn
    """

}

process HUMANN2 {
    tag "${prefix}"
    publishDir "$params.outdir/humann2_out", mode: 'copy'

    input:
    file humann2_protein
    tuple prefix, file(reads1), file(reads2), file(index)

    output:
    tuple prefix, file("${prefix}.humann2_*.tsv")

    script:
    """
    zcat $reads1 $reads2 | \\
    sed 's/ //g' | \\
    bowtie2 -p $task.cpus -x ${index}/customized.ffn -U - | \\
    humann2 -i - \\
    --output-basename ${prefix}.humann2 \\
    --remove-temp-output \\
    --input-format sam \\
    --protein-database $humann2_protein \\
    --threads $task.cpus \\
    -o ./;

    humann2_renorm_table --input ${prefix}.humann2_genefamilies.tsv \\
    --output ${prefix}.humann2_genefamilies.relab.tsv \\
    --units relab; \\

    humann2_renorm_table --input ${prefix}.humann2_pathabundance.tsv \\
    --output ${prefix}.humann2_pathabundance.relab.tsv \\
    --units relab 
    """
}
