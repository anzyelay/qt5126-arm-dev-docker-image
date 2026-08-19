# qt5126-arm-dev

Qt 5.12.6 ARM Cross Compile Docker Environment

## Components

- Qt 5.12.6
- QtMqtt
- gcc-linaro-7.2.1-2017.11
- arm-linux-gnueabihf
- OpenSSL
- SQLite
- CMake
- Ninja

## Build Image

```bash
docker build -t qt5126-arm-dev .
```

## Run Container

将目标板 rootfs 挂载到容器：

```bash
docker run -it \
    -v ~/rootfs:/opt/sysroot \
    -v $(pwd):/workspace \
    qt5126-arm-dev
```

## Verify Environment

```bash
source /opt/scripts/env.sh

arm-linux-gnueabihf-gcc -v

qmake -v
```

## Example Project

```pro
QT += core gui widgets network mqtt serialport svg sql

TARGET = mqtt_demo

TEMPLATE = app

SOURCES += main.cpp
```

如果工程依赖目标板库：

```pro
INCLUDEPATH += /opt/sysroot/usr/include

LIBS += \
    -L/opt/sysroot/usr/lib \
    -lssl \
    -lcrypto \
    -lmosquitto
```

编译：

```bash
qmake

make -j$(nproc)
```

检查生成文件：

```bash
file mqtt_demo
```

预期输出：

```text
ELF 32-bit LSB executable
ARM
EABI5
```
