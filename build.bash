set -x

wget http://boot.ipxe.org/ipxe.iso
#export LIBGUESTFS_DEBUG=1 LIBGUESTFS_TRACE=1
guestfish --new pxeboot.img=fs:vfat:4M \
          --add file://${CI_PROJECT_DIR}/ipxe.iso \
<<_EOF_
mount /dev/sda1 /
mkdir /media
mount /dev/sdb  /media
mkdir /boot
cp /media/ipxe.krn /boot
copy-in syslinux.cfg /boot
extlinux /boot
umount /media
rmdir /media
_EOF_