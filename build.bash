set -x

CA_CERT=cachain.txt
#git clone https://git.ipxe.org/ipxe.git
git clone https://github.com/ipxe/ipxe
cd ipxe/src
printf '‰s\n' '#define DOWNLOAD_PROTO_HTTPS /* Secure Hypertext Transfer Protocol */' >> config/general.h
make bin/ipxe.usb \
     TRUST=${CI_PROJECT_DIR}/${CA_CERT} \
     EMBED=${CI_PROJECT_DIR}/embedded.ipxe
mv bin/ipxe.usb bin/ipxe.raw