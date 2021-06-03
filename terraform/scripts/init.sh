#!/bin/bash

source .env

cd ./terraform

pwd

terraform init \
    -input=true \
    -backend-config="bucket=${TF_VAR_BACKEND_CONFIG_BUCKET}" \
    -backend-config="key=${TF_VAR_BACKEND_CONFIG_KEY}"
