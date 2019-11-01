#!/bin/bash

BASE_DIR=$(pwd)/basedir
LEAVES_DIR=$BASE_DIR/leaves
if [ -z "$1" ]; then
   echo "Please specify the name of the configuration properties file"
else
    PROPERTY_FILE=$1

    . $PROPERTY_FILE
    keytool -import \
        -file $BASE_DIR/intermediate/certs/intermediate.cert.pem \
        -alias intermediate \
        -storepass $trust_store_password  \
        -keystore $LEAVES_DIR/$prop_leaf_name/truststore/$prop_leaf_name-truststore.jks \
        -noprompt

    echo $trusted_subjects
    IFS=', ' read -r -a subjectArray<<< "$trusted_subjects"
    for index in "${!subjectArray[@]}"
    do
        echo "----- Task create trust store jks -----"
        keytool -import \
            -file $LEAVES_DIR/${subjectArray[index]}/certs/${subjectArray[index]}.cert.pem \
            -alias ${subjectArray[index]} \
            -storepass $trust_store_password \
            -keystore $LEAVES_DIR/$prop_leaf_name/truststore/$prop_leaf_name-truststore.jks \
            -noprompt
        echo "----- Task create trust store jks finished -----"  
    done


    keytool -list \
    -v -keystore $LEAVES_DIR/$prop_leaf_name/truststore/$prop_leaf_name-truststore.jks \
    -storepass $trust_store_password
fi