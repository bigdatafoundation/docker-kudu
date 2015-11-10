FROM centos:6.7


########################################
# Dependency: Java
########################################

ENV JAVA_VERSION	1.7.0

RUN yum install -y java-$JAVA_VERSION-openjdk java-$JAVA_VERSION-openjdk-devel



########################################
# Dependency: Impala
########################################
# Currently 
ENV IMPALA_VERSION	2.3.0

# Adds the "cdh5" repository required to install HDFS and Hive Metastore
# Adds the "impala-kudu" repository required to install a Kudu-compatible Impala version
RUN curl http://archive.cloudera.com/cdh5/redhat/6/x86_64/cdh/cloudera-cdh5.repo > /etc/yum.repos.d/cloudera-cdh5.repo  && \
    curl http://archive.cloudera.com/beta/impala-kudu/redhat/6/x86_64/impala-kudu/cloudera-impala-kudu.repo > /etc/yum.repos.d/cloudera-impala-kudu.repo  && \
    yum install -y impala-kudu-$IMPALA_VERSION\* \
	impala-kudu-catalog-$IMPALA_VERSION\* \
	impala-kudu-server-$IMPALA_VERSION\* \
	impala-kudu-shell-$IMPALA_VERSION\* \
	impala-kudu-state-store-$IMPALA_VERSION\* \
	hadoop-hdfs-datanode \
	hadoop-hdfs-namenode \
	hive-metastore



####################
# Kudu
####################

ENV KUDU_VERSION	0.5.0

RUN curl http://archive.cloudera.com/beta/kudu/redhat/6/x86_64/kudu/cloudera-kudu.repo > /etc/yum.repos.d/cloudera-kudu.repo  && \
    yum install -y kudu-$KUDU_VERSION\* kudu-master-$KUDU_VERSION\* kudu-tserver-$KUDU_VERSION\* kudu-client0-$KUDU_VERSION\* kudu-client-devel-$KUDU_VERSION\*


####################
# Configuring
####################

ENV WORKDIR /data

WORKDIR $WORKDIR

RUN mkdir /var/run/hdfs-sockets/ && \
    chown hdfs.hadoop /var/run/hdfs-sockets/

RUN mkdir -p $WORKDIR/dn/ && \
    chown hdfs.hadoop $WORKDIR/dn

RUN mkdir $WORKDIR/bin
ENV PATH=$PATH:$WORKDIR/bin

VOLUME $WORKDIR/persistent/dn


# Hadoop Configuration files
# /etc/hadoop/conf/ --> /etc/alternatives/hadoop-conf/ --> /etc/hadoop/conf/ --> /etc/hadoop/conf.empty/
# /etc/impala/conf/ --> /etc/impala/conf.dist
COPY etc/core-site.xml /etc/hadoop/conf/
COPY etc/hdfs-site.xml /etc/hadoop/conf/
COPY etc/core-site.xml /etc/impala/conf/
COPY etc/hdfs-site.xml /etc/impala/conf/
COPY etc/core-site.xml /etc/hive/conf/
COPY etc/hive-site.xml /etc/hive/conf/

# Various helper scripts
COPY bin/start.sh $WORKDIR/bin/
COPY bin/start-hdfs.sh $WORKDIR/bin/
COPY bin/start-impala.sh $WORKDIR/bin/
COPY bin/start-bash.sh $WORKDIR/bin/
COPY bin/start-daemon.sh $WORKDIR/bin/
RUN chmod +x $WORKDIR/bin/*
COPY bin/hdp /usr/bin/hdp

#VOLUME /data/kudu-master /data/kudu-tserver


####################
# PORTS
####################
#
#  7050 Kudu: TabletServer RPC Port
#  7051 Kudu: Master RPC Port
#  8050 Kudu: TabletServer Web UI
#  8051 Kudu: Master Web UI
#  9000 HDFS: Namenode IPC
# 21000 Impala: Shell
# 21050 Impala: ODBC/JDBC
# 25000 Impala: Daemon HTTP
# 25010 Impala: State Store HTTP
# 25020 Impala: Catalog HTTP
# 50010 HDFS: Datanode Transfer
# 50020 HDFS: Datanode IPC
# 50070 HDFS: Namenode HTTP
# 50075 HDFS: Datanode HTTP
#
EXPOSE 8050 8051

CMD $WORKDIR/bin/start-daemon.sh
