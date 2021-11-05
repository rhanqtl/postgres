#!/usr/bin/env bash

PROJECT_DIR_BASENAME="postgres"

while [[ "${PWD}" != "/" && $(basename "${PWD}") != "${PROJECT_DIR_BASENAME}" ]]; do
  cd ..
done

if [[ "${PWD}" == "/" ]]; then
  echo "please run the script in ${PROJECT_DIR_BASENAME}/"
  exit 1
fi

if [[ ! -f build.sh || ! -f init.sh ]]; then
  echo "build.sh or init.sh not found"
  exit 1
fi

run_mode='cluster'
if [[ "$#" -lt 0 ]]; then
  case "$1" in
    -s|--single)
      run_mode='single'
      ;;
    -c|--cluster)
      run_mode='cluster'
      ;;
    *)
      echo "unrecognized option"
      exit 1
      ;;
  esac
fi

export PROJECT_DIR=$(realpath .)
export OUTPUT_DIR="${PROJECT_DIR}"/output
export BUILD_DIR="${OUTPUT_DIR}"/build
export INSTALL_DIR="${OUTPUT_DIR}"/pgsql

export BASE_DIR="/tmp/postgres"
if [[ "${run_mode}" == 'single' ]]; then
  export MASTER_DATA_DIR="${BASE_DIR}"/data
elif [[ "${run_mode}" == 'cluster' ]]; then
  export MASTER_DATA_DIR="${BASE_DIR}"/master/data
  export SLAVE_DATA_DIR="${BASE_DIR}"/slave/data
fi
export OWNER="${USER}"
export OWN_GROUP=$(groups "${OWNER}" | awk '{ print $3 }')

bash build.sh && bash init.sh "${run_mode}"
