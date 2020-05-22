#!/bin/bash

set -e

# Setup docker group
DOCKER_SOCKET=/var/run/docker.sock
DOCKER_GROUP=docker

if [ -S ${DOCKER_SOCKET} ]; then
   DOCKER_GID=$(stat -c '%g' ${DOCKER_SOCKET})
   groupmod -g ${DOCKER_GID} ${DOCKER_GROUP}
   usermod -aG ${DOCKER_GROUP} demo
fi

if [ "$HOSTNAME" != "$SGEMASTER" ]; then
   echo "++++++++++++++++++++++Configuring SGE with new Master++++++++++++++++++++++++++++"
   echo "$HOSTNAME" >  /var/lib/gridengine/default/common/act_qmaster
   echo "domain $HOSTNAME" >> /etc/resolv.conf
   service gridengine-master restart
   sleep 1
   qconf -mattr "queue" "hostlist" "$HOSTNAME" "compute.q"
   qconf -as $HOSTNAME
   echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
fi

# Run whatever the user wants to
exec "$@"
