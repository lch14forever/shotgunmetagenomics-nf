// decontamination

params.index = 'hg19.fa'
params.outdir = './'

process DECONT {
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
    fastp -i $reads1 -I $reads2 --stdout -j ${prefix}.json -h ${prefix}.html | \\
    bwa mem -p -t $task.cpus ${index_path}/${params.index} - | \\
    samtools fastq -f12 -F256  -1  ${prefix}_fastpdecont_1.fastq.gz -2 ${prefix}_fastpdecont_2.fastq.gz -
    """
}