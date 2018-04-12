#
# Main Makefile
#
export ATH_TOPDIR=$(shell pwd)/../qca937x#no space 
# different customer want to use different wpa_supplicant
# in board_type config file, we can override it
export WPA_SUPPLICANT_TOPDIR=${ATH_TOPDIR}/apps/wpa_supplicant_8
export AIO_VER=1.4.2.07.23.08
export BOARD_TYPE=x86
export HOST_DRIVER_VERSION=4.0.10.213
export BLUETOOTHSTACK=bluedroid
export BOARD_TYPE_AIO_PATCH_CAF=
export IF_TYPE=USB
export ENG_PATCH=1

include ../qca937x/build/scripts/${BOARD_TYPE}/config.${BOARD_TYPE}
include ../qca937x/build/scripts/${BOARD_TYPE}/Makefile.${BOARD_TYPE}
#ifneq ($(wildcard scripts/${BOARD_TYPE}/Makefile.${BLUETOOTHSTACK}), )
#    include scripts/${BOARD_TYPE}/Makefile.${BLUETOOTHSTACK}
#endif
#################################################################################################################################
ifndef KERNELPATH
$(error "Must specify KERNELPATH value")
endif

ifndef KERNELARCH
$(error "Must specify KERNELARCH value")
endif

#################################################################################################################################
export MAKEARCH=make
export INSTALL_ROOT=${ATH_TOPDIR}/rootfs-$(BOARD_TYPE).build
export ROOTFS_TOPDIR=${ATH_TOPDIR}/rootfs
export WLAN_DRIVER_TOPDIR=${ATH_TOPDIR}/drivers
#export IW30_TOPDIR=${ATH_TOPDIR}/apps/iw-3.0
export LIBNL32_TOPDIR=${ATH_TOPDIR}/apps/libnl-3.2.25
#export QCMBR_TOPDIR=${ATH_TOPDIR}/apps/qcmbr
#export BLUETOPIA_TOPDIR=${ATH_TOPDIR}/apps/Bluetopia
#export BTDIAG_TOPDIR=${ATH_TOPDIR}/apps/Btdiag

export ATH_QCACLD_TOPDIR=${WLAN_DRIVER_TOPDIR}/qcacld-new
export ATHDIAG_TOPDIR=${ATH_QCACLD_TOPDIR}/tools/athdiag

#################################################################################################################################
# qcacld PATH
#################################################################################################################################
export FW_WLAN_NAME=qcacld-new
#################################################################################################################################
# CFG80211 PATH
#################################################################################################################################
export CFG80211_NAME=backports

#################################################################################################################################
clean: hostapd_clean wpa_supplicant_clean drivers_clean

#
# rootfs build
#
rootfs_prep:
	@mkdir -p $(INSTALL_ROOT)
	@mkdir -p $(INSTALL_ROOT)/sbin
	@mkdir -p $(INSTALL_ROOT)/usr/sbin
	@mkdir -p $(INSTALL_ROOT)/lib/modules
	@mkdir -p $(INSTALL_ROOT)/etc

drivers: rootfs_prep
	@echo Build drivers
	@echo ${BTDIAG_TOPDIR}
	cd ${WLAN_DRIVER_TOPDIR} && ${MAKEARCH}
	@echo qwerrt
	find ${WLAN_DRIVER_TOPDIR} -name 'cfg80211.ko' -exec cp '{}' $(INSTALL_ROOT)/lib/modules ';'
	find ${WLAN_DRIVER_TOPDIR} -name 'compat.ko' -exec cp '{}' $(INSTALL_ROOT)/lib/modules ';'
	find ${WLAN_DRIVER_TOPDIR} -name 'wlan.ko' -exec cp '{}' $(INSTALL_ROOT)/lib/modules ';'
	find ${WLAN_DRIVER_TOPDIR} -name 'bluetooth.ko' -exec cp '{}' $(INSTALL_ROOT)/lib/modules ';'
	find ${WLAN_DRIVER_TOPDIR} -name 'hci_uart.ko' -exec cp '{}' $(INSTALL_ROOT)/lib/modules ';'
	find ${WLAN_DRIVER_TOPDIR} -name 'btusb.ko' -exec cp '{}' $(INSTALL_ROOT)/lib/modules ';'
	find ${WLAN_DRIVER_TOPDIR} -name 'ath3k.ko' -exec cp '{}' $(INSTALL_ROOT)/lib/modules ';'
	find ${WLAN_DRIVER_TOPDIR} -name 'hidp.ko' -exec cp '{}' $(INSTALL_ROOT)/lib/modules ';'
	find ${WLAN_DRIVER_TOPDIR} -name 'rfcomm.ko' -exec cp '{}' $(INSTALL_ROOT)/lib/modules ';'
	find ${WLAN_DRIVER_TOPDIR} -name 'cmtp.ko' -exec cp '{}' $(INSTALL_ROOT)/lib/modules ';'
	find ${WLAN_DRIVER_TOPDIR} -name 'bnep.ko' -exec cp '{}' $(INSTALL_ROOT)/lib/modules ';'
	@echo Strip modules
	@cd ${INSTALL_ROOT}/lib/modules && ${TOOLPREFIX}strip --strip-unneeded *.ko


drivers_firmware: rootfs_prep
	@echo Install firmware
#	cd ${WLAN_DRIVER_TOPDIR} && ${MAKEARCH} firmware_install

drivers_firmware_transfer:
	@echo Transfer driver firmwares
	cd ${WLAN_DRIVER_TOPDIR} && ${MAKEARCH} firmware_toarray

drivers_clean:
	@echo Clean drivers
	cd ${WLAN_DRIVER_TOPDIR} && ${MAKEARCH} driver_clean

common_patch:
	@echo Start Common Patches
	@cd ${WLAN_DRIVER_TOPDIR} && patch -s -p0 < patches/001-cfg80211-backports-3.12.8-1.patch
	@cd ${WLAN_DRIVER_TOPDIR}/../apps/ && patch -s -p0 < ${WLAN_DRIVER_TOPDIR}/patches/002-wpa_supplicant-for-aio.patch
	@cd ${WPA_SUPPLICANT_TOPDIR} && cp wpa_supplicant/android.config wpa_supplicant/.config
	@cd ${WPA_SUPPLICANT_TOPDIR} && cp hostapd/android.config hostapd/.config
	@echo End of Common Patches

strip_modules:
	@echo Strip modules
	@cd ${INSTALL_ROOT}/lib/modules && ${TOOLPREFIX}strip --strip-unneeded *.ko

