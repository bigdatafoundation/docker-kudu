#!/bin/bash
set -e

function do_help {
  echo HELP:
  echo "Supported commands:"
  echo "   master              - Start a Kudu Master"
  echo "   tserver             - Start a Kudu TServer"
  echo "   help                - print useful information and exit"
  echo ""
  echo "Other commands can be specified to run shell commands."
  echo "Set the environment variable KUDU_OPTS to pass additional"
  echo "arguments to the kudu process. DEFAULT_KUDU_OPTS contains"
  echo "a recommended base set of options."

  exit 0
}

if [ "$1" = 'master' ]; then
	exec kudu-master -fs_wal_dir /data/kudu-master ${KUDU_OPTS}
elif [ "$1" = 'tserver' ]; then
  exec kudu-tserver -fs_wal_dir /data/kudu-tserver \
  -tserver_master_addrs ${KUDU_MASTER} ${KUDU_OPTS}
elif [ "$1" = 'cli' ]; then
  shift; # Remove first arg and pass remainder to kudu cli
  exec kudu-ts-cli -server_address=${KUDU_TSERVER} ${KUDU_OPTS} "$@"
elif [ "$1" = 'help' ]; then
  do_help
fi

exec "$@"
