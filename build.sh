#!/usr/bin/env bash

# NOTE: DO NOT run this script alone!

set -e

if [[ -z $(egrep '^output/$' .gitignore) ]]; then
  echo -e '\n# NOTE: DO NOT change following lines manually'
  echo 'output/' >> .gitignore
fi

mkdir -p "${BUILD_DIR}"
mkdir -p "${INSTALL_DIR}"

cd "${BUILD_DIR}"

sh ../../configure --prefix="${INSTALL_DIR}" CFLAGS='-O0 -ggdb -fno-inline' CXXFLAGS='-O0 -ggdb -fno-inline'

make && make install
