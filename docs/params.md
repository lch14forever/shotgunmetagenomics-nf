# nf-core/shotgunmetagenomics: parameters

## Show all available parameters:

- `--help`: List all available parameters and the default values

## Input arguments:

- `--read_path`: Path to a folder containing all input fastq files (this will be recursively searched for *fastq.gz/*fq.gz/*fq/*fastq files)
- `--reads`: Glob pattern to match reads, e.g. '/path/to/reads_*{R1,R2}.fq.gz' (this must be **quoted** and is in conflict with `--read_path`)

## Output arguments:

- `--outdir`: Pipeline output directory

## Decontamination arguments:

- `--decont_off`: Skip trimming and decontamination
- `--decont_ref_path`: Path to the host reference database
- `--decont_index`: BWA index prefix for the host

## Profiler configuration:

- `--profilers`: Metagenomics profilers to run. This can be empty, i.e. only run decontamination or a list of profilers delimited with `,`, e.g. `metaphlan2,humann2,kraken2`. By default, the pipeline runs all available profilers.

## Kraken2 arguments:

- `--kraken2_index`: Path to the kraken2 database

## MetaPhlAn2 arguments:

- `--metaphlan2_ref_path`: Path to the metaphlan2 database
- `--metaphlan2_index`: Bowtie2 index prefix for the marker genes
- `--metaphlan2_pkl`: Python pickle file for marker genes

## HUMAnN2 arguments:

- `--humann2_nucleotide`: Path to humann2 chocophlan database
- `--humann2_protein`: Path to humann2 protein database

## SRST2 arguments:

- `--srst2_ref`: Fasta file used for srst2

## AWSBatch options:

- `--awsqueue`:  The AWSBatch JobQueue that needs to be set when running on AWSBatch
- `--awsregion`: The AWS Region for your AWS Batch job to run on

