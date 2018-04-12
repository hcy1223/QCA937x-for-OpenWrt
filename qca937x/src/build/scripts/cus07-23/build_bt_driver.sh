#!/bin/bash
echo build android-x86 bluetooth kernel components
rm hardware/broadcom -rf
rm out/target/product/x86/kernel -f
make -j12 kernel TARGET_PRODUCT=android_x86
echo build android-x86 bluetooth kernel components done
mkdir -p btout
cp out/target/product/x86/obj/kernel/drivers/bluetooth/btusb/btusb.ko btout/
cp out/target/product/x86/obj/kernel/drivers/bluetooth/btsbc/btsbc.ko btout/
cp out/target/product/x86/obj/kernel/drivers/bluetooth/btpcm/btpcm.ko btout/
echo copy bt ko done

