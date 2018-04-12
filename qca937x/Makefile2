#
# Copyright (C) 2006-2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=qca937x
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define KernelPackage/qca937x
  SUBMENU:=Wireless Drivers
  TITLE:=support QCA937X WLAN driver(USB)
  AUTOLOAD:=$(call AutoLoad,85,compat cfg80211 wlan) 
  FILES:=$(PKG_BUILD_DIR)/rootfs-x86.build/lib/modules/*.ko
  DEPENDS:=+libpthread +libc +libgcc +librt +libm
endef

define KernelPackage/qca937x/description
	QCA937X driver.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

MAKE_OPTS:= \
	ARCH="$(LINUX_KARCH)" \
	CROSS_COMPILE="$(TARGET_CROSS)" \

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
			$(MAKE_OPTS) \
			LINUX_DIR:=$(LINUX_DIR) 
endef

define KernelPackage/qca937x/install
	$(INSTALL_DIR) $(1)/lib/firmware $(1)/sbin
	$(CP) ./firmware/* $(1)/lib/firmware/

endef

$(eval $(call KernelPackage,qca937x))

