#!/bin/bash -e

install -m 755 files/resize2fs_once	"${ROOTFS_DIR}/etc/init.d/"

install -d				"${ROOTFS_DIR}/etc/systemd/system/rc-local.service.d"
install -m 644 files/ttyoutput.conf	"${ROOTFS_DIR}/etc/systemd/system/rc-local.service.d/"

install -m 644 files/50raspi		"${ROOTFS_DIR}/etc/apt/apt.conf.d/"

install -m 644 files/console-setup   	"${ROOTFS_DIR}/etc/default/"

install -m 755 files/rc.local		"${ROOTFS_DIR}/etc/"

# Change to add files for static net config from /boot/netcfg.txt
install -m 755 files/boot2net.sh		"${ROOTFS_DIR}/usr/local/bin/"
install -m 644 files/boot-net-mods.service		"${ROOTFS_DIR}/lib/systemd/system/"
# End change to add files for static net config from /boot/netcfg.txt

on_chroot << EOF
systemctl disable hwclock.sh
systemctl disable nfs-common
systemctl disable rpcbind
if [ "${ENABLE_SSH}" == "1" ]; then
	systemctl enable ssh
else
	systemctl disable ssh
fi
systemctl enable regenerate_ssh_host_keys
EOF

if [ "${USE_QEMU}" = "1" ]; then
	echo "enter QEMU mode"
	install -m 644 files/90-qemu.rules "${ROOTFS_DIR}/etc/udev/rules.d/"
	on_chroot << EOF
systemctl disable resize2fs_once
EOF
	echo "leaving QEMU mode"
else
	on_chroot << EOF
systemctl enable resize2fs_once
EOF
fi

on_chroot <<EOF
for GRP in input spi i2c gpio; do
	groupadd -f -r "\$GRP"
done
for GRP in adm dialout cdrom audio users sudo video games plugdev input gpio spi i2c netdev; do
  adduser $FIRST_USER_NAME \$GRP
done
EOF

# Add line to replace the username for pi in sudoers.d/010_pi-nopasswd
# and enable boot-net-mods service
on_chroot <<EOF
sed "s/pi/$FIRST_USER_NAME/" -i /etc/sudoers.d/010_pi-nopasswd
ln -s /lib/systemd/system/boot-net-mods.service /etc/systemd/system/multi-user.target.wants/boot-net-mods.service
EOF
# End replace username and enable service
 
on_chroot << EOF
setupcon --force --save-only -v
EOF

on_chroot << EOF
usermod --pass='*' root
EOF

rm -f "${ROOTFS_DIR}/etc/ssh/"ssh_host_*_key*
