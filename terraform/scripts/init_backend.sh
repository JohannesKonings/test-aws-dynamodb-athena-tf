#!/bin/bash

source .env

cd ./terraform

pwd

terraform init

terraform apply \
    -no-color \
    -auto-approve \
    -target=aws_s3_bucket.terraform-state-storage-s3
