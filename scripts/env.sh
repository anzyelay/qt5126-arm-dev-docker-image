#!/bin/bash

export TOOLCHAIN=/opt/toolchain/gcc-linaro-7.2.1-2017.11-x86_64_arm-linux-gnueabihf

export QT_ROOT=/opt/qt5126

export SYSROOT=/opt/sysroot

export CROSS_COMPILE=arm-linux-gnueabihf-

export PATH=$QT_ROOT/bin:$TOOLCHAIN/bin:$PATH

export PKG_CONFIG_SYSROOT_DIR=$SYSROOT

export PKG_CONFIG_PATH=\
$SYSROOT/usr/lib/pkgconfig:\
$SYSROOT/usr/share/pkgconfig

export PKG_CONFIG_LIBDIR=\
$SYSROOT/usr/lib/pkgconfig

export LD_LIBRARY_PATH=$QT_ROOT/lib:$LD_LIBRARY_PATH
