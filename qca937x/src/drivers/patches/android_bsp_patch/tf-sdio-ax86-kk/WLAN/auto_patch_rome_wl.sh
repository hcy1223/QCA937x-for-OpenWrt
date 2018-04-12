#! /bin/bash
echo "Start to patch files"
mkdir temp
cd temp
wget https://www.codeaurora.org/cgit/quic/la/platform/hardware/qcom/wlan/snapshot/wlan-android-4.4.4_r2.0.1.tar.gz
tar -zxvf wlan-android-4.4.4_r2.0.1.tar.gz
cd ..

patch -p1 --no-backup-if-mismatch < 0001.WL-device.patch
patch -p1 --no-backup-if-mismatch < 0002.WL-frameworks.patch
patch -p1 --no-backup-if-mismatch < 0003.WL-hardware.patch
patch -p1 --no-backup-if-mismatch < 0004.WL-kernel.patch
patch -p1 --no-backup-if-mismatch < 0005.WL-3.10-kernel-tcp-rx-tput-fix.patch
cp sysctl.conf out/target/product/x86/system/etc/
if [ ! -d "hardware/qcom" ]; then
	mkdir hardware/qcom
fi
if [ ! -d "hardware/qcom/wlan" ]; then
	mkdir hardware/qcom/wlan
fi
mv temp/wlan-android-4.4.4_r2.0.1/qcwcn hardware/qcom/wlan/
rm -fr temp
echo "Done! patch completed!"
