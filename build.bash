set -x

wget http://boot.ipxe.org/ipxe.iso
#export LIBGUESTFS_DEBUG=1 LIBGUESTFS_TRACE=1
guestfish --new pxeboot.img=fs:vfat:4M \
          --add file://${CI_PROJECT_DIR}/ipxe.iso \
<<_EOF_
list-devices
list-filesystems
mount /dev/sda1 /
mkdir /media
mount /dev/sdb  /media
ls /
ls /media
mkdir /boot
cp /media/ipxe.krn /boot
copy-in syslinux.cfg /boot
extlinux /boot
umount /media
rmdir /media
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