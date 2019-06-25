set -x

CA_CERT=terena.pem
#git clone https://git.ipxe.org/ipxe.git
git clone https://github.com/ipxe/ipxe
cd ipxe/src
make bin/ipxe.usb \
     bin/undionly.kkpxe \
     TRUST=${CA_CERT} \
     EMBED=${CI_PROJECT_DIR}/embedded.ipxe
mv bin/ipxe.usb bin/ipxe.raw