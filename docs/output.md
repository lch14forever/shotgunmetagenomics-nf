# nf-core/shotgunmetagenomics: Output

This document describes the output produced by the pipeline. 

<!-- TODO nf-core: Write this documentation describing your workflow's output -->

## Pipeline overview
The pipeline is built using [Nextflow](https://www.nextflow.io/)
and processes data using the following steps:

- [Fastp](#fastp) - read quality control
- [Decontamination](#decontamination) - host DNA removal
- [Kraken2](#kraken2) - Reads classification with Kraken2
- [Bracken](#bracken) - Taxonomic profiling using Bracken
- [MetaPhlAn2](#metaphlan2) - Taxonomic profiling using MetaPhlAn2
- [HUMAnN2](#humann2) - Pathway profiling using HUMAnN2
- [SRST2](#srst2) - Resistome profiling with SRST2

## Fastp

[Fastp](https://github.com/OpenGene/fastp) performs adapter removal and low quality base trimming. This step is streamed to the next decontamination step.

**Output directory: `pipeline_output/decont/`**

* `sample.html` and `sample.json`
  * Fastp report

## Decontamination

This step takes the Fastp output, maps the reads to the host reference genome provided and outputs only the unmapped reads.

**Output directory: `pipeline_output/decont/`**

* `sample_fastpdecont_1.fastq.gz` and `sample_fastpdecont_2.fastq.gz`
  * Unmapped reads by the pipeline

## Kraken2

[Kraken2](https://ccb.jhu.edu/software/kraken2/) assign taxonomy to reads (read pairs) based on K-mer profile.

**Output directory: `pipeline_output/kraken2_out`**

* `sample.kraken2.report`
  * Plain text file for standard Kraken2 report
* `sample.kraken2.tax`
  * Plain text file for MetaPhlAn-like taxonomic profile (in read counts)

**Split table into taxonomic levels: `pipeline_output/split_kraken2_out`**

* `sample.[dpcofgs].tsv`
 * Plain text files for taxonomic profile at *d*omain, *p*hylum, *c*lass, *o*rder, *f*amily, *g*enus, *s*pecies, respectively

## Bracken

[Bracken](https://ccb.jhu.edu/software/bracken/) estimates relative abundances of taxa based on a Kraken2 report.

**Output directory: `pipeline_output/bracken_out`**

* `sample.bracken.g.tsv`
  * Tab-delimited text file for genus level relative abundances
* `sample.bracken.s.tsv`
  * Tab-delimited text file for species level relative abundances


## MetaPhlAn2

[MetaPhlAn2](https://bitbucket.org/biobakery/metaphlan2/) estimates relative abundances of taxa by mapping reads to clade-specific marker genes.

**Output directory: `pipeline_output/metaphlan2_out`**

* `sample.metaphlan2.tax`
  * Tab-delimited text file for the full taxonomic profile

**Split table into taxonomic levels: `pipeline_output/split_metaphlan2_out`**

* `sample.[dpcofgs].tsv`
 * Plain text files for taxonomic profile at *d*omain, *p*hylum, *c*lass, *o*rder, *f*amily, *g*enus, *s*pecies, respectively

## HUMAnN2

[HUMAnN2](https://bitbucket.org/biobakery/humann2/) estimates gene family and pathway abundances.

**Output directory: `pipeline_output/humann2_out`**

* `sample.humann2_genefamilies.tsv` and `sample.humann2_genefamilies.relab.tsv`
  * Tab-delimited text file for the raw and normalized gene family abundances
* `sample.humann2_pathabundance.tsv` and `sample.humann2_pathabundance.relab.tsv`
  * Tab-delimited text file for the raw and normalized pathway abundances
* `sample.humann2_pathcoverage.tsv`
  * Tab-delimited text file for the pathway coverage

## SRST2
[SRST2](https://github.com/katholt/srst2) reports the presence of antibiotics resistance genes.

**Output directory: `pipeline_output/srst2_out`**

* `sample__fullgenes__ARGannot.r3__results.txt`
  * Tab-delimited text file for the full report
* `sample__genes__ARGannot.r3__results.txt`
  * Tab-delimited text file for the simplified report
* `sample__ARGannot.r3__results.sorted.bam`
  * BAM file for alignments

See [here](https://github.com/katholt/srst2#gene-typing) for details





