set -x

disk_image="${1}.qcow2"
wget http://boot.ipxe.org/ipxe.iso

export LIBGUESTFS_DEBUG=1 LIBGUESTFS_TRACE=1
qemu-img create -f qcow2 ${disk_image} 10M
mkdosfs ${disk_image}

guestfish --add file://${CI_PROJECT_DIR}/${disk_image} \
          --add file://${CI_PROJECT_DIR}/ipxe.iso \
<<_EOF_
run
list-devices
list-filesystems
mount /dev/sda /
mkdir /media
mount /dev/sdb  /media
mkdir /boot
cp /media/ipxe.krn /
copy-in syslinux.cfg /
syslinux /dev/sda
umount /media
rmdir /media

_EOF_