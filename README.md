# QCA937x-for-OpenWrt
qca937x driver for openwrt

QCA9377/QCA9378 WLAN driver for openwrt(based on "Chaos Calmer-15.05,**linux-3.18.45**"), it tested on x86, use USB.  
## 1. Before build
#### 1. choose CPU Type  
`$vi package/qca937x/src/Makefile`
change BOARD_TYPE
#### 2. choose USB or PCIE
`$vi package/qca937x/src/Makefile`
change IF_TYPE
#### 3. remove some kmod  
kmod-mac80211,kmod-cfg80211,kmod-lib80211    
#### 4. depends  
libpthread,libc,kibgcc,librt,libm  
## 2. How to build
```
$cd openwrt/package/
$git clone https://github.com/hcyllw/QCA937x-for-OpenWrt.git
$cd ..
$make kernel_menuconfig
Power management and ACPI options --->
                [*] Run-time PM core functionality
$make menuconfig
Kernel modules --->
           Wireless Drivers -->
                    <*> kmod-QCA937x
$make V=s or make package/qca937x V=s

```
## 3. After builded  
### WLAN Drivers   
  compat.ko,cfg80211.ko,and wlan.ko.
### QCA9378 firmware  
athsetup.bin,athwlan.bin,fakeboar.bin,otp.bin,utf.bin
### QCA9378 configuration  
wlan/cfg.dat,wlan/qcom.cfg

## 4. install  
kmod is autoload  
```
$iwconfig 
```
you can see wlanX p2p0


---------  
First time use github,please make valuable suggestions.. 0_0

 


