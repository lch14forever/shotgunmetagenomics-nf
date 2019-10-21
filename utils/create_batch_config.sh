#!/bin/bash
## Usage ./create_batch_config.sh AWS-PROFILE READ-PATH BUCKET-FOR-REF
## Assume there is an aws configuration for the IAM

BASE_DIR=$(readlink -f "$0")
PROJECT_DIR=$(dirname $(dirname $BASE_DIR))

PROFILE=$1
READ_PATH=$2
REF_BUCKET=$3

echo "### Run the followings to configure your AWS IAM ###"
cat ~/.aws/credentials | paste - - -  | grep $PROFILE | cut -f 2- | sed 's/aws_access_key_id = //' | sed 's/aws_secret_access_key = //' | \
while read k1 k2;do
    echo export AWS_ACCESS_KEY_ID=$k1
    echo export AWS_SECRET_ACCESS_KEY=$k2
done

echo "### Use the following template to run the pipeline (provide --awsregion and --awsqueue) ###"
echo $PROJECT_DIR/main.nf -params-file pipeline_params.yaml -profile awsbatch -w s3://csb5-nextflow-work/scratch --awsregion ap-southeast-1 --awsqueue nextflow

cat <<EOF > pipeline_params.yaml
read_path          : "$READ_PATH"
decont_refpath     : "$REF_BUCKET/hg19/"
decont_index       : 'hg19.fa'
kraken2_index      : "$REF_BUCKET/minikraken2_v2_8GB_201904_UPDATE"
metaphlan2_refpath : "$REF_BUCKET/metaphlan2/"
metaphlan2_index   : 'mpa_v20_m200'
metaphlan2_pkl     : 'mpa_v20_m200.pkl'
EOF
