########################################
# Stage 1
########################################

FROM ubuntu:20.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    wget \
    curl \
    perl \
    python3 \
    flex \
    bison \
    gperf \
    cmake \
    ninja-build \
    rsync \
    unzip \
    xz-utils \
    pkg-config \
    libgl1-mesa-dev \
    libglib2.0-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libssl-dev \
    sqlite3 \
    libsqlite3-dev \
    ca-certificates

WORKDIR /opt

RUN git clone --depth 1 \
    https://github.com/orangepi-xunlong/toolchain.git

ENV TOOLCHAIN=/opt/toolchain/gcc-linaro-7.2.1-2017.11-x86_64_arm-linux-gnueabihf
ENV QT_ROOT=/opt/qt5126
ENV CROSS_COMPILE=arm-linux-gnueabihf-

ENV PATH=${QT_ROOT}/bin:${TOOLCHAIN}/bin:$PATH

COPY scripts /opt/scripts

RUN chmod +x /opt/scripts/*.sh

RUN /opt/scripts/build_qt.sh

RUN /opt/scripts/build_qtmqtt.sh

#########################################################
# Stage 2 only copy needed files to reduce the image size
#########################################################
# use this image as base image because of it contains all compononts needed by codespaces 
FROM mcr.microsoft.com/devcontainers/base:ubuntu-20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    vim \
    bash-completion \
    openssh-server \
    sudo \
    git \
    cmake \
    ninja-build \
    make \
    perl \
    python3 \
    pkg-config \
    libfontconfig1 \
    libfreetype6 \
    sqlite3 \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder \
    /opt/toolchain/gcc-linaro-7.2.1-2017.11-x86_64_arm-linux-gnueabihf \
    /opt/toolchain/gcc-linaro-7.2.1-2017.11-x86_64_arm-linux-gnueabihf

COPY --from=builder \
    /opt/qt5126 \
    /opt/qt5126

COPY --from=builder \
    /opt/scripts/env.sh \
    /opt/scripts/env.sh

ENV TOOLCHAIN=/opt/toolchain/gcc-linaro-7.2.1-2017.11-x86_64_arm-linux-gnueabihf

ENV QT_ROOT=/opt/qt5126

ENV CROSS_COMPILE=arm-linux-gnueabihf-

ENV PATH=${QT_ROOT}/bin:${TOOLCHAIN}/bin:$PATH

RUN echo "source /opt/scripts/env.sh" >> /root/.bashrc

WORKDIR /workspace

CMD ["/bin/bash"]
