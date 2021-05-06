#!/bin/bash

## https://stackoverflow.com/questions/9601800/print-only-parts-that-match-regex

declare -a cuda_vers=(`echo $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/cuda-cfg-[0-9]*.sh | grep -o -P "(\ *[0-9.]*sh)" | sed -r 's/\.sh//'`)
(>&2 echo -e "Total cuda_vers: ${#cuda_vers[@]}\n cuda_vers: ${cuda_vers[@]}")
for i in "${cuda_vers[@]}"; do
  (>&2 echo -e "i => $i")
done