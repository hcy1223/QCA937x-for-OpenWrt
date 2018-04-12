# Makefile for WlanSSR_sample

CC := $(ATH_CROSS_COMPILE_TYPE)gcc
TARGET_TYPE ?= AR9888
TARGET_VERS ?= v2


all:
	$(CC) -g3 -Wall \
		WlanSSR_sample.c -o WlanSSR

clean:
	rm -f WlanSSR
	rm -f *.o


