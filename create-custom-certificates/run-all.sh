#!/bin/bash
SCRIPT_DIR=$(pwd)
source ./create-ca.sh
cd $SCRIPT_DIR
# source ./create-leaves.sh
# pwd
# source ./verify.sh
source ./create-leaf.sh ./sample-server.properties
cd $SCRIPT_DIR
source ./create-leaf.sh ./sample-client.properties
cd $SCRIPT_DIR
source ./create-truststore-jks.sh ./sample-server.properties
cd $SCRIPT_DIR
source ./create-truststore-jks.sh ./sample-client.properties