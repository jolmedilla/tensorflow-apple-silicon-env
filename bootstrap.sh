#!/usr/bin/env bash
set -e

if [ -d env/apple ]; then
  echo "Existing environment, we will not re-create it"
  exit 0
fi

ARCH=$(uname -m)
if [[ "$ARCH" != "arm64" ]]; then
  echo "This environment is for Apple Silicon only"
  exit 1
fi

mkdir -p mamba
curl -Ls https://micro.mamba.pm/api/micromamba/osx-arm64/latest \
  | tar -xvj -C mamba --strip-components=1 bin/micromamba

./mamba/micromamba create \
  -y \
  -p ./env/apple \
  -f environment.yml
