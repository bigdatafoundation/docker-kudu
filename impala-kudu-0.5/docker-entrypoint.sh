#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Set the NameNode hostname at runtime.
export NAMENODE_HOST=${NAMENODE_HOST:-$(hostname)}
sed -i "s/___NAMENODE_HOST___/${NAMENODE_HOST}/" /etc/bigdatafoundation/core-site.xml


function do_help {
  echo HELP:
  echo "Supported commands:"

  exit 0
}


if [ "$1" = 'demo' ]; then
  service hadoop-hdfs-namenode start
  service hadoop-hdfs-datanode start
  service hive-metastore start
  # TMP: FIXME: find a way to monitor the process
  bash
elif [ "$1" = 'help' ]; then
  do_help
else
  exec "$@"
fi
