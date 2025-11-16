#!/bin/bash
# reference: https://suzuki-shunsuke.github.io/tfcmt/terragrunt-run-all

set -euo pipefail

command=$1
shift || true

base_dir=$(git rev-parse --show-toplevel)
target=${PWD#"$base_dir"/}

target=${target%%/.terragrunt-cache/*}

if [ "$command" == "plan" ]; then
  tfcmt -var "target:${target}" plan -patch -- terraform "$command" "$@"
elif [ "$command" == "apply" ]; then
  tfcmt -var "target:${target}" apply -patch -- terraform "$command" "$@"
else
  terraform "$command" "$@"
fi