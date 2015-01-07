//-----------------------------------------------------------------------------
//
// (c) Copyright 2012-2014 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information of Xilinx, Inc.
// and is protected under U.S. and international copyright and other
// intellectual property laws.
//
// DISCLAIMER
//
// This disclaimer is not a license and does not grant any rights to the
// materials distributed herewith. Except as otherwise provided in a valid
// license issued to you by Xilinx, and to the maximum extent permitted by
// applicable law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL
// FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS,
// IMPLIED, OR STATUTORY, INCLUDING BUT NOT LIMITED TO WARRANTIES OF
// MERCHANTABILITY, NON-INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE;
// and (2) Xilinx shall not be liable (whether in contract or tort, including
// negligence, or under any other theory of liability) for any loss or damage
// of any kind or nature related to, arising under or in connection with these
// materials, including for any direct, or any indirect, special, incidental,
// or consequential loss or damage (including loss of data, profits, goodwill,
// or any type of loss or damage suffered as a result of any action brought by
// a third party) even if such damage or loss was reasonably foreseeable or
// Xilinx had been advised of the possibility of the same.
//
// CRITICAL APPLICATIONS
//
// Xilinx products are not designed or intended to be fail-safe, or for use in
// any application requiring fail-safe performance, such as life-support or
// safety devices or systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any other
// applications that could lead to death, personal injury, or severe property
// or environmental damage (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and liability of any use of
// Xilinx products in Critical Applications, subject only to applicable laws
// and regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE
// AT ALL TIMES.

`timescale 1ps / 1ps

(* CORE_GENERATION_INFO = "network_path_shared,network_path_shared_v1_3,{x_ipproduct=Vivado2014.3,v7_xt_conn_trd=2014.3}" *)
module network_path_shared # (
    parameter RX_FIFO_CNT_WIDTH    =  13,
    parameter AXIS_TDATA_WIDTH  = 128, 
    parameter AXIS_TKEEP_WIDTH  = 16,
    parameter AXIS_XGEMAC_TDATA_WIDTH  = 64, 
    parameter ADDRESS_FILTER_EN = 1,
    parameter C_BASE_ADDRESS    = 32'h000,  
    parameter C_HIGH_ADDRESS    = 32'h07FF
)
(   
    // AXI Lite register interface
    input                            s_axi_aresetn, 
    output                           s_axi_awready,
    input  [31:0]                    s_axi_awaddr,
    input                            s_axi_awvalid,
    output                           s_axi_wready,
    input  [31:0]                    s_axi_wdata,
    input  [3:0]                     s_axi_wstrb,
    input                            s_axi_wvalid,
    output                           s_axi_bvalid,
    output [1:0]                     s_axi_bresp,
    input                            s_axi_bready,
    output                           s_axi_arready,
    input                            s_axi_arvalid,
    input  [31:0]                    s_axi_araddr,
    output [31:0]                    s_axi_rdata,
    output [1:0]                     s_axi_rresp,
    output                           s_axi_rvalid,
    input                            s_axi_rready, 
    // AXI Streaming data interface
    input  [AXIS_TDATA_WIDTH-1:0]    axi_str_wr_tdata,
    input  [AXIS_TKEEP_WIDTH-1:0]    axi_str_wr_tkeep,
    input                            axi_str_wr_tvalid,
    input                            axi_str_wr_tlast,
    output                           axi_str_wr_tready,
    output [AXIS_TDATA_WIDTH-1:0]    axi_str_rd_tdata,
    output [AXIS_TKEEP_WIDTH-1:0]    axi_str_rd_tkeep,
    output                           axi_str_rd_tvalid,
    output                           axi_str_rd_tlast,
    input                            axi_str_rd_tready,
    output                           rx_fifo_overflow,   
    output [RX_FIFO_CNT_WIDTH-1:0]   rd_data_count_xgmac,
    // Additional control inputs
    input  [47:0]                    mac_id,
    input                            mac_id_valid,
    input                            promiscuous_mode_en,
`ifdef USE_XPHY  
    input                            xphy_refclk_n,
    input                            xphy_refclk_p,
    output                           xphy_txp, 
    output                           xphy_txn, 
    input                            xphy_rxp, 
    input                            xphy_rxn, 
    output                           txusrclk, 
    output                           txusrclk2, 
//-Shared reset signals
    output                           areset_clk156,
    output                           gttxreset,   
    output                           gtrxreset,   
    output                           txuserrdy,
    output                           qplllock,
    output                           qplloutclk,
    output                           qplloutrefclk,
    output                           reset_counter_done,
    output                           tx_resetdone, 
`else    
    output [63 : 0]                  xgmii_txd_core,
    output [7 : 0]                   xgmii_txc_core,
    input [63 : 0]                   xgmii_rxd_core,
    input [7 : 0]                    xgmii_rxc_core,
`endif    
    input                            core_reset, 
    input                            tx_fault,
    input                            signal_detect,
    input [4 : 0]                    prtad,
    input [7:0]                      tx_ifg_delay,
    output                           xphy_tx_disable, 

    output [7:0]                     xphy_status,
    output                           clk156, 
    input                            dclk,
    input                            soft_reset, 
    input                            sys_rst,
    input                            user_clk,
    input                            sim_speedup_control
);


   // Signal declarations
   wire                           mdc;      
   wire                           mdio_in;
   wire                           mdio_out;


   wire                           axi_str_rd_tlast_to_fifo;
   wire                           axi_str_wr_tvalid_to_xgmac;
   wire                           axi_str_wr_tready_from_xgmac;
   wire                           axi_str_rd_tvalid_to_fifo;
   
   wire                           rx_statistics_valid;
   wire [29:0]                    rx_statistics_vector;

   wire  [AXIS_XGEMAC_TDATA_WIDTH-1:0]      axi_str_rd_tdata_to_fifo;
   wire  [(AXIS_XGEMAC_TDATA_WIDTH/8)-1:0]  axi_str_rd_tkeep_to_fifo;

   wire                                     axi_str_wr_tlast_i;
   wire  [AXIS_XGEMAC_TDATA_WIDTH-1:0]      axi_str_wr_tdata_i;          
   wire  [(AXIS_XGEMAC_TDATA_WIDTH/8)-1:0]  axi_str_wr_tkeep_i;
   wire                                     axi_str_rd_tlast_i;
   wire  [AXIS_XGEMAC_TDATA_WIDTH-1:0]      axi_str_rd_tdata_i;          
   wire  [(AXIS_XGEMAC_TDATA_WIDTH/8)-1:0]  axi_str_rd_tkeep_i;
   wire                                     axi_str_rd_tvalid_i;          
   wire                                     axi_str_rd_tready_i;

   reg                                      axi_str_rd_tvalid_to_fifo_r = 'd0;
`ifdef USE_XPHY
  //-10GBASE-R PHY Specific signals
  wire [63 : 0]                             xgmii_txd_core;
  wire [7 : 0]                              xgmii_txc_core;
  wire [63 : 0]                             xgmii_rxd_core;
  wire [7 : 0]                              xgmii_rxc_core;

  wire  xphy_resetdone;
`endif

  wire                                      drp_gnt;
  wire                                      drp_req;
  wire                                      drp_den_o;                                   
  wire                                      drp_dwe_o;
  wire [15 : 0]                             drp_daddr_o;                   
  wire [15 : 0]                             drp_di_o; 
  wire                                      drp_drdy_o;                
  wire [15 : 0]                             drp_drpdo_o;
  wire                                      drp_den_i;                                   
  wire                                      drp_dwe_i;
  wire [15 : 0]                             drp_daddr_i;                   
  wire [15 : 0]                             drp_di_i; 
  wire                                      drp_drdy_i;                
  wire [15 : 0]                             drp_drpdo_i;


  // 
  // XGEMAC keeps tready asserted for one cycle after tlast
  // Any back-to-back frame provided are dropped in that case by the MAC
  // Avoid providing back-to-back frames till this is resolved by MAC team
  // 
  reg wr_tlast_reg = 1'b0;

  always @(posedge clk156)
    wr_tlast_reg  <= axi_str_wr_tlast & axi_str_wr_tvalid;

  assign axi_str_wr_tvalid_to_xgmac = wr_tlast_reg ? 1'b0 : axi_str_wr_tvalid;
  assign axi_str_wr_tlast_i = axi_str_wr_tlast;
  assign axi_str_wr_tdata_i = axi_str_wr_tdata[63:0];
  assign axi_str_wr_tkeep_i = axi_str_wr_tkeep[7:0];
  assign axi_str_wr_tready = wr_tlast_reg ? 1'b0 : axi_str_wr_tready_from_xgmac;

  assign axi_str_rd_tdata   = {64'd0, axi_str_rd_tdata_i};
  assign axi_str_rd_tkeep   = {8'd0, axi_str_rd_tkeep_i};
  assign axi_str_rd_tvalid  = axi_str_rd_tvalid_i;
  assign axi_str_rd_tlast   = axi_str_rd_tlast_i;
  assign axi_str_rd_tready_i = axi_str_rd_tready;

  rx_interface #(
    .ADDRESS_FILTER_EN(ADDRESS_FILTER_EN),
    .FIFO_CNT_WIDTH(RX_FIFO_CNT_WIDTH)
  ) rx_interface_i (
    .axi_str_tdata_from_xgmac   (axi_str_rd_tdata_to_fifo     ),
    .axi_str_tkeep_from_xgmac   (axi_str_rd_tkeep_to_fifo     ),
    .axi_str_tvalid_from_xgmac  (axi_str_rd_tvalid_to_fifo    ),
    .axi_str_tlast_from_xgmac   (axi_str_rd_tlast_to_fifo     ),
    .axi_str_tuser_from_xgmac   (axi_str_rd_tuser_to_fifo     ),
    .axi_str_tready_from_fifo   (axi_str_rd_tready_i          ),
    .mac_id                     (mac_id                       ),
    .mac_id_valid               (mac_id_valid                 ),
    .rx_statistics_vector       (rx_statistics_vector         ),
    .rx_statistics_valid        (rx_statistics_valid          ),
    .promiscuous_mode_en        (promiscuous_mode_en          ),
    .axi_str_tdata_to_fifo      (axi_str_rd_tdata_i           ),
    .axi_str_tkeep_to_fifo      (axi_str_rd_tkeep_i           ),
    .axi_str_tvalid_to_fifo     (axi_str_rd_tvalid_i          ),
    .axi_str_tlast_to_fifo      (axi_str_rd_tlast_i           ),
    .rd_data_count              (rd_data_count_xgmac          ),
    .rd_pkt_len                 (rd_pkt_len                   ),
    .rx_fifo_overflow           (rx_fifo_overflow             ),
    .user_clk                   (clk156                       ),
    .soft_reset                 (soft_reset                   ),
    .reset                      (core_reset                   )
);


  ten_gig_eth_mac_axi_st_ip xgemac_core_inst (
    .reset                      (core_reset), 
    .tx_axis_aresetn            (!core_reset),  
    .tx_axis_tdata              (axi_str_wr_tdata_i           ),
    .tx_axis_tvalid             (axi_str_wr_tvalid_to_xgmac   ),
    .tx_axis_tlast              (axi_str_wr_tlast_i           ),
    .tx_axis_tuser              (1'b0                         ),
    .tx_ifg_delay               (tx_ifg_delay                 ),
    .tx_axis_tkeep              (axi_str_wr_tkeep_i           ),
    .tx_axis_tready             (axi_str_wr_tready_from_xgmac ),
    .tx_statistics_vector       (                             ),
    .tx_statistics_valid        (                             ),
    .pause_val                  (16'd0                        ),
    .pause_req                  (1'b0                         ),
    .rx_axis_aresetn            (!core_reset),  
    .rx_axis_tdata              (axi_str_rd_tdata_to_fifo     ),
    .rx_axis_tvalid             (axi_str_rd_tvalid_to_fifo    ),
    .rx_axis_tuser              (axi_str_rd_tuser_to_fifo     ),
    .rx_axis_tlast              (axi_str_rd_tlast_to_fifo     ),
    .rx_axis_tkeep              (axi_str_rd_tkeep_to_fifo     ),
    .rx_statistics_vector       (rx_statistics_vector         ),
    .rx_statistics_valid        (rx_statistics_valid          ),

    .s_axi_aclk                 (user_clk                     ),  
    .s_axi_aresetn              (s_axi_aresetn                ),  
    .s_axi_awaddr               (s_axi_awaddr                 ),
    .s_axi_awvalid              (s_axi_awvalid                ),
    .s_axi_awready              (s_axi_awready                ),
    .s_axi_wdata                (s_axi_wdata                  ),
    .s_axi_wvalid               (s_axi_wvalid                 ),
    .s_axi_wready               (s_axi_wready                 ),
    .s_axi_bresp                (s_axi_bresp                  ),
    .s_axi_bvalid               (s_axi_bvalid                 ),
    .s_axi_bready               (s_axi_bready                 ),
    .s_axi_araddr               (s_axi_araddr                 ),
    .s_axi_arvalid              (s_axi_arvalid                ),
    .s_axi_arready              (s_axi_arready                ),
    .s_axi_rdata                (s_axi_rdata                  ),
    .s_axi_rresp                (s_axi_rresp                  ),
    .s_axi_rvalid               (s_axi_rvalid                 ),
    .s_axi_rready               (s_axi_rready                 ),

    .xgmacint                   (                             ),
    .mdc                        (mdc                          ),
    .mdio_in                    (mdio_in                      ),
    .mdio_out                   (mdio_out                     ),
    .mdio_tri                   (                             ),
    .tx_clk0                    (clk156                       ), 
    .tx_dcm_locked                (1'b1                         ), 
    .xgmii_txd                  (xgmii_txd_core               ),
    .xgmii_txc                  (xgmii_txc_core               ),
    .rx_clk0                    (clk156                       ), 
    .rx_dcm_locked                (1'b1                         ), 
    .xgmii_rxd                  (xgmii_rxd_core               ),
    .xgmii_rxc                  (xgmii_rxc_core               )
  );

 
`ifdef USE_XPHY  


  assign tx_resetdone = xphy_resetdone;
  // If no arbitration is required on the GT DRP ports then connect REQ to GNT
  // and connect other signals i <= o;
  assign drp_gnt = drp_req;
  assign drp_den_i = drp_den_o;
  assign drp_dwe_i = drp_dwe_o;
  assign drp_daddr_i = drp_daddr_o;                   
  assign drp_di_i = drp_di_o;
  assign drp_drdy_i = drp_drdy_o;
  assign drp_drpdo_i = drp_drpdo_o;
  
  ten_gig_eth_pcs_pma_ip_shared_logic_in_core ten_gig_eth_pcs_pma_inst (
      .refclk_n               (xphy_refclk_n),
      .refclk_p               (xphy_refclk_p),
      .core_clk156_out        (clk156), 
      .dclk                   (dclk),
      .txusrclk_out           (txusrclk),
      .txusrclk2_out          (txusrclk2),
      .reset                  (sys_rst),
      .areset_clk156_out      (areset_clk156),
      .gttxreset_out          (gttxreset),
      .gtrxreset_out          (gtrxreset),
      .txuserrdy_out          (txuserrdy),
      .qplllock_out           (qplllock),
      .qplloutclk_out         (qplloutclk),
      .qplloutrefclk_out      (qplloutrefclk),
      .reset_counter_done_out (reset_counter_done),
      .xgmii_txd              (xgmii_txd_core),
      .xgmii_txc              (xgmii_txc_core),
      .xgmii_rxd              (xgmii_rxd_core),
      .xgmii_rxc              (xgmii_rxc_core),
      .txp                    (xphy_txp),    
      .txn                    (xphy_txn),    
      .rxp                    (xphy_rxp),    
      .rxn                    (xphy_rxn),    
      .mdc                    (mdc),
      .mdio_in                (mdio_out),
      .mdio_out               (mdio_in),
      .mdio_tri               (),                 
      .prtad                  (prtad),
      .core_status            (xphy_status), 
      .resetdone              (xphy_resetdone), 
      .signal_detect          (signal_detect),  
      .tx_fault               (tx_fault),
      .drp_req                (drp_req),
      .drp_gnt                (drp_gnt),
      .drp_den_o              (drp_den_o),
      .drp_dwe_o              (drp_dwe_o),
      .drp_daddr_o            (drp_daddr_o),
      .drp_di_o               (drp_di_o),
      .drp_drdy_o             (drp_drdy_o),
      .drp_drpdo_o            (drp_drpdo_o),
      .drp_den_i              (drp_den_i),
      .drp_dwe_i              (drp_dwe_i),
      .drp_daddr_i            (drp_daddr_i),
      .drp_di_i               (drp_di_i),
      .drp_drdy_i             (drp_drdy_i),
      .drp_drpdo_i            (drp_drpdo_i),
      .pma_pmd_type           (3'b101),
      .tx_disable             (xphy_tx_disable),
      .sim_speedup_control    (sim_speedup_control)
    );

`else
  assign tx_resetdone = 1'b1;
  assign xphy_tx_disable = 1'b0;

`endif

endmodule
