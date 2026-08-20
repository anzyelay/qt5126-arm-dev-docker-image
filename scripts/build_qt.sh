#!/bin/bash

set -e

QT_VERSION=5.12.6

create_mkspec() {

    QT_SRC=/opt/qt-everywhere-src-${QT_VERSION}

    SPEC=$QT_SRC/qtbase/mkspecs/linux-arm-gnueabihf-g++

    mkdir -p ${SPEC}

    cp ${QT_SRC}/qtbase/mkspecs/linux-g++/qplatformdefs.h ${SPEC}

    cat > ${SPEC}/qmake.conf << 'EOF'
#
# qmake configuration for building with arm-linux-gnueabihf-g++
#
QT_QPA_DEFAULT_PLATFORM = linuxfb
MAKEFILE_GENERATOR = UNIX
CONFIG += incremental
QMAKE_INCREMENTAL_STYLE = sublib

include(../common/linux.conf)
include(../common/gcc-base-unix.conf)
include(../common/g++-unix.conf)

# modifications to g++.conf
QMAKE_CC = arm-linux-gnueabihf-gcc
QMAKE_CXX = arm-linux-gnueabihf-g++
QMAKE_LINK = arm-linux-gnueabihf-g++
QMAKE_LINK_SHLIB = arm-linux-gnueabihf-g++

# modifications to linux.conf
QMAKE_AR = arm-linux-gnueabihf-ar cqs
QMAKE_OBJCOPY = arm-linux-gnueabihf-objcopy
QMAKE_NM = arm-linux-gnueabihf-nm -P
QMAKE_STRIP = arm-linux-gnueabihf-strip

QMAKE_CFLAGS           += -march=armv7-a -DLINUX=1
QMAKE_CXXFLAGS         += -march=armv7-a -DLINUX=1

load(qt_config)
EOF
}

cd /opt

if [ ! -d qt-everywhere-src-${QT_VERSION} ]; then

    wget -O qt.tar.xz \
    https://download.qt.io/archive/qt/5.12/${QT_VERSION}/single/qt-everywhere-src-${QT_VERSION}.tar.xz

    tar -xf qt.tar.xz

    create_mkspec
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
    -no-opengl \
    -no-xcb \
    -no-gtk \
    -no-feature-xcb \
    -linuxfb \
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
