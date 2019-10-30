#!/bin/bash

BASE_DIR=$(pwd)/basedir
. ca.properties
LEAVES_DIR=$BASE_DIR/leaves
if [ -z "$1" ]; then
   echo "Please specify the name of the configuration properties file"
else
    echo "----- Task reading property file $1 -----"
    PROPERTY_FILE=$1

    . $PROPERTY_FILE
    LEAF_DIR=$LEAVES_DIR/$prop_leaf_name
    mkdir $LEAF_DIR
    mkdir $LEAF_DIR/{certs,csr,private,truststore}
    read -p "Step 9 - Press enter to generate the private key for *.tmnt.local"
    cd $BASE_DIR/intermediate
    openssl genrsa \
            -passout $prop_pem_password \
            -aes256 \
            -out $LEAF_DIR/private/$prop_leaf_name.key.pem 2048

    read -p "Step 10 - Press enter to generate the CSR for *.tmnt.local"
    cd $BASE_DIR/intermediate
    openssl req \
            -config openssl.intermediate.cnf \
            -key $LEAF_DIR/private/$prop_leaf_name.key.pem \
            -new \
            -days 7300 \
            -sha256 \
            -passin $prop_pem_password \
            -subj "$prop_subj" \
            -out $LEAF_DIR/csr/$prop_leaf_name.csr.pem


    read -p "Step 11 - Press enter to sign the certificate for *.tmnt.local"
    cd $BASE_DIR/intermediate
    openssl ca \
            -config openssl.intermediate.cnf \
            -passin $prop_ca_intermediate_password \
            -extensions $extensions \
            -days 7500 \
            -md sha256 \
            -in $LEAF_DIR/csr/$prop_leaf_name.csr.pem \
            -out $LEAF_DIR/certs/$prop_leaf_name.cert.pem \
            -batch

    openssl pkcs12 -export \
            -in $LEAF_DIR/certs/$prop_leaf_name.cert.pem \
            -inkey $LEAF_DIR/private/$prop_leaf_name.key.pem \
            -passin $prop_pem_password\
            -out $LEAF_DIR/private/$prop_leaf_name.p12 \
            -password $prop_p12_password\
            -name "$prop_leaf_name" \
            -certfile $BASE_DIR/intermediate/certs/intermediate.cert.pem

    read -p "Step 12 - Press enter to verify wild card leaf cert"
    openssl verify \
            -CAfile $BASE_DIR/certs/root.cert.pem \
            -untrusted $BASE_DIR/intermediate/certs/intermediate.cert.pem \
            $LEAF_DIR/certs/$prop_leaf_name.cert.pem      
fi