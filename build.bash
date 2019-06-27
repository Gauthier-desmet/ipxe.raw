set -x

CA_CERT=TERENASSLCA3
#CA_CERT_URL=http://cacerts.digicert.com/${CA_CERT}.crt
#DEBUG=tls,x509,httpcore,https,rootcert

#curl --location --output ${CA_CERT}.crt ${CA_CERT_URL}

#openssl x509 -inform DER -outform PEM -text -in ${CA_CERT}.crt -out ${CA_CERT}.pem

#git clone https://git.ipxe.org/ipxe.git
git clone https://github.com/ipxe/ipxe
cd ipxe/src

printf '%s\n' '#define IMAGE_TRUST_CMD /* Image trust management commands */' >> config/general.h
printf '%s\n' '#define DOWNLOAD_PROTO_HTTPS /* Secure Hypertext Transfer Protocol */' >> config/general.h
printf '%s\n' '#define PING_CMD /* Ping command */' >> config/general.h
printf '%s\n' '#define NSLOOKUP_CMD /* Name resolution command */' >> config/general.h
printf '%s\n' '#define NEIGHBOUR_CMD /* Neighbour management commands */' >> config/general.h

make bin/ipxe.usb \
     CERT=${CI_PROJECT_DIR}/${CA_CERT}.pem \
     TRUST=${CI_PROJECT_DIR}/${CA_CERT}.pem \
     EMBED=${CI_PROJECT_DIR}/embedded.ipxe \
     DEBUG=${DEBUG}

mv bin/ipxe.usb ${CI_PROJECT_DIR}/ipxe.raw