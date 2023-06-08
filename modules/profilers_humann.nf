params.outdir = './humann_out'
params.presence_threshold = '0.01'
params.humanndb_version = 'v201901_v31'

process HUMANN_INDEX {
    tag "${prefix}"

    input:
    file humann_nucleotide
    tuple val(prefix), file(metaphlan_tax)

    output:
    tuple val(prefix), file("index")

    script:
    """
    touch customized.ffn
    mkdir index

    for i in `awk -v threshold=${params.presence_threshold} ' \$3>threshold {print \$1}' $metaphlan_tax | \\
        grep -o "g__.*s__.*" |  \\
        grep -v "t__" | \\
        sed 's/|/./' `; \\
    do 
        FILE=${humann_nucleotide}/\${i}.centroids.${params.humanndb_version}.ffn.gz
        if [ -f "\$FILE" ]; then
           zcat  \$FILE >> customized.ffn
        fi
    done 

    bowtie2-build customized.ffn index/customized.ffn

    rm  customized.ffn
    """

}

process HUMANN {
    tag "${prefix}"
    publishDir "$params.outdir/humann_out", mode: 'copy'

    input:
    file humann_protein
    tuple val(prefix), file(reads1), file(reads2), file(index)

    output:
    tuple val(prefix), file("${prefix}.humann_*.tsv")

    script:
    """
    zcat $reads1 $reads2 | \\
    sed 's/ //g' | \\
    bowtie2 -p $task.cpus -x ${index}/customized.ffn -U - | \\
    humann -i - \\
    --output-basename ${prefix}.humann \\
    --remove-temp-output \\
    --input-format sam \\
    --protein-database $humann_protein \\
    --threads $task.cpus \\
    -o ./

    humann_renorm_table --input ${prefix}.humann_genefamilies.tsv \\
    --output ${prefix}.humann_genefamilies.relab.tsv \\
    --units relab

    humann_renorm_table --input ${prefix}.humann_pathabundance.tsv \\
    --output ${prefix}.humann_pathabundance.relab.tsv \\
    --units relab 
    """
}
