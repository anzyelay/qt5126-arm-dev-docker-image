#!/bin/bash

QT_SRC=/opt/qt-everywhere-src-5.12.6

SPEC=$QT_SRC/qtbase/mkspecs/linux-arm-gnueabihf-g++

mkdir -p ${SPEC}

cp \
    ${QT_SRC}/qtbase/mkspecs/linux-g++/qplatformdefs.h \
    ${SPEC}
