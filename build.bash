set -x

export LIBGUESTFS_DEBUG=1 LIBGUESTFS_TRACE=1
guestfish --new pxeboot.img=fs:vfat:4M \
          --add http://boot.ipxe.org/ipxe.iso \
          list-devices | tail -1

exit 0
          --mount /dev/sda1:/mnt \
guestmount -i -a pxeboot.img /mnt
extlinux --install /mnt
wget http://boot.ipxe.org/ipxe.iso
guestmount -a ipxe.iso /media
cp /media/ipxe.krn /mnt
cat > /mnt/syslinux.cfg <<EOF
DEFAULT ipxe
LABEL ipxe
  KERNEL ipxe.krn dhcp && chain http://ipxe.consul.local/loader.ipxe
EOF
 
guestunmount /media
guestunmount /mnt