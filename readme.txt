*******************************************************************************
** © Copyright 2012-2014 Xilinx, Inc. All rights reserved.
** This file contains confidential and proprietary information of Xilinx, Inc. and 
** is protected under U.S. and international copyright and other intellectual property laws.
*******************************************************************************
**   ____  ____ 
**  /   /\/   / 
** /___/  \  /   Vendor: Xilinx 
** \   \   \/    
**  \   \        Readme Version: 1.3  
**  /   /          
** /___/   /\     
** \   \  /  \   Associated Filename: Virtex-7 XT Connectivity Targeted Reference Design 
**  \___\/\___\ 
** 
**  Device: XC7VX690T
**  Purpose: Targeted Reference Design
**  Reference: UG962
**     
*******************************************************************************
**
**  Disclaimer: 
**
**      This disclaimer is not a license and does not grant any rights to the materials 
**              distributed herewith. Except as otherwise provided in a valid license issued to you 
**              by Xilinx, and to the maximum extent permitted by applicable law: 
**              (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, 
**              AND XILINX HEREBY DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, 
**              INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT, OR 
**              FITNESS FOR ANY PARTICULAR PURPOSE; and (2) Xilinx shall not be liable (whether in contract 
**              or tort, including negligence, or under any other theory of liability) for any loss or damage 
**              of any kind or nature related to, arising under or in connection with these materials, 
**              including for any direct, or any indirect, special, incidental, or consequential loss 
**              or damage (including loss of data, profits, goodwill, or any type of loss or damage suffered 
**              as a result of any action brought by a third party) even if such damage or loss was 
**              reasonably foreseeable or Xilinx had been advised of the possibility of the same.


**  Critical Applications:
**
**      Xilinx products are not designed or intended to be fail-safe, or for use in any application 
**      requiring fail-safe performance, such as life-support or safety devices or systems, 
**      Class III medical devices, nuclear facilities, applications related to the deployment of airbags,
**      or any other applications that could lead to death, personal injury, or severe property or 
**      environmental damage (individually and collectively, "Critical Applications"). Customer assumes 
**      the sole risk and liability of any use of Xilinx products in Critical Applications, subject only 
**      to applicable laws and regulations governing limitations on product liability.

**  THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT ALL TIMES.

*******************************************************************************

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
01MAY2013   1.0          Initial Xilinx release for 2013.1.
            1.1          Updated for 2013.2
                           - New directory structure
                           - Updated PCIe, MIG IPs
                           - New NWL DMA with encoded RTL instead of NGC
                           - Modelsim version changed to 10.2a
	          1.2 	       Updated for 2014.1
	    		                 - Updated IPs for 2014.1
			                     - Shared Logic inside network_path_0 for Ethernet 
			                       paths 0,1,2,3
	    		                 - MIG settings reduced from 1866 to 1600 Mbps
			                     - No longer using 233 MHz clock input
			                     - New NWL DMA with reduced number of resets
                           - Minor modifications to resets
            1.3          Updated for 2014.3
                           - Updated IPs for 2014.3
                           - New NWL DMA netlist with unused modules removed
                           - Replaced AXI4Lite Interconnect IP with AXI Crossbar IP
                           - Address map for Power Monitoring registers modified
			   
=========================================================================

2. OVERVIEW

    This is a x8 GEN3 endpoint design which has scatter gather DMA from
    Northwest Logic, dual DDR3 controllers each operating at 1600Mbps, four 
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

    Also provided are linux (32-bit and 64-bit Fedora-16) device drivers with user 
    space application for traffic generation and consumption.

3. SOFTWARE TOOLS AND SYSTEM REQUIREMENTS

    a. Hardware
        i.  VC709 Connectivity Kit (Rev-1.0 with Production Silicon and other components in kit)
       ii. PC with PCI Express slot (x8 PCIe v3.0 compliant)
      iii.Keyboard, Monitor & Mouse

    b. Software
        i. QuestaSim/ModelSim v10.2a  
       ii. Vivado 2014.3
        
    c. IP Versions used
        i. 7 Series PCIe                              : v3.0
       ii. 7 Series MIG                               : v2.2
      iii. AXI Stream Interconnect                    : v1.1
       iv. AXI Virtual FIFO Controller                : v2.0
        v. AXI Crossbar                               : v2.1
       vi. Ten Gigabit Ethernet MAC                   : v14.0
      vii. Ten Gigabit PCS-PMA                        : v5.0
     viii. Fifo Generator                             : v12.0
       ix. NWL Packet DMA for Gen3                    : v1.10

4. DESIGN FILE HIERARCHY 

    v7_xt_conn_trd : Main TRD folder
    |
    |--readme.txt : the file you are currently reading  
    |        
    |---doc  : Link to documentation on the web         
    |
    |---hardware : All hardware related files
    |  |
    |  |---sources
    |  |  |
    |  |  |---constraints : Timing and Location constraints
    |  |  |
    |  |  |---hdl : Custom RTL deliverables for the TRD
    |  |  |  |
    |  |  |  |----clock_control : Files for controlling the Si5324 clock multiplier
    |  |  |  |
    |  |  |  |----common  : Common files for the design
    |  |  |  |
    |  |  |  |----network_path : Files for network application
    |  |  |  |
    |  |  |  |----gen_chk : Files for performance mode hardware generator & checker
    |  |  |  |
    |  |  |  |----pvtmon: Files for power, temperature monitoring
    |  |  |
    |  |  |---ip_catalog : Vivado IP Catalog IPs
    |  |  |
    |  |  |---ip_cores : Xilinx & third party IPs
    |  |  |
    |  |  |---testbench : Testbench for out-of-box simulation  
    |  |  |  |   
    |  |  |  |----dsport  : Wrapper files and tasks for downstream port   
    |  |      
    |  |---vivado  : Vivado scripts & project files
    |  |  |
    |  |  |---scripts : TCL scripts, .do files, and miscellaneous scripts
    |  |  |
    |  |  |---runs (generated by Vivado)
    |
    |---ready_to_test : Prebuilt bitfile & MCS file
    |
    |---software
    |  |
    |  |---linux : contains compressed tar file (v7_xt_conn_trd.tar.gz) 
       |           with drivers and GUI code


v7_xt_conn_trd.tar.gz once extracted will have the following directory structure:
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
    |  |   |---xrawdata0, xrawdata1, xrawdata2, xrawdata3 : Raw data driver source files
    |  |   |
    |  |   |---xxgbeth0, xxgbeth1, xxgbeth2, xxgbeth3 : Ethernet driver source files
    |  |
    |  |---gui : Application GUI source files   
    |  |
    |  |---util : Script for address translation for out-of-box ping test 
    |  |
    |--readme.txt : Information on the software driver
    |
    |--quickstart.sh : Script for starting the TRD GUI 

5. OPERATING INSTRUCTIONS 

   This section summarizes the operating instructions for implementation and simulation flow. 
   
 
 IMPLEMENTATION FLOW 
 -------------------
 a. In Windows, open Vivado Tcl Shell, and navigate to the TRD's vivado folder.
    To run the Vivado flow in batch mode, type at the prompt:
        source scripts/v7_xt_conn_trd_batch_impl.tcl
        
        This will run the entire implementation flow in Tcl mode, and generates a bitstream
      
    To run the Vivado flow in GUI mode, open the Vivado GUI, and from the Tcl Console, type:
        cd <TRD location>/vivado
        source scripts/v7_xt_conn_trd.tcl
        
        This loads the project, sources the RTL and generates IP files. Click on
        Generate Bitstream and the flow will run Synthesis and Implementation and generate 
        a bitstream.

 b. In Linux, open a Terminal window, and navigate to the TRD's vivado folder.
    To run the Vivado flow in batch mode, type at the prompt:
        vivado -mode batch -source scripts/v7_xt_conn_trd_batch_impl.tcl
        
        This will run the entire implementation flow in batch mode, and generates a bitstream.
      
    To run the Vivado flow in GUI mode, type at the prompt:
        vivado -source scripts/v7_xt_conn_trd.tcl
        
        This loads the project, sources the RTL and generates IP files. Click on
        Generate Bitstream and the flow will run Synthesis and Implementation and generate 
        a bitstream.

      Both these cases produce run files and logs under the vivado/runs directory.
      The bitfile will be available under
      runs/xt_conn_trd.runs/impl_1/xt_connectivity_trd.bit


 SIMULATION FLOW 
 ---------------

   Configuring the TRD for different modes (Simulation only)
   -------------------
   There are four configurations for the TRD, which can be easily selected by changing the
   v7_xt_conn_trd.tcl script on the line that says 'set TRD_MODE "FULL"'.  FULL is the default 
   value for the TRD.  Change the TRD_MODE to one of the following to simulate other 
   configurations.
 
    a. FULL        - Simulates the entire TRD, from PCIe/DMA to DDR3-based VFIFO to Ethernet.
    b. NODDR3      - Simulates PCIe/DMA to BRAM-based FIFO to Ethernet, no DDR3
    c. BASE        - Simulates PCIe/DMA to DDR3-based VFIFO in loopback, no Ethernet
    d. LOOPBACK    - Simulates PCIe/DMA in loopback, no DDR3 or Ethernet

   QuestaSim/ModelSim
   --------
   Requires Xilinx tools and QuestaSim or ModelSim.
   Set MODELSIM environment variable to point to the 'modelsim.ini' file which contains paths 
   to the compiled libraries.

    a. In Windows, open Vivado Tcl Shell, and navigate to the TRD's vivado folder.
       To run the simulation flow in batch mode, type at the prompt:
           source scripts/v7_xt_conn_trd_batch_sim_mti.tcl

           This will run the entire simulation flow in Tcl mode.

       To run the simulation flow in GUI mode, open the Vivado GUI, and from the Tcl Console, 
       type:
           cd <TRD location>/vivado
           source scripts/v7_xt_conn_trd.tcl
        
           This loads the project, sources the RTL and generates IP files. Click on
           Run Simulation to run the simulation.  QuestaSim/ModelSim GUI will be loaded by Vivado
           and should start automatically.
        

    b. In Linux, open a Terminal window, and navigate to the TRD's vivado folder.
       To run the simulation flow in batch mode, type at the prompt:
           vivado -mode batch -source scripts/v7_xt_conn_trd_batch_sim_mti.tcl
        
           This will run the entire simulation flow in batch mode.

       To run the simulation flow in GUI mode, type at the prompt:
           vivado -source scripts/v7_xt_conn_trd.tcl
        
           This loads the project, sources the RTL and generates IP files. Click on
           Run Simulation to run the simulation.  QuestaSim/ModelSim GUI will be loaded by Vivado.


   XSIM
   --------
   Requires Xilinx tools 

    a. In Windows, open Vivado Tcl Shell, and navigate to the TRD's vivado folder.
       To run the simulation flow in batch mode, type at the prompt:
           source scripts/v7_xt_conn_trd_batch_sim_xsim.tcl

           This will run the entire simulation flow in Tcl mode.

       To run the simulation flow in GUI mode, open the Vivado GUI, and from the Tcl Console, 
       type:
           cd <TRD location>/vivado
           source scripts/v7_xt_conn_trd.tcl
        
           This loads the project, sources the RTL and generates IP files. Click on
           Simulation Settings, and choose Vivado Simulator from the Target Simulator
           drop-down menu, confirm by clicking "Yes" then hit OK.  Click Run Simulation 
           to run the simulation.
        

    b. In Linux, open a Terminal window, and navigate to the TRD's vivado folder.
       To run the simulation flow in batch mode, type at the prompt:
           vivado -mode batch -source scripts/v7_xt_conn_trd_batch_sim_xsim.tcl
        
           This will run the entire simulation flow in batch mode.

       To run the simulation flow in GUI mode, type at the prompt:
           vivado -source scripts/v7_xt_conn_trd.tcl
        
           This loads the project, sources the RTL and generates IP files. Click on
           Simulation Settings, and choose Vivado Simulator from the Target Simulator
           drop-down menu, confirm by clicking "Yes" then hit OK.  Click Run Simulation 
           to run the simulation.

 TESTING
 -------
   To test the design in hardware, refer to either the GSG or 'Chapter-2 Getting Started' 
   in the TRD user guide. 
   
6. OTHER INFORMATION / TROUBLESHOOTING
        
  a. The graphical user interface does not show power number plots. 
     This can happen when FPGA is reprogrammed leaving the earlier design accessing PMBUS 
     controllers in an unknown state.
     Resolution: Power off the host machine and power cycle the VC709 board and this should 
     be fixed
     
  b. Unzipping the TRD zip file in Windows and copying over the unzipped folder to Linux 
     leaves some files without having execution permission. User has to manually do 
     'chmod +x <file name>' on a terminal to make the files executable.

  c. On Fedora 16 64-bit version performance is observed to be lower when compared with 
     Fedora latest versions(Fedora 17 and Fedora 18). 

  d. Linux GUI is tested with JDK 1.7 version.

  e. The Linux GUI in TRD uses jfreechart as a library and no modifications have 
     been done to the downloaded source/JAR. jfreechart is downloaded from 
     http://www.jfree.org/jfreechart/download.html and is licensed under the terms of LGPL. 
     A copy of the source along with license is included in this distribution.

  f. The TRD works on Virtex-7 XT production silicon

  g. The interrupt mode of operation of the Linux driver has been tested with Fedora kernel 
     version 3.5

  h. The user can download the Fedora 16 64-bit OS from the below link:
     http://www.fedoraproject.org
     It is advised that user installs the full version of Fedora (DVD ISO image) on the 
     machine with PCIe slot in it. Refer to UG962 for more details on PCIe host machine.
     
  i. The TRD synthesis and implementation steps may take a long time, depending on the machine 
     used. This is best saved for an overnight task.
     
  j. This TRD may have difficulty meeting timing if any changes are made to the RTL.  
     This design should meet timing if used as-shipped with 2014.3.
     
  k. The 10G Ethernet MAC IP core requires a license to build the design. The 
     license can be obtainined by clicking on Evalaute or Order in the following 
     page http://www.xilinx.com/products/intellectual-property/DO-DI-10GEMAC.htm    

  l. The 10G Ethernet PCS-PMA 10GBASE-R IP core requires a license to build the design. 
     The license can be obtainined by clicking on Evalaute or Order in the following 
     page http://www.xilinx.com/products/intellectual-property/10GBASE-R.htm
        
7. SUPPORT
     For more help, please see the Master Answer record for this TRD, at
     http://www.xilinx.com/support/answers/51901.htm.
     