#!/bin/bash

set -e

source /opt/scripts/env.sh

cd /opt

if [ ! -d qtmqtt ]; then
    git clone https://github.com/qt/qtmqtt.git
fi

cd qtmqtt

git fetch --tags

git checkout v5.12.6

${QT_ROOT}/bin/qmake

make -j$(nproc)

make install
