readarray cudavers < <(source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/cuda_vers.sh)
echo "cudavers: ${cudavers[@]}"
# printf '%s\n' "${myarray[0]}"