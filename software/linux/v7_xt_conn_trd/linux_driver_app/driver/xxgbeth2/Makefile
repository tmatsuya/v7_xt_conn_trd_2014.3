obj-m := xbasic_types.o
obj-m += xxgethernet.o
obj-m += xxgethernet_control.o
obj-m += xgadapter.o
obj-m := xxgbeth2.o
xxgbeth2-objs := xbasic_types.o xxgethernet.o xxgethernet_control.o xgadapter.o
ifeq ($(OS_TYPE),64)
EXTRA_CFLAGS += -DX86_64
endif
# Comment the following when using 1000BASE-X mode
#EXTRA_CFLAGS += -DK7_TRD -DAXI_VERSION  -DX86_PC -DXENV_LINUX -DUSE_IO_MACROS -DPHYSETUP -DXGEMAC_MAC1__ -DUSE_NW_PATH2 -DPM_SUPPORT -I $(XETHERNET2_PATH) -I $(ROOTDIR)/include 

EXTRA_CFLAGS += -DK7_TRD -DAXI_VERSION  -DX86_PC -DXENV_LINUX -DUSE_IO_MACROS -DPHYSETUP -DXGEMAC_MAC1__ -DUSE_NW_PATH2 -DMDIO_CHANGES -DPM_SUPPORT -I $(XETHERNET0_PATH) -I $(ROOTDIR)/include 

#-DDEBUG_VERBOSE -DXGEMAC_DEBUG_ 

#-DENABLE_JUMBO

all:
	$(MAKE) $(CFLAGS) -C $(KDIR) SUBDIRS=$(PWD)/xxgbeth2 
	
clean: 
	   rm -rf *.o *.ko *.mod.* .c* .t* .*.cmd 

# LOGGING: ---------------------------------------------------------------
# Add to EXTRA_CFLAGS, based on the logging level desired:
# -DDEBUG: To enable logging in TEMAC (xxgethernet*) code
# -DDEBUG_NORMAL: To enable normal logging levels in Adapter (xgadapter.c)
# -DDEBUG_VERBOSE: To enable verbose logging levels in Adapter (xgadapter.c)

