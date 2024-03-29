
APP_NAME='default_client'
CONFIG='/scripts/cert_client.cnf'
PASSWORD='CZgqFXyT5s6vA2wK'

#
# Generate CA private key and self-signed certificate
#
echo ----------------------------------------------------
openssl req                                             \
-new                                                    \
-x509                                                   \
-days 365                                               \
-extensions v3_ca                                       \
-keyout ca_$APP_NAME.key                                          \
-out ca_$APP_NAME.pem                                             \
-config $CONFIG                                         \
-passin pass:$PASSWORD                                  \
-passout pass:$PASSWORD                                 \

#
# CREATE THE CERTIFICATE SIGNING REQUEST (CSR)
#
echo ----------------------------------------------------
openssl req                                             \
    -new                                                \
    -x509                                               \
    -nodes                                              \
    -days 365                                           \
    -CA ca_$APP_NAME.pem                                \
    -CAkey ca_$APP_NAME.key                             \
    -newkey rsa:2048                                    \
    -keyout $APP_NAME.key                               \
    -out $APP_NAME.crt                                  \
    -config $CONFIG                                     \
    -passin pass:$PASSWORD                              \
    -passout pass:$PASSWORD                             \

#
# CONVERT TO PFX
#
echo ---------------------------------------------------
openssl pkcs12                                         \
    -inkey $APP_NAME.key                               \
    -in $APP_NAME.crt                                  \
    -export -out $APP_NAME.pfx                         \
    -passin pass:$PASSWORD                             \
    -passout pass:$PASSWORD                            \
    
#
# CREATE RSA
#   
echo ---------------------------------------------------
openssl pkcs12                                         \
    -in $APP_NAME.pfx                                  \
    -nocerts                                           \
    -nodes                                             \
    -out $APP_NAME.rsa                                 \
    -passin pass:$PASSWORD                             \

#
# CREATE PEM
#   
echo ---------------------------------------------------
openssl pkcs12                                         \
    -in $APP_NAME.pfx                                  \
    -out $APP_NAME.pem                                 \
    -nodes                                             \
    -passin pass:$PASSWORD                             \
