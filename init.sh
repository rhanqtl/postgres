#!/usr/bin/env bash

# NOTE: DO NOT run this script alone!

set -e

if [[ -d "${BASE_DIR}" ]]; then
  rm -rf "${BASE_DIR}"/**
else
  mkdir "${BASE_DIR}"
fi

run_mode="$1"
if [[ "${run_mode}" != 'cluster' && "${run_mode}" != 'single' ]]; then
  echo 'unrecognized running mode'
  exit 1
fi

if [[ "${run_mode}" == 'cluster' ]]; then
  mkdir -p "${MASTER_DATA_DIR}"
  # mkdir -p "${SLAVE_DATA_DIR}"
  sudo -u "${OWNER}" touch "${BASE_DIR}"/master/postgres.log
  mkdir -p "${BASE_DIR}"/slave
  sudo -u "${OWNER}" touch "${BASE_DIR}"/slave/postgres.log
elif [[ "${run_mode}" == 'single' ]]; then
  mkdir -p "${MASTER_DATA_DIR}"
  sudo -u "${OWNER}" touch "${BASE_DIR}"/postgres.log
fi

sudo chown -R "${OWNER}":"${OWN_GROUP}" "${BASE_DIR}"

if [[ "${run_mode}" == 'cluster' ]]; then
  sudo -u "${OWNER}" "${INSTALL_DIR}"/bin/initdb --pgdata="${MASTER_DATA_DIR}" --encoding=UTF8 --no-locale
  # sudo -u "${OWNER}" "${INSTALL_DIR}"/bin/initdb --pgdata="${SLAVE_DATA_DIR}" --encoding=UTF8 --no-locale
elif [[ "${run_mode}" == 'single' ]]; then
  sudo -u "${OWNER}" "${INSTALL_DIR}"/bin/initdb --pgdata="${MASTER_DATA_DIR}" --encoding=UTF8 --no-locale
fi

# sudo -u postgres output/pgsql/bin/pg_ctl -D /tmp/postgres/data -l /tmp/postgres/postgres.log start
