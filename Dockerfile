FROM ubuntu:14.04

####################
# Dependencies
####################

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        autoconf automake curl gcc liboauth-dev libssl-dev \
        libsasl2-dev libtool patch python ntp unzip \
        libboost-all-dev pkg-config git build-essential && \
     rm -rf /var/lib/apt/lists/*


####################
# Building Kudu
####################

ENV KUDU_VERSION=master \
    KUDU_HOME=/usr/local/kudu
ENV PATH=$PATH:$KUDU_HOME/thirdparty/installed/bin:$KUDU_HOME/build/latest

# Note: git and build-essential are required to build Kudu from source
RUN git clone https://github.com/cloudera/kudu.git $KUDU_HOME && \
    cd $KUDU_HOME && \
    ./thirdparty/build-if-necessary.sh && \
    cmake . && \
    make -j8 && \
    make install

VOLUME /data/kudu-master /data/kudu-tserver

####################
# PORTS
####################
#
# https://github.com/cloudera/kudu/blob/master/docs/installation.adoc
#
# TabletServer:
#   7050 = TabletServer RPC Port
#   8050 = TabletServer Web UI
# Kudu Master:
#   7051 = Master RPC Port
#   8051 = Master Web UI
#

ENV KUDU_OPTS=""

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
EXPOSE 8050 8051
CMD ["help"]
