set -x

CA_CERT1=AddTrust_External_CA_Root.pem
CA_CERT_URL1=http://www.terena.org/activities/tcs/repository/${CA_CERT1}

CA_CERT2=USERTrustRSAAddTrustCA.crt
CA_CERT_URL2=http://crt.usertrust.com/${CA_CERT2}

CA_CERT3=TERENASSLCA2.crt
CA_CERT_URL3=http://crt.usertrust.com/${CA_CERT3}

curl --location --output ${CA_CERT1} ${CA_CERT_URL1}
curl --location --output ${CA_CERT2} ${CA_CERT_URL2}
curl --location --output ${CA_CERT3} ${CA_CERT_URL3}

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

make bin/ipxe.usb \
     CERT=${CI_PROJECT_DIR}/${CA_CERT1},${CI_PROJECT_DIR}/${CA_CERT2},${CI_PROJECT_DIR}/${CA_CERT3} \
     TRUST=${CI_PROJECT_DIR}/${CA_CERT1} \
     EMBED=${CI_PROJECT_DIR}/embedded.ipxe \
     DEBUG=tls,x509,httpcore,https,rootcert

mv bin/ipxe.usb ${CI_PROJECT_DIR}/ipxe.raw