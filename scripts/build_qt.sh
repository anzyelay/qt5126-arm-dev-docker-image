#!/bin/bash

set -e

QT_VERSION=5.12.6

cd /opt

if [ ! -d qt-everywhere-src-${QT_VERSION} ]; then

    wget -O qt.tar.xz \
    https://download.qt.io/archive/qt/5.12/${QT_VERSION}/single/qt-everywhere-src-${QT_VERSION}.tar.xz

    tar -xf qt.tar.xz

fi

cd qt-everywhere-src-${QT_VERSION}

mkdir -p build

cd build

../configure \
    -opensource \
    -confirm-license \
    -release \
    -shared \
    -prefix /opt/qt5126 \
    -xplatform linux-arm-gnueabihf-g++ \
    -device-option CROSS_COMPILE=arm-linux-gnueabihf- \
    -nomake examples \
    -nomake tests \
    -skip qt3d \
    -skip qtdeclarative \
    -skip qtquickcontrols \
    -skip qtquickcontrols2 \
    -skip qtgamepad \
    -skip qtlocation \
    -skip qtpurchasing \
    -skip qtremoteobjects \
    -skip qtscript \
    -skip qtvirtualkeyboard \
    -skip qtwebengine \
    -make libs

make -j$(nproc)

make install
