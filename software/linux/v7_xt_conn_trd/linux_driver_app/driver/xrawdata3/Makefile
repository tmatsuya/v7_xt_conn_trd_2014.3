obj-m := sguser.c
obj-m := xrawdata3.o
xrawdata3-objs :=  sguser.o 

ifeq ($(DRIVER_MODE),RAWETHERNET)
EXTRA_CFLAGS += -DRAW_ETH
endif
ifeq ($(OS_TYPE),64)
EXTRA_CFLAGS += -DX86_64
endif
EXTRA_CFLAGS += -DK7_TRD -DX86_PC -DUSE_IO_MACROS -DNWLDMA -DXRAWDATA3 -DPM_SUPPORT -DFIFO_EMPTY_CHECK -DBACK_PRESSURE -I $(XRAWDATA3_PATH) -I $(ROOTDIR)/include/ 

all:
	$(MAKE) $(CFLAGS) -C $(KDIR) SUBDIRS=$(PWD)/xrawdata3 
clean: 
	   rm -rf *.o *.ko *.mod.* .c* .t* .xrawdata*

# LOGGING: ---------------------------------------------------------------
# Add to EXTRA_CFLAGS, based on the logging level desired:
# -DDEBUG_NORMAL: To enable normal logging levels 
# -DDEBUG_VERBOSE: To enable verbose logging levels 
#
