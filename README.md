# Shotgun Metagnomics Pipeline

## Description

This is a [Nextflow](https://www.nextflow.io/) re-implementation of the [original pipeline](https://github.com/lch14forever/shotgun-metagenomics-pipeline) used by [Computational and Systems Biology Group 5 (CSB5)](http://csb5.github.io/) at the [Genome Institute of Singapore (GIS)](https://www.a-star.edu.sg/gis).

[中文文档](README_CN.md)

## Development plan
 - [x] Add customized HUMAnN2 to a conda channel
 - [ ] Add nf-core style documentation
   - [x] [Output description](docs/output.md)
   - [ ] Installation
   - [ ] Usage
   - [ ] Reference databases

## Features
 - The new DSL2 syntax for pipeline modularity and reusabiligy
 - Dockerfile for each software (all containers can be found at [DockerHub](https://hub.docker.com/u/lichenhao))
 - Conda recipe for each software/step
 - Configuration for local execution (server), GIS HPC (using SGE schedular), AWS batch and AWS auto-scaling cluster


## Dependencies

### Main pipeline
 - [Nextflow](https://www.nextflow.io/)
 - Java Runtime Environment >= 1.8

### Quality control and host DNA decontamination
 - [Fastp](https://github.com/OpenGene/fastp) (>=0.20.0): Adapter trimming, low quality base trimming
 - [BWA](https://github.com/lh3/bwa) (>=0.7.17): Host DNA removal
 - [Samtools](https://github.com/samtools/samtools) (>=1.7): Host DNA removal

### Reference based analysis
 - [Kraken2](https://ccb.jhu.edu/software/kraken2/) (>=2.0.8-beta) + [Bracken](https://ccb.jhu.edu/software/bracken/) (>=2.5): Taxonomic profiling
 - [MetaPhlAn2](https://bitbucket.org/biobakery/metaphlan2/src/default/) (>=2.7.7): Taxonomic profiling
 - [HUMAnN2](https://bitbucket.org/biobakery/humann2/wiki/Home) (>=2.8.1): Pathway analysis. The following two files are modified to read a SAM file from standard input (See [Running HUMAnN2 with reduced disk storage](docs/run_humann2.md)):
   - `humann2.py`
   - `search/nucleotide.py`
 - [SRST2](https://github.com/katholt/srst2#installation) (=0.2.0): Resistome profiling



## Usage

Run using attached testing dataset

```sh
$ shotgunmetagenomics-nf/main.nf -profile test
N E X T F L O W  ~  version 19.09.0-edge
Launching `./main.nf` [cheesy_volhard] - revision: dc7259a08e
WARN: DSL 2 IS AN EXPERIMENTAL FEATURE UNDER DEVELOPMENT -- SYNTAX MAY CHANGE IN FUTURE RELEASE
executor >  local (8)
[d4/2492b7] process > DECONT (SRR1950772)  [100%] 2 of 2 ✔
[3f/d7402d] process > KRAKEN2 (SRR1950772) [100%] 2 of 2 ✔
[de/a05395] process > BRACKEN (SRR1950772) [100%] 4 of 4 ✔
Completed at: 02-Oct-2019 16:21:34
Duration    : 3m 47s
CPU hours   : 0.5
Succeeded   : 8
```

For the full help information, use

```sh
$ shotgunmetagenomics-nf/main.nf --help

N E X T F L O W  ~  version 19.09.0-edge
Launching `shotgunmetagenomics-nf/main.nf` [fabulous_feynman] - revision: e8ec2a095b
WARN: DSL 2 IS AN EXPERIMENTAL FEATURE UNDER DEVELOPMENT -- SYNTAX MAY CHANGE IN FUTURE RELEASE
###############################################################################

      +++++++++++++++++'++++
      ++++++++++++++++''+'''
      ++++++++++++++'''''''+
      ++++++++++++++''+'++++
      ++++++++++++++''''++++
      +++++++++++++'++''++++
      ++++++++++++++++++++++       ++++++++:,   +++   ++++++++
      +++++++++++++, +++++++     +++.  .'+++;  +++  :+++   '++
      ++++++ ``'+`  ++++++++   +++'        ';  +++  +++      +
      ++++`   +++  +++++++++  +++              +++  +++:
      ++,  ,+++`  ++++++++++  ++;              +++    ++++
      +, ;+++  + .++++++++++  +++     .++++++  +++       ++++
      + `++;  ++  +++++;;+++  +++         +++  +++          '++,
      + :;   +++, ;++; ;++++  ;++;        +++  +++           +++
      +: ,+++++++;,;++++++++   `+++;      +++  +++  +.      ;++,
      ++++++++++++++++++++++      ++++++++++   +++   ++++++++.
===============================================================================
    CSB5 Shotgun Metagenomics Pipeline [version 0.0.1dev]
Usage:
The typical command for running the pipeline is as follows:
  nextflow run /mnt/projects/lich/stooldrug/scratch/shotgunmetagenomics-nf/main.nf  --read_path PATH_TO_READS

Input arguments:
  --read_path               Path to a folder containing all input fastq files (this will be recursively searched for *fastq.gz/*fq.gz/*fq/*fastq files) [Default: false]
  --reads                   Glob pattern to match reads, e.g. '/path/to/reads_*{R1,R2}.fq.gz' (this is in conflict with `--read_path`) [Default: false]
  
Output arguments:
  --outdir                  Output directory [Default: ./pipeline_output/]

Decontamination arguments:
  --decont_ref_path         Path to the host reference database
  --decont_index            BWA index prefix for the host

Profiler configuration:
  --profilers               Metagenomics profilers to run [Default: kraken2,metaphlan2,humann2]

Kraken2 arguments:
  --kraken2_index           Path to the kraken2 database

MetaPhlAn2 arguments:
  --metaphlan2_ref_path     Path to the metaphlan2 database
  --metaphlan2_index        Bowtie2 index prefix for the marker genes [Default: mpa_v20_m200]
  --metaphlan2_pkl          Python pickle file for marker genes [mpa_v20_m200.pkl]

HUMAnN2 arguments:
  --humann2_nucleotide      Path to humann2 chocophlan database
  --humann2_protein         Path to humann2 protein database

AWSBatch options:
  --awsqueue                The AWSBatch JobQueue that needs to be set when running on AWSBatch
  --awsregion               The AWS Region for your AWS Batch job to run on
###############################################################################
```

Run on GIS cluster

```sh
$ shotgunmetagenomics-nf/main.nf -profile gis --read_path PATH_TO_READS
```

Run with docker

```sh
$ shotgunmetagenomics-nf/main.nf -profile docker --read_path PATH_TO_READS
```

Run on AWS batch ([AWS batch configuration tutorial](https://t-neumann.github.io/pipelines/AWS-pipeline/))

 - IAM configuration (set environment variables AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_DEFAULT_REGION)
 - Batch compute environment & job queue
 - Customized AMI (AWS ECS optimized linux + awscli installed with *miniconda*)

```sh
$ shotgunmetagenomics-nf/main.nf -profile test,awsbatch --awsqueue AWSBATCH_QUEUE --awsregion AWS_REGION -w S3_BUCKET --outdir S3_BUCKET 
```

You can specifiy multiple profiles separated by comma, e.g. `-profile docker,test`.

Run multiple profilers
```sh
$ shotgunmetagenomics-nf/main.nf -profile gis --profilers kraken2,metaphlan2 --read_path PATH_TO_READS
```

## Usage cases
 - Chng *et al*. Whole metagenome profiling reveals skin microbiome dependent susceptibility to atopic dermatitis flares. *Nature Microbiology* (2016)
 - Nandi *et al*. Gut microbiome recovery after antibiotic usage is mediated by specific bacterial species. *BioRxiv* (2018)
 - Chng *et al*. Cartography of opportunistic pathogens and antibiotic resistance genes in a tertiary hospital environment. *BioRxiv* (2019)

## Adding a module

1. Write a module and put it into `modules/`
1. Add to the main script `main.nf`
1. Modify the configuration file `conf/base.config` to add resources required (for GIS users, modify `conf/gis.config` as well for the specific conda envrionment)
1. Add conda and docker files for the new module

## Contact

Chenhao Li: lich@gis.a-star.edu.sg, lichenhao.sg@gmail.com
