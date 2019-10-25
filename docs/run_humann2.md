# Running HUMAnN2 with minimal disk usage

## Rationale

The [HUMAnN2](https://bitbucket.org/biobakery/humann2/wiki/Home) software runs the following workflow:

![](http://huttenhower.sph.harvard.edu/sites/default/files/humann2_diamond_500x500.jpg)

In the first step, it decompresses the fastq reads (if gzipped). If the reads are from the illumina casava v1.8+ format, it removes the space in each read's name to distinguish "read1" and "read2". Besides, the workflow produces a SAM file when mapping to the customized chocophlan database.

These steps could generate temporary files with size many times larger than the input files, which is unfriendly when running multiple samples.


## A quick and dirty fix

If we have run MetaPhlAn2 in prior, we can skip the taxonomic profiling step. Besides, we can modify the source code to let HUMAnN2 accept a SAM file from standard input -- this allows us to run the pangenome mapping step outside HUMAnN2 and pipe the generated SAM file to it.

### Run MetaPhlAn2

```sh
#!/bin/bash

read1=$1
read2=$2
prefix=$3
index_path=$4
pkl=$5
index=$6
cpu=8

metaphlan2.py ${reads1},${reads2} \
    --mpa_pkl ${index_path}/${pkl} \
    --bowtie2db ${index_path}/${index} \
    --bowtie2out ${prefix}.metaphlan2.bt2.bz2 \
    -s ${prefix}.metaphlan2.sam.bz2 \
    --nproc ${cpus} \
    --input_type multifastq \
    > ${prefix}.metaphlan2.tax 
```

### Building customized chocophlan pangenome database

```sh
#!/bin/bash

prefix=$1
humann2_nucleotide=$2
presence_threshold=0.01
humann2db_version='v0.1.1'

touch customized.ffn
mkdir index

for i in `awk -v threshold=${presence_threshold} ' $2>threshold {print $1}' ${prefix}.metaphlan2_tax | \
    grep -o "g__.*s__.*" |  \
    grep -v "t__" | \
    grep -v "unclassified" | \
    sed 's/|/./' `; \
do \
    FILE=${humann2_nucleotide}/${i}.centroids.${humann2db_version}.ffn.gz
    if [ -f "$FILE" ]; then
        zcat  $FILE >> customized.ffn; \
    fi
done 

bowtie2-build customized.ffn index/customized.ffn
rm  customized.ffn
```

### Modify HUMAnN2 code

#### humann2.py

```python
	...
	# Use the full path to the input file
    if args.input!='-':
        args.input=os.path.abspath(args.input)
	...
```

#### search/nucleotide.py

```python
	...
    if sam_alignment_file != '-':
        utilities.file_exists_readable(sam_alignment_file)
        file_handle_read=open(sam_alignment_file, "rt")
    else:
        file_handle_read=sys.stdin
	...
```

### Run HUMAnN2

```sh
#!/bin/bash

read1=$1
read2=$2
prefix=$3
humann2_protein=$4

cpus=8

zcat $reads1 $reads2 | \
    sed 's/ //g' | \
    bowtie2 -p $task.cpus -x index/customized.ffn -U - | \
    humann2 -i - \
    --output-basename ${prefix}.humann2 \
    --remove-temp-output \
    --input-format sam \
    --protein-database $humann2_protein \
    --threads $cpus \
    -o ./;

humann2_renorm_table --input ${prefix}.humann2_genefamilies.tsv \
    --output ${prefix}.humann2_genefamilies.relab.tsv \
    --units relab

humann2_renorm_table --input ${prefix}.humann2_pathabundance.tsv \
    --output ${prefix}.humann2_pathabundance.relab.tsv \
    --units relab 

```
