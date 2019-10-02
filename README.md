# Shotgun Metagnomics Pipeline

## Description

This is a [Nextflow](https://www.nextflow.io/) re-implementation of the [original pipeline](https://github.com/lch14forever/shotgun-metagenomics-pipeline) used by [Computational and Systems Biology Group 5 (CSB5)](http://csb5.github.io/) at the [Genome Institute of Singapore (GIS)](https://www.a-star.edu.sg/gis).

[中文文档](README_CN.md)

## Features
 - The new DSL2 syntax for pipeline modularity
 - Dockerfile for each software
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
 - [Kraken2](https://ccb.jhu.edu/software/kraken2/) (>=2.0.8-beta): Taxonomic profiling
 - MetaPhlAn2: Taxonomic profiling
 - SRST2: Resistome profiling
 - HUMAnN2: Pathway analysis


## Usage

Run using attached testing dataset

```sh
$ shotgunmetagenomics-nf/main.nf
N E X T F L O W  ~  version 19.09.0-edge
Launching `./main.nf` [cheesy_volhard] - revision: dc7259a08e
WARN: DSL 2 IS AN EXPERIMENTAL FEATURE UNDER DEVELOPMENT -- SYNTAX MAY CHANGE IN FUTURE RELEASE
executor >  local (8)
[d4/2492b7] process > DECONT (SRR1950772)  [100%] 2 of 2 ✔
[3f/d7402d] process > KRAKEN2 (SRR1950772) [100%] 2 of 2 ✔
[de/a05395] process > BRAKEN (SRR1950772)  [100%] 4 of 4 ✔
Completed at: 02-Oct-2019 16:21:34
Duration    : 3m 47s
CPU hours   : 0.5
Succeeded   : 8
```

For the full help information, use

```
$ shotgunmetagenomics-nf/main.nf --help
```

## Usage cases
 - Chng *et al*. Whole metagenome profiling reveals skin microbiome dependent susceptibility to atopic dermatitis flares. *Nature Microbiology* (2016)
 - Chng *et al*. Cartography of opportunistic pathogens and antibiotic resistance genes in a tertiary hospital environment. *BioRxiv* (2019)

## Contact

Chenhao Li: lich@gis.a-star.edu.sg, lichenhao.sg@gmail.com