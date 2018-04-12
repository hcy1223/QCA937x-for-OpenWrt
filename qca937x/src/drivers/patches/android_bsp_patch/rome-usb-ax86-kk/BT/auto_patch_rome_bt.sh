#!/bin/sh
echo "Start to sync hci of bluedroid"
mkdir -p external/bluetooth/bluedroid/hci
mkdir temp
cd temp
wget https://www.codeaurora.org/cgit/quic/la/platform/external/bluetooth/bluedroid/snapshot/bluedroid-7ee41708ce979ae1051e03f8f98dff3df3413124.tar.gz
tar -zxvf bluedroid-7ee41708ce979ae1051e03f8f98dff3df3413124.tar.gz
mv bluedroid-7ee41708ce979ae1051e03f8f98dff3df3413124 bluedroid
cp -rf bluedroid/hci ../external/bluetooth/bluedroid
cd ../
echo "DONE! sync hci of bluedroid completed"

echo "Start to sync QCOM libbt"
mkdir -p hardware/qcom/bt
cd temp
wget https://www.codeaurora.org/cgit/quic/la/platform/hardware/qcom/bt/snapshot/bt-58e312a0bc18be867f8dfebbce8e3f08f19a7651.tar.gz
tar -zxvf bt-58e312a0bc18be867f8dfebbce8e3f08f19a7651.tar.gz
mv bt-58e312a0bc18be867f8dfebbce8e3f08f19a7651 bt
cp -rf bt ../hardware/qcom
echo "DONE! sync QCOM libbt completed"
cd ../
rm -rf temp

echo "Copy SS1BTUSB files"
mv SS1BTUSB.c kernel/drivers/bluetooth/SS1BTUSB.c
mv SS1BTUSB.h kernel/drivers/bluetooth/SS1BTUSB.h
echo "DONE! copy SS1BTUSB files completed"

echo "Start to patch files"
patch -p1 --no-backup-if-mismatch < 0001.BT-device-config.patch
patch -p1 --no-backup-if-mismatch < 0002.BT-bluedroid.patch
patch -p1 --no-backup-if-mismatch < 0003.BT-libbt.patch
patch -p1 --no-backup-if-mismatch < 0004.BT-kernel.patch
patch -p1 --no-backup-if-mismatch < 0005.BT-vendor.patch
echo "DONE! patch completed"
