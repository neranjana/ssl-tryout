#!/bin/sh

clear

echo "******************* Creating CA *******************"

BASE_DIR=$(pwd)

echo "******************* Base directory for this process is $BASE_DIR *******************"

echo "******************* Task cleaning directory strucutre *******************"

rm -rf $BASE_DIR/ca/root

echo "******************* Task dleaning directory structure finished *******************"


echo "******************* Task creating directory structure for CA *******************"

mkdir -p ./ca/root/{certs,newcerts,private}

echo "******************* Task creation of directory structure for CA finished *******************"

echo "******************* Task create files to keep track of issued certificates and their serial numbers finished *******************"

cd $BASE_DIR/ca/root
touch index.txt
echo "unique_subject = yes" > index.txt.attr
echo FFFFFF > serial

cd $BASE_DIR
echo "******************* Task creation of files to keep track of issued certificates and their serial numbers finished *******************"

echo "******************* Task copy openssl.root.cnf to /opt/ca/tmnt and replace space holder *******************"

cp $BASE_DIR/static-artifacts/openssl.root.cnf $BASE_DIR/ca/root/openssl.root.cnf

sed -i -e 's|{{BASE_DIR}}|'"$BASE_DIR"'|g' $BASE_DIR/ca/root/openssl.root.cnf
rm $BASE_DIR/opt/ca/tmnt/root/openssl.root.cnf-e

echo "******************* Task copy openssl.root.cnf to /opt/ca/tmnt finished and replace space holder*******************"

echo "******************* Task generate root CA certificate and private key *******************"

cd $BASE_DIR/ca/root
openssl req -config openssl.root.cnf \
              -x509 \
              -passout pass:rootpass \
              -days 7300 \
              -newkey rsa \
              -keyout ./private/root.key.pem \
              -out    ./certs/root.cert.pem

 cd $BASE_DIR             
echo "******************* Task generate root CA certificate and private key finished *******************"
