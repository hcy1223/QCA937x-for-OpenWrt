#!/bin/bash 
echo "auto soft link"
ln -s /lib/libuClibc-0.9.33.2.so /lib/libc.so.6
ln -s /lib/libm-0.9.33.2.so /lib/libm.so.6
ln -s /lib/librt.so.0 /lib/librt.so.1
