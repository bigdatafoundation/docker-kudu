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

# The "cdh5" and "impala-kudu" repositories are required to install Impala
RUN curl http://archive.cloudera.com/cdh5/redhat/6/x86_64/cdh/cloudera-cdh5.repo > /etc/yum.repos.d/cloudera-cdh5.repo  && \
    curl http://archive.cloudera.com/beta/impala-kudu/redhat/6/x86_64/impala-kudu/cloudera-impala-kudu.repo > /etc/yum.repos.d/cloudera-impala-kudu.repo  && \
    yum install -y impala-kudu-$IMPALA_VERSION\* impala-kudu-catalog-$IMPALA_VERSION\* impala-kudu-server-$IMPALA_VERSION\* impala-kudu-shell-$IMPALA_VERSION\* impala-kudu-state-store-$IMPALA_VERSION\*



####################
# Kudu
####################

ENV KUDU_VERSION	0.5.0

RUN curl http://archive.cloudera.com/beta/kudu/redhat/6/x86_64/kudu/cloudera-kudu.repo > /etc/yum.repos.d/cloudera-kudu.repo  && \
    yum install -y kudu-$KUDU_VERSION\* kudu-master-$KUDU_VERSION\* kudu-tserver-$KUDU_VERSION\* kudu-client0-$KUDU_VERSION\* kudu-client-devel-$KUDU_VERSION\*

#VOLUME /data/kudu-master /data/kudu-tserver


####################
# PORTS
####################
#
# https://github.com/cloudera/kudu/blob/master/docs/installation.adoc
# 
# TabletServer:
#	 7050 = TabletServer RPC Port
# 	 8050 = TabletServer Web UI
# Kudu Master:
#	 7051 = Master RPC Port
#	 8051 = Master Web UI
#
EXPOSE 8050 8051
