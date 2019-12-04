# Run shotgunmetagenomics pipeline on AWS

## GIS configuration profile

An IAM with all needed permission has been created.

## Databases 

All the databases were stored at `s3://csb5-nextflow-ref/` (`$REF_BUCKET` below)

decont_refpath = "$REF_BUCKET/hg19/"
decont_index = 'hg19.fa'
kraken2_index = "$REF_BUCKET/minikraken2_v2_8GB_201904_UPDATE"
metaphlan2_refpath = "$REF_BUCKET/metaphlan2/"
metaphlan2_index = 'mpa_v20_m200'
metaphlan2_pkl = 'mpa_v20_m200.pkl'
humann2_nucleotide = '$REF_BUCKET/humann2/chocophlan'
humann2_protein = '$REF_BUCKET/humann2/uniref'
srst2_ref = $REF_BUCKET/srst2/ARGannot_r3.fasta'

## Run command

You can use the helper script to generate runnable command:

```sh
$ shotgunmetagenomics-nf/utils/create_batch_config.sh AWS_PROFILE READ_PATH
```

**Note**: The `AWS_PROFILE` is the aws-cli configuration profile (set by `aws configure`) and has the value `default` if not set with `aws configure --profile AWS_PROFILE`.
