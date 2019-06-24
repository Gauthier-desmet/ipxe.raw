set -x

disk_image="${1}"
wget http://boot.ipxe.org/ipxe.iso

export LIBGUESTFS_DEBUG=1 LIBGUESTFS_TRACE=1
guestfish --new ${disk_image}=fs:ext4:4M \
          --add file://${CI_PROJECT_DIR}/ipxe.iso \
<<_EOF_
mount /dev/sda1 /
mkdir /media
mount /dev/sdb  /media
mkdir /boot
cp /media/ipxe.krn /boot
copy-in syslinux.cfg /boot
extlinux /boot
pwrite-device /dev/sda /boot/mbr.bin 0
part-set-bootable /dev/sda 1 true
umount /media
rmdir /media
_EOF_