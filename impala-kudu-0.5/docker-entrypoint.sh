#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Set the NameNode hostname at runtime.
NAMENODE_HOST=${NAMENODE_HOST:-$(hostname)}
sed -i "s/___NAMENODE_HOST___/${NAMENODE_HOST}/" /etc/bigdatafoundation/core-site.xml


function do_help {
  echo HELP:
  echo "Supported commands:"

  exit 0
}


if [ "$1" = 'TODO' ]; then
	echo "no yet implemented"
  exec "$@"
elif [ "$1" = 'help' ]; then
  do_help
else
  exec "$@"
fi
