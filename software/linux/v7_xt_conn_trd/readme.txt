*************************************************************************
   ____  ____ 
  /   /\/   / 
 /___/  \  /   
 \   \   \/    © Copyright 2014 Xilinx, Inc. All rights reserved.
  \   \        This file contains confidential and proprietary 
  /   /        information of Xilinx, Inc. and is protected under U.S. 
 /___/   /\    and international copyright and other intellectual 
 \   \  /  \   property laws. 
  \___\/\___\ 
 
*************************************************************************

Vendor: Xilinx 
Current readme.txt Version: 1.1 
Date Last Modified: 06MAY2014 
Date Created: 02MAY2013

Associated Filename: Virtex-7 XT Connectivity Targeted Reference Design
Associated Document: UG962/GSG966

Supported Device(s): Virtex-7 XT (690T-FFG1761) 
   
*************************************************************************

Disclaimer: 

      This disclaimer is not a license and does not grant any rights to 
      the materials distributed herewith. Except as otherwise provided in 
      a valid license issued to you by Xilinx, and to the maximum extent 
      permitted by applicable law: (1) THESE MATERIALS ARE MADE AVAILABLE 
      "AS IS" AND WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL 
      WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, 
      INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, 
      NON-INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and 
      (2) Xilinx shall not be liable (whether in contract or tort, 
      including negligence, or under any other theory of liability) for 
      any loss or damage of any kind or nature related to, arising under 
      or in connection with these materials, including for any direct, or 
      any indirect, special, incidental, or consequential loss or damage 
      (including loss of data, profits, goodwill, or any type of loss or 
      damage suffered as a result of any action brought by a third party) 
      even if such damage or loss was reasonably foreseeable or Xilinx 
      had been advised of the possibility of the same.

Critical Applications:

      Xilinx products are not designed or intended to be fail-safe, or 
      for use in any application requiring fail-safe performance, such as 
      life-support or safety devices or systems, Class III medical 
      devices, nuclear facilities, applications related to the deployment 
      of airbags, or any other applications that could lead to death, 
      personal injury, or severe property or environmental damage 
      (individually and collectively, "Critical Applications"). Customer 
      assumes the sole risk and liability of any use of Xilinx products 
      in Critical Applications, subject only to applicable laws and 
      regulations governing limitations on product liability.

THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS 
FILE AT ALL TIMES.

*************************************************************************

This readme file contains these sections:

1. REVISION HISTORY
2. OVERVIEW
3. SOFTWARE TOOLS AND SYSTEM REQUIREMENTS
4. DESIGN FILE HIERARCHY
5. INSTALLATION AND OPERATING INSTRUCTIONS
6. OTHER INFORMATION (OPTIONAL)
7. SUPPORT


1. REVISION HISTORY 

            Readme  
Date        Version      Revision Description
=========================================================================
02MAY2013   1.0          Initial Xilinx release.
06MAY2014   1.1		 Updated for 2014.1 release, 1600 Mbps DDR3
=========================================================================

2. OVERVIEW

    This is a x8 GEN3 endpoint design which has scatter gather DMA from
    Northwest Logic, two DDR3 controllers each operating at 1600Mbps, four
    ten gigabit ethernet MAC with 10GBASE-R physical layer.
    The design operates in the following modes-
    
    a. Performance Mode (GEN/CHK) : This mode highlights PCIe-DMA performance
    with traffic generator and checker connected behind C2S0 and S2C0 channels
    respectively. This mode exercises traffic only through these two DMA
    channels.
    Following options are provided in this mode-
      i. Loopback - Software generates traffic which is transferred to FPGA
      over PCIe-DMA. This data is stored in DDR3 based virtual FIFO and looped
      back to software.
      ii. Checker - Software generates traffic which is transferred to FPGA
      over PCIe-DMA. This is stored in DDR3 based virtual FIFO and verified by
      checker in hardware.
      iii. Generator - Hardware generates traffic which is stored in DDR3
      based virtual FIFO and then passed onto software over PCIe-DMA.

    b. Performance Mode (Raw Ethernet) : This mode highlights hardware network
    path performance. Raw Ethernet broadcast frames from software driver
    traverse through PCIe-DMA, DDR3 virtual FIFO and 10GMAC-10GBASE-R PHY.

    c. Application Mode : This mode showcases use in quad NIC scenario. Basic
    ping functionality is provided as an example.

    Also provided are linux (32-bit and 64-bit Fedora-16) device drivers with user space
    application for traffic generation and consumption.

3. SOFTWARE TOOLS AND SYSTEM REQUIREMENTS

    a. Hardware
      i.  VC709 Base Kit with Avago module and Fiber optic cables 
      ii. PC with PCI Express slot (x8 PCIe v3.0 compliant)
      iii.Keyboard & Mouse

    b. Software
      i. Fedora-16 (32-bit) live CD

    c. Test Setup
      i. Connect the four Avago modules in four SFP+ cages on VC709
     ii. Connect Fiber optic cable between the following-
            P2 - P3 cage and P4 - P5 cage
        This connection ordering is necessary to ensure proper software 
        driver operation.   

4. SOFTWARE DESIGN FILE HIERARCHY

    After extracting v7_xt_conn_trd.tar.gz, this is what the directory
    structure will look like:

    v7_xt_conn_trd : Main software folder
    |
    |--linux_driver_app : Source code for linux device driver, user application and Java based GUI         
    |  |
    |  |---App : CRC and thread functions
    |  |
    |  |---Docs : Doxygen html files
    |  |
    |  |---driver : Linux driver source files
    |  |   |   
    |  |   |---xdma : Base DMA driver source files
    |  |   |
    |  |   |---xrawdata0, xrawdata1, xrawdata2, xrawdata3: 
    |  |   |                             Raw data driver source files
    |  |   |---xxgbeth0, xxgbeth1, xxgbeth2, xxgbeth3: 
    |  |                                10GMAC driver source files
    |  |
    |  |---gui : Application GUI source files   
    |  |
    |  |---util : Script for address translation for out-of-box ping test   
    |
    |--readme.txt : the file you are currently reading  
    |
    |--quickstart.sh : Script for starting the TRD GUI


5. INSTALLATION AND OPERATING INSTRUCTIONS 
  
   See the Getting Started Guide - UG966 

6. OTHER INFORMATION (OPTIONAL) 

   a)  Known Issues

    i. The graphical user interface does not show power number plots. 
    This can happen when FPGA is reprogrammed leaving the earlier design 
    accessing PMBUS controllers in an unknown state.
   ii. 64-bit OS performance
        On Fedora 16 64-bit version performance is observed to be less when 
        compared with Fedora latest versions(Fedora 17 and Fedora 18). 

7. SUPPORT

    To obtain technical support for this reference design, go to 
    www.xilinx.com/support to locate answers to known issues in the Xilinx
    Answers Database or to create a WebCase.  
