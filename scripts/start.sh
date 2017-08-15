#!/usr/bin/env bash

docker pull arangodb/arangodb-starter

docker run -it --name=adb --rm -p 8528:8528 \
    -v /mnt/disks/db/data:/data \
    -v /var/run/docker.sock:/var/run/docker.sock \
    arangodb/arangodb-starter \
    --starter.address=$1,$2,$3 \
    --server.storage-engine=rocksdb
