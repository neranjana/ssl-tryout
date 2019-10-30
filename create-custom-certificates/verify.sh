#!/bin/bash

BASE_DIR=$(pwd)/basedir
read -p "Step 15 - Press enter to verify wild card leaf cert"
openssl verify \
        -CAfile $BASE_DIR/certs/root.cert.pem \
        -untrusted $BASE_DIR/intermediate/certs/intermediate.cert.pem \
        $BASE_DIR/intermediate/certs/tmnt.local.cert.pem


read -p "Step 16 - Press enter to verify client leaf cert"
openssl verify \
        -CAfile $BASE_DIR/certs/root.cert.pem \
        -untrusted $BASE_DIR/intermediate/certs/intermediate.cert.pem \
        $BASE_DIR/intermediate/certs/donatello.cert.pem
