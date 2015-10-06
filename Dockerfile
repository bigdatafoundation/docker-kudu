FROM ubuntu:14.04


####################
# Dependencies
####################

# Note: git is required to download the Kudu sources
#       (e.g. it is not a dependency of Kudu itself)

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        autoconf automake curl gcc liboauth-dev libssl-dev \
        libsasl2-dev libtool patch python ntp unzip \
        libboost-all-dev pkg-config git && \
    echo TEMPORARY_DISABLED_FOR_TESTING rm -rf /var/lib/apt/lists/*

# CMake and its dependencies
# (Ubuntu 14.04 only ships with CMake 2.8.12, and Kudu requires version 3.2.3)
# Source: http://askubuntu.com/questions/610291/how-to-install-cmake-3-2-on-ubuntu-14-04/652321
#
ENV CMAKE_VERSION	3.2.3
ENV CMAKE_HOME		/usr/local/cmake


RUN apt-get install -y build-essential wget && \
    cd   /tmp && \
    wget http://www.cmake.org/files/v3.2/cmake-$CMAKE_VERSION.tar.gz && \
    tar  -xzf cmake-$CMAKE_VERSION.tar.gz && \
    rm   cmake-$CMAKE_VERSION.tar.gz && \
    mv   cmake-$CMAKE_VERSION $CMAKE_HOME && \
    cd   $CMAKE_HOME && \
    ./configure && \
    make && \
    make install



####################
# Building Kudu
####################

ENV KUDU_VERSION	master
ENV KUDU_HOME		/usr/local/kudu
ENV PATH		$PATH:$KUDU_HOME/build/latest

RUN git clone https://github.com/cloudera/kudu.git $KUDU_HOME && \
    cd $KUDU_HOME && \
    ./thirdparty/build-if-necessary.sh && \
    cmake . && \
    make -j8 && \
    make install


####################
# PORTS
####################
#
# https://github.com/cloudera/kudu/blob/master/docs/installation.adoc
# 
# TabletServer:
# 	 8050 = TabletServer Web UI
# 	 8051 = Master Web UI
#
EXPOSE 8050 8051
