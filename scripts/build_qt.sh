#!/bin/bash

set -e

QT_VERSION=5.12.6

cd /opt

if [ ! -d qt-everywhere-src-${QT_VERSION} ]; then

    wget -O qt.tar.xz \
    https://download.qt.io/archive/qt/5.12/${QT_VERSION}/single/qt-everywhere-src-${QT_VERSION}.tar.xz

    tar -xf qt.tar.xz

    QT_SRC=/opt/qt-everywhere-src-5.12.6

    SPEC=$QT_SRC/qtbase/mkspecs/devices/linux-arm-gnueabihf-g++

    mkdir -p ${SPEC}

    cp \
        ${QT_SRC}/qtbase/mkspecs/devices/linux-arm-generic-g++/qplatformdefs.h \
        ${SPEC}

    cat << EOF >> ${SPEC}/qmake.conf

QT_QPA_DEFAULT_PLATFORM = linuxfb
MAKEFILE_GENERATOR      = UNIX
CONFIG                 += incremental gdb_dwarf_index
QMAKE_INCREMENTAL_STYLE = sublib

include(../../common/linux.conf)
include(../../common/gcc-base-unix.conf)
include(../../common/g++-unix.conf)

load(device_config)

# modifications to g++.conf
QMAKE_CC                = $${CROSS_COMPILE}gcc
QMAKE_CXX               = $${CROSS_COMPILE}g++
QMAKE_LINK              = $${QMAKE_CXX}
QMAKE_LINK_SHLIB        = $${QMAKE_CXX}

# modifications to linux.conf
QMAKE_AR                = $${CROSS_COMPILE}ar cqs
QMAKE_OBJCOPY           = $${CROSS_COMPILE}objcopy
QMAKE_NM                = $${CROSS_COMPILE}nm -P
QMAKE_STRIP             = $${CROSS_COMPILE}strip

# modifications to gcc-base.conf
QMAKE_AR_LTCG           = $${CROSS_COMPILE}gcc-ar cqs
QMAKE_NM_LTCG           = $${CROSS_COMPILE}gcc-nm -P

contains(DISTRO_OPTS, deb-multi-arch):  QMAKE_PKG_CONFIG = $${CROSS_COMPILE}pkg-config

QMAKE_CFLAGS           += -march=armv7-a -DLINUX=1
QMAKE_CXXFLAGS         += -march=armv7-a -DLINUX=1

include(../common/linux_device_post.conf)

load(qt_config)

EOF

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
