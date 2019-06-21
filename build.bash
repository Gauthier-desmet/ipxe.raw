set -x

#dd if=/dev/zero of=pxeboot.img bs=1M count=4
qemu-img create -f raw pxeboot.img 4M

mkdosfs pxeboot.img
sudo losetup /dev/loop0 pxeboot.img
mount /dev/loop0 /mnt
syslinux --install /dev/loop0
wget http://boot.ipxe.org/ipxe.iso
sudo mount -o loop ipxe.iso /media
cp /media/ipxe.krn /mnt
cat > /mnt/syslinux.cfg <<EOF
DEFAULT ipxe
LABEL ipxe
  KERNEL ipxe.krn dhcp && chain http://ipxe.consul.local/loader.ipxe
EOF
sudo umount /media
sudo umount /mnt