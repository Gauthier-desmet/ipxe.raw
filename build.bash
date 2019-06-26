set -x

CA_CERT=cachain.txt
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
     TRUST=${CI_PROJECT_DIR}/${CA_CERT} \
     EMBED=${CI_PROJECT_DIR}/embedded.ipxe \
     DEBUG=x509,httpcore,https,rootcert

mv bin/ipxe.usb ${CI_PROJECT_DIR}/ipxe.raw

make bin/ipxe.iso \
     TRUST=${CI_PROJECT_DIR}/${CA_CERT} \
     EMBED=${CI_PROJECT_DIR}/embedded.ipxe \
     DEBUG=x509,httpcore,https,rootcert

mv bin/ipxe.iso ${CI_PROJECT_DIR}/ipxe.iso