ifeq ($(BOARD_HAS_QCOM_WLAN), true)

CFLAGS += -DSIM_AKA_IDENTITY_IMSI
#CFLAGS += -DSIM_AKA_IMSI_RAW_ENABLED

LIBS += -lqmi -lqmiservices -lqcci_legacy

CFLAGS += -I$(WORKSPACE)/qmi/inc
CFLAGS += -I$(WORKSPACE)/qmi/platform
CFLAGS += -I$(WORKSPACE)/qmi/src
CFLAGS += -I$(WORKSPACE)/qmi/services
CFLAGS += -I$(WORKSPACE)/qmi/core/lib/inc

# EAP-AKA' (enable CONFIG_PCSC, if EAP-AKA' is used).
# This requires CONFIG_EAP_AKA to be enabled, too.
# This is supported only in B Family devices.
ifdef CONFIG_EAP_PROXY_AKA_PRIME
CONFIG_EAP_AKA_PRIME=y
endif

endif
