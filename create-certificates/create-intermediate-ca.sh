BASE_DIR=$(pwd)
echo "******************* Task creating directory structure for CA *******************"

mkdir -p ./opt/ca/tmnt/intermediate/{certs,csr,newcerts,private}

echo "******************* Task creation of directory structure for CA finished *******************"
echo "******************* Task create files to keep track of issued certificates and their serial numbers finished *******************"

cd $BASE_DIR/opt/ca/tmnt/intermediate
touch index.txt
echo "unique_subject = yes" > index.txt.attr
echo FFFFFF > serial

cd $BASE_DIR
echo "******************* Task creation of files to keep track of issued certificates and their serial numbers finished *******************"

echo "******************* Task copy openssl.intermediate.cnf to /opt/ca/tmnt/intermediate and replace space holder *******************"

cp $BASE_DIR/static-artifacts/openssl.intermediate.cnf $BASE_DIR/opt/ca/tmnt/intermediate/openssl.intermediate.cnf

sed -i -e 's|{{BASE_DIR}}|'"$BASE_DIR"'|g' $BASE_DIR/opt/ca/tmnt/intermediate/openssl.intermediate.cnf   
rm $BASE_DIR/opt/ca/tmnt/intermediate/openssl.intermediate.cnf-e

echo "******************* Task copy openssl.intermediate.cnf to /opt/ca/tmnt/intermediate and replace space holderfinished *******************"

echo "******************* Task generate private key for intermediate CA *******************"

cd $BASE_DIR/opt/ca/tmnt/intermediate
openssl genrsa \
          -passout pass:interpass \
          -aes256 \
          -out ./private/intermediate.key.pem 2048

cd $BASE_DIR

echo "******************* Task generate private key for intermediate CA finished *******************"

echo "******************* Task generate csr for intermediate CA *******************"

cd $BASE_DIR/opt/ca/tmnt/intermediate
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

echo "******************* Task generate csr for intermediate CA finished *******************"

echo "******************* Task generate intermediate CA signed certificate *******************"

cd $BASE_DIR/opt/ca/tmnt
openssl ca -config ./root/openssl.root.cnf \
           -extensions v3_intermediate_ca \
           -notext \
           -passin pass:rootpass \
           -in ./intermediate/csr/intermediate.csr.pem \
           -out ./intermediate/certs/intermediate.cert.pem
cd $BASE_DIR

echo "******************* Task generate intermediate CA signed certificate finished *******************"

echo "******************* Task create a certificate for *.tmnt.local that is signed by intermediate CA *******************"

# Generating the private key
cd $BASE_DIR/opt/ca/tmnt/intermediate
openssl genrsa \
        -passout pass:tmntpass \
        -aes256 \
        -out ./private/tmnt.local.key.pem 2048

# Generatibg the signing request
openssl req \
        -config ./openssl.intermediate.cnf \
        -key ./private/tmnt.local.key.pem \
        -new \
        -days 7300 \
        -sha256 \
        -passin pass:tmntpass \
        -subj "/emailAddress=admin@tmnt.local/C=AU/ST=Victoria/O=TMNT Inc/CN=*.tmnt.local" \
        -out ./csr/tmnt.local.csr.pem        

# Generating the certificate for *.tmnt.local
openssl ca \
        -config ./openssl.intermediate.cnf \
        -passin pass:interpass \
        -extensions server_cert \
        -days 7500 \
        -md sha256 \
        -in ./csr/tmnt.local.csr.pem \
        -out ./certs/tmnt.local.cert.pem   

 cd $BASE_DIR            
        
echo "******************* Task create a certificate for *.tmnt.local that is signed by intermediate CA finished *******************"

echo "******************* Task create a certificate for donatelo that is signed by intermediate CA *******************"
cd $BASE_DIR/opt/ca/tmnt/intermediate
# Generating the private key
openssl genrsa \
          -passout pass:donatellopass \
          -aes256 \
          -out ./private/donatello.key.pem 2048

# Generating the signing request
openssl req \
        -config openssl.intermediate.cnf \
        -key ./private/donatello.key.pem \
        -new \
        -days 7300 \
        -sha256 \
        -passin pass:donatellopass \
        -subj "/emailAddress=donatello@tmnt.local/C=AU/ST=Victoria/O=TMNT Inc/CN=Donatello" \
        -out ./csr/donatello.csr.pem

# Generating the certificate for Donatello
openssl ca \
        -config openssl.intermediate.cnf \
        -passin pass:interpass \
        -extensions client_cert \
        -days 7500 \
        -md sha256 \
        -in ./csr/donatello.csr.pem \
        -out ./certs/donatello.cert.pem

cd $BASE_DIR
echo "******************* Task create a certificate for donatelo that is signed by intermediate CA finished *******************"

echo "******************* Task verify certificate for *.tmnt.local *******************"

openssl verify \
        -CAfile $BASE_DIR/opt/ca/tmnt/root/certs/root.cert.pem \
        -untrusted $BASE_DIR/opt/ca/tmnt/intermediate/certs/intermediate.cert.pem \
        $BASE_DIR/opt/ca/tmnt/intermediate/certs/tmnt.local.cert.pem
echo "******************* Task verify certificate for *.tmnt.local finished *******************"

echo "******************* Task verify certificate for Donatello *******************"
openssl verify \
        -CAfile $BASE_DIR/opt/ca/tmnt/root/certs/root.cert.pem \
        -untrusted $BASE_DIR/opt/ca/tmnt/intermediate/certs/intermediate.cert.pem \
        $BASE_DIR/opt/ca/tmnt/intermediate/certs/donatello.cert.pem
echo "******************* Task verify certificate for Donatello finished *******************"