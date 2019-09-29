# Shotgun Metagnomics Pipeline

## Description

This is a [Nextflow](https://www.nextflow.io/) re-implementation of the [original pipeline](https://github.com/lch14forever/shotgun-metagenomics-pipeline) used by [Computational and Systems Biology Group 5 (CSB5)](http://csb5.github.io/) at the [Genome Institute of Singapore (GIS)](https://www.a-star.edu.sg/gis).

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
 - Kraken2: Taxonomic profiling
 - MetaPhlAn2: Taxonomic profiling
 - SRST2: Resistome profiling
 - HUMAnN2: Pathway analysis


## Usage

```sh
shotgunmetagenomics-nf/main.nf
```


## Usage cases
 - Chng *et al*. Whole metagenome profiling reveals skin microbiome dependent susceptibility to atopic dermatitis flares. *Nature Microbiology* (2016)
 - Chng *et al*. Cartography of opportunistic pathogens and antibiotic resistance genes in a tertiary hospital environment. *BioRxiv* (2019)