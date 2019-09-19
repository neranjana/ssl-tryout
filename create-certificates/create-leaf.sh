#!/bin/sh
echo "----- Task reading property file $1 -----"
PROPERTY_FILE=$1

. $1
echo "----- Task reading property file $1 finished -----"

echo "----- Task creating directory structure for $name -----"
BASE_DIR=$(pwd)

mkdir leaves

OUT_DIR=$BASE_DIR/leaves/$name
rm -rf $OUT_DIR
mkdir $OUT_DIR
mkdir $OUT_DIR/{private,csr,certs}

echo "----- Task creating directory structure for $name finished -----"

echo "----- Task generating private key for $name -----"

cd $BASE_DIR/ca/intermediate
openssl genrsa \
        -passout $privateKeyFilePassword \
        -$encryptionAlgorithm \
        -out $OUT_DIR/private/$name.key.pem 2048

echo "----- Task generating private key for $name finished -----"        

echo "----- Task generating csr for $name -----"
openssl req \
        -config ./openssl.intermediate.cnf \
        -key $OUT_DIR/private/$name.key.pem \
        -new \
        -days $reqDays \
        -$digestAlgorithm \
        -passin $privateKeyFilePassword \
        -subj "$subj" \
        -out $OUT_DIR/csr/$name.csr.pem      
echo "----- Task generating csr for $name finished -----"          

echo "----- Task generating certificate for $name -----"
openssl ca \
        -config ./openssl.intermediate.cnf \
        -passin pass:interpass \
        -extensions $extensions \
        -days $certDays \
        -md $digestAlgorithm \
        -in $OUT_DIR/csr/$name.csr.pem \
        -out $OUT_DIR/certs/$name.cert.pem   

 cd $BASE_DIR            

echo "----- Task generating certificate for $name finished -----"        



echo "----- Task verify certificate for $name -----"
cd $BASE_DIR
openssl verify \
        -CAfile ./ca/root/certs/root.cert.pem \
        -untrusted ./ca/intermediate/certs/intermediate.cert.pem \
        $OUT_DIR/certs/$name.cert.pem
echo "----- Task verify certificate for $name finished -----"

