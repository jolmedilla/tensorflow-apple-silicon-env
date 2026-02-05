#!/usr/bin/env bash
exec ./mamba/micromamba run \
  -p ./env/apple \
  jupyter lab
