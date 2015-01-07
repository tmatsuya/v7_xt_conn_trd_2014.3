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
//
//-----------------------------------------------------------------------------
// Project    : Virtex-7 XT Connectivity Domain Targeted Reference Design 
// File       : axis_vfifo_ctrl_ip.v
//
//-----------------------------------------------------------------------------
//
(* CORE_GENERATION_INFO = "axis_vfifo_ctrl_ip,axis_vfifo_ctrl_ip_v1_3,{x_ipproduct=Vivado2014.3,v7_xt_conn_trd=2014.3}" *)
module axis_vfifo_ctrl_ip #(
  parameter AXIS_TDATA_WIDTH          = 256,
  parameter AXI_MIG_DATA_WIDTH        = 512,
  parameter AWIDTH                    = 32,
  parameter DWIDTH                    = AXIS_TDATA_WIDTH,
  parameter NUM_PORTS                 = 1,
  parameter NUM_CONTROLLERS           = 2,
  parameter ID_WIDTH                  = 2,
  parameter CNTWIDTH                  = 32
  )(
    input [11:0]                               device_temp,
    // DDR3 ports
    output reg                                 c0_calib_done = 1'b0,
    output reg                                 c1_calib_done = 1'b0,
    input                                      axi_ic_mig_shim_rst_n, 
    input                                      clk_ref_i,
        //- SODIMM-1
    input                                      c0_sys_clk_i,   
    input                                      c1_sys_clk_i,   
    output [15:0]                              c0_ddr_addr,             
    output [2:0]                               c0_ddr_ba,               
    output                                     c0_ddr_cas_n,            
    output                                     c0_ddr_ck_p,               
    output                                     c0_ddr_ck_n,             
    output                                     c0_ddr_cke,              
    output                                     c0_ddr_cs_n,             
    output [7:0]                               c0_ddr_dm,               
    inout  [63:0]                              c0_ddr_dq,               
    inout  [7:0]                               c0_ddr_dqs_p,              
    inout  [7:0]                               c0_ddr_dqs_n,            
    output                                     c0_ddr_odt,              
    output                                     c0_ddr_ras_n,            
    output                                     c0_ddr_reset_n,          
    output                                     c0_ddr_we_n,             
    
    output                                     c0_mcb_clk, 
    output                                     c0_mcb_rst,

        //- SODIMM-2
    output [15:0]                              c1_ddr_addr,             
    output [2:0]                               c1_ddr_ba,               
    output                                     c1_ddr_cas_n,            
    output                                     c1_ddr_ck_p,               
    output                                     c1_ddr_ck_n,             
    output                                     c1_ddr_cke,              
    output                                     c1_ddr_cs_n,             
    output [7:0]                               c1_ddr_dm,               
    inout  [63:0]                              c1_ddr_dq,               
    inout  [7:0]                               c1_ddr_dqs_p,              
    inout  [7:0]                               c1_ddr_dqs_n,            
    output                                     c1_ddr_odt,              
    output                                     c1_ddr_ras_n,            
    output                                     c1_ddr_reset_n,          
    output                                     c1_ddr_we_n,             
    
   output                                      c1_mcb_clk, 
   output                                      c1_mcb_rst,
   // AXI streaming Interface for Write port 
   input  [NUM_PORTS-1:0]                      axi_str_wr_tlast,
   input  [(AXIS_TDATA_WIDTH*NUM_PORTS)-1:0]   axi_str_wr_tdata,
   input  [NUM_PORTS-1:0]                      axi_str_wr_tvalid,
   input  [(AXIS_TDATA_WIDTH/8*NUM_PORTS)-1:0] axi_str_wr_tkeep,
   output [NUM_PORTS-1:0]                      axi_str_wr_tready,
   input  [NUM_PORTS-1:0]                      axi_str_wr_aclk, 

   // AXI streaming Interface for Read port 
   output [NUM_PORTS-1:0]                      axi_str_rd_tlast,
   output [(DWIDTH*NUM_PORTS)-1:0]             axi_str_rd_tdata,
   output [NUM_PORTS-1:0]                      axi_str_rd_tvalid,
   output [(DWIDTH/8*NUM_PORTS)-1:0]           axi_str_rd_tkeep,
   input  [NUM_PORTS-1:0]                      axi_str_rd_tready,
   input  [NUM_PORTS-1:0]                      axi_str_rd_aclk, 
    
   input  [NUM_PORTS-1:0]                      wr_reset_n, 
   input  [NUM_PORTS-1:0]                      rd_reset_n, 
   output [NUM_PORTS-1:0]                      ddr3_fifo_empty,
   input                                       user_reset

);

  // ----------------
  // -- Parameters --
  // ----------------
  
  localparam  AXI_VFIFO_DATA_WIDTH    = AXIS_TDATA_WIDTH;

wire [CNTWIDTH-1:0]                   px_vf_rd_data_cnt_0;
wire [CNTWIDTH-1:0]                   px_vf_rd_data_cnt_1;
wire [CNTWIDTH-1:0]                   px_vf_rd_data_cnt_2;
wire [CNTWIDTH-1:0]                   px_vf_rd_data_cnt_3;
wire [CNTWIDTH-1:0]                   px_vf_rd_data_cnt_4;
wire [CNTWIDTH-1:0]                   px_vf_rd_data_cnt_5;
wire [CNTWIDTH-1:0]                   px_vf_rd_data_cnt_6;
wire [CNTWIDTH-1:0]                   px_vf_rd_data_cnt_7;
wire [NUM_PORTS*CNTWIDTH-1:0]         px_vf_rd_data_cnt;
wire [CNTWIDTH-1:0]                   px_vf_wr_data_cnt [NUM_PORTS-1:0];
wire [AXIS_TDATA_WIDTH-1:0]           px_str_rd_tdata [NUM_PORTS-1:0];
wire [(AXIS_TDATA_WIDTH/8)-1:0]       px_str_rd_tkeep [NUM_PORTS-1:0];
wire [AXIS_TDATA_WIDTH-1:0]           px_str_wr_tdata [NUM_PORTS-1:0];
wire [(AXIS_TDATA_WIDTH/8)-1:0]       px_str_wr_tkeep [NUM_PORTS-1:0];

wire [0:0]                            axis_wr_mux_tvalid[NUM_CONTROLLERS-1:0];
wire [0:0]                            axis_wr_mux_tready[NUM_CONTROLLERS-1:0];
wire [0:0]                            axis_wr_mux_tlast[NUM_CONTROLLERS-1:0];
wire [1:0]                            axis_wr_mux_tdest[NUM_CONTROLLERS-1:0];
wire [(AXI_MIG_DATA_WIDTH/8 -1 ):0]   axis_wr_mux_tkeep[NUM_CONTROLLERS-1:0];
wire [AXI_MIG_DATA_WIDTH-1 :0]        axis_wr_mux_tdata[NUM_CONTROLLERS-1:0];
                                      
wire [0:0]                            axis_rd_mux_tvalid[NUM_CONTROLLERS-1:0];
wire [0:0]                            axis_rd_mux_tready[NUM_CONTROLLERS-1:0];
wire [0:0]                            axis_rd_mux_tlast[NUM_CONTROLLERS-1:0];
wire [1:0]                            axis_rd_mux_tdest[NUM_CONTROLLERS-1:0];
wire [(AXI_MIG_DATA_WIDTH/8 -1):0]    axis_rd_mux_tkeep[NUM_CONTROLLERS-1:0];
wire [AXI_MIG_DATA_WIDTH-1:0]         axis_rd_mux_tdata[NUM_CONTROLLERS-1:0];
                                      

wire [NUM_CONTROLLERS-1:0]            mcb_clk;
wire [31:0]                           s_axi_awaddr[NUM_CONTROLLERS-1:0];
wire [7:0]                            s_axi_awlen[NUM_CONTROLLERS-1:0];
wire [2:0]                            s_axi_awsize[NUM_CONTROLLERS-1:0];
wire [1:0]                            s_axi_awburst[NUM_CONTROLLERS-1:0];
wire [0:0]                            s_axi_awlock[NUM_CONTROLLERS-1:0];
wire [3:0]                            s_axi_awcache[NUM_CONTROLLERS-1:0];
wire [2:0]                            s_axi_awprot[NUM_CONTROLLERS-1:0];
wire [3:0]                            s_axi_awqos[NUM_CONTROLLERS-1:0];
wire [0:0]                            s_axi_awvalid[NUM_CONTROLLERS-1:0];
wire [0:0]                            s_axi_awready[NUM_CONTROLLERS-1:0];
wire [AXI_MIG_DATA_WIDTH-1:0]         s_axi_wdata[NUM_CONTROLLERS-1:0];
wire [AXI_MIG_DATA_WIDTH/8-1:0]       s_axi_wstrb[NUM_CONTROLLERS-1:0];
wire [0:0]                            s_axi_wlast[NUM_CONTROLLERS-1:0];
wire [0:0]                            s_axi_wvalid[NUM_CONTROLLERS-1:0];
wire [0:0]                            s_axi_wready[NUM_CONTROLLERS-1:0];
wire [1:0]                            s_axi_bresp[NUM_CONTROLLERS-1:0];
wire [0:0]                            s_axi_bvalid[NUM_CONTROLLERS-1:0];
wire [0:0]                            s_axi_bready[NUM_CONTROLLERS-1:0];
wire [31:0]                           s_axi_araddr[NUM_CONTROLLERS-1:0];
wire [7:0]                            s_axi_arlen[NUM_CONTROLLERS-1:0];
wire [2:0]                            s_axi_arsize[NUM_CONTROLLERS-1:0];
wire [1:0]                            s_axi_arburst[NUM_CONTROLLERS-1:0];
wire [0:0]                            s_axi_arlock[NUM_CONTROLLERS-1:0];
wire [3:0]                            s_axi_arcache[NUM_CONTROLLERS-1:0];
wire [2:0]                            s_axi_arprot[NUM_CONTROLLERS-1:0];
wire [3:0]                            s_axi_arqos[NUM_CONTROLLERS-1:0];
wire [0:0]                            s_axi_arvalid[NUM_CONTROLLERS-1:0];
wire [0:0]                            s_axi_arready[NUM_CONTROLLERS-1:0];
wire [AXI_MIG_DATA_WIDTH-1:0]         s_axi_rdata[NUM_CONTROLLERS-1:0];
wire [1:0]                            s_axi_rresp[NUM_CONTROLLERS-1:0];
wire [0:0]                            s_axi_rlast[NUM_CONTROLLERS-1:0];
wire [0:0]                            s_axi_rvalid[NUM_CONTROLLERS-1:0];
wire [0:0]                            s_axi_rready[NUM_CONTROLLERS-1:0];
wire [ID_WIDTH-1:0]                   s_axi_awid[NUM_CONTROLLERS-1:0];
wire [ID_WIDTH-1:0]                   s_axi_arid[NUM_CONTROLLERS-1:0];
wire [ID_WIDTH-1:0]                   s_axi_bid[NUM_CONTROLLERS-1:0];
wire [ID_WIDTH-1:0]                   s_axi_rid[NUM_CONTROLLERS-1:0];

reg [NUM_PORTS-1:0]                   vfifo_mm2s_channel_full_250;
reg [NUM_PORTS-1:0]                   vfifo_mm2s_channel_full_200_d1;
reg [3:0]                             vfifo_mm2s_channel_full[NUM_CONTROLLERS-1:0];

wire [3:0]                            vfifo_s2mm_channel_full[NUM_CONTROLLERS-1:0];
reg [NUM_PORTS-1:0]                   vfifo_s2mm_channel_full_reg;

wire                                  c0_calib_done_i;
wire                                  c1_calib_done_i;
reg [NUM_CONTROLLERS-1:0]             ic_reset;
wire [NUM_PORTS-1:0]                  vfifo_idle;
wire [NUM_PORTS-1:0]                  vfifo_idle_rdclk;

wire axi_ic_mig_shim_rst_n_sync_c0;
wire axi_ic_mig_shim_rst_n_sync_c1;

  synchronizer_simple #(.DATA_WIDTH (1)) sync_to_user_clk_c0
  (
    .data_in          (axi_ic_mig_shim_rst_n),
    .new_clk          (mcb_clk[0]),
    .data_out         (axi_ic_mig_shim_rst_n_sync_c0)
  );

  synchronizer_simple #(.DATA_WIDTH (1)) sync_to_user_clk_c1
  (
    .data_in          (axi_ic_mig_shim_rst_n),
    .new_clk          (mcb_clk[1]),
    .data_out         (axi_ic_mig_shim_rst_n_sync_c1)
  );

// New

genvar m;
generate
  for (m=0; m< NUM_PORTS; m=m+1) begin : gen_sync_vfifo_idle_to_rd_clk
    synchronizer_simple #(.DATA_WIDTH (1)) sync_vfifo_idle_to_rd_clk_0
    (
     .data_in          (vfifo_idle[m]),
     .new_clk          (axi_str_rd_aclk[m]),
     .data_out         (vfifo_idle_rdclk[m])
   );
  end
endgenerate

genvar ii;
genvar jj;
genvar i;

  assign mcb_clk = {c1_mcb_clk, c0_mcb_clk};
 
  assign px_vf_rd_data_cnt_0 = px_vf_rd_data_cnt[CNTWIDTH-1:0];
  assign px_vf_rd_data_cnt_1 = px_vf_rd_data_cnt[2*CNTWIDTH-1:CNTWIDTH];
  assign px_vf_rd_data_cnt_2 = px_vf_rd_data_cnt[3*CNTWIDTH-1:2*CNTWIDTH];
  assign px_vf_rd_data_cnt_3 = px_vf_rd_data_cnt[4*CNTWIDTH-1:3*CNTWIDTH];
  assign px_vf_rd_data_cnt_4 = px_vf_rd_data_cnt[5*CNTWIDTH-1:4*CNTWIDTH];
  assign px_vf_rd_data_cnt_5 = px_vf_rd_data_cnt[6*CNTWIDTH-1:5*CNTWIDTH];
  assign px_vf_rd_data_cnt_6 = px_vf_rd_data_cnt[7*CNTWIDTH-1:6*CNTWIDTH];
  assign px_vf_rd_data_cnt_7 = px_vf_rd_data_cnt[8*CNTWIDTH-1:7*CNTWIDTH];

  always @(posedge axi_str_rd_aclk[0])
    vfifo_mm2s_channel_full_250[0]  <= 
                         (px_vf_rd_data_cnt_0 > 32'h0180) ? 1'b1 : 1'b0;

  always @(posedge axi_str_rd_aclk[1])
    vfifo_mm2s_channel_full_250[1]  <= 
                         (px_vf_rd_data_cnt_1 > 32'h00B0) ? 1'b1 : 1'b0;

  always @(posedge axi_str_rd_aclk[2])
    vfifo_mm2s_channel_full_250[2]  <= 
                         (px_vf_rd_data_cnt_2 > 32'h0180) ? 1'b1 : 1'b0;

  always @(posedge axi_str_rd_aclk[3])
    vfifo_mm2s_channel_full_250[3]  <= 
                         (px_vf_rd_data_cnt_3 > 32'h00B0) ? 1'b1 : 1'b0;

  always @(posedge axi_str_rd_aclk[4])
    vfifo_mm2s_channel_full_250[4]  <= 
                         (px_vf_rd_data_cnt_4 > 32'h0180) ? 1'b1 : 1'b0;

  always @(posedge axi_str_rd_aclk[5])
    vfifo_mm2s_channel_full_250[5]  <= 
                         (px_vf_rd_data_cnt_5 > 32'h00B0) ? 1'b1 : 1'b0;

  always @(posedge axi_str_rd_aclk[6])
    vfifo_mm2s_channel_full_250[6]  <= 
                         (px_vf_rd_data_cnt_6 > 32'h0180) ? 1'b1 : 1'b0;

  always @(posedge axi_str_rd_aclk[7])
    vfifo_mm2s_channel_full_250[7]  <= 
                         (px_vf_rd_data_cnt_7 > 32'h00B0) ? 1'b1 : 1'b0;

  always @(posedge mcb_clk[0])
  begin
    vfifo_s2mm_channel_full_reg[3:0]  <= vfifo_s2mm_channel_full[0];
  end

  always @(posedge mcb_clk[1])
  begin
    vfifo_s2mm_channel_full_reg[7:4]  <= vfifo_s2mm_channel_full[1];
  end

  always @(posedge mcb_clk[0])
  begin
    vfifo_mm2s_channel_full_200_d1[0]  <= vfifo_mm2s_channel_full_250[0];
    vfifo_mm2s_channel_full[0][0] <= vfifo_mm2s_channel_full_200_d1[0];

    vfifo_mm2s_channel_full_200_d1[1]  <= vfifo_mm2s_channel_full_250[1];
    vfifo_mm2s_channel_full[0][1] <= vfifo_mm2s_channel_full_200_d1[1];

    vfifo_mm2s_channel_full_200_d1[2]  <= vfifo_mm2s_channel_full_250[2];
    vfifo_mm2s_channel_full[0][2] <= vfifo_mm2s_channel_full_200_d1[2];

    vfifo_mm2s_channel_full_200_d1[3]  <= vfifo_mm2s_channel_full_250[3];
    vfifo_mm2s_channel_full[0][3] <= vfifo_mm2s_channel_full_200_d1[3];
  end

  always @(posedge mcb_clk[1])
  begin
    vfifo_mm2s_channel_full_200_d1[4]  <= vfifo_mm2s_channel_full_250[4];
    vfifo_mm2s_channel_full[1][0] <= vfifo_mm2s_channel_full_200_d1[4];

    vfifo_mm2s_channel_full_200_d1[5]  <= vfifo_mm2s_channel_full_250[5];
    vfifo_mm2s_channel_full[1][1] <= vfifo_mm2s_channel_full_200_d1[5];

    vfifo_mm2s_channel_full_200_d1[6]  <= vfifo_mm2s_channel_full_250[6];
    vfifo_mm2s_channel_full[1][2] <= vfifo_mm2s_channel_full_200_d1[6];

    vfifo_mm2s_channel_full_200_d1[7]  <= vfifo_mm2s_channel_full_250[7];
    vfifo_mm2s_channel_full[1][3] <= vfifo_mm2s_channel_full_200_d1[7];
  end


  always @(posedge mcb_clk[0])
    c0_calib_done <= c0_calib_done_i;

  always @(posedge mcb_clk[1])
    c1_calib_done <= c1_calib_done_i;

  always @(posedge mcb_clk[0])
  begin
    ic_reset[0] <= c0_calib_done & axi_ic_mig_shim_rst_n_sync_c0;
  end

  always @(posedge mcb_clk[1])
  begin
    ic_reset[1] <= c1_calib_done & axi_ic_mig_shim_rst_n_sync_c1;
  end

generate
  begin: assign_output
    for (ii = 0; ii<NUM_PORTS; ii=ii+1)
    begin
  
    assign axi_str_rd_tdata[((AXIS_TDATA_WIDTH*ii)+(AXIS_TDATA_WIDTH-1)) : AXIS_TDATA_WIDTH*ii] = px_str_rd_tdata[ii];
    assign axi_str_rd_tkeep[(((AXIS_TDATA_WIDTH/8)*ii)+((AXIS_TDATA_WIDTH/8)-1)) : (AXIS_TDATA_WIDTH/8)*ii] = px_str_rd_tkeep[ii];

    end
  end
endgenerate

generate
  begin: assign_input
    for (jj=0; jj<NUM_PORTS; jj=jj+1)
    begin
    assign px_str_wr_tdata[jj] = axi_str_wr_tdata[((AXIS_TDATA_WIDTH*jj)+(AXIS_TDATA_WIDTH-1)) : (AXIS_TDATA_WIDTH*jj)];
    assign px_str_wr_tkeep[jj] = axi_str_wr_tkeep[(((AXIS_TDATA_WIDTH/8)*jj)+((AXIS_TDATA_WIDTH/8)-1)) : ((AXIS_TDATA_WIDTH/8)*jj)];
    end
  end
endgenerate

  genvar nn;

  generate
  begin: axis_vf_inst
    for (nn=0; nn<NUM_CONTROLLERS; nn=nn+1)
    begin

  axis_ic_4x1_wr  axis_ic_4x1_wr_inst (
      .ACLK                 (mcb_clk[nn]),
      .ARESETN              (ic_reset[nn]),

      .S00_AXIS_ACLK        (axi_str_wr_aclk[4*nn]),
      .S00_AXIS_ARESETN     (wr_reset_n[4*nn]),
      .S00_AXIS_TVALID      (axi_str_wr_tvalid[4*nn]),
      .S00_AXIS_TREADY      (axi_str_wr_tready[4*nn]),
      .S00_AXIS_TDATA       (px_str_wr_tdata[4*nn]),
      .S00_AXIS_TKEEP       (px_str_wr_tkeep[4*nn]),
      .S00_AXIS_TLAST       (axi_str_wr_tlast[4*nn]),
      .S00_AXIS_TDEST       (4*nn),
      .S00_FIFO_DATA_COUNT  (px_vf_wr_data_cnt[4*nn]),
      .S00_ARB_REQ_SUPPRESS (vfifo_s2mm_channel_full_reg[4*nn]),
      .S00_DECODE_ERR       (),

      .S01_AXIS_ACLK        (axi_str_wr_aclk[4*nn + 1]),
      .S01_AXIS_ARESETN     (wr_reset_n[4*nn + 1]),
      .S01_AXIS_TVALID      (axi_str_wr_tvalid[4*nn + 1]),
      .S01_AXIS_TREADY      (axi_str_wr_tready[4*nn + 1]),
      .S01_AXIS_TDATA       (px_str_wr_tdata[4*nn + 1]),
      .S01_AXIS_TKEEP       (px_str_wr_tkeep[4*nn + 1]),
      .S01_AXIS_TLAST       (axi_str_wr_tlast[4*nn + 1]),
      .S01_AXIS_TDEST       (4*nn + 1),
      .S01_FIFO_DATA_COUNT  (px_vf_wr_data_cnt[4*nn + 1]),
      .S01_ARB_REQ_SUPPRESS (vfifo_s2mm_channel_full_reg[4*nn + 1]),
      .S01_DECODE_ERR       (),

      .S02_AXIS_ACLK        (axi_str_wr_aclk[4*nn + 2]),
      .S02_AXIS_ARESETN     (wr_reset_n[4*nn + 2]),
      .S02_AXIS_TVALID      (axi_str_wr_tvalid[4*nn + 2]),
      .S02_AXIS_TREADY      (axi_str_wr_tready[4*nn + 2]),
      .S02_AXIS_TDATA       (px_str_wr_tdata[4*nn + 2]),
      .S02_AXIS_TKEEP       (px_str_wr_tkeep[4*nn + 2]),
      .S02_AXIS_TLAST       (axi_str_wr_tlast[4*nn + 2]),
      .S02_AXIS_TDEST       (4*nn + 2),
      .S02_FIFO_DATA_COUNT  (px_vf_wr_data_cnt[4*nn + 2]),
      .S02_ARB_REQ_SUPPRESS (vfifo_s2mm_channel_full_reg[4*nn + 2]),
      .S02_DECODE_ERR       (),

      .S03_AXIS_ACLK        (axi_str_wr_aclk[4*nn + 3]),
      .S03_AXIS_ARESETN     (wr_reset_n[4*nn + 3]),
      .S03_AXIS_TVALID      (axi_str_wr_tvalid[4*nn + 3]),
      .S03_AXIS_TREADY      (axi_str_wr_tready[4*nn + 3]),
      .S03_AXIS_TDATA       (px_str_wr_tdata[4*nn + 3]),
      .S03_AXIS_TKEEP       (px_str_wr_tkeep[4*nn + 3]),
      .S03_AXIS_TLAST       (axi_str_wr_tlast[4*nn + 3]),
      .S03_AXIS_TDEST       (4*nn + 3),
      .S03_FIFO_DATA_COUNT  (px_vf_wr_data_cnt[4*nn + 3]),
      .S03_ARB_REQ_SUPPRESS (vfifo_s2mm_channel_full_reg[4*nn + 3]),
      .S03_DECODE_ERR       (),

      .M00_AXIS_ACLK        (mcb_clk[nn]),
      .M00_AXIS_ARESETN     (ic_reset[nn]),
      .M00_AXIS_TVALID      (axis_wr_mux_tvalid[nn]),
      .M00_AXIS_TREADY      (axis_wr_mux_tready[nn]),
      .M00_AXIS_TDATA       (axis_wr_mux_tdata[nn]),
      .M00_AXIS_TKEEP       (axis_wr_mux_tkeep[nn]),
      .M00_AXIS_TLAST       (axis_wr_mux_tlast[nn]),
      .M00_AXIS_TDEST       (axis_wr_mux_tdest[nn])
  );

  axis_ic_1x4_rd  axis_ic_1x4_rd_inst (
      .ACLK                 (mcb_clk[nn]),
      .ARESETN              (ic_reset[nn]),

      .S00_AXIS_ACLK        (mcb_clk[nn]),
      .S00_AXIS_ARESETN     (ic_reset[nn]), 
      .S00_AXIS_TVALID      (axis_rd_mux_tvalid[nn]),
      .S00_AXIS_TREADY      (axis_rd_mux_tready[nn]),
      .S00_AXIS_TDATA       (axis_rd_mux_tdata[nn]),
      .S00_AXIS_TKEEP       (axis_rd_mux_tkeep[nn]),
      .S00_AXIS_TLAST       (axis_rd_mux_tlast[nn]),
      .S00_AXIS_TDEST       (axis_rd_mux_tdest[nn]),
      .S00_DECODE_ERR       (),

      .M00_AXIS_ACLK        (axi_str_rd_aclk[4*nn]),
      .M00_AXIS_ARESETN     (rd_reset_n[4*nn]),
      .M00_AXIS_TVALID      (axi_str_rd_tvalid[4*nn]),
      .M00_AXIS_TREADY      (axi_str_rd_tready[4*nn]),
      .M00_AXIS_TDATA       (px_str_rd_tdata[4*nn]),
      .M00_AXIS_TLAST       (axi_str_rd_tlast[4*nn]),
      .M00_AXIS_TKEEP       (px_str_rd_tkeep[4*nn]),
      .M00_AXIS_TDEST       (),
      .M00_FIFO_DATA_COUNT  (px_vf_rd_data_cnt[(4*nn*CNTWIDTH)+CNTWIDTH-1:(4*nn*CNTWIDTH)]),

      .M01_AXIS_ACLK        (axi_str_rd_aclk[4*nn+1]),
      .M01_AXIS_ARESETN     (rd_reset_n[4*nn+1]),
      .M01_AXIS_TVALID      (axi_str_rd_tvalid[4*nn+1]),
      .M01_AXIS_TREADY      (axi_str_rd_tready[4*nn+1]),
      .M01_AXIS_TDATA       (px_str_rd_tdata[4*nn+1]),
      .M01_AXIS_TLAST       (axi_str_rd_tlast[4*nn+1]),
      .M01_AXIS_TKEEP       (px_str_rd_tkeep[4*nn+1]),
      .M01_AXIS_TDEST       (),
      .M01_FIFO_DATA_COUNT  (px_vf_rd_data_cnt[((4*nn+1)*CNTWIDTH)+CNTWIDTH-1:((4*nn+1)*CNTWIDTH)]),

      .M02_AXIS_ACLK        (axi_str_rd_aclk[4*nn+2]),
      .M02_AXIS_ARESETN     (rd_reset_n[4*nn+2]),
      .M02_AXIS_TVALID      (axi_str_rd_tvalid[4*nn+2]),
      .M02_AXIS_TREADY      (axi_str_rd_tready[4*nn+2]),
      .M02_AXIS_TDATA       (px_str_rd_tdata[4*nn+2]),
      .M02_AXIS_TLAST       (axi_str_rd_tlast[4*nn+2]),
      .M02_AXIS_TKEEP       (px_str_rd_tkeep[4*nn+2]),
      .M02_AXIS_TDEST       (),
      .M02_FIFO_DATA_COUNT  (px_vf_rd_data_cnt[((4*nn+2)*CNTWIDTH)+CNTWIDTH-1:((4*nn+2)*CNTWIDTH)]),

      .M03_AXIS_ACLK        (axi_str_rd_aclk[4*nn+3]),
      .M03_AXIS_ARESETN     (rd_reset_n[4*nn+3]),
      .M03_AXIS_TVALID      (axi_str_rd_tvalid[4*nn+3]),
      .M03_AXIS_TREADY      (axi_str_rd_tready[4*nn+3]),
      .M03_AXIS_TDATA       (px_str_rd_tdata[4*nn+3]),
      .M03_AXIS_TLAST       (axi_str_rd_tlast[4*nn+3]),
      .M03_AXIS_TKEEP       (px_str_rd_tkeep[4*nn+3]),
      .M03_AXIS_TDEST       (),
      .M03_FIFO_DATA_COUNT  (px_vf_rd_data_cnt[((4*nn+3)*CNTWIDTH)+CNTWIDTH-1:((4*nn+3)*CNTWIDTH)])
  );

  axi_vfifo_ctrl_ip axi_vfifo_ctrl_inst (
      .aclk (mcb_clk[nn]),
      .aresetn (ic_reset[nn]),
      .s_axis_tvalid (axis_wr_mux_tvalid[nn]),
      .s_axis_tready (axis_wr_mux_tready[nn]),
      .s_axis_tdata (axis_wr_mux_tdata[nn]),
      .s_axis_tkeep (axis_wr_mux_tkeep[nn]),
      .s_axis_tstrb ({64{1'b1}}),
      .s_axis_tlast (axis_wr_mux_tlast[nn]),
      .s_axis_tid   (2'b00),
      .s_axis_tdest (axis_wr_mux_tdest[nn]),

      .m_axis_tvalid (axis_rd_mux_tvalid[nn]),
      .m_axis_tready (axis_rd_mux_tready[nn]),
      .m_axis_tdata (axis_rd_mux_tdata[nn]),
      .m_axis_tstrb (),
      .m_axis_tkeep (axis_rd_mux_tkeep[nn]),
      .m_axis_tlast (axis_rd_mux_tlast[nn]),
      .m_axis_tid (),
      .m_axis_tdest (axis_rd_mux_tdest[nn]),

      .m_axi_awid (s_axi_awid[nn]),
      .m_axi_awaddr (s_axi_awaddr[nn]),
      .m_axi_awlen (s_axi_awlen[nn]),
      .m_axi_awsize (s_axi_awsize[nn]),
      .m_axi_awburst (s_axi_awburst[nn]),
      .m_axi_awlock (s_axi_awlock[nn]),
      .m_axi_awcache (s_axi_awcache[nn]),
      .m_axi_awprot (s_axi_awprot[nn]),
      .m_axi_awqos (s_axi_awqos[nn]),
      .m_axi_awregion (),
      .m_axi_awuser (),
      .m_axi_awvalid (s_axi_awvalid[nn]),
      .m_axi_awready (s_axi_awready[nn]),
      .m_axi_wdata (s_axi_wdata[nn]),
      .m_axi_wstrb (s_axi_wstrb[nn]),
      .m_axi_wuser (),
      .m_axi_wlast (s_axi_wlast[nn]),
      .m_axi_wvalid (s_axi_wvalid[nn]),
      .m_axi_wready (s_axi_wready[nn]),
      .m_axi_bid (s_axi_bid[nn]),
      .m_axi_bresp (s_axi_bresp[nn]),
      .m_axi_buser (1'd0),
      .m_axi_bvalid (s_axi_bvalid[nn]),
      .m_axi_bready (s_axi_bready[nn]),
      .m_axi_arid (s_axi_arid[nn]),
      .m_axi_araddr (s_axi_araddr[nn]),
      .m_axi_arlen (s_axi_arlen[nn]),
      .m_axi_arsize (s_axi_arsize[nn]),
      .m_axi_arburst (s_axi_arburst[nn]),
      .m_axi_arlock (s_axi_arlock[nn]),
      .m_axi_arcache (s_axi_arcache[nn]),
      .m_axi_arprot (s_axi_arprot[nn]),
      .m_axi_arqos (s_axi_arqos[nn]),
      .m_axi_arregion (),
      .m_axi_aruser (),
      .m_axi_arvalid (s_axi_arvalid[nn]),
      .m_axi_arready (s_axi_arready[nn]),
      .m_axi_rid (s_axi_rid[nn]),
      .m_axi_rdata (s_axi_rdata[nn]),
      .m_axi_rresp (s_axi_rresp[nn]),
      .m_axi_ruser (1'd0),
      .m_axi_rlast (s_axi_rlast[nn]),
      .m_axi_rvalid (s_axi_rvalid[nn]),
      .m_axi_rready (s_axi_rready[nn]),
      .vfifo_s2mm_channel_full (vfifo_s2mm_channel_full[nn]),
      .vfifo_mm2s_channel_full (vfifo_mm2s_channel_full[nn]),
      .vfifo_mm2s_channel_empty (),
      .vfifo_idle (vfifo_idle[(nn*4)+3:(nn*4)])
    );
  end
  end
 endgenerate 
  
  //- Figure out all empty

    localparam TIMEOUT_CYCLE  = 64;

    reg [NUM_PORTS-1:0] axis_ic_empty;
    reg [NUM_PORTS-1:0] axis_vf_empty;

    reg [6:0]   to_cntr_c0;
    reg [6:0]   to_cntr_c1;
    reg [6:0]   to_cntr_c2;
    reg [6:0]   to_cntr_c3;
    reg [6:0]   to_cntr_c4;
    reg [6:0]   to_cntr_c5;
    reg [6:0]   to_cntr_c6;
    reg [6:0]   to_cntr_c7;

    always @(posedge axi_str_rd_aclk[0])
    begin
      axis_ic_empty[0]  <= ((px_vf_rd_data_cnt_0 == 0) & ~axi_str_rd_tvalid[0]);
      axis_vf_empty[0]  <= axis_ic_empty[0] & vfifo_idle_rdclk[0];
    end

    always @(posedge axi_str_rd_aclk[1])
    begin
      axis_ic_empty[1]  <= ((px_vf_rd_data_cnt_1 == 0) & ~axi_str_rd_tvalid[1]);
      axis_vf_empty[1]  <= axis_ic_empty[1] & vfifo_idle_rdclk[1];
    end

    always @(posedge axi_str_rd_aclk[2])
    begin
      axis_ic_empty[2]  <= ((px_vf_rd_data_cnt_2 == 0) & ~axi_str_rd_tvalid[2]);
      axis_vf_empty[2]  <= axis_ic_empty[2] & vfifo_idle_rdclk[2];
    end

    always @(posedge axi_str_rd_aclk[3])
    begin
      axis_ic_empty[3]  <= ((px_vf_rd_data_cnt_3 == 0) & ~axi_str_rd_tvalid[3]);
      axis_vf_empty[3]  <= axis_ic_empty[3] & vfifo_idle_rdclk[3];
    end

    always @(posedge axi_str_rd_aclk[4])
    begin
      axis_ic_empty[4]  <= ((px_vf_rd_data_cnt_4 == 0) & ~axi_str_rd_tvalid[4]);
      axis_vf_empty[4]  <= axis_ic_empty[4] & vfifo_idle_rdclk[4];
    end

    always @(posedge axi_str_rd_aclk[5])
    begin
      axis_ic_empty[5]  <= ((px_vf_rd_data_cnt_5 == 0) & ~axi_str_rd_tvalid[5]);
      axis_vf_empty[5]  <= axis_ic_empty[5] & vfifo_idle_rdclk[5];
    end

    always @(posedge axi_str_rd_aclk[6])
    begin
      axis_ic_empty[6]  <= ((px_vf_rd_data_cnt_6 == 0) & ~axi_str_rd_tvalid[6]);
      axis_vf_empty[6]  <= axis_ic_empty[6] & vfifo_idle_rdclk[6];
    end

    always @(posedge axi_str_rd_aclk[7])
    begin
      axis_ic_empty[7]  <= ((px_vf_rd_data_cnt_7 == 0) & ~axi_str_rd_tvalid[7]);
      axis_vf_empty[7]  <= axis_ic_empty[7] & vfifo_idle_rdclk[7];
    end
    //- timeout of 64 clock cycles to make sure both interconnect and vfifo
    //are empty
    always @(posedge axi_str_rd_aclk[0])
    begin
      if (~axis_vf_empty[0])
        to_cntr_c0 <= 7'd0;
      else if (axis_vf_empty[0] & ~to_cntr_c0[6])
        to_cntr_c0 <= to_cntr_c0 + 1'b1;
    end

    always @(posedge axi_str_rd_aclk[1])
    begin
      if (~axis_vf_empty[1])
        to_cntr_c1 <= 7'd0;
      else if (axis_vf_empty[1] & ~to_cntr_c1[6])
        to_cntr_c1 <= to_cntr_c1 + 1'b1;
    end

    always @(posedge axi_str_rd_aclk[2])
    begin
      if (~axis_vf_empty[2])
        to_cntr_c2 <= 7'd0;
      else if (axis_vf_empty[2] & ~to_cntr_c2[6])
        to_cntr_c2 <= to_cntr_c2 + 1'b1;
    end

    always @(posedge axi_str_rd_aclk[3])
    begin
      if (~axis_vf_empty[3])
        to_cntr_c3 <= 7'd0;
      else if (axis_vf_empty[3] & ~to_cntr_c3[6])
        to_cntr_c3 <= to_cntr_c3 + 1'b1;
    end
    always @(posedge axi_str_rd_aclk[4])
    begin
      if (~axis_vf_empty[4])
        to_cntr_c4 <= 7'd0;
      else if (axis_vf_empty[4] & ~to_cntr_c4[6])
        to_cntr_c4 <= to_cntr_c4 + 1'b1;
    end
    always @(posedge axi_str_rd_aclk[5])
    begin
      if (~axis_vf_empty[5])
        to_cntr_c5 <= 7'd0;
      else if (axis_vf_empty[5] & ~to_cntr_c5[6])
        to_cntr_c5 <= to_cntr_c5 + 1'b1;
    end
    always @(posedge axi_str_rd_aclk[6])
    begin
      if (~axis_vf_empty[6])
        to_cntr_c6 <= 7'd0;
      else if (axis_vf_empty[6] & ~to_cntr_c6[6])
        to_cntr_c6 <= to_cntr_c6 + 1'b1;
    end
    always @(posedge axi_str_rd_aclk[7])
    begin
      if (~axis_vf_empty[7])
        to_cntr_c7 <= 7'd0;
      else if (axis_vf_empty[7] & ~to_cntr_c7[6])
        to_cntr_c7 <= to_cntr_c7 + 1'b1;
    end

      assign ddr3_fifo_empty = {
                              to_cntr_c7[6], to_cntr_c6[6],
                              to_cntr_c5[6], to_cntr_c4[6],
                              to_cntr_c3[6], to_cntr_c2[6],
                              to_cntr_c1[6], to_cntr_c0[6]
                              };




mig_axi_mm_dual mig_inst (
  .device_temp_i                            (device_temp              ), 
  .sys_rst                                  (user_reset               ),
  .c0_sys_clk_i                             (c0_sys_clk_i             ),
  .c1_sys_clk_i                             (c1_sys_clk_i             ),
  .clk_ref_i                                (clk_ref_i                ),
  .c0_ui_clk                                (c0_mcb_clk               ),
  .c0_ui_clk_sync_rst                       (c0_mcb_rst               ),
  .c0_ddr3_dq                               (c0_ddr_dq                ),
  .c0_ddr3_dqs_n                            (c0_ddr_dqs_n             ),
  .c0_ddr3_dqs_p                            (c0_ddr_dqs_p             ),
  .c0_ddr3_addr                             (c0_ddr_addr              ),
  .c0_ddr3_ba                               (c0_ddr_ba                ),
  .c0_ddr3_ras_n                            (c0_ddr_ras_n             ),
  .c0_ddr3_cas_n                            (c0_ddr_cas_n             ),
  .c0_ddr3_we_n                             (c0_ddr_we_n              ),
  .c0_ddr3_reset_n                          (c0_ddr_reset_n           ),
  .c0_ddr3_ck_p                             (c0_ddr_ck_p              ),
  .c0_ddr3_ck_n                             (c0_ddr_ck_n              ),
  .c0_ddr3_cke                              (c0_ddr_cke               ),
  .c0_ddr3_cs_n                             (c0_ddr_cs_n              ),
  .c0_ddr3_dm                               (c0_ddr_dm                ),
  .c0_ddr3_odt                              (c0_ddr_odt               ),
  .c0_aresetn                               (ic_reset[0]              ),
  .c0_app_sr_req                            (1'b0),
  .c0_app_ref_req                           (1'b0),
  .c0_app_zq_req                            (1'b0),
  .c0_app_sr_active                         (), 
  .c0_app_ref_ack                           (),
  .c0_app_zq_ack                            (),
  .c0_init_calib_complete                   (c0_calib_done_i          ),   
  .c0_s_axi_awid                            (s_axi_awid[0]            ),
  .c0_s_axi_awaddr                          (s_axi_awaddr[0]          ),
  .c0_s_axi_awlen                           (s_axi_awlen[0]           ),
  .c0_s_axi_awsize                          (s_axi_awsize[0]          ),
  .c0_s_axi_awburst                         (s_axi_awburst[0]         ),
  .c0_s_axi_awlock                          (s_axi_awlock[0]          ),
  .c0_s_axi_awcache                         (s_axi_awcache[0]         ),
  .c0_s_axi_awprot                          (s_axi_awprot[0]          ),
  .c0_s_axi_awqos                           (s_axi_awqos[0]           ),
  .c0_s_axi_awvalid                         (s_axi_awvalid[0]         ),
  .c0_s_axi_awready                         (s_axi_awready[0]         ),
  .c0_s_axi_wdata                           (s_axi_wdata[0]           ),
  .c0_s_axi_wstrb                           (s_axi_wstrb[0]           ),
  .c0_s_axi_wlast                           (s_axi_wlast[0]           ),
  .c0_s_axi_wvalid                          (s_axi_wvalid[0]          ),
  .c0_s_axi_wready                          (s_axi_wready[0]          ),
  .c0_s_axi_bid                             (s_axi_bid[0]             ),
  .c0_s_axi_bresp                           (s_axi_bresp[0]           ),
  .c0_s_axi_bvalid                          (s_axi_bvalid[0]          ),
  .c0_s_axi_bready                          (s_axi_bready[0]          ),
  .c0_s_axi_arid                            (s_axi_arid[0]            ),
  .c0_s_axi_araddr                          (s_axi_araddr[0]          ),
  .c0_s_axi_arlen                           (s_axi_arlen[0]           ),
  .c0_s_axi_arsize                          (s_axi_arsize[0]          ),
  .c0_s_axi_arburst                         (s_axi_arburst[0]         ),
  .c0_s_axi_arlock                          (s_axi_arlock[0]          ),
  .c0_s_axi_arcache                         (s_axi_arcache[0]         ),
  .c0_s_axi_arprot                          (s_axi_arprot[0]          ),
  .c0_s_axi_arqos                           (s_axi_arqos[0]           ),
  .c0_s_axi_arvalid                         (s_axi_arvalid[0]         ),
  .c0_s_axi_arready                         (s_axi_arready[0]         ),
  .c0_s_axi_rid                             (s_axi_rid[0]             ),
  .c0_s_axi_rdata                           (s_axi_rdata[0]           ),
  .c0_s_axi_rresp                           (s_axi_rresp[0]           ),
  .c0_s_axi_rlast                           (s_axi_rlast[0]           ),
  .c0_s_axi_rvalid                          (s_axi_rvalid[0]          ),
  .c0_s_axi_rready                          (s_axi_rready[0]          ),

  .c1_ui_clk                                (c1_mcb_clk               ),
  .c1_ui_clk_sync_rst                       (c1_mcb_rst               ),
  .c1_ddr3_dq                               (c1_ddr_dq                ),
  .c1_ddr3_dqs_n                            (c1_ddr_dqs_n             ),
  .c1_ddr3_dqs_p                            (c1_ddr_dqs_p             ),
  .c1_ddr3_addr                             (c1_ddr_addr              ),
  .c1_ddr3_ba                               (c1_ddr_ba                ),
  .c1_ddr3_ras_n                            (c1_ddr_ras_n             ),
  .c1_ddr3_cas_n                            (c1_ddr_cas_n             ),
  .c1_ddr3_we_n                             (c1_ddr_we_n              ),
  .c1_ddr3_reset_n                          (c1_ddr_reset_n           ),
  .c1_ddr3_ck_p                             (c1_ddr_ck_p              ),
  .c1_ddr3_ck_n                             (c1_ddr_ck_n              ),
  .c1_ddr3_cke                              (c1_ddr_cke               ),
  .c1_ddr3_cs_n                             (c1_ddr_cs_n              ),
  .c1_ddr3_dm                               (c1_ddr_dm                ),
  .c1_ddr3_odt                              (c1_ddr_odt               ),
  .c1_aresetn                               (ic_reset[1]              ),
  .c1_app_sr_req                            (1'b0),
  .c1_app_ref_req                           (1'b0),
  .c1_app_zq_req                            (1'b0),
  .c1_app_sr_active                         (), 
  .c1_app_ref_ack                           (),
  .c1_app_zq_ack                            (),
  .c1_init_calib_complete                   (c1_calib_done_i          ),   
  .c1_s_axi_awid                            (s_axi_awid[1]            ),
  .c1_s_axi_awaddr                          (s_axi_awaddr[1]          ),
  .c1_s_axi_awlen                           (s_axi_awlen[1]           ),
  .c1_s_axi_awsize                          (s_axi_awsize[1]          ),
  .c1_s_axi_awburst                         (s_axi_awburst[1]         ),
  .c1_s_axi_awlock                          (s_axi_awlock[1]          ),
  .c1_s_axi_awcache                         (s_axi_awcache[1]         ),
  .c1_s_axi_awprot                          (s_axi_awprot[1]          ),
  .c1_s_axi_awqos                           (s_axi_awqos[1]           ),
  .c1_s_axi_awvalid                         (s_axi_awvalid[1]         ),
  .c1_s_axi_awready                         (s_axi_awready[1]         ),
  .c1_s_axi_wdata                           (s_axi_wdata[1]           ),
  .c1_s_axi_wstrb                           (s_axi_wstrb[1]           ),
  .c1_s_axi_wlast                           (s_axi_wlast[1]           ),
  .c1_s_axi_wvalid                          (s_axi_wvalid[1]          ),
  .c1_s_axi_wready                          (s_axi_wready[1]          ),
  .c1_s_axi_bid                             (s_axi_bid[1]             ),
  .c1_s_axi_bresp                           (s_axi_bresp[1]           ),
  .c1_s_axi_bvalid                          (s_axi_bvalid[1]          ),
  .c1_s_axi_bready                          (s_axi_bready[1]          ),
  .c1_s_axi_arid                            (s_axi_arid[1]            ),
  .c1_s_axi_araddr                          (s_axi_araddr[1]          ),
  .c1_s_axi_arlen                           (s_axi_arlen[1]           ),
  .c1_s_axi_arsize                          (s_axi_arsize[1]          ),
  .c1_s_axi_arburst                         (s_axi_arburst[1]         ),
  .c1_s_axi_arlock                          (s_axi_arlock[1]          ),
  .c1_s_axi_arcache                         (s_axi_arcache[1]         ),
  .c1_s_axi_arprot                          (s_axi_arprot[1]          ),
  .c1_s_axi_arqos                           (s_axi_arqos[1]           ),
  .c1_s_axi_arvalid                         (s_axi_arvalid[1]         ),
  .c1_s_axi_arready                         (s_axi_arready[1]         ),
  .c1_s_axi_rid                             (s_axi_rid[1]             ),
  .c1_s_axi_rdata                           (s_axi_rdata[1]           ),
  .c1_s_axi_rresp                           (s_axi_rresp[1]           ),
  .c1_s_axi_rlast                           (s_axi_rlast[1]           ),
  .c1_s_axi_rvalid                          (s_axi_rvalid[1]          ),
  .c1_s_axi_rready                          (s_axi_rready[1]          )
); 

endmodule
