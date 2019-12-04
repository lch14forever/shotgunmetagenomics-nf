# Run shotgunmetagenomics pipeline on GIS cluster

## GIS configuration profile

Activate with `--profile gis`. This uses miniconda (`/mnt/software/unstowable/miniconda3-4.6.14/`) and the configured environments to execute the pipeline.

## Databases (assigned when using `--profile gis`)

```
decont_refpath = '/mnt/genomeDB/genomeIndices/hg19/bwa_index/nucleotide/'
decont_index   = 'hg19.fa'
kraken2_index  = '/mnt/genomeDB/misc/softwareDB/kraken2/minikraken2_v2_8GB_201904_UPDATE'
metaphlan2_refpath = '/mnt/genomeDB/misc/softwareDB/metaphlan2/db_v20/'
metaphlan2_index   = 'mpa_v20_m200'
metaphlan2_pkl     = 'mpa_v20_m200.pkl'
humann2_nucleotide = '/mnt/genomeDB/misc/softwareDB/humann2/chocophlan/'
humann2_protein    = '/mnt/genomeDB/misc/softwareDB/humann2/uniref/'
srst2_ref = '/mnt/genomeDB/misc/softwareDB/srst2/ARGannot_r3.fasta'
```

## Run command

```sh
$ shotgunmetagenomics-nf/main.nf -profile gis --read_path PATH_TO_READS
```
