#!/bin/sh
DMA_MODULE_NAME="xdma_v7"
RAWMODULE="xrawdata3"
RAWMODULE1="xrawdata0"
ETHERAPP="xxgbeth0"
STATSFILE="xdma_stat"

if [ -d /sys/module/$DMA_MODULE_NAME ]; then
	if [ -d /sys/module/$RAWMODULE ]; then
		cd driver && sudo make DRIVER_MODE=RAWETHERNET remove
	elif [ -d /sys/module/$RAWMODULE1 ]; then
		cd driver && sudo make remove
	elif [ -d /sys/module/$ETHERAPP ]; then
		cd driver && sudo make DRIVER_MODE=ETHERNETAPP remove
	else
		sudo rmmod $DMA_MODULE_NAME
	fi
fi
if [ -c /dev/$STATSFILE ]; then
	sudo rm -rf /dev/$STATSFILE
fi

#pgrep App|xargs kill -SIGINT 1>/dev/null 2>&1
#sleep 5;

