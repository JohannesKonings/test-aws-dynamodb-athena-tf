#!/bin/bash

source .env

aws s3 rm s3://$TF_VAR_S3_BUCKET_NAME --recursive