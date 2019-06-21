set -x

wget http://boot.ipxe.org/ipxe.iso
#export LIBGUESTFS_DEBUG=1 LIBGUESTFS_TRACE=1
guestfish --new pxeboot.img=fs:vfat:4M \
          --add file://${CI_PROJECT_DIR}/ipxe.iso \
          --mount /dev/sda1:/mnt \
          --mount /dev/sdb:/media \
<<_EOF_
list-devices
list-filesystems
_EOF_

exit 0
          --mount /dev/sda1:/mnt \
guestmount -i -a pxeboot.img /mnt
extlinux --install /mnt

guestmount -a ipxe.iso /media
cp /media/ipxe.krn /mnt
cat > /mnt/syslinux.cfg <<EOF
DEFAULT ipxe
LABEL ipxe
  KERNEL ipxe.krn dhcp && chain http://ipxe.consul.local/loader.ipxe
EOF
 
guestunmount /media
guestunmount /mnt