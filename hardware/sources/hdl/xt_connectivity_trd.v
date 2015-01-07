/*******************************************************************************
** � Copyright 2009 - 2014 Xilinx, Inc. All rights reserved.
** This file contains confidential and proprietary information of Xilinx, Inc. and 
** is protected under U.S. and international copyright and other intellectual property laws.
*******************************************************************************
**   ____  ____ 
**  /   /\/   / 
** /___/  \  /   Vendor: Xilinx 
** \   \   \/    
**  \   \        
**  /   /          
** /___/   /\     
** \   \  /  \   Virtex-7 XT Connectivity Domain Targeted Reference Design
**  \___\/\___\ 
** 
**  Device: xc7vx690t
**  Version: 1.3
**  Reference: UG962
**     
*******************************************************************************
**
**  Disclaimer: 
**
**    This disclaimer is not a license and does not grant any rights to the materials 
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
**    Xilinx products are not designed or intended to be fail-safe, or for use in any application 
**    requiring fail-safe performance, such as life-support or safety devices or systems, 
**    Class III medical devices, nuclear facilities, applications related to the deployment of airbags,
**    or any other applications that could lead to death, personal injury, or severe property or 
**    environmental damage (individually and collectively, "Critical Applications"). Customer assumes 
**    the sole risk and liability of any use of Xilinx products in Critical Applications, subject only 
**    to applicable laws and regulations governing limitations on product liability.

**  THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT ALL TIMES.

*******************************************************************************/

`timescale 1ps / 1ps
(* CORE_GENERATION_INFO = "xt_connectivity_trd,xt_connectivity_trd_v1_3,{x_ipproduct=Vivado2014.3,v7_xt_conn_trd=2014.3}" *)
module xt_connectivity_trd #
(
    parameter CNTWIDTH = 32,
    parameter NUM_LANES = 8
) (
      // PCI Express slot PERST# reset signal
    input                          perst_n,      
      // PCIe differential reference clock input
    input                          pcie_clk_p,   
    input                          pcie_clk_n,   
      // PCIe differential transmit output
    output  [NUM_LANES-1:0]        pcie_tx_p,         
    output  [NUM_LANES-1:0]        pcie_tx_n,         
      // PCIe differential receive output
    input   [NUM_LANES-1:0]        pcie_rx_p,         
    input   [NUM_LANES-1:0]        pcie_rx_n,         

      // 200MHz reference clock input
    input                          clk_ref_p,
    input                          clk_ref_n,
`ifdef USE_DDR3_FIFO
      // Connection to SODIMM-A
    output [15:0]                  c0_ddr3_addr,             
    output [2:0]                   c0_ddr3_ba,               
    output                         c0_ddr3_cas_n,            
    output                         c0_ddr3_ck_p,               
    output                         c0_ddr3_ck_n,             
    output                         c0_ddr3_cke,              
    output                         c0_ddr3_cs_n,             
    output [7:0]                   c0_ddr3_dm,               
    inout  [63:0]                  c0_ddr3_dq,               
    inout  [7:0]                   c0_ddr3_dqs_p,              
    inout  [7:0]                   c0_ddr3_dqs_n,            
    output                         c0_ddr3_odt,              
    output                         c0_ddr3_ras_n,            
    output                         c0_ddr3_reset_n,          
    output                         c0_ddr3_we_n,             

      // Connection to SODIMM-B
    output [15:0]                  c1_ddr3_addr,             
    output [2:0]                   c1_ddr3_ba,               
    output                         c1_ddr3_cas_n,            
    output                         c1_ddr3_ck_p,               
    output                         c1_ddr3_ck_n,             
    output                         c1_ddr3_cke,              
    output                         c1_ddr3_cs_n,             
    output [7:0]                   c1_ddr3_dm,               
    inout  [63:0]                  c1_ddr3_dq,               
    inout  [7:0]                   c1_ddr3_dqs_p,              
    inout  [7:0]                   c1_ddr3_dqs_n,            
    output                         c1_ddr3_odt,              
    output                         c1_ddr3_ras_n,            
    output                         c1_ddr3_reset_n,          
    output                         c1_ddr3_we_n,             
`endif  
  `ifndef DMA_LOOPBACK
    //-SI5324 I2C programming interface
    inout                          i2c_clk,
    inout                          i2c_data,
    output                         i2c_mux_rst_n,
    output                         si5324_rst_n,
    // 156.25 MHz clock in
    input                          xphy_refclk_clk_p,
    input                          xphy_refclk_clk_n,
  `endif
  `ifdef USE_XPHY
      // 10G PHY ports
    output                         xphy0_txp,
    output                         xphy0_txn,
    input                          xphy0_rxp,
    input                          xphy0_rxn,
    output                         xphy1_txp,
    output                         xphy1_txn,
    input                          xphy1_rxp,
    input                          xphy1_rxn,
    output                         xphy2_txp,
    output                         xphy2_txn,
    input                          xphy2_rxp,
    input                          xphy2_rxn,
    output                         xphy3_txp,
    output                         xphy3_txn,
    input                          xphy3_rxp,
    input                          xphy3_rxn,
    output [3:0]                   sfp_tx_disable,   
  `endif // USE_PHY
`ifdef USE_PVTMON
    //- Power monitoring
    inout                          pmbus_clk,
    inout                          pmbus_data,
    input                          pmbus_alert,
`endif

    // Diagnostic LEDs
    output  [6:0]                  led           

  );



  // ----------------
  // -- Parameters --
  // ----------------
  
  localparam  CORE_DATA_WIDTH         = 256;
  localparam  CORE_BE_WIDTH           = 32;
  localparam  CORE_REMAIN_WIDTH       = 8;

  localparam  AXIS_TDATA_WIDTH          = CORE_DATA_WIDTH;
  localparam  AXIS_TUSER_WIDTH          = 64;
  localparam  AXIS_TKEEP_WIDTH          = (AXIS_TDATA_WIDTH/8);  
  
  localparam  LED_CTR_WIDTH           = 26;   

    //- PCIe specific parameters
  localparam  PCIE_EXT_CLK            = "TRUE";  
  localparam  VENDOR_ID               = 16'h10EE; 
  localparam  DEVICE_ID               = 16'h7083; // V7-XT, x8, Gen3,
  localparam  DEVICE_SN               = 64'h0;
  localparam  PL_LINK_CAP_MAX_LINK_SPEED  = 4;    //-GEN3
  localparam  PL_LINK_CAP_MAX_LINK_WIDTH  = 8;    //-x8
  localparam  C_DATA_WIDTH            = CORE_DATA_WIDTH;
  localparam  KEEP_WIDTH              = C_DATA_WIDTH/32;
    //- Packet FIFO specific parameters
  localparam  AXI_VFIFO_DATA_WIDTH    = 256;
  localparam  AXI_MIG_DATA_WIDTH      = 512;
    //- Using 2 controllers each with 4 ports
  localparam  NUM_PORTS               = 8;
  localparam  AWIDTH                  = 32;
  localparam  DWIDTH                  = CORE_DATA_WIDTH;
  localparam  ID_WIDTH                = 2;
  //- Address maps
  localparam C_AXILITE_DATA_WIDTH = 32;
  localparam C_AXILITE_ADDR_WIDTH = 32;
    //- Offset range for user space registers
  localparam C_BASE_USER_REG  = 32'h0000_9000;
  localparam C_HIGH_USER_REG  = 32'h0000_9FFF;
 
  localparam  C_FAMILY  = "virtex7";

  // -------------------
  // -- Local Signals --
  // -------------------
  
  wire                                  clk_ref_200;
  wire                                  clk_ref_200_i;
  // Clock and Reset
  wire                                  pcie_ref_clk;
  wire                                  perst_n_c;
  
  wire [31:0]                           axi4lite_s_awaddr;
  wire                                  axi4lite_s_awvalid;
  wire                                  axi4lite_s_awready;
  wire [CORE_DATA_WIDTH-1:0]            axi4lite_s_wdata;
  wire [CORE_BE_WIDTH-1:0]              axi4lite_s_wstrb;
  wire                                  axi4lite_s_wvalid;
  wire                                  axi4lite_s_wready;
  wire                                  axi4lite_s_bvalid;
  wire                                  axi4lite_s_bready;
  wire [1:0]                            axi4lite_s_bresp;
  wire [31:0]                           axi4lite_s_araddr;
  wire                                  axi4lite_s_arready;
  wire                                  axi4lite_s_arvalid;
  wire [CORE_DATA_WIDTH-1:0]            axi4lite_s_rdata;
  wire [1:0]                            axi4lite_s_rresp;
  wire                                  axi4lite_s_rready;
  wire                                  axi4lite_s_rvalid;

  wire    [63:0]                        axi_str_s2c0_tuser;      
  wire                                  axi_str_s2c0_tlast;              
  wire    [AXIS_TDATA_WIDTH-1:0]        axi_str_s2c0_tdata;             
  wire    [AXIS_TKEEP_WIDTH-1:0]        axi_str_s2c0_tkeep;
  wire                                  axi_str_s2c0_tvalid;          
  wire                                  axi_str_s2c0_tready;          
  wire                                  axi_str_s2c0_aresetn;
  wire                                  axi_str_s2c0_tvalid_perf;
  wire                                  axi_str_s2c0_tready_perf;
  wire                                  axi_str_s2c0_tvalid_app;
  wire                                  axi_str_s2c0_tready_app;

  wire    [63:0]                        axi_str_c2s0_tuser;      
  wire                                  axi_str_c2s0_tlast;              
  wire    [AXIS_TDATA_WIDTH-1:0]        axi_str_c2s0_tdata;             
  wire    [AXIS_TKEEP_WIDTH-1:0]        axi_str_c2s0_tkeep;
  wire                                  axi_str_c2s0_tvalid;          
  wire                                  axi_str_c2s0_tready;          
  wire                                  axi_str_c2s0_aresetn;
  wire    [63:0]                        axi_str_c2s0_tuser_perf;
  wire                                  axi_str_c2s0_tlast_perf;
  wire    [AXIS_TDATA_WIDTH-1:0]        axi_str_c2s0_tdata_perf;
  wire    [AXIS_TKEEP_WIDTH-1:0]        axi_str_c2s0_tkeep_perf;
  wire                                  axi_str_c2s0_tvalid_perf;
  wire                                  axi_str_c2s0_tlast_app;
  wire    [AXIS_TDATA_WIDTH-1:0]        axi_str_c2s0_tdata_app;
  wire    [AXIS_TKEEP_WIDTH-1:0]        axi_str_c2s0_tkeep_app;
  wire                                  axi_str_c2s0_tvalid_app;

  wire    [63:0]                        axi_str_s2c1_tuser;      
  wire                                  axi_str_s2c1_tlast;              
  wire    [AXIS_TDATA_WIDTH-1:0]        axi_str_s2c1_tdata;             
  wire    [AXIS_TKEEP_WIDTH-1:0]        axi_str_s2c1_tkeep;
  wire                                  axi_str_s2c1_tvalid;          
  wire                                  axi_str_s2c1_tready;          
  wire                                  axi_str_s2c1_aresetn;

  wire    [63:0]                        axi_str_c2s1_tuser;      
  wire                                  axi_str_c2s1_tlast;              
  wire    [AXIS_TDATA_WIDTH-1:0]        axi_str_c2s1_tdata;             
  wire    [AXIS_TKEEP_WIDTH-1:0]        axi_str_c2s1_tkeep;
  wire                                  axi_str_c2s1_tvalid;          
  wire                                  axi_str_c2s1_tready;          
  wire                                  axi_str_c2s1_aresetn;

  wire    [63:0]                        axi_str_s2c2_tuser;      
  wire                                  axi_str_s2c2_tlast;              
  wire    [AXIS_TDATA_WIDTH-1:0]        axi_str_s2c2_tdata;             
  wire    [AXIS_TKEEP_WIDTH-1:0]        axi_str_s2c2_tkeep;
  wire                                  axi_str_s2c2_tvalid;          
  wire                                  axi_str_s2c2_tready;          
  wire                                  axi_str_s2c2_aresetn;

  wire    [63:0]                        axi_str_c2s2_tuser;      
  wire                                  axi_str_c2s2_tlast;              
  wire    [AXIS_TDATA_WIDTH-1:0]        axi_str_c2s2_tdata;             
  wire    [AXIS_TKEEP_WIDTH-1:0]        axi_str_c2s2_tkeep;
  wire                                  axi_str_c2s2_tvalid;          
  wire                                  axi_str_c2s2_tready;          
  wire                                  axi_str_c2s2_aresetn;

  wire    [63:0]                        axi_str_s2c3_tuser;      
  wire                                  axi_str_s2c3_tlast;              
  wire    [AXIS_TDATA_WIDTH-1:0]        axi_str_s2c3_tdata;             
  wire    [AXIS_TKEEP_WIDTH-1:0]        axi_str_s2c3_tkeep;
  wire                                  axi_str_s2c3_tvalid;          
  wire                                  axi_str_s2c3_tready;          
  wire                                  axi_str_s2c3_aresetn;

  wire    [63:0]                        axi_str_c2s3_tuser;      
  wire                                  axi_str_c2s3_tlast;              
  wire    [AXIS_TDATA_WIDTH-1:0]        axi_str_c2s3_tdata;             
  wire    [AXIS_TKEEP_WIDTH-1:0]        axi_str_c2s3_tkeep;
  wire                                  axi_str_c2s3_tvalid;          
  wire                                  axi_str_c2s3_tready;          
  wire                                  axi_str_c2s3_aresetn;

  wire                                  app0_en_gen;
  wire                                  app0_en_chk;
  wire                                  app0_en_lpbk;
  wire                                  app0_chk_status;
  wire [15:0]                           app0_pkt_len;
  wire                                  ch0_perf_mode_en;

  wire  [11:0]                          init_fc_cpld;
  wire  [7:0]                           init_fc_cplh;
  wire  [11:0]                          init_fc_npd;
  wire  [7:0]                           init_fc_nph;
  wire  [11:0]                          init_fc_pd;
  wire  [7:0]                           init_fc_ph;

  wire  [1:0]                           scaling_factor;
  wire  [31:0]                          tx_pcie_byte_cnt;
  wire  [31:0]                          rx_pcie_byte_cnt;
  wire  [31:0]                          tx_pcie_payload_cnt;
  wire  [31:0]                          rx_pcie_payload_cnt;
 
  reg     [LED_CTR_WIDTH-1:0]           led_ctr;
  reg     [LED_CTR_WIDTH-1:0]           phy_led_ctr;
  reg                                   lane_width_error;
  reg                                   link_speed_error;  

  wire                                  axi_str_rmac0_tlast;              
  wire    [AXIS_TDATA_WIDTH-1:0]        axi_str_rmac0_tdata;             
  wire    [AXIS_TKEEP_WIDTH-1:0]        axi_str_rmac0_tkeep;
  wire                                  axi_str_rmac0_tvalid;          
  wire                                  axi_str_rmac0_tready;          

  wire                                  axi_str_tmac0_tlast;              
  wire    [AXIS_TDATA_WIDTH-1:0]        axi_str_tmac0_tdata;             
  wire    [AXIS_TKEEP_WIDTH-1:0]        axi_str_tmac0_tkeep;
  wire                                  axi_str_tmac0_tvalid;          
  wire                                  axi_str_tmac0_tready;          

    // Ethernet related signal declarations
  wire                                  xphyrefclk_i;
  wire                                  xgemac_clk_156;
  wire                                  dclk_i;
  wire                                  clk156_25; 
  reg                                   core_reset = 1'b0;
  wire                                  xphy_gt0_tx_resetdone;
  wire                                  xphy_gt1_tx_resetdone;
  wire                                  xphy_gt2_tx_resetdone;
  wire                                  xphy_gt3_tx_resetdone;
  wire                                  xphy_tx_fault;
   
`ifdef USE_XPHY
  wire  [3:0]                           xphy_tx_disable;
  wire                                  xphy_gt_txclk322;
  wire                                  xphy_gt_txusrclk;
  wire                                  xphy_gt_txusrclk2;
  wire                                  xphy_gt_qplllock;
  wire                                  xphy_gt_qplloutclk;
  wire                                  xphy_gt_qplloutrefclk;
  wire                                  xphy_gt_txuserrdy;
  wire                                  xphy_areset_clk_156_25;
  wire                                  xphy_reset_counter_done;
  wire                                  xphy_gttxreset;
  wire                                  xphy_gtrxreset;



  wire [4:0]                            xphy0_prtad;
  wire                                  xphy0_signal_detect;
  wire [47:0]                           mac0_adrs;
  wire                                  mac0_pm_enable;
  wire                                  mac0_rx_fifo_overflow;
  wire [7:0]                            xphy0_status;

  wire [4:0]                            xphy1_prtad;
  wire                                  xphy1_signal_detect;
  wire [47:0]                           mac1_adrs;
  wire                                  mac1_pm_enable;
  wire                                  mac1_rx_fifo_overflow;
  wire [7:0]                            xphy1_status;

  wire [4:0]                            xphy2_prtad;
  wire                                  xphy2_signal_detect;
  wire [47:0]                           mac2_adrs;
  wire                                  mac2_pm_enable;
  wire                                  mac2_rx_fifo_overflow;
  wire [7:0]                            xphy2_status;

  wire [4:0]                            xphy3_prtad;
  wire                                  xphy3_signal_detect;
  wire [47:0]                           mac3_adrs;
  wire                                  mac3_pm_enable;
  wire                                  mac3_rx_fifo_overflow;
  wire [7:0]                            xphy3_status;

`else
  wire [0:0]                            xphy0_status = 'b0;
  wire [0:0]                            xphy1_status = 'b0;
  wire [0:0]                            xphy2_status = 'b0;
  wire [0:0]                            xphy3_status = 'b0;
`endif

  wire                                  axi_str_rmac1_tlast;              
  wire    [AXIS_TDATA_WIDTH-1:0]        axi_str_rmac1_tdata;             
  wire    [AXIS_TKEEP_WIDTH-1:0]        axi_str_rmac1_tkeep;
  wire                                  axi_str_rmac1_tvalid;          
  wire                                  axi_str_rmac1_tready;          
  wire                                  axi_str_tmac1_tlast;              
  wire    [AXIS_TDATA_WIDTH-1:0]        axi_str_tmac1_tdata;             
  wire    [AXIS_TKEEP_WIDTH-1:0]        axi_str_tmac1_tkeep;
  wire                                  axi_str_tmac1_tvalid;          
  wire                                  axi_str_tmac1_tready;          

  wire                                  axi_str_rmac2_tlast;              
  wire    [AXIS_TDATA_WIDTH-1:0]        axi_str_rmac2_tdata;             
  wire    [AXIS_TKEEP_WIDTH-1:0]        axi_str_rmac2_tkeep;
  wire                                  axi_str_rmac2_tvalid;          
  wire                                  axi_str_rmac2_tready;          
  wire                                  axi_str_tmac2_tlast;              
  wire    [AXIS_TDATA_WIDTH-1:0]        axi_str_tmac2_tdata;             
  wire    [AXIS_TKEEP_WIDTH-1:0]        axi_str_tmac2_tkeep;
  wire                                  axi_str_tmac2_tvalid;          
  wire                                  axi_str_tmac2_tready;          

  wire                                  axi_str_rmac3_tlast;              
  wire    [AXIS_TDATA_WIDTH-1:0]        axi_str_rmac3_tdata;             
  wire    [AXIS_TKEEP_WIDTH-1:0]        axi_str_rmac3_tkeep;
  wire                                  axi_str_rmac3_tvalid;          
  wire                                  axi_str_rmac3_tready;          
  wire                                  axi_str_tmac3_tlast;              
  wire    [AXIS_TDATA_WIDTH-1:0]        axi_str_tmac3_tdata;             
  wire    [AXIS_TKEEP_WIDTH-1:0]        axi_str_tmac3_tkeep;
  wire                                  axi_str_tmac3_tvalid;          
  wire                                  axi_str_tmac3_tready;          

// -------------------
// -- Local Signals --
// -------------------

// Xilinx Hard Core Instantiation

  wire                                  user_clk;
  wire                                  user_reset;
  wire                                  user_lnk_up;
  wire                                  user_reset_c;
  wire                                  user_lnk_up_c;

  wire                                       s_axis_rq_tlast;
  wire                 [C_DATA_WIDTH-1:0]    s_axis_rq_tdata;
  wire                             [59:0]    s_axis_rq_tuser;
  wire                   [KEEP_WIDTH-1:0]    s_axis_rq_tkeep;
  wire                              [3:0]    s_axis_rq_tready;
  wire                                       s_axis_rq_tvalid;

  wire                 [C_DATA_WIDTH-1:0]    m_axis_rc_tdata;
  wire                             [74:0]    m_axis_rc_tuser;
  wire                                       m_axis_rc_tlast;
  wire                   [KEEP_WIDTH-1:0]    m_axis_rc_tkeep;
  wire                                       m_axis_rc_tvalid;
  wire                             [21:0]    m_axis_rc_tready;
  wire                                       m_axis_rc_tready_i;

  wire                 [C_DATA_WIDTH-1:0]    m_axis_cq_tdata;
  wire                             [84:0]    m_axis_cq_tuser;
  wire                                       m_axis_cq_tlast;
  wire                   [KEEP_WIDTH-1:0]    m_axis_cq_tkeep;
  wire                                       m_axis_cq_tvalid;
  wire                             [21:0]    m_axis_cq_tready;
  wire                                       m_axis_cq_tready_i;

  wire                 [C_DATA_WIDTH-1:0]    s_axis_cc_tdata;
  wire                             [32:0]    s_axis_cc_tuser;
  wire                                       s_axis_cc_tlast;
  wire                   [KEEP_WIDTH-1:0]    s_axis_cc_tkeep;
  wire                                       s_axis_cc_tvalid;
  wire                              [3:0]    s_axis_cc_tready;

  wire                              [3:0]    pcie_rq_seq_num;
  wire                                       pcie_rq_seq_num_vld;
  wire                              [5:0]    pcie_rq_tag;
  wire                                       pcie_rq_tag_vld;

  wire                              [1:0]    pcie_tfc_nph_av;
  wire                              [1:0]    pcie_tfc_npd_av;
  wire                                       pcie_cq_np_req;
  wire                              [5:0]    pcie_cq_np_req_count;

  wire                                       cfg_phy_link_down;
  wire                              [1:0]    cfg_phy_link_status;
  wire                              [3:0]    cfg_negotiated_width;
  wire                              [2:0]    cfg_current_speed;
  wire                              [2:0]    cfg_max_payload;
  wire                              [2:0]    cfg_max_read_req;
  wire                              [7:0]    cfg_function_status;
  wire                              [5:0]    cfg_function_power_state;
  wire                             [11:0]    cfg_vf_status;
  wire                             [17:0]    cfg_vf_power_state;
  wire                              [1:0]    cfg_link_power_state;

  // Management Interface
  wire                             [31:0]    cfg_mgmt_read_data;
  wire                                       cfg_mgmt_read_write_done;
  wire                                       cfg_mgmt_type1_cfg_reg_access;

  // Error Reporting Interface
  wire                                       cfg_err_cor_out;
  wire                                       cfg_err_nonfatal_out;
  wire                                       cfg_err_fatal_out;

  wire                                       cfg_ltr_enable;
  wire                              [5:0]    cfg_ltssm_state;
  wire                              [1:0]    cfg_rcb_status;
  wire                              [1:0]    cfg_dpa_substate_change;
  wire                              [1:0]    cfg_obff_enable;
  wire                                       cfg_pl_status_change;

  wire                              [1:0]    cfg_tph_requester_enable;
  wire                              [5:0]    cfg_tph_st_mode;
  wire                              [5:0]    cfg_vf_tph_requester_enable;
  wire                             [17:0]    cfg_vf_tph_st_mode;

  wire                                       cfg_msg_received;
  wire                              [7:0]    cfg_msg_received_data;
  wire                              [4:0]    cfg_msg_received_type;

  wire                             [31:0]    cfg_msg_transmit_data;
  wire                                       cfg_msg_transmit_done;

  wire                              [7:0]    cfg_fc_ph;
  wire                             [11:0]    cfg_fc_pd;
  wire                              [7:0]    cfg_fc_nph;
  wire                             [11:0]    cfg_fc_npd;
  wire                              [7:0]    cfg_fc_cplh;
  wire                             [11:0]    cfg_fc_cpld;
  wire                              [2:0]    cfg_fc_sel;

  wire                              [2:0]    cfg_per_func_status_control;
  wire                             [15:0]    cfg_per_func_status_data;
  wire                              [15:0]   cfg_subsys_vend_id = 16'h10EE;      

  wire                              [2:0]    cfg_per_function_number;
  wire                                       cfg_per_function_output_request;
  wire                                       cfg_per_function_update_done;

  wire                             [63:0]    cfg_dsn;
  wire                                       cfg_power_state_change_interrupt;
  wire                                       cfg_err_cor_in;

  wire                              [1:0]    cfg_flr_in_process;
  wire                              [1:0]    cfg_flr_done;
  wire                              [5:0]    cfg_vf_flr_in_process;
  wire                              [5:0]    cfg_vf_flr_done;

  wire                                       cfg_link_training_enable;

  wire                                       cfg_ext_read_received;
  wire                                       cfg_ext_write_received;
  wire                              [9:0]    cfg_ext_register_number;
  wire                              [7:0]    cfg_ext_function_number;
  wire                             [31:0]    cfg_ext_write_data;
  wire                              [3:0]    cfg_ext_write_byte_enable;
  wire                             [31:0]    cfg_ext_read_data;
  wire                                       cfg_ext_read_data_valid;

  //----------------------------------------------------------------------------------------------------------------//
  // EP Only                                                                                                        //
  //----------------------------------------------------------------------------------------------------------------//

  // Interrupt Interface Signals
  wire                              [3:0]    cfg_interrupt_int;
  wire                              [1:0]    cfg_interrupt_pending;
  wire                                       cfg_interrupt_sent;

  wire                              [5:0]    cfg_interrupt_msi_vf_enable;
  wire                              [5:0]    cfg_interrupt_msi_mmenable;
  wire                                       cfg_interrupt_msi_mask_update;
  wire                             [31:0]    cfg_interrupt_msi_data;
  wire                             [31:0]    cfg_interrupt_msi_int;
  wire                             [63:0]    cfg_interrupt_msi_pending_status;
  wire                                       cfg_interrupt_msi_sent;
  wire                                       cfg_interrupt_msi_fail;
  wire                              [1:0]    cfg_interrupt_msi_enable;

  wire                              [1:0]    cfg_interrupt_msix_enable;
  wire                              [1:0]    cfg_interrupt_msix_mask;
  wire                              [5:0]    cfg_interrupt_msix_vf_enable;
  wire                              [5:0]    cfg_interrupt_msix_vf_mask;
  wire                                       cfg_interrupt_msix_sent;
  wire                                       cfg_interrupt_msix_fail;

  wire                              [2:0]    cfg_interrupt_msi_attr;
  wire                                       cfg_interrupt_msi_tph_present;
  wire                              [1:0]    cfg_interrupt_msi_tph_type;
  wire                              [8:0]    cfg_interrupt_msi_tph_st_tag;
  wire                              [2:0]    cfg_interrupt_msi_function_number;

// EP only
  wire                                       cfg_hot_reset_out;
  wire                                       cfg_config_space_enable;
  wire                                       cfg_req_pm_transition_l23_ready;

// RP only

  wire                              [7:0]    cfg_ds_port_number;
  wire                              [7:0]    cfg_ds_bus_number;
  wire                              [4:0]    cfg_ds_device_number;
  wire                              [2:0]    cfg_ds_function_number;

  wire                              [4:0]     user_tph_stt_address;
  wire                              [2:0]     user_tph_function_num;
  wire                              [31:0]    user_tph_stt_read_data;
  wire                                        user_tph_stt_read_data_valid;
  wire                                        user_tph_stt_read_enable;


  
  wire                                  clk200;
  wire    [7:0]                         clk_period_in_ns;

`ifdef USE_DDR3_FIFO

  wire                                          c0_calib_done;
  wire                                          c1_calib_done;
  wire                                          mcb_clk;
  wire                                          mcb_rst;
  wire                                          axi_ic_mig_shim_rst_n;
  wire [NUM_PORTS-1:0]                          ddr3_fifo_empty;
`endif
  wire [NUM_PORTS-1:0]                          px_axi_str_wr_aclk;
  wire [NUM_PORTS-1:0]                          px_axi_str_wr_tlast;
  wire [(AXI_VFIFO_DATA_WIDTH*NUM_PORTS)-1:0]   px_axi_str_wr_tdata;
  wire [NUM_PORTS-1:0]                          px_axi_str_wr_tvalid;
  wire [(AXI_VFIFO_DATA_WIDTH/8*NUM_PORTS)-1:0] px_axi_str_wr_tkeep;
  wire [NUM_PORTS-1:0]                          px_axi_str_wr_tready;
  wire [NUM_PORTS-1:0]                          px_axi_str_wr_rst_n;
  wire [NUM_PORTS-1:0]                          px_axi_str_rd_aclk;
  wire [NUM_PORTS-1:0]                          px_axi_str_rd_tlast;
  wire [(AXI_VFIFO_DATA_WIDTH*NUM_PORTS)-1:0]   px_axi_str_rd_tdata;
  wire [NUM_PORTS-1:0]                          px_axi_str_rd_tvalid;
  wire [(AXI_VFIFO_DATA_WIDTH/8*NUM_PORTS)-1:0] px_axi_str_rd_tkeep;
  wire [NUM_PORTS-1:0]                          px_axi_str_rd_tready;
  wire [NUM_PORTS-1:0]                          px_axi_str_rd_rst_n;
  wire [(NUM_PORTS*16)-1:0]                     px_axi_str_wr_len;
  wire [(NUM_PORTS*16)-1:0]                     px_axi_str_rd_len;
  wire [(NUM_PORTS*CNTWIDTH)-1:0]               px_axi_str_rd_cnt;
  
  wire                                        pipe_pclk_in;
  wire  [7:0]                                 pipe_rxusrclk_in;
  wire  [7:0]                                 pipe_rxoutclk_in;
  wire                                        pipe_dclk_in;
  wire                                        pipe_userclk1_in;
  wire                                        pipe_userclk2_in;
  wire                                        pipe_mmcm_lock_in;
  wire                                        pipe_oobclk_in;

  wire                                        pipe_txoutclk_out;
  wire [7:0]                                  pipe_rxoutclk_out;
  wire [7:0]                                  pipe_pclk_sel_out;
  wire                                        pipe_gen3_out;

// ---------------
// Clock and Reset
// ---------------

// PCIe Reference Clock Input buffer
IBUFDS_GTE2 refclk_ibuf (

    .I      (pcie_clk_p     ),
    .IB     (pcie_clk_n     ),
    .O      (pcie_ref_clk        ),
    .CEB    (1'b0           ),
    .ODIV2  (               )

);

// PCIe PERST# input buffer
IBUF perst_n_ibuf (

    .I      (perst_n        ),
    .O      (perst_n_c      )

);

// Register to improve timing
FDCP #(

  .INIT     (1'b1           )

) user_lnk_up_int_i (

    .Q      (user_lnk_up    ),
    .D      (user_lnk_up_c  ),
    .C      (user_clk       ),
    .CLR    (1'b0           ),
    .PRE    (1'b0           )

);

// Register to improve timing
FDCP #(

  .INIT(1'b1)

) user_reset_i (

    .Q      (user_reset    ),
    .D      (user_reset_c | (~user_lnk_up)),
    .C      (user_clk        ),
    .CLR    (1'b0           ),
    .PRE    (1'b0           )

);

    IBUFGDS #(
      .DIFF_TERM    ("TRUE"),
      .IBUF_LOW_PWR ("FALSE")
    ) diff_clk_200 (
      .I    (clk_ref_p  ),
      .IB   (clk_ref_n  ),
      .O    (clk_ref_200_i )  
    );

    BUFG u_bufg_clk_ref
    (
      .O (clk_ref_200),
      .I (clk_ref_200_i)
    );

  //- Clocking
  wire [11:0]   device_temp;
  wire          clk50;
  reg [1:0]     clk_divide = 2'b00;


  always @(posedge clk_ref_200)
    clk_divide  <= clk_divide + 1'b1;

  BUFG buffer_clk50 (
    .I    (clk_divide[1]),
    .O    (clk50        )
  );


  // Generate External Clock Module if External Clocking is selected
  generate
    if (PCIE_EXT_CLK == "TRUE") begin : ext_clk
    pipe_clock #
    (
    .PCIE_ASYNC_EN                  ( "FALSE" ),       // PCIe async enable
    .PCIE_TXBUF_EN                  ( "FALSE" ),       // PCIe TX buffer enable for Gen1/Gen2 only
    .PCIE_LANE                      ( NUM_LANES ),     // PCIe number of lanes
    .PCIE_LINK_SPEED                ( 3 ),             // PCIe Maximum Link Speed
    .PCIE_REFCLK_FREQ               ( 0 ),             // PCIe Reference Clock Frequency - 0=100MHz, 1=125MHz, 2=250MHz

    .PCIE_USERCLK1_FREQ             ( 5 ),             // PCIe Core Clock Frequency - AKA Core Clock Freq
    .PCIE_USERCLK2_FREQ             ( 4 ),             // PCIe User Clock Frequency - AKA User Clock Freq
    //   0: Disable User Clock
    //   1: 31.25 MHz
    //   2: 62.50 MHz  (default)
    //   3: 125.00 MHz
    //   4: 250.00 MHz
    //   5: 500.00 MHz

    .PCIE_DEBUG_MODE                ( 0 )              // Debug Enable
) pipe_clock_i (

    //---------- Input -------------------------------------
    .CLK_CLK                        (pcie_ref_clk ),                     // Reference clock in
    .CLK_TXOUTCLK                   (pipe_txoutclk_out ),           // GT Reference clock out from lane 0
    .CLK_RXOUTCLK_IN                (pipe_rxoutclk_out ),
    .CLK_RST_N                      (1'b1 ),
    .CLK_PCLK_SEL                   (pipe_pclk_sel_out ),           // PIPE Clock Select (125MHz or 250MHz)
    .CLK_GEN3                       (pipe_gen3_out ),

    //---------- Output ------------------------------------
    .CLK_PCLK                       (pipe_pclk_in ),
    .CLK_RXUSRCLK                   (pipe_rxusrclk_in ),
    .CLK_RXOUTCLK_OUT               (pipe_rxoutclk_in ),
    .CLK_DCLK                       (pipe_dclk_in ),
    .CLK_USERCLK1                   (pipe_userclk1_in ),
    .CLK_USERCLK2                   (pipe_userclk2_in ),
    .CLK_MMCM_LOCK                  (pipe_mmcm_lock_in ),
    .CLK_OOBCLK                     (pipe_oobclk_in )

);

    end
  endgenerate

pcie3_x8_ip pcie_inst (

    // -------------------------------
    // PCI Express (pci_exp) Interface
    // -------------------------------

    // Tx
    .pci_exp_txp                    (pcie_tx_p                      ), 
    .pci_exp_txn                    (pcie_tx_n                      ), 
    // Rx
    .pci_exp_rxp                    (pcie_rx_p                      ), 
    .pci_exp_rxn                    (pcie_rx_n                      ), 

  //----------------------------------------------------------------------------------------------------------------//
  // 2. Clocking Interface - For Partial Reconfig Support                                                           //
  //----------------------------------------------------------------------------------------------------------------//
  .pipe_pclk_in                              ( pipe_pclk_in ),
  .pipe_rxusrclk_in                          ( pipe_rxusrclk_in ),
  .pipe_rxoutclk_in                          ( pipe_rxoutclk_in ),
  .pipe_dclk_in                              ( clk50 ), 
  .pipe_userclk1_in                          ( pipe_userclk1_in ),
  .pipe_userclk2_in                          ( pipe_userclk2_in ),
  .pipe_oobclk_in                            ( pipe_oobclk_in ),
  .pipe_mmcm_lock_in                         ( pipe_mmcm_lock_in ),
  
  .pipe_txoutclk_out                         ( pipe_txoutclk_out ),
  .pipe_rxoutclk_out                         ( pipe_rxoutclk_out ),
  .pipe_pclk_sel_out                         ( pipe_pclk_sel_out ),
  .pipe_gen3_out                             ( pipe_gen3_out ),
  .pipe_mmcm_rst_n                           (1'b1),

    // ---------------------------
    // Transaction (TRN) Interface
    // ---------------------------

    // Common
    .user_clk                                       (user_clk        ),
    .user_reset                                     (user_reset_c    ),
    .user_lnk_up                                    (user_lnk_up_c   ),
    .user_app_rdy                                   ( ),

    .s_axis_rq_tlast                                ( s_axis_rq_tlast ),
    .s_axis_rq_tdata                                ( s_axis_rq_tdata ),
    .s_axis_rq_tuser                                ( s_axis_rq_tuser ),
    .s_axis_rq_tkeep                                ( s_axis_rq_tkeep ),
    .s_axis_rq_tready                               ( s_axis_rq_tready ),
    .s_axis_rq_tvalid                               ( s_axis_rq_tvalid ),

    .m_axis_rc_tdata                                ( m_axis_rc_tdata ),
    .m_axis_rc_tuser                                ( m_axis_rc_tuser ),
    .m_axis_rc_tlast                                ( m_axis_rc_tlast ),
    .m_axis_rc_tkeep                                ( m_axis_rc_tkeep ),
    .m_axis_rc_tvalid                               ( m_axis_rc_tvalid ),
    .m_axis_rc_tready                               ( m_axis_rc_tready ),

    .m_axis_cq_tdata                                ( m_axis_cq_tdata ),
    .m_axis_cq_tuser                                ( m_axis_cq_tuser ),
    .m_axis_cq_tlast                                ( m_axis_cq_tlast ),
    .m_axis_cq_tkeep                                ( m_axis_cq_tkeep ),
    .m_axis_cq_tvalid                               ( m_axis_cq_tvalid ),
    .m_axis_cq_tready                               ( m_axis_cq_tready ),

    .s_axis_cc_tdata                                ( s_axis_cc_tdata ),
    .s_axis_cc_tuser                                ( s_axis_cc_tuser ),
    .s_axis_cc_tlast                                ( s_axis_cc_tlast ),
    .s_axis_cc_tkeep                                ( s_axis_cc_tkeep ),
    .s_axis_cc_tvalid                               ( s_axis_cc_tvalid ),
    .s_axis_cc_tready                               ( s_axis_cc_tready ),

    .pcie_rq_seq_num                                ( pcie_rq_seq_num ),
    .pcie_rq_seq_num_vld                            ( pcie_rq_seq_num_vld ),
    .pcie_rq_tag                                    ( pcie_rq_tag ),
    .pcie_rq_tag_vld                                ( pcie_rq_tag_vld ),

    .pcie_tfc_nph_av                                ( pcie_tfc_nph_av ),
    .pcie_tfc_npd_av                                ( pcie_tfc_npd_av ),
    .pcie_cq_np_req                                 ( pcie_cq_np_req  ),
    .pcie_cq_np_req_count                           ( pcie_cq_np_req_count ),

    //---------------------------------------------------------------------------------------//
    //  Configuration (CFG) Interface                                                        //
    //---------------------------------------------------------------------------------------//

    //-------------------------------------------------------------------------------//
    // EP and RP                                                                     //
    //-------------------------------------------------------------------------------//

    .cfg_phy_link_down                              ( cfg_phy_link_down ),
    .cfg_phy_link_status                            ( cfg_phy_link_status ),
    .cfg_negotiated_width                           ( cfg_negotiated_width ),
    .cfg_current_speed                              ( cfg_current_speed ),
    .cfg_max_payload                                ( cfg_max_payload ),
    .cfg_max_read_req                               ( cfg_max_read_req ),
    .cfg_function_status                            ( cfg_function_status ),
    .cfg_function_power_state                       ( cfg_function_power_state ),
    .cfg_vf_status                                  ( cfg_vf_status ),
    .cfg_vf_power_state                             ( cfg_vf_power_state ),
    .cfg_link_power_state                           ( cfg_link_power_state ),

    // Management Interface
    .cfg_mgmt_addr                                  ( 19'd0 ),
    .cfg_mgmt_write                                 ( 1'b0 ),
    .cfg_mgmt_write_data                            ( 32'd0 ),
    .cfg_mgmt_byte_enable                           ( 4'd0 ),
    .cfg_mgmt_read                                  ( 1'b0 ),
    .cfg_mgmt_read_data                             ( cfg_mgmt_read_data ),
    .cfg_mgmt_read_write_done                       ( cfg_mgmt_read_write_done ),
    .cfg_mgmt_type1_cfg_reg_access                  ( 1'b0 ),

    // Error Reporting Interface
    .cfg_err_cor_out                                ( cfg_err_cor_out ),
    .cfg_err_nonfatal_out                           ( cfg_err_nonfatal_out ),
    .cfg_err_fatal_out                              ( cfg_err_fatal_out ),

    .cfg_ltr_enable                                 ( cfg_ltr_enable ),
    .cfg_ltssm_state                                ( cfg_ltssm_state ),
    .cfg_rcb_status                                 ( cfg_rcb_status ),
    .cfg_dpa_substate_change                        ( cfg_dpa_substate_change ),
    .cfg_obff_enable                                ( cfg_obff_enable ),
    .cfg_pl_status_change                           ( cfg_pl_status_change ),

    .cfg_tph_requester_enable                       ( cfg_tph_requester_enable ),
    .cfg_tph_st_mode                                ( cfg_tph_st_mode ),
    .cfg_vf_tph_requester_enable                    ( cfg_vf_tph_requester_enable ),
    .cfg_vf_tph_st_mode                             ( cfg_vf_tph_st_mode ),

    .cfg_msg_received                               ( cfg_msg_received ),
    .cfg_msg_received_data                          ( cfg_msg_received_data ),
    .cfg_msg_received_type                          ( cfg_msg_received_type ),

    .cfg_msg_transmit                               ( 1'b0),  
    .cfg_msg_transmit_type                          ( 3'd0),  
    .cfg_msg_transmit_data                          ( 32'd0), 
    .cfg_msg_transmit_done                          ( cfg_msg_transmit_done ),

    .cfg_fc_ph                                      ( cfg_fc_ph ),
    .cfg_fc_pd                                      ( cfg_fc_pd ),
    .cfg_fc_nph                                     ( cfg_fc_nph ),
    .cfg_fc_npd                                     ( cfg_fc_npd ),
    .cfg_fc_cplh                                    ( cfg_fc_cplh ),
    .cfg_fc_cpld                                    ( cfg_fc_cpld ),
    .cfg_fc_sel                                     ( cfg_fc_sel ),

    .cfg_per_func_status_control                    ( 3'd0 ),
    .cfg_per_func_status_data                       ( cfg_per_func_status_data ),
    .cfg_subsys_vend_id                             ( cfg_subsys_vend_id ),
    .cfg_per_function_number                        ( 3'd0 ),
    .cfg_per_function_output_request                ( 1'b0 ),
    .cfg_per_function_update_done                   ( cfg_per_function_update_done ),

    .cfg_dsn                                        ( cfg_dsn ),
    .cfg_power_state_change_ack                     ( 1'b1),  
    .cfg_power_state_change_interrupt               ( cfg_power_state_change_interrupt ),
    .cfg_err_cor_in                                 ( cfg_err_cor_in ),
    .cfg_err_uncor_in                               ( 1'b0),  

    .cfg_flr_in_process                             ( cfg_flr_in_process ),
    .cfg_flr_done                                   ( 2'b0 ),
    .cfg_vf_flr_in_process                          ( cfg_vf_flr_in_process ),
    .cfg_vf_flr_done                                ( 6'h0 ),

    .cfg_link_training_enable                       ( 1'b1 ),

    .cfg_ext_read_received                          ( cfg_ext_read_received ),
    .cfg_ext_write_received                         ( cfg_ext_write_received ),
    .cfg_ext_register_number                        ( cfg_ext_register_number ),
    .cfg_ext_function_number                        ( cfg_ext_function_number ),
    .cfg_ext_write_data                             ( cfg_ext_write_data ),
    .cfg_ext_write_byte_enable                      ( cfg_ext_write_byte_enable ),
    .cfg_ext_read_data                              ( 32'd0 ),
    .cfg_ext_read_data_valid                        ( 1'b0 ),

    //-------------------------------------------------------------------------------//
    // EP Only                                                                       //
    //-------------------------------------------------------------------------------//

    // Interrupt Interface Signals
    .cfg_interrupt_int                              ( cfg_interrupt_int ),
    .cfg_interrupt_pending                          ( 2'd0),
    .cfg_interrupt_sent                             ( cfg_interrupt_sent ),

    .cfg_interrupt_msi_enable                       ( cfg_interrupt_msi_enable ),
    .cfg_interrupt_msi_vf_enable                    ( cfg_interrupt_msi_vf_enable ),
    .cfg_interrupt_msi_mmenable                     ( cfg_interrupt_msi_mmenable ),
    .cfg_interrupt_msi_mask_update                  ( cfg_interrupt_msi_mask_update ),
    .cfg_interrupt_msi_data                         ( cfg_interrupt_msi_data ),
      //- PF0 selected
    .cfg_interrupt_msi_select                       ( 4'h0),
    .cfg_interrupt_msi_int                          ( cfg_interrupt_msi_int ),
    .cfg_interrupt_msi_pending_status               ( 64'd0),
    .cfg_interrupt_msi_sent                         ( cfg_interrupt_msi_sent ),
    .cfg_interrupt_msi_fail                         ( cfg_interrupt_msi_fail ),

    .cfg_interrupt_msi_attr                         ( 3'd0 ),
    .cfg_interrupt_msi_tph_present                  ( 1'b0 ),
    .cfg_interrupt_msi_tph_type                     ( 2'd0 ),
    .cfg_interrupt_msi_tph_st_tag                   ( 9'd0 ),
    .cfg_interrupt_msi_function_number              ( 3'd0 ),

  // EP only
    .cfg_hot_reset_out                              (  ),
    .cfg_config_space_enable                        ( 1'b1 ),
    .cfg_req_pm_transition_l23_ready                ( 1'b0 ),

  // RP only
    .cfg_hot_reset_in                               ( 1'b0),  

    .cfg_ds_bus_number                              ( 8'd0 ),
    .cfg_ds_device_number                           ( 5'd0 ),
    .cfg_ds_function_number                         ( 3'd0 ),
    .cfg_ds_port_number                             ( 8'd0 ),


    // -----------------------
    // System  (SYS) Interface
    // -----------------------

    .sys_clk                        (pcie_ref_clk                        ), 
    .sys_reset                      (~perst_n_c                      )  

);

  assign m_axis_cq_tready = {22{m_axis_cq_tready_i}};
  assign m_axis_rc_tready = {22{m_axis_rc_tready_i}};

  assign pcie_cq_np_req = 1'b1;

  //- Drive appropriately for MSI or Legacy interrupts
  assign cfg_interrupt_int[3:1] = 3'b000;
  assign cfg_interrupt_msi_int[31:1] = 31'b0;
  
// Device Serial Number Capability

assign cfg_dsn                      = DEVICE_SN;

//+++++++++++++++++++++++++++++++++++++++++++++++++++

// -------------------------
// Packet DMA Instance
// -------------------------

    // always use 250 MHz for GEN3
    assign clk_period_in_ns = 8'h4; 

packet_dma_axi # (
    .CORE_DATA_WIDTH               (AXIS_TDATA_WIDTH              ),
    .KEEP_WIDTH                    (KEEP_WIDTH                    ), 
    .CORE_BE_WIDTH                 (AXIS_TDATA_WIDTH/8            ) 
) packet_dma_axi_inst (

    .user_reset                     (user_reset                     ),
    .user_clk                       (user_clk                       ),
    .user_lnk_up                    (user_lnk_up                    ),
    .clk_period_in_ns               (clk_period_in_ns               ),

    .user_interrupt                 (1'b0                           ), 

    .s_axis_rq_tlast                ( s_axis_rq_tlast ),
    .s_axis_rq_tdata                ( s_axis_rq_tdata ),
    .s_axis_rq_tuser                ( s_axis_rq_tuser ),
    .s_axis_rq_tkeep                ( s_axis_rq_tkeep ),
    .s_axis_rq_tready               ( s_axis_rq_tready ),
    .s_axis_rq_tvalid               ( s_axis_rq_tvalid ),

    .m_axis_rc_tdata                ( m_axis_rc_tdata ),
    .m_axis_rc_tuser                ( m_axis_rc_tuser ),
    .m_axis_rc_tlast                ( m_axis_rc_tlast ),
    .m_axis_rc_tkeep                ( m_axis_rc_tkeep ),
    .m_axis_rc_tvalid               ( m_axis_rc_tvalid ),
    .m_axis_rc_tready               ( m_axis_rc_tready_i ),

    .m_axis_cq_tdata                ( m_axis_cq_tdata ),
    .m_axis_cq_tuser                ( m_axis_cq_tuser ),
    .m_axis_cq_tlast                ( m_axis_cq_tlast ),
    .m_axis_cq_tkeep                ( m_axis_cq_tkeep ),
    .m_axis_cq_tvalid               ( m_axis_cq_tvalid ),
    .m_axis_cq_tready               ( m_axis_cq_tready_i ),

    .s_axis_cc_tdata                ( s_axis_cc_tdata ),
    .s_axis_cc_tuser                ( s_axis_cc_tuser ),
    .s_axis_cc_tlast                ( s_axis_cc_tlast ),
    .s_axis_cc_tkeep                ( s_axis_cc_tkeep ),
    .s_axis_cc_tvalid               ( s_axis_cc_tvalid ),
    .s_axis_cc_tready               ( s_axis_cc_tready[0] ),

    // Flow Control
    .fc_cpld                        (cfg_fc_cpld                        ), 
    .fc_cplh                        (cfg_fc_cplh                        ), 
    .fc_npd                         (cfg_fc_npd                         ), 
    .fc_nph                         (cfg_fc_nph                         ), 
    .fc_pd                          (cfg_fc_pd                          ), 
    .fc_ph                          (cfg_fc_ph                          ), 
    .fc_sel                         (cfg_fc_sel                         ), 
    
    .cfg_err_cor                    (cfg_err_cor_in                    ), 
    .cfg_err_ur                     (cfg_err_ur                     ), 
    .cfg_err_ecrc                   (cfg_err_ecrc                   ), 
    .cfg_err_cpl_timeout            (cfg_err_cpl_timeout            ), 
    .cfg_err_cpl_abort              (cfg_err_cpl_abort              ), 
    .cfg_err_cpl_unexpect           (cfg_err_cpl_unexpect           ), 
    .cfg_err_posted                 (cfg_err_posted                 ), 
    .cfg_err_locked                 (cfg_err_locked                 ), 
    .cfg_err_tlp_cpl_header         (cfg_err_tlp_cpl_header         ), 

    .cfg_interrupt_int              (cfg_interrupt_int              ),
    .cfg_interrupt_sent             (cfg_interrupt_sent             ),
    .cfg_interrupt_msi_int          (cfg_interrupt_msi_int          ),
    .cfg_interrupt_msi_enable       (cfg_interrupt_msi_enable       ),
    .cfg_interrupt_msi_sent         (cfg_interrupt_msi_sent         ),
    .cfg_interrupt_msix_enable      (2'b0                           ),
    .cfg_interrupt_msixfm           (1'b0                           ),

    .cfg_turnoff_ok                 (cfg_turnoff_ok                 ), 
    .cfg_to_turnoff                 (cfg_to_turnoff                 ), 
    .cfg_trn_pending                (cfg_trn_pending                ), 
    .cfg_pm_wake                    (cfg_pm_wake                    ), 

    .cfg_function_status            ( cfg_function_status ),
    .cfg_max_payload                (cfg_max_payload),
    .cfg_max_read_req               (cfg_max_read_req),

    //- AXI-ST S2C-0
    .s2c0_aclk                      (user_clk                       ),
    .s2c0_tvalid                    (axi_str_s2c0_tvalid            ),
    .s2c0_tready                    (axi_str_s2c0_tready            ),
    .s2c0_tlast                     (axi_str_s2c0_tlast             ),
    .s2c0_tdata                     (axi_str_s2c0_tdata             ),
    .s2c0_tkeep                     (axi_str_s2c0_tkeep             ),
    .s2c0_tuser                     (axi_str_s2c0_tuser             ),
    .s2c0_areset_n                  (axi_str_s2c0_aresetn           ),  
      //- AXI-ST C2S-0
    .c2s0_aclk                      (user_clk                       ),  
    .c2s0_tvalid                    (axi_str_c2s0_tvalid            ),
    .c2s0_tready                    (axi_str_c2s0_tready            ),
    .c2s0_tlast                     (axi_str_c2s0_tlast             ),
    .c2s0_tdata                     (axi_str_c2s0_tdata             ),
    .c2s0_tkeep                     (axi_str_c2s0_tkeep             ),
    .c2s0_tuser                     (axi_str_c2s0_tuser             ),
    .c2s0_areset_n                  (axi_str_c2s0_aresetn           ),      
    
    //- AXI-ST S2C-1
    .s2c1_aclk                      (user_clk                       ),
    .s2c1_tvalid                    (axi_str_s2c1_tvalid            ),
    .s2c1_tready                    (axi_str_s2c1_tready            ),
    .s2c1_tlast                     (axi_str_s2c1_tlast             ),
    .s2c1_tdata                     (axi_str_s2c1_tdata             ),
    .s2c1_tkeep                     (axi_str_s2c1_tkeep             ),
    .s2c1_areset_n                  (axi_str_s2c1_aresetn           ),  
    .s2c1_tuser                     (axi_str_s2c1_tuser             ),
      //- AXI-ST C2S-1
    .c2s1_aclk                      (user_clk                       ),  
    .c2s1_tvalid                    (axi_str_c2s1_tvalid            ),
    .c2s1_tready                    (axi_str_c2s1_tready            ),
    .c2s1_tlast                     (axi_str_c2s1_tlast             ),
    .c2s1_tdata                     (axi_str_c2s1_tdata             ),
    .c2s1_tkeep                     (axi_str_c2s1_tkeep             ),
    .c2s1_areset_n                  (axi_str_c2s1_aresetn           ),      
    .c2s1_tuser                     (axi_str_c2s1_tuser             ),

    //- AXI-ST S2C-2
    .s2c2_aclk                      (user_clk                       ),
    .s2c2_tvalid                    (axi_str_s2c2_tvalid            ),
    .s2c2_tready                    (axi_str_s2c2_tready            ),
    .s2c2_tlast                     (axi_str_s2c2_tlast             ),
    .s2c2_tdata                     (axi_str_s2c2_tdata             ),
    .s2c2_tkeep                     (axi_str_s2c2_tkeep             ),
    .s2c2_areset_n                  (axi_str_s2c2_aresetn           ),  
    .s2c2_tuser                     (axi_str_s2c2_tuser             ),
      //- AXI-ST C2S-2
    .c2s2_aclk                      (user_clk                       ),  
    .c2s2_tvalid                    (axi_str_c2s2_tvalid            ),
    .c2s2_tready                    (axi_str_c2s2_tready            ),
    .c2s2_tlast                     (axi_str_c2s2_tlast             ),
    .c2s2_tdata                     (axi_str_c2s2_tdata             ),
    .c2s2_tkeep                     (axi_str_c2s2_tkeep             ),
    .c2s2_areset_n                  (axi_str_c2s2_aresetn           ),      
    .c2s2_tuser                     (axi_str_c2s2_tuser             ),

    //- AXI-ST S2C-3
    .s2c3_aclk                      (user_clk                       ),
    .s2c3_tvalid                    (axi_str_s2c3_tvalid            ),
    .s2c3_tready                    (axi_str_s2c3_tready            ),
    .s2c3_tlast                     (axi_str_s2c3_tlast             ),
    .s2c3_tdata                     (axi_str_s2c3_tdata             ),
    .s2c3_tkeep                     (axi_str_s2c3_tkeep             ),
    .s2c3_areset_n                  (axi_str_s2c3_aresetn           ),  
    .s2c3_tuser                     (axi_str_s2c3_tuser             ),
      //- AXI-ST C2S-3
    .c2s3_aclk                      (user_clk                       ),  
    .c2s3_tvalid                    (axi_str_c2s3_tvalid            ),
    .c2s3_tready                    (axi_str_c2s3_tready            ),
    .c2s3_tlast                     (axi_str_c2s3_tlast             ),
    .c2s3_tdata                     (axi_str_c2s3_tdata             ),
    .c2s3_tkeep                     (axi_str_c2s3_tkeep             ),
    .c2s3_areset_n                  (axi_str_c2s3_aresetn           ),      
    .c2s3_tuser                     (axi_str_c2s3_tuser             ),
    
    //- AXI Master Lite
    .t_aclk                           (user_clk                       ),
    .t_areset_n                       (~user_reset                    ),
    .t_awvalid                        (axi4lite_s_awvalid             ),
    .t_awready                        (axi4lite_s_awready             ),
    .t_awaddr                         (axi4lite_s_awaddr              ),
    .t_awlen                          (),
    .t_awregion                       (),
    .t_awsize                         (),
    
    .t_wlast                          (                               ),
    .t_wvalid                         (axi4lite_s_wvalid              ),
    .t_wready                         (axi4lite_s_wready              ),
    .t_wdata                          (axi4lite_s_wdata               ),
    .t_wstrb                          (axi4lite_s_wstrb               ),
    
    .t_bresp                          (axi4lite_s_bresp               ),
    .t_bvalid                         (axi4lite_s_bvalid              ),
    .t_bready                         (axi4lite_s_bready              ),
    
    .t_araddr                         (axi4lite_s_araddr              ),
    .t_arvalid                        (axi4lite_s_arvalid             ),
    .t_arready                        (axi4lite_s_arready             ),
    .t_arlen                          (),
    .t_arregion                       (),
    .t_arsize                         (),

    .t_rdata                          (axi4lite_s_rdata               ),
    .t_rresp                          (axi4lite_s_rresp               ),
    .t_rvalid                         (axi4lite_s_rvalid              ),
    .t_rlast                          (axi4lite_s_rvalid              ),
    .t_rready                         (axi4lite_s_rready              ) 
);

  /********* SHIM FOR TARGET AXI to AXI-LITE connection ***********/

    //- This shim enables the 256-bit target AXI master to connect to
    //- 32-bit AXILITE interconnect
    //- All register operations issued by software are read-modify-write
    //- operations i.e. access to all bits of one entire register 

    /*
      In case of writes, it puts the appropriate 32-bit data slice based on
      value of wstrb. 
          wstrb         wdata bit locations
          ---------------------------------
          [0] = 1       [31:0]
          [4] = 1       [63:32]
          [8] = 1       [95:64]
          [12] = 1      [127:96]
          [16] = 1      [159:128]
          [20] = 1      [191:160]
          [24] = 1      [223:192]
          [28] = 1      [255:224]
          ---------------------------------
          
      In case of reads, it places the 32-bit read data value in the
      appropriate segment in the 256-bit read data bus based on the read
      address' lowest nibble value.
          araddr[4:0]         rdata segment
          ----------------------------------
           5'b0_0000          [31:0]
           5'b0_0100          [63:32]
           5'b0_1000          [95:64]
           5'b0_1100          [127:96]
           5'b1_0000          [159:128] 
           5'b1_0100          [191:160] 
           5'b1_1000          [223:192] 
           5'b1_1100          [255:224] 
          ---------------------------------
     */

  wire [31:0] rdata, wdata;
  reg [4:0] rd_addr_nibble = 5'd0;
  
    //- Extract out valid write data based on strobe
  assign wdata = axi4lite_s_wstrb[0] ? axi4lite_s_wdata[31:0] :
                  axi4lite_s_wstrb[4] ? axi4lite_s_wdata[63:32] :
                  axi4lite_s_wstrb[8] ? axi4lite_s_wdata[95:64] :
                  axi4lite_s_wstrb[12] ? axi4lite_s_wdata[127:96] :
                  axi4lite_s_wstrb[16] ? axi4lite_s_wdata[159:128] :
                  axi4lite_s_wstrb[20] ? axi4lite_s_wdata[191:160] :
                  axi4lite_s_wstrb[24] ? axi4lite_s_wdata[223:192] :
                  axi4lite_s_wdata[255:224];

    //- Latch onto the read address lowest nibble
  always @(posedge user_clk)
    if (axi4lite_s_arvalid & axi4lite_s_arready)
      rd_addr_nibble  <= axi4lite_s_araddr[4:0];

    //- Place the read 32-bit data into the appropriate 128-bit rdata
    //  location based on address nibble latched above
  assign axi4lite_s_rdata = (rd_addr_nibble == 5'h1C) ? {rdata,224'd0} :
                            (rd_addr_nibble == 5'h18) ? {32'd0,rdata,192'd0} :
                            (rd_addr_nibble == 5'h14) ? {64'd0,rdata,160'd0} :
                            (rd_addr_nibble == 5'h10) ? {96'd0,rdata,128'd0} :
                            (rd_addr_nibble == 5'h0C) ? {128'd0,rdata,96'd0} :
                            (rd_addr_nibble == 5'h08) ? {160'd0,rdata,64'd0} :
                            (rd_addr_nibble == 5'h04) ? {192'd0,rdata,32'd0} :
                            {224'd0,rdata};


  /*
   * This section instantiates the user applications behind the DMA
   */

`ifndef DMA_LOOPBACK
                  
`ifdef USE_DDR3_FIFO

  // Virtual FIFO Wrapper instance containing
  //  * AXI4 Stream Interconnect (4x1 and 1x4)
  //  * AXI4 Virtual FIFO Controller 
  //  * MIG for 2 DDR3 SODIMM
  //
  axis_vfifo_ctrl_ip #(
    .NUM_PORTS                (NUM_PORTS          ),
    .AXIS_TDATA_WIDTH         (AXIS_TDATA_WIDTH   ),
    .AXI_MIG_DATA_WIDTH       (AXI_MIG_DATA_WIDTH ),
    .AWIDTH                   (AWIDTH),    
    .CNTWIDTH                 (CNTWIDTH),
    .DWIDTH                   (DWIDTH),
    .ID_WIDTH                 (ID_WIDTH)
  ) mp_pfifo_inst (
`ifdef USE_PVTMON  
      .device_temp                          (device_temp          ),  
`else      
      .device_temp                          (12'd0                ),  
`endif      
      .c0_calib_done                        (c0_calib_done        ),
      .c1_calib_done                        (c1_calib_done        ),
      .c0_sys_clk_i                         (clk_ref_200            ),
      .c1_sys_clk_i                         (clk_ref_200            ),
      .clk_ref_i                            (clk_ref_200            ),
      .c0_mcb_clk                           (mcb_clk               ),
      .c1_mcb_clk                           (),
      .c0_mcb_rst                           (mcb_rst               ),
      .c1_mcb_rst                           (),

      .c0_ddr_addr                          (c0_ddr3_addr             ),
      .c0_ddr_ba                            (c0_ddr3_ba               ),
      .c0_ddr_cas_n                         (c0_ddr3_cas_n            ),
      .c0_ddr_ck_p                          (c0_ddr3_ck_p             ),
      .c0_ddr_ck_n                          (c0_ddr3_ck_n             ),
      .c0_ddr_cke                           (c0_ddr3_cke              ),
      .c0_ddr_cs_n                          (c0_ddr3_cs_n             ),
      .c0_ddr_dm                            (c0_ddr3_dm               ),
      .c0_ddr_odt                           (c0_ddr3_odt              ),
      .c0_ddr_ras_n                         (c0_ddr3_ras_n            ),
      .c0_ddr_reset_n                       (c0_ddr3_reset_n          ),
      .c0_ddr_we_n                          (c0_ddr3_we_n             ),
      .c0_ddr_dq                            (c0_ddr3_dq               ),
      .c0_ddr_dqs_p                         (c0_ddr3_dqs_p            ),
      .c0_ddr_dqs_n                         (c0_ddr3_dqs_n            ),

      .c1_ddr_addr                          (c1_ddr3_addr             ),
      .c1_ddr_ba                            (c1_ddr3_ba               ),
      .c1_ddr_cas_n                         (c1_ddr3_cas_n            ),
      .c1_ddr_ck_p                          (c1_ddr3_ck_p             ),
      .c1_ddr_ck_n                          (c1_ddr3_ck_n             ),
      .c1_ddr_cke                           (c1_ddr3_cke              ),
      .c1_ddr_cs_n                          (c1_ddr3_cs_n             ),
      .c1_ddr_dm                            (c1_ddr3_dm               ),
      .c1_ddr_odt                           (c1_ddr3_odt              ),
      .c1_ddr_ras_n                         (c1_ddr3_ras_n            ),
      .c1_ddr_reset_n                       (c1_ddr3_reset_n          ),
      .c1_ddr_we_n                          (c1_ddr3_we_n             ),
      .c1_ddr_dq                            (c1_ddr3_dq               ),
      .c1_ddr_dqs_p                         (c1_ddr3_dqs_p            ),
      .c1_ddr_dqs_n                         (c1_ddr3_dqs_n            ),
 
   // AXI streaming Interface
     .axi_str_wr_tlast                 (px_axi_str_wr_tlast    ),
     .axi_str_wr_tdata                 (px_axi_str_wr_tdata    ),
     .axi_str_wr_tvalid                (px_axi_str_wr_tvalid   ),
     .axi_str_wr_tready                (px_axi_str_wr_tready   ),
     .axi_str_wr_tkeep                 (px_axi_str_wr_tkeep    ),
     .wr_reset_n                       (px_axi_str_wr_rst_n),
     .axi_str_wr_aclk                  (px_axi_str_wr_aclk),     
     .axi_str_rd_aclk                  (px_axi_str_rd_aclk),     
     .rd_reset_n                       (px_axi_str_rd_rst_n),
   // AXI streaming Interface
     .axi_str_rd_tlast                 (px_axi_str_rd_tlast    ),
     .axi_str_rd_tdata                 (px_axi_str_rd_tdata    ),
     .axi_str_rd_tvalid                (px_axi_str_rd_tvalid   ),
     .axi_str_rd_tready                (px_axi_str_rd_tready   ),
     .axi_str_rd_tkeep                 (px_axi_str_rd_tkeep    ),
     .ddr3_fifo_empty                  (ddr3_fifo_empty       ),
     .axi_ic_mig_shim_rst_n            (axi_ic_mig_shim_rst_n ),
     .user_reset                       (~perst_n_c            )
    );  

`else
  //- Uses Block RAM based AXIS-IC for connection to XGEMAC
  axis_ic_bram #(
    .NUM_PORTS                (NUM_PORTS          ),
    .AXIS_TDATA_WIDTH         (AXIS_TDATA_WIDTH   )
  ) axis_ic_inst (
   // AXI streaming Interface
     .axi_str_wr_tlast                 (px_axi_str_wr_tlast    ),
     .axi_str_wr_tdata                 (px_axi_str_wr_tdata    ),
     .axi_str_wr_tvalid                (px_axi_str_wr_tvalid   ),
     .axi_str_wr_tready                (px_axi_str_wr_tready   ),
     .axi_str_wr_tkeep                 (px_axi_str_wr_tkeep    ),
     .wr_reset_n                       (px_axi_str_wr_rst_n),
     .axi_str_wr_aclk                  (px_axi_str_wr_aclk),     
     .axi_str_rd_aclk                  (px_axi_str_rd_aclk),     
     .rd_reset_n                       (px_axi_str_rd_rst_n),
   // AXI streaming Interface
     .axi_str_rd_tlast                 (px_axi_str_rd_tlast    ),
     .axi_str_rd_tdata                 (px_axi_str_rd_tdata    ),
     .axi_str_rd_tvalid                (px_axi_str_rd_tvalid   ),
     .axi_str_rd_tready                (px_axi_str_rd_tready   ),
     .axi_str_rd_tkeep                 (px_axi_str_rd_tkeep    ),
     .user_clk                         (user_clk               ),
     .user_reset                       (user_reset             )            

  );

`endif  //-USE_DDR3_FIFO

  assign px_axi_str_wr_rst_n  = {
                                  ~core_reset,
                                  axi_str_s2c3_aresetn,
                                  ~core_reset,
                                  axi_str_s2c2_aresetn,
                                  ~core_reset,
                                  axi_str_s2c1_aresetn,
                                  ~core_reset,
                                  axi_str_s2c0_aresetn
  };

  assign px_axi_str_rd_rst_n  = {
                                  axi_str_c2s3_aresetn,
                                  ~core_reset,
                                  axi_str_c2s2_aresetn,
                                  ~core_reset,
                                  axi_str_c2s1_aresetn,
                                  ~core_reset,
                                  axi_str_c2s0_aresetn,
                                  ~core_reset
  };

  assign px_axi_str_wr_aclk = {
                                xgemac_clk_156,
                                user_clk,
                                xgemac_clk_156,
                                user_clk,
                                xgemac_clk_156,
                                user_clk,
                                xgemac_clk_156,
                                user_clk
  };

  assign px_axi_str_rd_aclk = {
                                user_clk,
                                xgemac_clk_156,
                                user_clk,
                                xgemac_clk_156,
                                user_clk,
                                xgemac_clk_156,
                                user_clk,
                                xgemac_clk_156
  };

  assign px_axi_str_wr_tdata = {
                                axi_str_rmac3_tdata,
                                axi_str_s2c3_tdata,
                                axi_str_rmac2_tdata,
                                axi_str_s2c2_tdata,
                                axi_str_rmac1_tdata,
                                axi_str_s2c1_tdata,
                                axi_str_rmac0_tdata,
                                axi_str_s2c0_tdata
  };

  assign px_axi_str_wr_tkeep  = {
                                axi_str_rmac3_tkeep,
                                axi_str_s2c3_tkeep,
                                axi_str_rmac2_tkeep,
                                axi_str_s2c2_tkeep,
                                axi_str_rmac1_tkeep,
                                axi_str_s2c1_tkeep,
                                axi_str_rmac0_tkeep,
                                axi_str_s2c0_tkeep
  };

  assign px_axi_str_wr_tvalid = {
                                axi_str_rmac3_tvalid,
                                axi_str_s2c3_tvalid,
                                axi_str_rmac2_tvalid,
                                axi_str_s2c2_tvalid,
                                axi_str_rmac1_tvalid,
                                axi_str_s2c1_tvalid,
                                axi_str_rmac0_tvalid,
                                axi_str_s2c0_tvalid_app
  };

  assign px_axi_str_wr_tlast  = {
                                axi_str_rmac3_tlast,
                                axi_str_s2c3_tlast,
                                axi_str_rmac2_tlast,
                                axi_str_s2c2_tlast,
                                axi_str_rmac1_tlast,
                                axi_str_s2c1_tlast,
                                axi_str_rmac0_tlast,
                                axi_str_s2c0_tlast
  };

  assign axi_str_s2c0_tready_app  = px_axi_str_wr_tready[0];
  assign axi_str_rmac0_tready     = px_axi_str_wr_tready[1];
  assign axi_str_s2c1_tready      = px_axi_str_wr_tready[2];
  assign axi_str_rmac1_tready     = px_axi_str_wr_tready[3];
  assign axi_str_s2c2_tready      = px_axi_str_wr_tready[4];
  assign axi_str_rmac2_tready     = px_axi_str_wr_tready[5];
  assign axi_str_s2c3_tready      = px_axi_str_wr_tready[6];
  assign axi_str_rmac3_tready     = px_axi_str_wr_tready[7];
 
  assign px_axi_str_rd_tready = {
                                axi_str_c2s3_tready,  
                                axi_str_tmac3_tready,
                                axi_str_c2s2_tready,  
                                axi_str_tmac2_tready,
                                axi_str_c2s1_tready,  
                                axi_str_tmac1_tready,
                                axi_str_c2s0_tready,  
                                axi_str_tmac0_tready
  };
 
  assign {  
            axi_str_c2s3_tdata, 
            axi_str_tmac3_tdata,
            axi_str_c2s2_tdata,
            axi_str_tmac2_tdata,
            axi_str_c2s1_tdata, 
            axi_str_tmac1_tdata,
            axi_str_c2s0_tdata_app,
            axi_str_tmac0_tdata   } = px_axi_str_rd_tdata;

  assign {  
            axi_str_c2s3_tvalid,
            axi_str_tmac3_tvalid,
            axi_str_c2s2_tvalid,
            axi_str_tmac2_tvalid,
            axi_str_c2s1_tvalid,
            axi_str_tmac1_tvalid,
            axi_str_c2s0_tvalid_app,
            axi_str_tmac0_tvalid  } = px_axi_str_rd_tvalid;

  assign {  
            axi_str_c2s3_tkeep, 
            axi_str_tmac3_tkeep,
            axi_str_c2s2_tkeep, 
            axi_str_tmac2_tkeep,
            axi_str_c2s1_tkeep, 
            axi_str_tmac1_tkeep,
            axi_str_c2s0_tkeep_app,
            axi_str_tmac0_tkeep } = px_axi_str_rd_tkeep;

  assign {  
            axi_str_c2s3_tlast, 
            axi_str_tmac3_tlast,
            axi_str_c2s2_tlast, 
            axi_str_tmac2_tlast,
            axi_str_c2s1_tlast, 
            axi_str_tmac1_tlast,
            axi_str_c2s0_tlast_app,
            axi_str_tmac0_tlast } = px_axi_str_rd_tlast;
`endif

`ifdef DMA_LOOPBACK
  assign axi_str_s2c0_tready = axi_str_c2s0_tready;
  assign axi_str_c2s0_tlast = axi_str_s2c0_tlast;
  assign axi_str_c2s0_tvalid = axi_str_s2c0_tvalid;
  assign axi_str_c2s0_tuser = axi_str_s2c0_tuser;
  assign axi_str_c2s0_tdata = axi_str_s2c0_tdata;
  assign axi_str_c2s0_tkeep = axi_str_s2c0_tkeep;
  
  assign axi_str_s2c1_tready = axi_str_c2s1_tready;
  assign axi_str_c2s1_tlast = axi_str_s2c1_tlast;
  assign axi_str_c2s1_tvalid = axi_str_s2c1_tvalid;
  assign axi_str_c2s1_tuser = axi_str_s2c1_tuser;
  assign axi_str_c2s1_tdata = axi_str_s2c1_tdata;
  assign axi_str_c2s1_tkeep = axi_str_s2c1_tkeep;

  assign axi_str_s2c2_tready = axi_str_c2s2_tready;
  assign axi_str_c2s2_tlast =  axi_str_s2c2_tlast;
  assign axi_str_c2s2_tvalid = axi_str_s2c2_tvalid;
  assign axi_str_c2s2_tuser =  axi_str_s2c2_tuser;
  assign axi_str_c2s2_tdata =  axi_str_s2c2_tdata;
  assign axi_str_c2s2_tkeep =  axi_str_s2c2_tkeep;
  
  assign axi_str_s2c3_tready = axi_str_c2s3_tready;
  assign axi_str_c2s3_tlast =  axi_str_s2c3_tlast;
  assign axi_str_c2s3_tvalid = axi_str_s2c3_tvalid;
  assign axi_str_c2s3_tuser =  axi_str_s2c3_tuser;
  assign axi_str_c2s3_tdata =  axi_str_s2c3_tdata;
  assign axi_str_c2s3_tkeep =  axi_str_s2c3_tkeep;

`else


  assign axi_str_c2s1_tuser = 64'd0;
  assign axi_str_c2s2_tuser = 64'd0;
  assign axi_str_c2s3_tuser = 64'd0;

  //- Enable AXI4LITE Interconnect
  //
  //    AXI-Lite Interconnect instantiation to fan out the control path
  //    The design currently uses 1M:5S AXI-Lite Interconnect core. DMA
  //    AXI-Target interface is the master driving this, which is mapped to
  //    PCIe BAR-0.
  //  Address mapping is as follows-
  //  Address Range (High - Low)    Application
  //  ------------------------------------------
  //  0x9FFF - 0x9000               User logic registers
  //  0xBFFF - 0xB000               XGEMAC # 0
  //  0xCFFF - 0xC000               XGEMAC # 1
  //  0xDFFF - 0xD000               XGEMAC # 2
  //  0xEFFF - 0xE000               XGEMAC # 3
  //  ------------------------------------------
  //
   
  //- Internal signals for user application

  wire [31:0]                     axilite_m0_awaddr;
  wire                            axilite_m0_awvalid;
  wire                            axilite_m0_awready;
  wire [31:0]                     axilite_m0_wdata;
  wire [3:0]                      axilite_m0_wstrb;
  wire                            axilite_m0_wvalid;
  wire                            axilite_m0_wready;
  wire                            axilite_m0_bvalid;
  wire                            axilite_m0_bready;
  wire [1:0]                      axilite_m0_bresp;
  wire [31:0]                     axilite_m0_araddr;
  wire                            axilite_m0_arready;
  wire                            axilite_m0_arvalid;
  wire [31:0]                     axilite_m0_rdata;
  wire [1:0]                      axilite_m0_rresp;
  wire                            axilite_m0_rready;
  wire                            axilite_m0_rvalid;

  wire [31:0]                     axilite_m1_awaddr;
  wire                            axilite_m1_awvalid;
  wire                            axilite_m1_awready;
  wire [31:0]                     axilite_m1_wdata;
  wire [3:0]                      axilite_m1_wstrb;
  wire                            axilite_m1_wvalid;
  wire                            axilite_m1_wready;
  wire                            axilite_m1_bvalid;
  wire                            axilite_m1_bready;
  wire [1:0]                      axilite_m1_bresp;
  wire [31:0]                     axilite_m1_araddr;
  wire                            axilite_m1_arready;
  wire                            axilite_m1_arvalid;
  wire [31:0]                     axilite_m1_rdata;
  wire [1:0]                      axilite_m1_rresp;
  wire                            axilite_m1_rready;
  wire                            axilite_m1_rvalid;

  wire [31:0]                     axilite_m2_awaddr;
  wire                            axilite_m2_awvalid;
  wire                            axilite_m2_awready;
  wire [31:0]                     axilite_m2_wdata;
  wire [3:0]                      axilite_m2_wstrb;
  wire                            axilite_m2_wvalid;
  wire                            axilite_m2_wready;
  wire                            axilite_m2_bvalid;
  wire                            axilite_m2_bready;
  wire [1:0]                      axilite_m2_bresp;
  wire [31:0]                     axilite_m2_araddr;
  wire                            axilite_m2_arready;
  wire                            axilite_m2_arvalid;
  wire [31:0]                     axilite_m2_rdata;
  wire [1:0]                      axilite_m2_rresp;
  wire                            axilite_m2_rready;
  wire                            axilite_m2_rvalid;

  wire [31:0]                     axilite_m3_awaddr;
  wire                            axilite_m3_awvalid;
  wire                            axilite_m3_awready;
  wire [31:0]                     axilite_m3_wdata;
  wire [3:0]                      axilite_m3_wstrb;
  wire                            axilite_m3_wvalid;
  wire                            axilite_m3_wready;
  wire                            axilite_m3_bvalid;
  wire                            axilite_m3_bready;
  wire [1:0]                      axilite_m3_bresp;
  wire [31:0]                     axilite_m3_araddr;
  wire                            axilite_m3_arready;
  wire                            axilite_m3_arvalid;
  wire [31:0]                     axilite_m3_rdata;
  wire [1:0]                      axilite_m3_rresp;
  wire                            axilite_m3_rready;
  wire                            axilite_m3_rvalid;

  wire                            axilite_m4_clk;          
  wire [31:0]                     axilite_m4_awaddr;
  wire                            axilite_m4_awvalid;
  wire                            axilite_m4_awready;
  wire [31:0]                     axilite_m4_wdata;
  wire [3:0]                      axilite_m4_wstrb;
  wire                            axilite_m4_wvalid;
  wire                            axilite_m4_wready;
  wire                            axilite_m4_bvalid;
  wire                            axilite_m4_bready;
  wire [1:0]                      axilite_m4_bresp;
  wire [31:0]                     axilite_m4_araddr;
  wire                            axilite_m4_arready;
  wire                            axilite_m4_arvalid;
  wire [31:0]                     axilite_m4_rdata;
  wire [1:0]                      axilite_m4_rresp;
  wire                            axilite_m4_rready;
  wire                            axilite_m4_rvalid;
  //
  // This AXILITE interconnect is 1M:5S configuration. The received 1DW
  // register transactions from the target AXI master are connected to
  // this for routing to appropriate slave.
  // For address mapping, only lower 16-bits as received over the target
  // AXI master are used. As an alternative, BAR0 could have been read
  // through backdoor access and address received XOR'd with it to provide
  // the right offset. 
  

  //- Hold AXI4LITE interconnect in reset till all clocks are stable

  reg clk_stable = 1'b0;
  reg ic_rstdone  = 1'b0;
  reg ic_reset;
  reg [15:0] axi_ic_rst = 'd0;
  wire core_reset_sync;

  // synchronize core_reset to user_clk
    synchronizer_simple #(.DATA_WIDTH (1)) sync_core_reset_to_userclk
  (
    .data_in          (core_reset),
    .new_clk          (user_clk),
    .data_out         (core_reset_sync)
  );


  always @(posedge user_clk)
    if (user_reset | core_reset_sync | ic_reset)
      clk_stable  <= 1'b0;
    else if (~ic_rstdone)
      clk_stable  <= 1'b1;

  always @(posedge user_clk)
    if (user_reset)
      ic_rstdone  <= 1'b0;
    else if (clk_stable)
      ic_rstdone  <= 1'b1;
      
  always @(posedge user_clk)
    if (clk_stable)
      axi_ic_rst  <= 16'd1;
    else
      axi_ic_rst <= {axi_ic_rst[14:0],1'b0};
      
  always @(posedge user_clk)
  begin
    ic_reset <= |(axi_ic_rst);
  end
                                                          

  
  axilite_system  axilite_system (
    .user_clk        (user_clk),
    .resetn          (~ic_reset),
    
   
    .axilite_m4_awaddr                (axilite_m4_awaddr),
    .axilite_m4_awvalid               (axilite_m4_awvalid),
    .axilite_m4_awready               (axilite_m4_awready),
    .axilite_m4_wdata                 (axilite_m4_wdata),
    .axilite_m4_wstrb                 (axilite_m4_wstrb),
    .axilite_m4_wvalid                (axilite_m4_wvalid),
    .axilite_m4_wready                (axilite_m4_wready),
    .axilite_m4_bresp                 (axilite_m4_bresp),
    .axilite_m4_bvalid                (axilite_m4_bvalid),
    .axilite_m4_bready                (axilite_m4_bready),
    .axilite_m4_araddr                (axilite_m4_araddr),
    .axilite_m4_arvalid               (axilite_m4_arvalid),
    .axilite_m4_arready               (axilite_m4_arready),
    .axilite_m4_rdata                 (axilite_m4_rdata),
    .axilite_m4_rresp                 (axilite_m4_rresp),
    .axilite_m4_rvalid                (axilite_m4_rvalid),
    .axilite_m4_rready                (axilite_m4_rready),

    .axilite_m3_awaddr                (axilite_m3_awaddr),
    .axilite_m3_awvalid               (axilite_m3_awvalid),
    .axilite_m3_awready               (axilite_m3_awready),
    .axilite_m3_wdata                 (axilite_m3_wdata),
    .axilite_m3_wstrb                 (axilite_m3_wstrb),
    .axilite_m3_wvalid                (axilite_m3_wvalid),
    .axilite_m3_wready                (axilite_m3_wready),
    .axilite_m3_bresp                 (axilite_m3_bresp),
    .axilite_m3_bvalid                (axilite_m3_bvalid),
    .axilite_m3_bready                (axilite_m3_bready),
    .axilite_m3_araddr                (axilite_m3_araddr),
    .axilite_m3_arvalid               (axilite_m3_arvalid),
    .axilite_m3_arready               (axilite_m3_arready),
    .axilite_m3_rdata                 (axilite_m3_rdata),
    .axilite_m3_rresp                 (axilite_m3_rresp),
    .axilite_m3_rvalid                (axilite_m3_rvalid),
    .axilite_m3_rready                (axilite_m3_rready),

    .axilite_m2_awaddr                (axilite_m2_awaddr),
    .axilite_m2_awvalid               (axilite_m2_awvalid),
    .axilite_m2_awready               (axilite_m2_awready),
    .axilite_m2_wdata                 (axilite_m2_wdata),
    .axilite_m2_wstrb                 (axilite_m2_wstrb),
    .axilite_m2_wvalid                (axilite_m2_wvalid),
    .axilite_m2_wready                (axilite_m2_wready),
    .axilite_m2_bresp                 (axilite_m2_bresp),
    .axilite_m2_bvalid                (axilite_m2_bvalid),
    .axilite_m2_bready                (axilite_m2_bready),
    .axilite_m2_araddr                (axilite_m2_araddr),
    .axilite_m2_arvalid               (axilite_m2_arvalid),
    .axilite_m2_arready               (axilite_m2_arready),
    .axilite_m2_rdata                 (axilite_m2_rdata),
    .axilite_m2_rresp                 (axilite_m2_rresp),
    .axilite_m2_rvalid                (axilite_m2_rvalid),
    .axilite_m2_rready                (axilite_m2_rready),

    .axilite_m1_awaddr                (axilite_m1_awaddr),
    .axilite_m1_awvalid               (axilite_m1_awvalid),
    .axilite_m1_awready               (axilite_m1_awready),
    .axilite_m1_wdata                 (axilite_m1_wdata),
    .axilite_m1_wstrb                 (axilite_m1_wstrb),
    .axilite_m1_wvalid                (axilite_m1_wvalid),
    .axilite_m1_wready                (axilite_m1_wready),
    .axilite_m1_bresp                 (axilite_m1_bresp),
    .axilite_m1_bvalid                (axilite_m1_bvalid),
    .axilite_m1_bready                (axilite_m1_bready),
    .axilite_m1_araddr                (axilite_m1_araddr),
    .axilite_m1_arvalid               (axilite_m1_arvalid),
    .axilite_m1_arready               (axilite_m1_arready),
    .axilite_m1_rdata                 (axilite_m1_rdata),
    .axilite_m1_rresp                 (axilite_m1_rresp),
    .axilite_m1_rvalid                (axilite_m1_rvalid),
    .axilite_m1_rready                (axilite_m1_rready),
    
    .axilite_m0_awaddr                (axilite_m0_awaddr),
    .axilite_m0_awvalid               (axilite_m0_awvalid),
    .axilite_m0_awready               (axilite_m0_awready),
    .axilite_m0_wdata                 (axilite_m0_wdata),
    .axilite_m0_wstrb                 (axilite_m0_wstrb),
    .axilite_m0_wvalid                (axilite_m0_wvalid),
    .axilite_m0_wready                (axilite_m0_wready),
    .axilite_m0_bresp                 (axilite_m0_bresp),
    .axilite_m0_bvalid                (axilite_m0_bvalid),
    .axilite_m0_bready                (axilite_m0_bready),
    .axilite_m0_araddr                (axilite_m0_araddr),
    .axilite_m0_arvalid               (axilite_m0_arvalid),
    .axilite_m0_arready               (axilite_m0_arready),
    .axilite_m0_rdata                 (axilite_m0_rdata),
    .axilite_m0_rresp                 (axilite_m0_rresp),
    .axilite_m0_rvalid                (axilite_m0_rvalid),
    .axilite_m0_rready                (axilite_m0_rready),

    .axi4lite_s_awaddr               ({16'd0,axi4lite_s_awaddr[15:0]}),
    .axi4lite_s_awvalid              (axi4lite_s_awvalid),
    .axi4lite_s_awready              (axi4lite_s_awready),
    .axi4lite_s_wdata                (wdata             ),
    .axi4lite_s_wstrb                (4'b1111          ),
    .axi4lite_s_wvalid               (axi4lite_s_wvalid),
    .axi4lite_s_wready               (axi4lite_s_wready),
    .axi4lite_s_bresp                (axi4lite_s_bresp),
    .axi4lite_s_bvalid               (axi4lite_s_bvalid),
    .axi4lite_s_bready               (axi4lite_s_bready),
    .axi4lite_s_araddr               ({16'd0,axi4lite_s_araddr[15:0]}),
    .axi4lite_s_arvalid              (axi4lite_s_arvalid),
    .axi4lite_s_arready              (axi4lite_s_arready),
    .axi4lite_s_rdata                (rdata            ),
    .axi4lite_s_rresp                (axi4lite_s_rresp ),
    .axi4lite_s_rvalid               (axi4lite_s_rvalid),
    .axi4lite_s_rready               (axi4lite_s_rready)
  );


  `ifndef SIMULATION
    //-SI 5324 programming
    clock_control cc_inst (
      .i2c_clk        (i2c_clk        ),
      .i2c_data       (i2c_data       ),
      .i2c_mux_rst_n  (i2c_mux_rst_n  ),
      .si5324_rst_n   (si5324_rst_n   ),
      .rst            (~perst_n_c     ),  
      .clk50          (clk50          )
    );
  `else
    assign i2c_clk        = 1'b1;
    assign i2c_data       = 1'b1;
    assign i2c_mux_rst_n  = 1'b1;
    assign si5324_rst_n   = 1'b1;
  `endif  

  wire perst_n_sync_eth;
  wire user_reset_sync_eth;
  wire perst_sys_rst;
  reg  core_reset_tmp;
  //synthesis attribute async_reg of core_reset_tmp is "true";
  //synthesis attribute async_reg of core_reset is "true";
  
  // Synchronize perst_n to Ethernet clock
    synchronizer_simple #(.DATA_WIDTH (1)) sync_perst_to_ethclk
  (
    .data_in          (perst_n_c),
    .new_clk          (xgemac_clk_156),
    .data_out         (perst_n_sync_eth)
  );
  
  // Use async assert, synchronous deassert, active high
  assign perst_sys_rst = ~perst_n_c || ~perst_n_sync_eth;
  
  // synchronize user_reset to clk156
    synchronizer_simple #(.DATA_WIDTH (1)) sync_user_reset_to_ethclk
  (
    .data_in          (user_reset),
    .new_clk          (xgemac_clk_156),
    .data_out         (user_reset_sync_eth)
  );
  
  always @(posedge user_reset_sync_eth or posedge xgemac_clk_156)
  begin
    if(user_reset_sync_eth)
    begin
      core_reset_tmp <= 1'b1;
      core_reset <= 1'b1;
    end
    else
    begin
      // Hold core in reset until everything else is ready...
      core_reset_tmp <= (!(xphy_gt0_tx_resetdone) || !(xphy_gt1_tx_resetdone) || 
                         !(xphy_gt2_tx_resetdone) || !(xphy_gt3_tx_resetdone) || 
                           user_reset_sync_eth || xphy_tx_fault );
      core_reset <= core_reset_tmp;
    end
  end 
 
`ifdef BASE_ONLY
  //- Differential to Single-ended Clock conversion for 10G PHY
   IBUFDS_GTE2 xgphy_refclk_ibuf (
   
       .I      (xphy_refclk_clk_p),
       .IB     (xphy_refclk_clk_n),
       .O      (xphyrefclk_i  ),
       .CEB    (1'b0          ),
       .ODIV2  (              )   
   );

   BUFG xgphy_refclk_bufg (

      .I      (xphyrefclk_i),
      .O      (xgemac_clk_156  )
   );

   // No Ethernet paths
   // Put VFIFO channels into loopback
   assign axi_str_rmac0_tvalid = axi_str_tmac0_tvalid;
   assign axi_str_rmac0_tdata  = {64'b0,axi_str_tmac0_tdata[63:0]};
   assign axi_str_rmac0_tlast  = axi_str_tmac0_tlast;
   assign axi_str_rmac0_tkeep  = {8'b0,axi_str_tmac0_tkeep[7:0]};
   assign axi_str_tmac0_tready = axi_str_rmac0_tready;
   
   assign axi_str_rmac1_tvalid = axi_str_tmac1_tvalid;
   assign axi_str_rmac1_tdata  = {64'b0,axi_str_tmac1_tdata[63:0]};
   assign axi_str_rmac1_tlast  = axi_str_tmac1_tlast;
   assign axi_str_rmac1_tkeep  = {8'b0,axi_str_tmac1_tkeep[7:0]};
   assign axi_str_tmac1_tready = axi_str_rmac1_tready;
   
   assign axi_str_rmac2_tvalid = axi_str_tmac2_tvalid;
   assign axi_str_rmac2_tdata  = {64'b0,axi_str_tmac2_tdata[63:0]};
   assign axi_str_rmac2_tlast  = axi_str_tmac2_tlast;
   assign axi_str_rmac2_tkeep  = {8'b0,axi_str_tmac2_tkeep[7:0]};
   assign axi_str_tmac2_tready = axi_str_rmac2_tready;
   
   assign axi_str_rmac3_tvalid = axi_str_tmac3_tvalid;
   assign axi_str_rmac3_tdata  = {64'b0,axi_str_tmac3_tdata[63:0]};
   assign axi_str_rmac3_tlast  = axi_str_tmac3_tlast;
   assign axi_str_rmac3_tkeep  = {8'b0,axi_str_tmac3_tkeep[7:0]};
   assign axi_str_tmac3_tready = axi_str_rmac3_tready;
   
   assign xphy_gt0_tx_resetdone = 1'b1;
   assign xphy_gt1_tx_resetdone = 1'b1;
   assign xphy_gt2_tx_resetdone = 1'b1;
   assign xphy_gt3_tx_resetdone = 1'b1;
   assign xphy_tx_fault = 1'b0;

`else // ! BASE_ONLY

`ifdef USE_XPHY
  `ifdef SIMULATION
  // Deliberately not driving to default value or assigning a value
  // It will be driven by the simulation testbench by dot reference
    wire sim_speedup_control;
  `else
    wire sim_speedup_control = 1'b0;
  `endif
 
  //- Network Path instance #0
  assign xphy0_prtad          = 5'd0;
  assign xphy0_signal_detect  = 1'b1;
  assign xphy_tx_fault        = 1'b0;
  wire [47:0] mac0_id;

  synchronizer_vector #(.DATA_WIDTH (48)) sync_macid0_to_mac_clk
  (
   .data_in          (mac0_adrs),
   .old_clk          (user_clk),
   .new_clk          (xgemac_clk_156),
   .data_out         (mac0_id)
  );


  network_path_shared #(
    .AXIS_TDATA_WIDTH                 (AXIS_TDATA_WIDTH            ),
    .AXIS_TKEEP_WIDTH                 (AXIS_TKEEP_WIDTH            ) 
  ) network_path_inst_0 (
    // AXI Lite register interface
    .s_axi_aresetn                    (~core_reset_sync            ), 
    .s_axi_awready                    (axilite_m1_awready          ),
    .s_axi_wready                     (axilite_m1_wready           ),
    .s_axi_bvalid                     (axilite_m1_bvalid           ),
    .s_axi_bresp                      (axilite_m1_bresp            ),
    .s_axi_arready                    (axilite_m1_arready          ),
    .s_axi_rdata                      (axilite_m1_rdata            ),
    .s_axi_rresp                      (axilite_m1_rresp            ),
    .s_axi_rvalid                     (axilite_m1_rvalid           ),
    .s_axi_arvalid                    (axilite_m1_arvalid          ),
    .s_axi_araddr                     (axilite_m1_araddr           ),
    .s_axi_awaddr                     (axilite_m1_awaddr           ),
    .s_axi_wdata                      (axilite_m1_wdata            ),
    .s_axi_wstrb                      (axilite_m1_wstrb            ),
    .s_axi_wvalid                     (axilite_m1_wvalid           ),
    .s_axi_bready                     (axilite_m1_bready           ),
    .s_axi_awvalid                    (axilite_m1_awvalid          ),
    .s_axi_rready                     (axilite_m1_rready           ), 

     //Data interface 
    .axi_str_wr_tdata                 ({64'd0, axi_str_tmac0_tdata[63:0]}),
    .axi_str_wr_tkeep                 ({8'd0, axi_str_tmac0_tkeep[7:0]}),
    .axi_str_wr_tvalid                (axi_str_tmac0_tvalid        ),
    .axi_str_wr_tlast                 (axi_str_tmac0_tlast         ),
    .axi_str_wr_tready                (axi_str_tmac0_tready        ),
    .axi_str_rd_tdata                 (axi_str_rmac0_tdata         ),
    .axi_str_rd_tkeep                 (axi_str_rmac0_tkeep         ),
    .axi_str_rd_tvalid                (axi_str_rmac0_tvalid        ),
    .axi_str_rd_tlast                 (axi_str_rmac0_tlast         ),
    .axi_str_rd_tready                (axi_str_rmac0_tready        ),
    .rx_fifo_overflow                 (mac0_rx_fifo_overflow      ),
    .mac_id                           (mac0_id                    ),
    .tx_ifg_delay                     (8'd0                        ),
    .mac_id_valid                     (1'b1                        ),
    .promiscuous_mode_en              (mac0_pm_enable              ),
    //XGEMAC PHY IO
    .xphy_refclk_p                    (xphy_refclk_clk_p),
    .xphy_refclk_n                    (xphy_refclk_clk_n),
    .xphy_txp                         (xphy0_txp),
    .xphy_txn                         (xphy0_txn),
    .xphy_rxp                         (xphy0_rxp),
    .xphy_rxn                         (xphy0_rxn),
    .txusrclk                         (xphy_gt_txusrclk),
    .txusrclk2                        (xphy_gt_txusrclk2),
    .core_reset                        (core_reset),
    .tx_resetdone                      (xphy_gt0_tx_resetdone),
    .areset_clk156                    (xphy_areset_clk_156_25),
    .gttxreset                        (xphy_gttxreset),
    .gtrxreset                        (xphy_gtrxreset),
    .txuserrdy                        (xphy_gt_txuserrdy),
    .qplllock                         (xphy_gt_qplllock),
    .qplloutclk                       (xphy_gt_qplloutclk),
    .qplloutrefclk                    (xphy_gt_qplloutrefclk),
    .reset_counter_done               (xphy_reset_counter_done),
    .dclk                             (xgemac_clk_156),  
    .xphy_status                      (xphy0_status),
    .xphy_tx_disable                  (xphy_tx_disable[0]),
    .signal_detect                    (xphy0_signal_detect),
    .tx_fault                          (xphy_tx_fault), 
    .prtad                            (xphy0_prtad),
    .clk156                           (xgemac_clk_156),
    .soft_reset                       (~axi_str_c2s0_aresetn),
    .sys_rst                          (perst_sys_rst),
    .user_clk                         (user_clk),
    .sim_speedup_control              (sim_speedup_control)
  ); 

  //- Network Path instance #1
  assign xphy1_prtad          = 5'd1;
  assign xphy1_signal_detect  = 1'b1;
  wire [47:0] mac1_id;
  synchronizer_vector #(.DATA_WIDTH (48)) sync_macid1_to_mac_clk
  (
   .data_in          (mac1_adrs),
   .old_clk          (user_clk),
   .new_clk          (xgemac_clk_156),
   .data_out         (mac1_id)
  );


  network_path #(
    .AXIS_TDATA_WIDTH                 (AXIS_TDATA_WIDTH           ),
    .AXIS_TKEEP_WIDTH                 (AXIS_TKEEP_WIDTH           ) 
  ) network_path_inst_1 (
    // AXI Lite register interface
    .s_axi_aresetn                    (~core_reset_sync            ), 
    .s_axi_awready                    (axilite_m2_awready          ),
    .s_axi_wready                     (axilite_m2_wready           ),
    .s_axi_bvalid                     (axilite_m2_bvalid           ),
    .s_axi_bresp                      (axilite_m2_bresp            ),
    .s_axi_arready                    (axilite_m2_arready          ),
    .s_axi_rdata                      (axilite_m2_rdata            ),
    .s_axi_rresp                      (axilite_m2_rresp            ),
    .s_axi_rvalid                     (axilite_m2_rvalid           ),
    .s_axi_arvalid                    (axilite_m2_arvalid          ),
    .s_axi_araddr                     (axilite_m2_araddr           ),
    .s_axi_awaddr                     (axilite_m2_awaddr           ),
    .s_axi_wdata                      (axilite_m2_wdata            ),
    .s_axi_wstrb                      (axilite_m2_wstrb            ),
    .s_axi_wvalid                     (axilite_m2_wvalid           ),
    .s_axi_bready                     (axilite_m2_bready           ),
    .s_axi_awvalid                    (axilite_m2_awvalid          ),
    .s_axi_rready                     (axilite_m2_rready           ), 

     //Data interface 
    .axi_str_wr_tdata                 ({64'd0, axi_str_tmac1_tdata[63:0]}),
    .axi_str_wr_tkeep                 ({8'd0, axi_str_tmac1_tkeep[7:0]}),
    .axi_str_wr_tvalid                (axi_str_tmac1_tvalid        ),
    .axi_str_wr_tlast                 (axi_str_tmac1_tlast         ),
    .axi_str_wr_tready                (axi_str_tmac1_tready        ),
    .axi_str_rd_tdata                 (axi_str_rmac1_tdata         ),
    .axi_str_rd_tkeep                 (axi_str_rmac1_tkeep         ),
    .axi_str_rd_tvalid                (axi_str_rmac1_tvalid        ),
    .axi_str_rd_tlast                 (axi_str_rmac1_tlast         ),
    .axi_str_rd_tready                (axi_str_rmac1_tready        ),
    .rx_fifo_overflow                 (mac1_rx_fifo_overflow      ),
    .mac_id                           (mac1_id                   ),
    .tx_ifg_delay                     (8'd0                        ),
    .mac_id_valid                     (1'b1                        ),
    .promiscuous_mode_en              (mac1_pm_enable              ),
    //XGEMAC PHY IO
    .xphy_txp                         (xphy1_txp),
    .xphy_txn                         (xphy1_txn),
    .xphy_rxp                         (xphy1_rxp),
    .xphy_rxn                         (xphy1_rxn),
    .txusrclk                         (xphy_gt_txusrclk),
    .txusrclk2                        (xphy_gt_txusrclk2),
    .core_reset                        (core_reset),
    .tx_resetdone                      (xphy_gt1_tx_resetdone),
    .areset_clk156                    (xphy_areset_clk_156_25),
    .gttxreset                        (xphy_gttxreset),
    .gtrxreset                        (xphy_gtrxreset),
    .txuserrdy                        (xphy_gt_txuserrdy),
    .qplllock                         (xphy_gt_qplllock),
    .qplloutclk                       (xphy_gt_qplloutclk),
    .qplloutrefclk                    (xphy_gt_qplloutrefclk),
    .reset_counter_done               (xphy_reset_counter_done),
    .dclk                             (xgemac_clk_156),  
    .xphy_status                      (xphy1_status),
    .xphy_tx_disable                  (xphy_tx_disable[1]),
    .signal_detect                    (xphy1_signal_detect),
    .tx_fault                          (xphy_tx_fault), 
    .prtad                            (xphy1_prtad),
    .clk156                           (xgemac_clk_156),
    .soft_reset                       (~axi_str_c2s1_aresetn),
    .sys_rst                          (perst_sys_rst),
    .user_clk                         (user_clk),
    .sim_speedup_control              (sim_speedup_control)
  ); 

  //- Network Path instance #2
  assign xphy2_prtad          = 5'd2;
  assign xphy2_signal_detect  = 1'b1;
  wire [47:0] mac2_id;

  synchronizer_vector #(.DATA_WIDTH (48)) sync_macid2_to_mac_clk
  (
   .data_in          (mac2_adrs),
   .old_clk          (user_clk),
   .new_clk          (xgemac_clk_156),
   .data_out         (mac2_id)
  );


  network_path #(
    .AXIS_TDATA_WIDTH                 (AXIS_TDATA_WIDTH           ),
    .AXIS_TKEEP_WIDTH                 (AXIS_TKEEP_WIDTH           ) 
  ) network_path_inst_2 (
    // AXI Lite register interface
    .s_axi_aresetn                    (~core_reset_sync            ), 
    .s_axi_awready                    (axilite_m3_awready          ),
    .s_axi_wready                     (axilite_m3_wready           ),
    .s_axi_bvalid                     (axilite_m3_bvalid           ),
    .s_axi_bresp                      (axilite_m3_bresp            ),
    .s_axi_arready                    (axilite_m3_arready          ),
    .s_axi_rdata                      (axilite_m3_rdata            ),
    .s_axi_rresp                      (axilite_m3_rresp            ),
    .s_axi_rvalid                     (axilite_m3_rvalid           ),
    .s_axi_arvalid                    (axilite_m3_arvalid          ),
    .s_axi_araddr                     (axilite_m3_araddr           ),
    .s_axi_awaddr                     (axilite_m3_awaddr           ),
    .s_axi_wdata                      (axilite_m3_wdata            ),
    .s_axi_wstrb                      (axilite_m3_wstrb            ),
    .s_axi_wvalid                     (axilite_m3_wvalid           ),
    .s_axi_bready                     (axilite_m3_bready           ),
    .s_axi_awvalid                    (axilite_m3_awvalid          ),
    .s_axi_rready                     (axilite_m3_rready           ), 

     //Data interface 
    .axi_str_wr_tdata                 ({64'd0, axi_str_tmac2_tdata[63:0]}),
    .axi_str_wr_tkeep                 ({8'd0, axi_str_tmac2_tkeep[7:0]}),
    .axi_str_wr_tvalid                (axi_str_tmac2_tvalid        ),
    .axi_str_wr_tlast                 (axi_str_tmac2_tlast         ),
    .axi_str_wr_tready                (axi_str_tmac2_tready        ),
    .axi_str_rd_tdata                 (axi_str_rmac2_tdata         ),
    .axi_str_rd_tkeep                 (axi_str_rmac2_tkeep         ),
    .axi_str_rd_tvalid                (axi_str_rmac2_tvalid        ),
    .axi_str_rd_tlast                 (axi_str_rmac2_tlast         ),
    .axi_str_rd_tready                (axi_str_rmac2_tready        ),
    .rx_fifo_overflow                 (mac2_rx_fifo_overflow      ),
    .mac_id                           (mac2_id                   ),
    .tx_ifg_delay                     (8'd0                        ),
    .mac_id_valid                     (1'b1                        ),
    .promiscuous_mode_en              (mac2_pm_enable              ),
    //XGEMAC PHY IO
    .xphy_txp                         (xphy2_txp),
    .xphy_txn                         (xphy2_txn),
    .xphy_rxp                         (xphy2_rxp),
    .xphy_rxn                         (xphy2_rxn),
    .txusrclk                         (xphy_gt_txusrclk),
    .txusrclk2                        (xphy_gt_txusrclk2),
    .core_reset                        (core_reset),
    .tx_resetdone                      (xphy_gt2_tx_resetdone),
    .areset_clk156                    (xphy_areset_clk_156_25),
    .gttxreset                        (xphy_gttxreset),
    .gtrxreset                        (xphy_gtrxreset),
    .txuserrdy                        (xphy_gt_txuserrdy),
    .qplllock                         (xphy_gt_qplllock),
    .qplloutclk                       (xphy_gt_qplloutclk),
    .qplloutrefclk                    (xphy_gt_qplloutrefclk),
    .reset_counter_done               (xphy_reset_counter_done),
    .dclk                             (xgemac_clk_156),  
    .xphy_status                      (xphy2_status),
    .xphy_tx_disable                  (xphy_tx_disable[2]),
    .signal_detect                    (xphy2_signal_detect),
    .tx_fault                          (xphy_tx_fault), 
    .prtad                            (xphy2_prtad),
    .clk156                           (xgemac_clk_156),
    .soft_reset                       (~axi_str_c2s2_aresetn),
    .sys_rst                          (perst_sys_rst),
    .user_clk                         (user_clk),
    .sim_speedup_control              (sim_speedup_control)
  ); 

  //- Network Path instance #3
  assign xphy3_prtad          = 5'd3;
  assign xphy3_signal_detect  = 1'b1;
  wire [47:0] mac3_id;

  synchronizer_vector #(.DATA_WIDTH (48)) sync_macid3_to_mac_clk
  (
   .data_in          (mac3_adrs),
   .old_clk          (user_clk),
   .new_clk          (xgemac_clk_156),
   .data_out         (mac3_id)
  );

  network_path #(
    .AXIS_TDATA_WIDTH                 (AXIS_TDATA_WIDTH           ),
    .AXIS_TKEEP_WIDTH                 (AXIS_TKEEP_WIDTH           ) 
  ) network_path_inst_3 (
    // AXI Lite register interface
    .s_axi_aresetn                    (~core_reset_sync            ), 
    .s_axi_awready                    (axilite_m4_awready          ),
    .s_axi_wready                     (axilite_m4_wready           ),
    .s_axi_bvalid                     (axilite_m4_bvalid           ),
    .s_axi_bresp                      (axilite_m4_bresp            ),
    .s_axi_arready                    (axilite_m4_arready          ),
    .s_axi_rdata                      (axilite_m4_rdata            ),
    .s_axi_rresp                      (axilite_m4_rresp            ),
    .s_axi_rvalid                     (axilite_m4_rvalid           ),
    .s_axi_arvalid                    (axilite_m4_arvalid          ),
    .s_axi_araddr                     (axilite_m4_araddr           ),
    .s_axi_awaddr                     (axilite_m4_awaddr           ),
    .s_axi_wdata                      (axilite_m4_wdata            ),
    .s_axi_wstrb                      (axilite_m4_wstrb            ),
    .s_axi_wvalid                     (axilite_m4_wvalid           ),
    .s_axi_bready                     (axilite_m4_bready           ),
    .s_axi_awvalid                    (axilite_m4_awvalid          ),
    .s_axi_rready                     (axilite_m4_rready           ), 

     //Data interface 
    .axi_str_wr_tdata                 ({64'd0, axi_str_tmac3_tdata[63:0]}),
    .axi_str_wr_tkeep                 ({8'd0, axi_str_tmac3_tkeep[7:0]}),
    .axi_str_wr_tvalid                (axi_str_tmac3_tvalid        ),
    .axi_str_wr_tlast                 (axi_str_tmac3_tlast         ),
    .axi_str_wr_tready                (axi_str_tmac3_tready        ),
    .axi_str_rd_tdata                 (axi_str_rmac3_tdata         ),
    .axi_str_rd_tkeep                 (axi_str_rmac3_tkeep         ),
    .axi_str_rd_tvalid                (axi_str_rmac3_tvalid        ),
    .axi_str_rd_tlast                 (axi_str_rmac3_tlast         ),
    .axi_str_rd_tready                (axi_str_rmac3_tready        ),
    .rx_fifo_overflow                 (mac3_rx_fifo_overflow      ),
    .mac_id                           (mac3_id                   ),
    .tx_ifg_delay                     (8'd0                        ),
    .mac_id_valid                     (1'b1                        ),
    .promiscuous_mode_en              (mac3_pm_enable              ),
    //XGEMAC PHY IO
    .xphy_txp                         (xphy3_txp),
    .xphy_txn                         (xphy3_txn),
    .xphy_rxp                         (xphy3_rxp),
    .xphy_rxn                         (xphy3_rxn),
    .txusrclk                         (xphy_gt_txusrclk),
    .txusrclk2                        (xphy_gt_txusrclk2),
    .core_reset                        (core_reset),
    .tx_resetdone                      (xphy_gt3_tx_resetdone),
    .areset_clk156                    (xphy_areset_clk_156_25),
    .gttxreset                        (xphy_gttxreset),
    .gtrxreset                        (xphy_gtrxreset),
    .txuserrdy                        (xphy_gt_txuserrdy),
    .qplllock                         (xphy_gt_qplllock),
    .qplloutclk                       (xphy_gt_qplloutclk),
    .qplloutrefclk                    (xphy_gt_qplloutrefclk),
    .reset_counter_done               (xphy_reset_counter_done),
    .dclk                             (xgemac_clk_156),  
    .xphy_status                      (xphy3_status),
    .xphy_tx_disable                  (xphy_tx_disable[3]),
    .signal_detect                    (xphy3_signal_detect),
    .tx_fault                          (xphy_tx_fault), 
    .prtad                            (xphy3_prtad),
    .clk156                           (xgemac_clk_156),
    .soft_reset                       (~axi_str_c2s3_aresetn),
    .sys_rst                          (perst_sys_rst),
    .user_clk                         (user_clk),
    .sim_speedup_control              (sim_speedup_control)
  ); 

`endif   // USE_XPHY 
    //- Network instance ends
`endif  //! BASE_ONLY

//- Performance mode GEN/CHK connection
  assign axi_str_s2c0_tvalid_app = ch0_perf_mode_en ? 1'b0 :
                                          axi_str_s2c0_tvalid;
  assign axi_str_s2c0_tvalid_perf= ch0_perf_mode_en ? axi_str_s2c0_tvalid :
                                          1'b0;
  
  assign axi_str_s2c0_tready  = ch0_perf_mode_en ? axi_str_s2c0_tready_perf :
                                    axi_str_s2c0_tready_app;
  assign axi_str_c2s0_tvalid = ch0_perf_mode_en ? axi_str_c2s0_tvalid_perf :
                                    axi_str_c2s0_tvalid_app;
  assign axi_str_c2s0_tlast = ch0_perf_mode_en ? axi_str_c2s0_tlast_perf :
                                    axi_str_c2s0_tlast_app;
  assign axi_str_c2s0_tdata = ch0_perf_mode_en ? axi_str_c2s0_tdata_perf :
                                    axi_str_c2s0_tdata_app;
  assign axi_str_c2s0_tkeep = ch0_perf_mode_en ? axi_str_c2s0_tkeep_perf :
                                    axi_str_c2s0_tkeep_app;
  assign axi_str_c2s0_tuser_perf[63:16] = 'b0;
  assign axi_str_c2s0_tuser = ch0_perf_mode_en ? axi_str_c2s0_tuser_perf :
                                      64'd0;
`ifndef BASE_ONLY

  //- S2C/C2S - 0 GEN/CHK
  axi_stream_crc_gen_check #(
    .CNT_WIDTH              (16               ),
    .SEQ_END_CNT_WIDTH      (16               ),
    .AXIS_TDATA_WIDTH       (AXIS_TDATA_WIDTH )
  ) gen_chk_inst0 (
    .enable_loopback        (app0_en_lpbk        ),
    .enable_gen             (app0_en_gen         ),
    .enable_check           (app0_en_chk         ),
    .gen_length             (app0_pkt_len        ),
    .check_length           (app0_pkt_len        ),
    .seq_end_cnt            (16'hFFFF            ),
    .axi_stream_s2c_tdata   (axi_str_s2c0_tdata  ),
    .axi_stream_s2c_tkeep   (axi_str_s2c0_tkeep  ),
    .axi_stream_s2c_tvalid  (axi_str_s2c0_tvalid_perf ),
    .axi_stream_s2c_tlast   (axi_str_s2c0_tlast  ),
    .axi_stream_s2c_tuser   (axi_str_s2c0_tuser  ),
    .axi_stream_s2c_tready  (axi_str_s2c0_tready_perf ),
    .axi_stream_c2s_tdata   (axi_str_c2s0_tdata_perf  ),
    .axi_stream_c2s_tkeep   (axi_str_c2s0_tkeep_perf  ),
    .axi_stream_c2s_tvalid  (axi_str_c2s0_tvalid_perf ),
    .axi_stream_c2s_tlast   (axi_str_c2s0_tlast_perf  ),
    .axi_stream_c2s_tuser   (axi_str_c2s0_tuser_perf),
    .axi_stream_c2s_tready  (axi_str_c2s0_tready ),
    .error_flag             (app0_chk_status     ),
    .user_clk               (user_clk            ),
    .reset                  (user_reset | ~axi_str_c2s0_aresetn)
  );

`endif  // !BASE_ONLY
`endif	//-DMA_LOOPBACK


  //
  // Instatiation of AXI-Lite Slave for User Space Registers
  //
   
    user_registers_slave #(
      .CORE_DATA_WIDTH      (CORE_DATA_WIDTH      ),
      .CORE_BE_WIDTH        (CORE_BE_WIDTH        ),
      .CORE_REMAIN_WIDTH    (CORE_REMAIN_WIDTH    ),
      .C_S_AXI_ADDR_WIDTH   (C_AXILITE_ADDR_WIDTH ),
      .C_S_AXI_DATA_WIDTH   (C_AXILITE_DATA_WIDTH ),
      .C_BASE_ADDRESS       (C_BASE_USER_REG      ),
      .C_HIGH_ADDRESS       (C_HIGH_USER_REG      ),
      .C_S_AXI_MIN_SIZE     (32'h0000_FFFF        ),
      .C_TOTAL_NUM_CE       (1                    ),
      .C_NUM_ADDRESS_RANGES (1                    ),
      .C_DPHASE_TIMEOUT     (32                   ),
      .C_FAMILY             (C_FAMILY             )
    ) user_reg_slave_inst (
      .s_axi_clk            (user_clk             ),
      .s_axi_areset_n       (~user_reset          ),
`ifdef DMA_LOOPBACK      
      .s_axi_awaddr         ({16'd0,axi4lite_s_awaddr[15:0]}    ),
      .s_axi_awready        (axi4lite_s_awready   ),
      .s_axi_awvalid        (axi4lite_s_awvalid   ),
      .s_axi_wdata          (wdata     ),
      .s_axi_wstrb          (4'b1111),
      .s_axi_wvalid         (axi4lite_s_wvalid    ),
      .s_axi_wready         (axi4lite_s_wready    ),
      .s_axi_bresp          (axi4lite_s_bresp     ),
      .s_axi_bvalid         (axi4lite_s_bvalid    ),
      .s_axi_bready         (axi4lite_s_bready    ),
      .s_axi_araddr         ({16'd0,axi4lite_s_araddr[15:0]}    ),
      .s_axi_arvalid        (axi4lite_s_arvalid   ),
      .s_axi_arready        (axi4lite_s_arready   ),
      .s_axi_rdata          (rdata     ),
      .s_axi_rresp          (axi4lite_s_rresp     ),
      .s_axi_rvalid         (axi4lite_s_rvalid    ),
      .s_axi_rready         (axi4lite_s_rready    ),
`else
      .s_axi_awaddr         (axilite_m0_awaddr    ),
      .s_axi_awready        (axilite_m0_awready   ),
      .s_axi_awvalid        (axilite_m0_awvalid   ),
      .s_axi_wdata          (axilite_m0_wdata     ),
      .s_axi_wstrb          (axilite_m0_wstrb     ),
      .s_axi_wvalid         (axilite_m0_wvalid    ),
      .s_axi_wready         (axilite_m0_wready    ),
      .s_axi_bresp          (axilite_m0_bresp     ),
      .s_axi_bvalid         (axilite_m0_bvalid    ),
      .s_axi_bready         (axilite_m0_bready    ),
      .s_axi_araddr         (axilite_m0_araddr    ),
      .s_axi_arvalid        (axilite_m0_arvalid   ),
      .s_axi_arready        (axilite_m0_arready   ),
      .s_axi_rdata          (axilite_m0_rdata     ),
      .s_axi_rresp          (axilite_m0_rresp     ),
      .s_axi_rvalid         (axilite_m0_rvalid    ),
      .s_axi_rready         (axilite_m0_rready    ),
`endif      

      .scaling_factor       (scaling_factor       ),
      .tx_pcie_byte_cnt     (tx_pcie_byte_cnt     ),
      .rx_pcie_byte_cnt     (rx_pcie_byte_cnt     ),
      .tx_pcie_payload_cnt  (tx_pcie_payload_cnt  ),
      .rx_pcie_payload_cnt  (rx_pcie_payload_cnt  ),
      .init_fc_cpld         (init_fc_cpld         ),
      .init_fc_cplh         (init_fc_cplh         ),
      .init_fc_npd          (init_fc_npd          ),
      .init_fc_nph          (init_fc_nph          ),
      .init_fc_pd           (init_fc_pd           ),
      .init_fc_ph           (init_fc_ph           ),
      
      .pcie_link_up           (user_lnk_up        ),
      .ch0_perf_mode_en     (ch0_perf_mode_en     ),  
      .app0_en_gen          (app0_en_gen          ),
      .app0_en_lpbk         (app0_en_lpbk         ),
      .app0_en_chk          (app0_en_chk          ),
      .app0_pkt_len         (app0_pkt_len         ),
      .app0_chk_status      (app0_chk_status      ),
`ifdef USE_PVTMON
      .pmbus_clk            (pmbus_clk            ),
      .pmbus_data           (pmbus_data           ),
      .pmbus_control        (),
      .pmbus_alert          (pmbus_alert          ),
      .clk50                (clk50                ),
      .device_temp          (device_temp          ),
`endif
      .axi_ic_mig_shim_rst_n(axi_ic_mig_shim_rst_n),
`ifdef USE_DDR3_FIFO
      .c0_calib_done        (c0_calib_done        ),
      .c1_calib_done        (c1_calib_done        ),
      .ddr3_fifo_empty      (ddr3_fifo_empty      ),
`else
      .c0_calib_done        (1'b1                 ),
      .c1_calib_done        (1'b1                 ),
      .ddr3_fifo_empty      ({8{1'b1}}            ),
`endif
`ifdef USE_XPHY
      .xphy0_status         (xphy0_status[0]      ),
      .xphy1_status         (xphy1_status[0]      ),
      .xphy2_status         (xphy2_status[0]      ),
      .xphy3_status         (xphy3_status[0]      ),
`else
      .xphy0_status         (1'b1), 
      .xphy1_status         (1'b1), 
      .xphy2_status         (1'b1), 
      .xphy3_status         (1'b1), 
`endif      
      .mac0_pm_enable       (mac0_pm_enable       ),
      .mac0_adrs            (mac0_adrs            ),
      .mac0_rx_fifo_overflow(mac0_rx_fifo_overflow),
      .mac1_pm_enable       (mac1_pm_enable       ),
      .mac1_rx_fifo_overflow(mac1_rx_fifo_overflow),
      .mac1_adrs            (mac1_adrs            ),
      .mac2_pm_enable       (mac2_pm_enable       ),
      .mac2_adrs            (mac2_adrs            ),
      .mac2_rx_fifo_overflow(mac2_rx_fifo_overflow),
      .mac3_pm_enable       (mac3_pm_enable       ),
      .mac3_rx_fifo_overflow(mac3_rx_fifo_overflow),
      .mac3_adrs            (mac3_adrs            )
    );


  //- PCIe Performance Monitoring
 pcie_monitor_gen3 #(
    .TDATA_WIDTH          (AXIS_TDATA_WIDTH)
 ) U_PCIE_MON (
   .clk                   (user_clk),
   .reset                 (user_reset),
   .clk_period_in_ns      (clk_period_in_ns),
   .scaling_factor        (scaling_factor),

   // PCIe Completer Request Interface                    
   .m_axis_cq_tdata       (m_axis_cq_tdata),
   .m_axis_cq_tlast       (m_axis_cq_tlast),
   .m_axis_cq_tvalid      (m_axis_cq_tvalid),
   .m_axis_cq_tready      (m_axis_cq_tready_i),
   .m_axis_cq_tuser       (m_axis_cq_tuser),
   
   // PCIe Completer Completion Interface
   .s_axis_cc_tdata       (s_axis_cc_tdata),
   .s_axis_cc_tlast       (s_axis_cc_tlast),
   .s_axis_cc_tvalid      (s_axis_cc_tvalid),
   .s_axis_cc_tready      (s_axis_cc_tready),
   .s_axis_cc_tuser       (s_axis_cc_tuser),

   // PCIe Requester Request Interface
   .s_axis_rq_tdata       (s_axis_rq_tdata),
   .s_axis_rq_tlast       (s_axis_rq_tlast),
   .s_axis_rq_tvalid      (s_axis_rq_tvalid),
   .s_axis_rq_tready      (s_axis_rq_tready),
   .s_axis_rq_tkeep       (s_axis_rq_tkeep),
   .s_axis_rq_tuser       (s_axis_rq_tuser),

   // PCIe Requester Completion Interface                    
   .m_axis_rc_tdata       (m_axis_rc_tdata),
   .m_axis_rc_tlast       (m_axis_rc_tlast),
   .m_axis_rc_tvalid      (m_axis_rc_tvalid),
   .m_axis_rc_tready      (m_axis_rc_tready_i),
   .m_axis_rc_tuser       (m_axis_rc_tuser),
   
   .fc_cpld               (cfg_fc_cpld),
   .fc_cplh               (cfg_fc_cplh),
   .fc_npd                (cfg_fc_npd),
   .fc_nph                (cfg_fc_nph),
   .fc_pd                 (cfg_fc_pd),
   .fc_ph                 (cfg_fc_ph),
   .fc_sel                (cfg_fc_sel),

   .init_fc_cpld          (init_fc_cpld),
   .init_fc_cplh          (init_fc_cplh),
   .init_fc_npd           (init_fc_npd),
   .init_fc_nph           (init_fc_nph),
   .init_fc_pd            (init_fc_pd),
   .init_fc_ph            (init_fc_ph),

   .tx_byte_count         (tx_pcie_byte_cnt),
   .rx_byte_count         (rx_pcie_byte_cnt),
   .tx_payload_count      (tx_pcie_payload_cnt),
   .rx_payload_count      (rx_pcie_payload_cnt)
 ); 

// LEDs - Status
// ---------------
// Heart beat LED; flashes when primary PCIe core clock is present
always @(posedge user_clk)
begin
    led_ctr <= led_ctr + {{(LED_CTR_WIDTH-1){1'b0}}, 1'b1};
end

always @(posedge xgemac_clk_156)
begin
    phy_led_ctr <= phy_led_ctr + {{(LED_CTR_WIDTH-1){1'b0}}, 1'b1};
end

`ifdef SIMULATION
// Initialize for simulation
initial
begin
    led_ctr = {LED_CTR_WIDTH{1'b0}};
    phy_led_ctr = {LED_CTR_WIDTH{1'b0}};
end
`endif

always @(posedge user_clk or posedge user_reset)
begin
    if (user_reset == 1'b1)
    begin
        lane_width_error  <= 1'b0;
        link_speed_error  <= 1'b0;
    end    
    else
    begin
        lane_width_error <= (cfg_negotiated_width != NUM_LANES); // Negotiated Link Width
        link_speed_error  <= (cfg_current_speed != PL_LINK_CAP_MAX_LINK_SPEED);
    end    
end

// led[0] lights up when PCIe core has trained
assign led[0] = user_lnk_up; 

// led[1] flashes to indicate PCIe clock is running
assign led[1] = led_ctr[LED_CTR_WIDTH-1];  // Flashes when user_clk is present

// led[2] lights up when the correct lane width is acheived
// If the link is not operating at full width, it flashes at twice the speed of the heartbeat on led[1]
assign led[2] = lane_width_error ? led_ctr[LED_CTR_WIDTH-2] : 1'b1;

// led[3] lights up when the correct link speed is acheived
assign led[3] = link_speed_error ? led_ctr[LED_CTR_WIDTH-2] : 1'b1;

`ifdef USE_DDR3_FIFO
// led[6] glows when the DDR3 initialization has completed
assign led[6] = c0_calib_done & c1_calib_done;
`else
assign led[6] = 1'b0;
`endif

  // Combined 10GBASE-R quad link status
// led[5] glows when all Ethernet PHY status bits are high
assign led[5] = (xphy0_status[0] & xphy1_status[0] & 
                    xphy2_status[0] & xphy3_status[0]);


  // heartbeat LED for 156.25MHz clock
assign led[4] = phy_led_ctr[LED_CTR_WIDTH-1];

`ifdef USE_XPHY
  //- Disable Laser when unconnected on SFP+
  assign sfp_tx_disable = 4'b0000;
`endif

endmodule

