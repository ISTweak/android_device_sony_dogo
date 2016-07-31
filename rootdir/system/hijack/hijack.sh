#!/temp/sh
set +x
echo "======= Hijack: Start hijack.sh =======" > /dev/kmsg
export PATH="/temp:/system/xbin:/system/bin:/sbin"

LED_RED="/sys/class/leds/lm3533-red/brightness"
LED_GREEN="/sys/class/leds/lm3533-green/brightness"
LED_BLUE="/sys/class/leds/lm3533-blue/brightness"

SETLED() {
	if [ "$1" = "off" ]; then
		echo "0" > ${LED_RED}
		echo "0" > ${LED_GREEN}
		echo "0" > ${LED_BLUE}
	else
		echo "$1" > ${LED_RED}
		echo "$2" > ${LED_GREEN}
		echo "$3" > ${LED_BLUE}
	fi
}

boot_rom () {
	cd /
	# Stop services
	ps > /cache/log/pre_ps.txt
	mount > /cache/log/pre_umount.txt
	
	pkill -9 /sbin/ric
	rm /sbin/*
	
	for SVCRUNNING in $(getprop | grep -E '^\[init\.svc\..*\]: \[running\]'); do
		SVCNAME=$(expr ${SVCRUNNING} : '\[init\.svc\.\(.*\)\]:.*')
		if [ "${SVCNAME}" != "" ]; then
			stop ${SVCNAME}
			if [ -f "/system/bin/${SVCNAME}" ]; then
				pkill -f /system/bin/${SVCNAME}
			fi
		fi
	done

	for LOCKINGPID in `lsof | awk '{print $1" "$2}' | egrep "/bin|/system|/data|/cache" | awk '{print $1}'`; do
		BINARY=$(cat /proc/${LOCKINGPID}/status | grep -i "name" | awk -F':\t' '{print $2}')
		if [ "$BINARY" != "" ]; then
			killall $BINARY
		fi
	done

	ps > /cache/log/post_ps.txt
	lsmod > /cache/log/post_mod.txt
	
	# umount
	umount -l /acct
	umount -l /dev/cpuctl
	umount -l /dev/pts
	umount -l /data
	umount -l /mnt/idd
	umount -l /lta-label

	## misc
	umount -l /mnt/secure
	umount -l /mnt/asec
	umount -l /mnt/obb
	umount -l /mnt/qcks

	umount -d /system/odex.priv-app
	umount -d /system/odex.app
	umount -l /system
	
	mount > /cache/log/post_umount.txt

	umount -l /cache

	umount -l /dtvtmp/dtv
	umount -l /dev
	umount -l /sys/fs/selinux
	umount -l /sys/fs/cgroup
	umount -l /sys/kernel/debug
	umount -l /sys
	umount -l /proc
	umount -l /tmp

#	mount > /temp/log/post_umount.txt
	# clean /
	cd /
	rm -rf /sbin
	rm -rf /storage
	rm -rf /mnt
	rm -f sdcard sdcard1 ext_card init*
#	ls -laR > /temp/log/post_clean_ls.txt
#	ps a > /temp/log/finish_ps.txt
}

mount -o remount,rw rootfs /
if [ "$(grep 'warmboot=0x77665502' /proc/cmdline | wc -l)" = "1" -o -e /cache/recovery/command ]; then
	touch /cache/recovery/twrp
else
	SETLED 255 255 0
	echo 150 > /sys/class/timed_output/vibrator/enable
	usleep 300000
	echo 150 > /sys/class/timed_output/vibrator/enable

	for EVENTDEV in $(/temp/find /dev/input -name event*)
	do
		SUFFIX="$(expr ${EVENTDEV} : '/dev/input/event\(.*\)')"
		/temp/cat ${EVENTDEV} > /temp/keyevent${SUFFIX} &
	done

	sleep 3

	for CATPROC in $(ps | grep '/temp/cat' | grep -v grep | awk '{print $1;}')
	do
		/temp/kill -9 ${CATPROC}
	done
	SETLED off

	hexdump /temp/keyevent* | grep -e '^.* 0001 0073 .... ....$' > /temp/keycheck_up
	hexdump /temp/keyevent* | grep -e '^.* 0001 0072 .... ....$' > /temp/keycheck_down
fi

# vol-, boot recovery
if [ -s /temp/keycheck_down -o -e /cache/recovery/boot ]
then
    echo "======= Hijack: boot recovery =======" > /dev/kmsg
	SETLED 50 255 0
	rm -f /cache/recovery/boot
	boot_rom
	SETLED off
	
	mkdir /recovery
	cd /recovery
	cpio -idu < /temp/ramdisk-recovery.cpio
	pwd
	chroot /recovery /init
elif [ -s /temp/keycheck_up -o -e /cache/recovery/twrp ]
then
	echo "======= Hijack: boot twrp =======" > /dev/kmsg
	SETLED 0 255 255
	rm -f /cache/recovery/twrp
	boot_rom
	SETLED off
	
	mkdir /recovery
	cd /recovery
	gzip -dc /temp/ramdisk-recovery.img | cpio -i
	pwd
	chroot /recovery /init
elif [ -e /temp/hijacked ]
then
	rm /temp/hijacked
	# Return path variable to default
	export PATH="/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin"
	sleep 1
	exec /system/bin/taimport.orig
else
    echo "======= Hijack: boot ramdisk =======" > /dev/kmsg
	export PATH="/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin"
	touch /temp/hijacked
	boot_rom
	cd /
	cpio -idu < /temp/ramdisk.cpio
	sync
	sleep 2
	#dmesg > /temp/log/post_hijack_dmesg.txt
	ls -laR > /temp/log/post_hijack_ls.txt
	chroot / /init
	sleep 3
fi