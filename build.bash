set -x

#git clone https://git.ipxe.org/ipxe.git
git clone https://github.com/ipxe/ipxe
cd ipxe/src
make bin/ipxe.usb \
     EMBED=${CI_PROJECT_DIR}/embedded.ipxe