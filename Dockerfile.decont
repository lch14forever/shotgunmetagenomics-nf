############################################################
# Dockerfile to build image for fastq preprocessing
# Based on ubuntu
# To build:
# cat Dockerfile | docker build -t decont -
# Ref: https://github.com/ddiez/samtools/blob/master/Dockerfile
############################################################

FROM ubuntu:18.04
MAINTAINER Chenhao Li

RUN apt-get update

ENV VERSION=1.9
RUN apt-get install -y curl gcc make bzip2 autoconf && \
    apt-get install -y zlib1g zlib1g-dev libncurses5 libncurses5-dev  && \
    apt-get install -y libbz2-1.0 libbz2-dev liblzma5 liblzma-dev && \
    apt-get install -y libcurl4 libcurl4-openssl-dev openssl libssl-dev && \
    curl -L https://github.com/samtools/samtools/releases/download/$VERSION/samtools-$VERSION.tar.bz2 > /tmp/samtools-$VERSION.tar.bz2 && \
    cd /tmp && tar xfjv samtools-$VERSION.tar.bz2 && rm samtools-$VERSION.tar.bz2 && \
    cd samtools-$VERSION && ./configure && make && make install && \
    cd /tmp && rm -rf samtools-$VERSION

ENV VERSION=0.20.0
RUN apt-get install -y g++ && \
    curl -L https://github.com/OpenGene/fastp/archive/v${VERSION}.tar.gz > /tmp/fastp-$VERSION.tar.gz && \
    cd /tmp && tar xvf fastp-$VERSION.tar.gz && rm fastp-$VERSION.tar.gz &&\
    cd fastp-$VERSION && make && make install && \
    cd /tmp && rm -rf fastp-$VERSION

ENV VERSION=0.7.17
RUN curl -L https://github.com/lh3/bwa/releases/download/v${VERSION}/bwa-${VERSION}.tar.bz2 > /tmp/bwa-${VERSION}.tar.bz2 && \
    cd /tmp && tar xfjv bwa-${VERSION}.tar.bz2 && rm bwa-${VERSION}.tar.bz2 && \
    cd bwa-${VERSION} && make && mv bwa /usr/local/bin/ && \
    cd /tmp && rm -rf bwa-${VERSION}

RUN apt-get clean -y && \
    apt-get purge -y g++ curl gcc make bzip2 autoconf zlib1g-dev libncurses5-dev libbz2-dev liblzma-dev libcurl4-openssl-dev libssl-dev && \
    apt-get autoremove -y



RUN useradd -ms /bin/bash biodev
RUN echo 'biodev:biodev' | chpasswd
USER biodev
WORKDIR /home/biodev