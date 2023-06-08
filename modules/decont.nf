// decontamination

params.index = 'hg19.fa'
params.outdir = './'

process DECONT {
    tag "${prefix}"
    publishDir "$params.outdir/decont", mode: 'copy'
    // on AWS batch the input are downloaded to a local tmp folder
    afterScript { workflow.profile == 'awsbatch'? "rm -v -f `readlink -f $reads1` `readlink -f $reads2`;" : 'echo "Local"'} 

    input:
    file index_path
    tuple val(prefix), file(reads1), file(reads2)

    output:
    tuple val(prefix), file("${prefix}*fastpdecont_1.fastq.gz"), file("${prefix}*fastpdecont_2.fastq.gz")
    tuple file("${prefix}.html"), file("${prefix}.json"), file("${prefix}*fastpdecont_single.fastq.gz")

    script:
    """
    fastp -i $reads1 -I $reads2 --stdout -j ${prefix}.json -h ${prefix}.html | \\
    bwa mem -k 19 -p -t $task.cpus ${index_path}/${params.index} - | \\
    decont_filter.py | \\
    samtools fastq -f12 -F256  -1  ${prefix}_fastpdecont_1.fastq.gz -2 ${prefix}_fastpdecont_2.fastq.gz -s ${prefix}_fastpdecont_single.fastq.gz  - 
    """
}