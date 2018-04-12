/*
* Copyright (c) 2015 Qualcomm Technologies, Inc.
* All Rights Reserved.
* Confidential and Proprietary - Qualcomm Technologies, Inc.
*/

/****************************************************************************
 * WlanSSR_sample.c
 *
 * This file is a sample implements of the Wlan Sub-System Recover funtion.
 * It receives the broadcast netlink message, picks the offline action and
 * prints it to the screen.
 *
 ****************************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <sys/types.h>
#include <linux/types.h>
#include <sys/socket.h>
#include <linux/netlink.h>

#define MAX_BUF_SIZE 4096
#define MIN_MSG_SIZE 32

static char *offlineStr = "offline";
static char *actionStr = "ACTION=offline";
static char *subsystemStr = "SUBSYSTEM=sdio";
static char *driverStr = "DRIVER=ar6k_wlan";

int main(int argc, char **argv)
{
	int sockid;
	int length;
	char buf[MAX_BUF_SIZE];
	struct sockaddr_nl socketAddr;
	struct iovec iovector;
	struct msghdr msgh;
	int count;
	FILE *fp;
	char *str;
	int bPrint;

	printf("#### WlanSSR Starting ####\n");

	memset(&socketAddr, 0, sizeof(socketAddr));
	socketAddr.nl_family = AF_NETLINK;
	socketAddr.nl_groups = NETLINK_KOBJECT_UEVENT;
	socketAddr.nl_pid = 0;

	memset(&iovector, 0, sizeof(iovector));
	iovector.iov_base = (void *)buf;
	iovector.iov_len = sizeof(buf);

	memset(&msgh, 0, sizeof(msgh));
	msgh.msg_name = (void *)&socketAddr;
	msgh.msg_namelen = sizeof(socketAddr);
	msgh.msg_iov = &iovector;
	msgh.msg_iovlen = 1;

	/* create a socket descriptor */
	sockid = socket(AF_NETLINK, SOCK_RAW, NETLINK_KOBJECT_UEVENT);
	if (sockid < 0) {
		printf("fail to create socket:%s\n", strerror(errno));
		return -ENOTSOCK;
	}

	/* bind the descriptor */
	if (bind(sockid, (struct sockaddr *)&socketAddr,
		sizeof(struct sockaddr)) == -1) {
		printf("bind socket error:%s\n", strerror(errno));
		return -ENOTSOCK;
	}

	/* open a txt file to store the received netlink message */
	fp = fopen("msg.txt", "w");
	if (fp == NULL)
		printf("open msg file error:%s\n", strerror(errno));

	/* receive netlink message */
	while (1) {
		bPrint = 0;
		memset(buf, 0, MAX_BUF_SIZE);
		length = recvmsg(sockid, &msgh, 0);
		if (length < 0) {
			printf("receive error\n");
			continue;
		} else if (length < MIN_MSG_SIZE || length > sizeof(buf)) {
			printf("invalid message\n");
			continue;
		}

		//printf("Received msg, buf: %s\n", buf);

		if (strncmp(offlineStr, buf, strlen(offlineStr)) == 0)
			bPrint |= 1;
		else
			continue;

		for (count = 0; count < length; count++) {
			if (*(buf+count) == '\0') {
				if (count < length-2) {
					str = buf+count+1;
				if (strstr(str, actionStr) != NULL)
					bPrint |= 2;
				if (strstr(str, subsystemStr) != NULL)
					bPrint |= 4;
				if (strstr(str, driverStr) != NULL)
					bPrint |= 8;
				}
				buf[count] = '\n';
			}
		}

		//printf("recieved str: %s, bPrint: %x-%d \n", buf, bPrint, bPrint); 

		if (bPrint == 15)
			printf("received %d bytes\n%s\n", length, buf);
		if (fp != NULL)
			fputs(buf, fp);

		/*******************************************************************/
		//  As to the FW crash recovery, notification message are already  //
		//  detected in above sample code, and additional recovery actions //
		//  can be placed here.                                            //
		//  For example, call a script (reload_wlan.sh) to reload the wlan //
		//  driver.                                                        //
		//  Below is a simple demostration for this action                 //
		//
		//  	
		//  ********* A sample to call the wlan.ko reload script ********* //
		/* 						   
		    printf("Calling %s to reload wlan driver...\n", scriptfile);
		    {
			char *scriptfile = "./reload_wlan.sh";
			int ret = 0;
			ret = system(scriptfile);
			if (ret < 0)
				printf("Failed to run script..");
			else
				printf("Done (%d)..", ret);
		    }
		*/
		//  ************** A sample for reload_wlan.sh ******************* //
		/*  reload_wlan.sh						   
		    #!/bin/sh
		    SCRIPT_LOCATION=/lib/firmware
		    rmmod wlan
		    insmod $SCRIPT_LOCATION/wlan.ko
		*/
		/*******************************************************************/
	
	}

	if (fp != NULL)
		fclose(fp);

	return 0;
}
