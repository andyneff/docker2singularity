#!/usr/bin/env bash

set -eu

versions=(
  # v2.3
  # v2.4
  # v2.5
  v2.6
  # v3.1
  # v3.2.1
  # v3.3.0
  # v3.4.0
  # v3.4.1
  # v3.4.2
  # v3.5.0
)

for version in "${versions[@]}"; do
  docker build -t "vsiri/docker2singularity:${version}" --build-arg "SINGULARITY_VERSION=${version}" .
done

# for version in "${versions[@]}"; do
#   docker push "vsiri/docker2singularity:${version}"
# done