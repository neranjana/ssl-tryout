BASE_DIR=$(pwd)

echo "----- Task cleaning directory strucutre -----"

rm -rf $BASE_DIR/ca/intermediate

echo "----- Task dleaning directory structure finished -----"
echo "----- Task creating directory structure -----"

mkdir -p ./ca/intermediate/{certs,csr,newcerts,private}

echo "----- Task creation of directory structurefinished -----"
echo "----- Task create files to keep track of issued certificates and their serial numbers finished -----"

cd $BASE_DIR/ca/intermediate
touch index.txt
echo "unique_subject = yes" > index.txt.attr
echo FFFFFF > serial

cd $BASE_DIR
echo "----- Task creation of files to keep track of issued certificates and their serial numbers finished -----"

echo "----- Task copy openssl.intermediate.cnf to /ca/intermediate and replace space holder -----"

cp $BASE_DIR/static-artifacts/openssl.intermediate.cnf $BASE_DIR/ca/intermediate/openssl.intermediate.cnf

sed -i -e 's|{{BASE_DIR}}|'"$BASE_DIR"'|g' $BASE_DIR/ca/intermediate/openssl.intermediate.cnf   
rm $BASE_DIR/ca/intermediate/openssl.intermediate.cnf-e

echo "----- Task copy openssl.intermediate.cnf to /ca/intermediate and replace space holderfinished -----"

echo "----- Task generate private key for intermediate CA -----"

cd $BASE_DIR/ca/intermediate
openssl genrsa \
    -passout pass:interpass \
    -aes256 \
    -out ./private/intermediate.key.pem 2048

cd $BASE_DIR

echo "----- Task generate private key for intermediate CA finished -----"

echo "----- Task generate csr for intermediate CA -----"

cd $BASE_DIR/ca/intermediate
openssl req \
    -config openssl.intermediate.cnf \
    -new \
    -days 7300 \
    -sha256 \
    -key ./private/intermediate.key.pem \
    -passin pass:interpass \
    -subj "/emailAddress=admin@tmnt.local/C=AU/ST=Victoria/O=TMNT Inc/CN=TMNT Intermediate CA" \
    -out ./csr/intermediate.csr.pem
       

cd $BASE_DIR

echo "----- Task generate csr for intermediate CA finished -----"

echo "----- Task generate intermediate CA signed certificate -----"

cd $BASE_DIR/ca
openssl ca -config ./root/openssl.root.cnf \
    -extensions v3_intermediate_ca \
    -notext \
    -passin pass:rootpass \
    -in ./intermediate/csr/intermediate.csr.pem \
    -out ./intermediate/certs/intermediate.cert.pem \
    -batch
cd $BASE_DIR

echo "----- Task generate intermediate CA signed certificate finished -----"