# Copyright (C) 2006-2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=hostapd_for_qca
PKG_VERSION:=2018-04-11
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

PKG_BUILD_PARALLEL:=1

PKG_CONFIG_DEPENDS:= \
	CONFIG_DRIVER_WIRED_SUPPORT \
	CONFIG_DRIVER_NL80211_SUPPORT


TARGET_LDFLAGS += -lcrypto -lssl
TARGET_CFLAGS += -DNO_TIMESTAMP_CHECK
  
ifdef CONFIG_USE_GLIBC
  TARGET_LDFLAGS += -lrt
  TARGET_LDFLAGS_C += lrt
endif

DRV_DEPENDS:=+libnl-tiny

DRIVER_MAKEOPTS= \
	CONFIG_OS=unix \
	CONFIG_PEERKEY=y \
	CONFIG_AP=y 

NL80211_MAKEOPTS= \
	CONFIG_ACS=y \
	CONFIG_DRIVER_NL80211=y \
	CONFIG_LIBNL32=y \
	CONFIG_IEEE80211N=y \
	CONFIG_IEEE80211R=y \
	CONFIG_IEEE80211W=y \
	CONFIG_IEEE80211AC=y 


WPS_MAKEOPTS= \
	CONFIG_WPS=y \
	CONFIG_WPS2=y \
	CONFIG_PKCS12=y \
	CONFIG_IPV6=y \
	CONFIG_NO_RADIUS=y \
	CONFIG_PKCS12=y 

DRIVER_MAKEOPTS += $(NL80211_MAKEOPTS)
DRIVER_MAKEOPTS += $(WPS_MAKEOPTS)
DRIVER_MAKEOPTS += CONFIG_TLS=openssl
DRIVER_MAKEOPTS += NEED_RFKILL=y

define Package/hostapd_for_qca
  SECTION:=net
  CATEGORY:=Network
  TITLE:=hostapd for QCA
  DEPENDS:=$(DRV_DEPENDS) +libopenssl +libubus +libubox
endef



define Package/hostapd_for_qca/Description
  Hostapd for QCA937X.
  If you want to modify the configuration file,please modify the variable DRIVER_MAKEOPTS in this Makefile.
endef


ifneq ($(wildcard $(PKG_BUILD_DIR)/wpa_supplicant_8.config*),$(subst .configured,.config,$(STAMP_CONFIGURED)))
  define Build/Configure/rebuild
	$(FIND) $(PKG_BUILD_DIR) -name \*.o -or -name \*.a | $(XARGS) rm -f
	rm -f $(PKG_BUILD_DIR)/wpa_supplicant_8/hostapd/hostapd
	rm -f $(PKG_BUILD_DIR)/wpa_supplicant_8/.config*
	touch $(subst .configured_,.config_,$(STAMP_CONFIGURED))
  endef
endif

define Build/Configure
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
	$(CP) $(PKG_BUILD_DIR)/wpa_supplicant_8/hostapd/android.config $(PKG_BUILD_DIR)/wpa_supplicant_8/hostapd/.config
endef

TARGET_CPPFLAGS := \
	-I$(STAGING_DIR)/usr/include/libnl-tiny \
	-I$(PKG_BUILD_DIR)/src/crypto \
	$(TARGET_CPPFLAGS) \
	-DCONFIG_LIBNL20 \
	-D_GNU_SOURCE 

TARGET_CFLAGS += -ffunction-sections -fdata-sections
TARGET_LDFLAGS += -Wl,--gc-sections
#ifeq ($(findstring supplicant,$(BUILD_VARIANT)),)
TARGET_LDFLAGS += -lubox -lubus
#endif

ifdef CONFIG_PACKAGE_kmod-qca937x
TARGET_LDFLAGS += -lm -lnl-tiny
endif


define Build/Compile
	CFLAGS="$(TARGET_CPPFLAGS) $(TARGET_CFLAGS)" \
	make -C $(PKG_BUILD_DIR)/wpa_supplicant_8/hostapd	\
		$(TARGET_CONFIGURE_OPTS) \
		$(DRIVER_MAKEOPTS) \
		LIBS="$(TARGET_LDFLAGS)" \
		LIBS_c="$(TARGET_LDFLAGS_C)" \
		BCHECK= \
		 hostapd 
endef


define Package/hostapd_for_qca/install
	$(INSTALL_DIR) $(1)/usr/sbin $(1)/etc
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/wpa_supplicant_8/hostapd/hostapd $(1)/usr/sbin/
	$(CP) $(PKG_BUILD_DIR)/wpa_supplicant_8/hostapd/hostapd.conf $(1)/etc
endef

$(eval $(call BuildPackage,hostapd_for_qca))
