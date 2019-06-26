set -x

CA_CERT1=AddTrust_External_CA_Root
CA_CERT_URL1=http://www.terena.org/activities/tcs/repository/${CA_CERT1}.pem

CA_CERT2=USERTrustRSAAddTrustCA
CA_CERT_URL2=http://crt.usertrust.com/${CA_CERT2}.crt

CA_CERT3=TERENASSLCA3
CA_CERT_URL3=http://cacerts.digicert.com/${CA_CERT3}.crt

curl --location --output ${CA_CERT1}.pem ${CA_CERT_URL1}
curl --location --output ${CA_CERT2}.crt ${CA_CERT_URL2}
curl --location --output ${CA_CERT3}.crt ${CA_CERT_URL3}

openssl x509 -inform DER -outform PEM -text -in ${CA_CERT2}.crt -out ${CA_CERT2}.pem
openssl x509 -inform DER -outform PEM -text -in ${CA_CERT3}.crt -out ${CA_CERT3}.pem

#git clone https://git.ipxe.org/ipxe.git
git clone https://github.com/ipxe/ipxe
cd ipxe/src

printf '%s\n' '#define IMAGE_TRUST_CMD /* Image trust management commands */' >> config/general.h
printf '%s\n' '#define DOWNLOAD_PROTO_HTTPS /* Secure Hypertext Transfer Protocol */' >> config/general.h
printf '%s\n' '#define PING_CMD /* Ping command */' >> config/general.h
printf '%s\n' '#define NSLOOKUP_CMD /* Name resolution command */' >> config/general.h
printf '%s\n' '#define NEIGHBOUR_CMD /* Neighbour management commands */' >> config/general.h
#sed -i '/KEYBOARD_MAP/d' config/general.h
#printf '%s\n' '#define KEYBOARD_MAP fr' >> config/general.h

#     CERT=${CI_PROJECT_DIR}/${CA_CERT1}.pem,${CI_PROJECT_DIR}/${CA_CERT2}.pem,${CI_PROJECT_DIR}/${CA_CERT3}.pem \

make bin/ipxe.usb \
     CERT=${CI_PROJECT_DIR}/${CA_CERT3}.pem \
     TRUST=${CI_PROJECT_DIR}/${CA_CERT3}.pem \
     EMBED=${CI_PROJECT_DIR}/embedded.ipxe \
     DEBUG=tls,x509,httpcore,https,rootcert

mv bin/ipxe.usb ${CI_PROJECT_DIR}/ipxe.raw