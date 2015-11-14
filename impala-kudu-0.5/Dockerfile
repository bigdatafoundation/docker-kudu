FROM centos:6.7

# Inspired by
# http://www.cloudera.com/content/www/en-us/documentation/cdh/5-1-x/CDH5-Installation-Guide/CDH5-Installation-Guide.html


########################################
# Dependency: Java
########################################
ENV JAVA_VERSION	1.7.0

RUN yum install -y java-$JAVA_VERSION-openjdk java-$JAVA_VERSION-openjdk-devel



########################################
# Dependency: Impala
########################################
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
COPY ./etc /etc/bigdatafoundation/

RUN ln -sf /etc/bigdatafoundation/core-site.xml /etc/hadoop/conf/  \
 && ln -sf /etc/bigdatafoundation/hdfs-site.xml /etc/hadoop/conf/  \
 && ln -sf /etc/bigdatafoundation/hive-site.xml /etc/hive/conf/  \
 && ln -sf /etc/bigdatafoundation/hdfs-site.xml /etc/impala/conf/  \
 && ln -sf /etc/bigdatafoundation/core-site.xml /etc/impala/conf/  \
 && ln -sf /etc/bigdatafoundation/hive-site.xml /etc/impala/conf/  \
 && mkdir -p /var/run/hdfs-sockets \
 && chown hdfs:hadoop /var/run/hdfs-sockets \
 && echo "Formatting HDFS ..." \
 && service hadoop-hdfs-namenode init

#VOLUME /data/kudu-master /data/kudu-tserver

VOLUME /var/lib/hadoop-hdfs /var/lib/hive /var/lib/impala


####################
# PORTS
####################
# http://www.cloudera.com/content/www/en-us/documentation/enterprise/latest/topics/cdh_ig_ports_cdh5.html
# http://www.cloudera.com/content/www/en-us/documentation/enterprise/latest/topics/cm_ig_ports_impala.html
####################
#
#  7050 Kudu: TabletServer RPC Port
#  7051 Kudu: Master RPC Port
#  8020 HDFS: NameNode IPC
#  8050 Kudu: TabletServer HTTP (Web UI)
#  8051 Kudu: Master HTTP (Web UI)
#  9083 Hive: Metastore
# 15000 Impala: Llama ApplicationMaster Thrift (internal)
# 15001 Impala: Llama ApplicationMaster HTTP (Web UI)
# 15002 Impala: Llama ApplicationMaster Admin Thrift (internal)
# 21000 Impala: Daemon Shell (RPC)
# 21050 Impala: Daemon ODBC/JDBC (RPC)
# 22000 Impala: Daemon Backend (internal)
# 23000 Impala: Daemon StateStoreSubscriber (internal)
# 23020 Impala: Catalog StateStoreSubscriber (internal)
# 24000 Impala: StateStore Thrift (internal)
# 25000 Impala: Daemon HTTP (Web UI)
# 25010 Impala: StateStore HTTP (Web UI)
# 25020 Impala: Catalog HTTP (Web UI)
# 26000 Impala: Catalog, push updates to daemons (internal)
# 28000 Impala: Llama Callback (internal)
# 50010 HDFS: DataNode Transfer
# 50020 HDFS: DataNode IPC
# 50070 HDFS: NameNode HTTP (Web UI)
# 50075 HDFS: DataNode HTTP (Web UI)
#
EXPOSE 8050 8051 25000 25010 25020 50070 50075


COPY ./docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
