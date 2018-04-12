#!/bin/sh
echo "Start to patch files"
patch -p1 --no-backup-if-mismatch < 0001.BT-device.patch
patch -p1 --no-backup-if-mismatch < 0002.BT-bluedroid.patch
patch -p1 --no-backup-if-mismatch < 0003.BT-libbt.patch
patch -p1 --no-backup-if-mismatch < 0004.BT-vendor.patch
echo "DONE! patch completed"
