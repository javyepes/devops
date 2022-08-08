#!/bin/bash

workload=$1
env=$2

deploy_ml () {
  echo -e "terraform -chdir=workloads/ml-test apply"
  if [[ -z "$env" ]];
    export TF_env=dev
  else
    export TF_ENV=$2
  fi
  terraform -chdir=workloads/ml-test apply
}

echo -e "usage\n\t./deploy.sh WORKLOAD ENV\n\t e.g. deploy.sh deploy_ml dev"
echo "deploying $1 in $2"

$workload
