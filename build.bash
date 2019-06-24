set -x

git clone https://git.ipxe.org/ipxe.git
cd ipxe/src
make bin/ipxe.usb EMBED=${CI_PROJECT_DIR}/embed.ipxe

exit 0
disk_image="${1}.qcow2"
wget http://boot.ipxe.org/ipxe.iso

#export LIBGUESTFS_DEBUG=1 LIBGUESTFS_TRACE=1
qemu-img create -f qcow2 ${disk_image} 1G
guestfish --add file://${CI_PROJECT_DIR}/${disk_image} \
          --add file://${CI_PROJECT_DIR}/ipxe.iso \
<<_EOF_
run
part-disk /dev/sda mbr
part-set-bootable /dev/sda 1 true
pwrite-device /dev/sda /usr/share/syslinux/mbr.bin 0
mkfs ext2 /dev/sda1
mount /dev/sda1 /
mkdir /media
mount /dev/sdb  /media
list-devices
list-filesystems
mkdir-p /boot/extlinux
cp /media/ipxe.krn /boot/
copy-in extlinux.conf /boot/extlinux
extlinux /boot/extlinux
umount /media
rmdir /media
_EOF_