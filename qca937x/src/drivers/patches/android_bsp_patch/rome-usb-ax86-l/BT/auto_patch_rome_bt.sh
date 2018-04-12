#!/bin/sh
echo "Start to patch files"
mv SS1BTUSB.c kernel/drivers/usb/misc/SS1BTUSB.c
mv SS1BTUSB.h kernel/drivers/usb/misc/SS1BTUSB.h
patch -p1 --no-backup-if-mismatch < 0001.BT-device.patch
patch -p1 --no-backup-if-mismatch < 0002.BT-bluedroid.patch
patch -p1 --no-backup-if-mismatch < 0003.BT-frameworks.patch
patch -p1 --no-backup-if-mismatch < 0004.BT-kernel.patch
patch -p1 --no-backup-if-mismatch < 0005.BT-system.patch
patch -p1 --no-backup-if-mismatch < 0006.BT-libbt.patch
patch -p0 --no-backup-if-mismatch < 0007.BT-bluedroid-hci-interface.patch
patch -p0 --no-backup-if-mismatch < 0008.BT-hardware-hci-interface.patch
patch -p0 --no-backup-if-mismatch < 0009.BT-jni-hci-interface.patch
echo "DONE! patch completed"
