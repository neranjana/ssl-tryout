#!/bin/bash

BASE_DIR=$(pwd)/basedir
. ca.properties

echo "Step 0 - deleting base directory $BASE_DIR"
rm -fr $BASE_DIR

echo "Step 1 - making the $BASE_DIR directory tree"
mkdir -p $BASE_DIR/{certs,newcerts,private}
mkdir -p $BASE_DIR/intermediate/{certs,csr,newcerts,private}
mkdir -p $BASE_DIR/leaves

tree $BASE_DIR

echo "Step 2 - preparing auxiliary files"
cd $BASE_DIR
touch index.txt
echo "unique_subject = yes" > index.txt.attr
echo FFFFFF > serial

cd $BASE_DIR/intermediate
touch index.txt
echo "unique_subject = yes" > index.txt.attr
echo FFFFFF > serial

tree $BASE_DIR

echo "Step 3 - preparing $BASE_DIR/openssl.root.cnf"
cat << ROOT_CONF > $BASE_DIR/openssl.root.cnf
[ req ]
default_bits        = 2048
default_md          = sha256
distinguished_name  = req_distinguished_name
prompt              = no
x509_extensions     = v3_ca

[ req_distinguished_name ]
commonName          = "$prop_ca_root_common_name"
stateOrProvinceName = "$prop_ca_root_state_or_province"
countryName         = "$prop_ca_root_country_name"
emailAddress        = "$prop_ca_root_email_address"
organizationName    = "$prop_ca_root_organization_name"

[ v3_ca ]
subjectKeyIdentifier   = hash
authorityKeyIdentifier = keyid:always, issuer
basicConstraints       = critical, CA:true
keyUsage               = critical, digitalSignature, keyCertSign

[ v3_intermediate_ca ]
subjectKeyIdentifier    = hash
authorityKeyIdentifier  = keyid:always,issuer
basicConstraints        = critical, CA:true, pathlen:0
keyUsage                = critical, digitalSignature, keyCertSign

[ ca ]
default_ca = $prop_ca_default_ca

[$prop_ca_default_ca]
dir                     = $BASE_DIR
database                = \$dir/index.txt
new_certs_dir           = \$dir/newcerts
serial                  = \$dir/serial
private_key             = \$dir/private/root.key.pem
certificate             = \$dir/certs/root.cert.pem
default_md              = sha256
name_opt                = ca_default
cert_opt                = ca_default
default_days            = 7300
policy                  = $prop_ca_policy

[$prop_ca_policy]
commonName              = supplied
stateOrProvinceName     = match
countryName             = match
emailAddress            = optional
organizationName        = match
organizationalUnitName  = optional
ROOT_CONF

cat $BASE_DIR/openssl.root.cnf

echo "Step 4 - generating the root key pair"
cd $BASE_DIR
openssl req -config openssl.root.cnf \
            -x509 \
            -passout $prop_ca_root_password \
            -days 7300 \
            -newkey rsa \
            -keyout private/root.key.pem \
            -out    certs/root.cert.pem

echo "Inspecting root.cert.pem"

cd $BASE_DIR
openssl x509 -noout -text \
       -in certs/root.cert.pem \
       -fingerprint -sha256

echo "Step 5 - preparing $BASE_DIR/intermediate/openssl.intermediate.cnf"
cat << INTERMEDIATE_CONF > $BASE_DIR/intermediate/openssl.intermediate.cnf
[ req ]
default_bits            = 2048
default_md              = sha256
distinguished_name      = req_distinguished_name
x509_extensions         = v3_ca

[ req_distinguished_name ]
countryName             = Country Name (2 letter code)
stateOrProvinceName     = State or Province Name
localityName            = Locality Name
organizationName        = Organization Name
organizationalUnitName  = Organizational Unit Name
commonName              = Common Name
emailAddress            = Email Address

stateOrProvinceName = "$prop_ca_intermediate_state_or_province"
countryName         = "$prop_ca_intermediate_country_name"
emailAddress        = "$prop_ca_intermediate_email_address"
organizationName    = "$prop_ca_intermediate_organization_name"

[ v3_ca ]
subjectKeyIdentifier    = hash
authorityKeyIdentifier  = keyid:always, issuer
basicConstraints        = critical, CA:true
keyUsage                = critical, digitalSignature, keyCertSign

[ ca ]
default_ca = $prop_ca_intermediate_default_ca

[ $prop_ca_intermediate_default_ca ]
dir                     = $BASE_DIR/intermediate
database                = \$dir/index.txt
new_certs_dir           = \$dir/newcerts
serial                  = \$dir/serial
private_key             = \$dir/private/intermediate.key.pem
certificate             = \$dir/certs/intermediate.cert.pem
default_md              = sha256
name_opt                = ca_default
cert_opt                = ca_default
default_days            = 7300
policy                  = $prop_ca_intermediate_policy

[ $prop_ca_intermediate_policy ]
countryName             = optional
stateOrProvinceName     = optional
localityName            = optional
organizationName        = optional
organizationalUnitName  = optional
commonName              = supplied
emailAddress            = optional

[ client_cert ]
basicConstraints       = CA:FALSE
subjectKeyIdentifier   = hash
authorityKeyIdentifier = keyid,issuer
keyUsage               = critical, nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage       = clientAuth

[ server_cert ]
basicConstraints       = CA:FALSE
subjectKeyIdentifier   = hash
authorityKeyIdentifier = keyid,issuer:always
keyUsage               = critical, digitalSignature, keyEncipherment
extendedKeyUsage       = serverAuth
INTERMEDIATE_CONF

cat $BASE_DIR/intermediate/openssl.intermediate.cnf

echo "Step 6 - generating the intermediate private key"
cd $BASE_DIR/intermediate
openssl genrsa \
        -aes256 \
        -passout $prop_ca_intermediate_password \
        -out private/intermediate.key.pem 2048

echo "Step 7 - generating the CSR for the intermediate CA's certificate"
cd $BASE_DIR/intermediate
openssl req \
        -config openssl.intermediate.cnf \
        -new \
        -days 7300 \
        -sha256 \
        -key private/intermediate.key.pem \
        -passin $prop_ca_intermediate_password \
        -subj "$prop_ca_intermediate_subj" \
        -out csr/intermediate.csr.pem

echo "Step 8 - signing the the intermediate CA's certificate"
cd $BASE_DIR
openssl ca -config openssl.root.cnf \
           -extensions v3_intermediate_ca \
           -notext \
           -passin $prop_ca_root_password \
           -in intermediate/csr/intermediate.csr.pem \
           -out intermediate/certs/intermediate.cert.pem \
           -batch
cd $BASE_DIR/../