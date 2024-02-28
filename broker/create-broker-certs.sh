
echo "Start Script"

#
#  Generating key store for the Broker, containing its certificate and private key.
#
echo ----------------------------------------------------
echo "Generating key store for the Broker"
echo ----------------------------------------------------
keytool -genkey                                         \
    -keyalg RSA                                         \
    -alias $ALIAS                                       \
    -keystore $KEY_STORE                                \
    -storepass $STORE_PASSWORD                          \
    -validity 360                                       \
    -keysize 2048                                       \
    -dname $DISTINGUISHED_NAME                          \
    -ext $EXT                                           \

#
# Exporting certificate from key store for Broker, for import into trust store.
#
echo ----------------------------------------------------
echo "Exporting certificate from key store"
echo ----------------------------------------------------
keytool -exportcert                                     \
    -storepass $STORE_PASSWORD                          \
    -alias $ALIAS                                       \
    -keystore $KEY_STORE                                \
    -file $SERVER_CERT                                  \

#
# Generating certificate and private key for Broker client into PEM files.
#
echo ----------------------------------------------------
echo "Generating key and pem files"
echo ----------------------------------------------------
openssl req                                             \
    -subj $SUBJECT                                      \
    -x509 -newkey rsa:2048                              \
    -keyout $CLIENT_KEY                                 \
    -out $CLIENT_PEM                                    \
    -passout pass:$STORE_PASSWORD                       \
    -days 360                                           \

#
# Converting certificate and private key for HiveMQ client into combined PFX file for use in .NET code.
#
echo ----------------------------------------------------
echo "Generating pfx files"
echo ----------------------------------------------------
openssl pkcs12                                          \
    -inkey $CLIENT_KEY                                  \
    -in $CLIENT_PEM                                     \
    -passin pass:$STORE_PASSWORD                        \
    -export -out $CLIENT_CERT                           \
        -passout pass:$STORE_PASSWORD                   \
        -name $ALIAS                                    \

#
# Importing certificate HiveMQ client into trust store for HiveMQ broker.
#
echo ----------------------------------------------------
echo "Create trust store"
echo ----------------------------------------------------
keytool -importkeystore                                 \
        -srckeystore $CLIENT_CERT                       \
        -srcstoretype pkcs12                            \
        -srcstorepass $STORE_PASSWORD                   \
        -destkeystore $TRUST_STORE                      \
        -deststoretype pkcs12                           \
        -deststorepass $TRUST_PASSWORD                  \

keytool -exportcert -storepass $TRUST_PASSWORD -rfc -keystore $TRUST_STORE -alias $ALIAS -file explorer-cert.crt
keytool -importkeystore -srckeystore $TRUST_STORE -destkeystore explorer-keystore.p12 -srcstoretype jks -deststoretype pkcs12 -srcstorepass $TRUST_PASSWORD  -deststorepass $TRUST_PASSWORD
openssl pkcs12 -in explorer-keystore.p12 -nodes -nocerts -out explorer-key.key -passin pass:$TRUST_PASSWORD
openssl pkcs12 -in explorer-keystore.p12 -nokeys -out explorer-cert.pem -passin pass:$TRUST_PASSWORD

mkdir -p /dist/hive-mq/certs
cp $TRUST_STORE /dist/hive-mq/certs/$KEY_STORE
cp $TRUST_STORE /dist/hive-mq/certs/$TRUST_STORE 

mkdir -p /dist/hive-mq/config
cat > /dist/hive-mq/config/config.xml<< EOF
<?xml version="1.0"?>
<hivemq>
    <listeners>
        <tcp-listener>
            <port>1883</port>
            <bind-address>0.0.0.0</bind-address>
        </tcp-listener>
        <tls-tcp-listener>
            <port>8883</port>
            <bind-address>0.0.0.0</bind-address>
            <proxy-protocol>true</proxy-protocol>
            <tls>
                <keystore>
                    <path>certificates/$KEY_STORE</path>
                    <password>$STORE_PASSWORD</password>
                    <private-key-password>$STORE_PASSWORD</private-key-password>
                </keystore>
                <client-authentication-mode>REQUIRED</client-authentication-mode>
                <truststore>
                    <path>certificates/$TRUST_STORE</path>
                    <password>$TRUST_PASSWORD</password>
                </truststore>
            </tls>
        </tls-tcp-listener>
    </listeners>
</hivemq>
EOF

cp /scripts/config/*.* /dist/hive-mq/config

mkdir -p /dist/hive-mq/mqtt-explorer
cp /export/explorer-cert.pem /dist/hive-mq/mqtt-explorer
cp /export/explorer-key.key /dist/hive-mq/mqtt-explorer

echo "End Script"