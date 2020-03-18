# Run shotgunmetagenomics pipeline on NSCC HPC

## NSCC configuration profile

Activate with `--profile nscc`. This uses miniconda (`/home/projects/14001280/software/anaconda3/`) and the configured environments to execute the pipeline.

## Databases (assigned when using `--profile nscc`)

```
decont_refpath = '/home/projects/14001280/software/genomeDB/genomeIndices/hg19/bwa_index/nucleotide/'
decont_index   = 'hg19.fa'
kraken2_index  = '/home/projects/14001280/software/genomeDB/misc/softwareDB/kraken2/minikraken2_v2_8GB_201904_UPDATE'
metaphlan2_refpath = '/home/projects/14001280/software/genomeDB/misc/softwareDB/metaphlan2/db_v20/'
metaphlan2_index   = 'mpa_v20_m200'
metaphlan2_pkl     = 'mpa_v20_m200.pkl'
humann2_nucleotide = '/home/projects/14001280/software/genomeDB/misc/softwareDB/humann2/chocophlan/'
humann2_protein    = '/home/projects/14001280/software/genomeDB/misc/softwareDB/humann2/uniref/'
srst2_ref = '/home/projects/14001280/software/genomeDB/misc/softwareDB/srst2/ARGannot_r3.fasta'
conda_init = '/home/projects/14001280/software/anaconda3/etc/profile.d/conda.sh'
```

## Run command

```sh
$ shotgunmetagenomics-nf/main.nf -profile nscc --read_path PATH_TO_READS
```
