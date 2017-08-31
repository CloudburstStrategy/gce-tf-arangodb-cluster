#!/usr/bin/env bash

PASSWORD=$1
MY_IP=$2
MASTER_IP=$3

docker pull arangodb/arangodb-starter

if [ -z $MASTER_IP ]; then

echo "Starting Master ArangoDB on ip $MY_IP for logs use: docker logs adb";

docker run -d --name=adb --rm -p 8528:8528 \
    -v /mnt/disks/db/data:/data \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -e ARANGO_ROOT_PASSWORD=$PASSWORD \
    arangodb/arangodb-starter \
    --starter.address=$MY_IP \
    --server.storage-engine=rocksdb

else

echo "Starting Slave ArangoDB on ip $MY_IP connecting to master on $MASTER_IP for logs use: docker logs adb";

docker run -d --name=adb --rm -p 8528:8528 \
    -v /mnt/disks/db/data:/data \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -e ARANGO_ROOT_PASSWORD=$PASSWORD \
    arangodb/arangodb-starter \
    --starter.address=$MY_IP \
    --starter.join=$MASTER_IP \
    --server.storage-engine=rocksdb

fi
