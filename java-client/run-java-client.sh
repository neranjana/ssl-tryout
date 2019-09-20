#!/bin/sh

cd ../
CURRENT_DIR=`pwd`
TRUST_STORE_PATH="$CURRENT_DIR/create-certificates/ca/root/certs/tmnt-truststore.jks"
KEY_STORE_PATH="$CURRENT_DIR/create-certificates/leaves/donatello/private/donatello.p12"
cd java-client/src
javac SimpleHttpClient.java
java SimpleHttpClient $TRUST_STORE_PATH $KEY_STORE_PATH