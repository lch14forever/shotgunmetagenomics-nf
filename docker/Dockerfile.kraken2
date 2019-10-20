FROM ubuntu:18.04
MAINTAINER Chenhao Li

RUN apt-get update --fix-missing

ENV VERSION=2.0.8-beta
RUN apt-get install -y curl
RUN apt-get install -y build-essential 
RUN curl -L https://github.com/DerrickWood/kraken2/archive/v${VERSION}.tar.gz > /tmp/kraken2-$VERSION.tar.gz && \
    cd /tmp && tar xfv kraken2-$VERSION.tar.gz && rm kraken2-$VERSION.tar.gz && \
    cd kraken2-$VERSION && ./install_kraken2.sh /usr/local/bin/ && \
    cd /tmp && rm -rf kraken2-$VERSION

ENV VERSION=2.5
RUN curl -L https://github.com/jenniferlu717/Bracken/archive/v${VERSION}.tar.gz > /tmp/bracken-$VERSION.tar.gz && \
    cd /tmp && tar xvf bracken-${VERSION}.tar.gz && rm bracken-${VERSION}.tar.gz && \
    cd Bracken-${VERSION} && sh ./install_bracken.sh && \
    mv bracken-build bracken src /usr/local/bin && \
    cd /tmp && rm -rf Braken-$VERSION
RUN apt-get install -y python3
RUN ln -s /usr/bin/python3 /usr/bin/python

RUN apt-get clean -y && \
    apt-get autoremove -y


RUN useradd -ms /bin/bash biodev
RUN echo 'biodev:biodev' | chpasswd
USER biodev
WORKDIR /home/biodev
