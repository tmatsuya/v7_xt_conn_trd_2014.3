// -------------------------------------------------------------------------
//
//  PROJECT: DMA Back End
//  COMPANY: Northwest Logic, Inc.
//
// ------------------------- CONFIDENTIAL ----------------------------------
//
//                 Copyright 2010 by Northwest Logic, Inc.
//
//  All rights reserved.  No part of this source code may be reproduced or
//  transmitted in any form or by any means, electronic or mechanical,
//  including photocopying, recording, or any information storage and
//  retrieval system, without permission in writing from Northest Logic, Inc.
//
//  Further, no use of this source code is permitted in any form or means
//  without a valid, written license agreement with Northwest Logic, Inc.
//
//                         Northwest Logic, Inc.
//                  1100 NW Compton Drive, Suite 100
//                      Beaverton, OR 97006, USA
//
//                       Ph.  +1 503 533 5800
//                       Fax. +1 503 533 5900
//                          www.nwlogic.com
//
// -------------------------------------------------------------------------

// -------------------------------------------------------------------------
//
// This module is a top level reference design file containing:
//   * Xilinx V7 Hard PCI Express Core
//   * Wrapper logic to interface to NW Logic DMA Back-End
//
// -------------------------------------------------------------------------

`timescale 1ns / 1ps



// -----------------------
// -- Module Definition --
// -----------------------
(* CORE_GENERATION_INFO = "packet_dma_axi,packet_dma_axi_v1_3,{x_ipproduct=Vivado2014.3,v7_xt_conn_trd=2014.3}" *)
module packet_dma_axi # (

    parameter  CORE_BE_WIDTH            = 32,
    parameter  KEEP_WIDTH               = 32,
    parameter  CORE_DATA_WIDTH          = 256
)
(

    input                               user_reset,
    input                               user_clk,
    input                               user_lnk_up,

    input                  [7:0]        clk_period_in_ns,
    input                               user_interrupt,

    output                              s_axis_rq_tlast,
    output [CORE_DATA_WIDTH-1:0]        s_axis_rq_tdata,
    output                [59:0]        s_axis_rq_tuser,
    output      [KEEP_WIDTH-1:0]        s_axis_rq_tkeep,
    input                  [3:0]        s_axis_rq_tready,
    output                              s_axis_rq_tvalid,
                                        
    input  [CORE_DATA_WIDTH-1:0]        m_axis_rc_tdata,
    input                 [74:0]        m_axis_rc_tuser,
    input                               m_axis_rc_tlast,
    input       [KEEP_WIDTH-1:0]        m_axis_rc_tkeep,
    input                               m_axis_rc_tvalid,
    output                              m_axis_rc_tready,
                                        
    input  [CORE_DATA_WIDTH-1:0]        m_axis_cq_tdata,
    input                 [84:0]        m_axis_cq_tuser,
    input                               m_axis_cq_tlast,
    input       [KEEP_WIDTH-1:0]        m_axis_cq_tkeep,
    input                               m_axis_cq_tvalid,
    output                              m_axis_cq_tready,
                                        
    output [CORE_DATA_WIDTH-1:0]        s_axis_cc_tdata,
    output                [32:0]        s_axis_cc_tuser,
    output                              s_axis_cc_tlast,
    output      [KEEP_WIDTH-1:0]        s_axis_cc_tkeep,
    output                              s_axis_cc_tvalid,
    input                               s_axis_cc_tready,
    


    input  [11:0]                       fc_cpld,
    input  [7:0]                        fc_cplh,
    input  [11:0]                       fc_npd,
    input  [7:0]                        fc_nph,
    input  [11:0]                       fc_pd,
    input  [7:0]                        fc_ph,
    input  [2:0]                        fc_sel,

    
    // PCIe Configuration Interface 
    output                              cfg_err_cor,
    output                              cfg_err_ur,
    output                              cfg_err_ecrc,
    output reg                          cfg_err_cpl_timeout,
    output                              cfg_err_cpl_abort,
    output reg                          cfg_err_cpl_unexpect,
    output reg                          cfg_err_posted,
    output                              cfg_err_locked,
    output [47:0]                       cfg_err_tlp_cpl_header,
    
    output [3:0]                        cfg_interrupt_int,
    input                               cfg_interrupt_sent,   
    input                               cfg_interrupt_msi_sent,
    output                              cfg_interrupt_msi_int,
    input  [1:0]                        cfg_interrupt_msi_enable,
    input  [1:0]                        cfg_interrupt_msix_enable,
    input                               cfg_interrupt_msixfm,

    output reg                          cfg_turnoff_ok,
    input                               cfg_to_turnoff,
    output reg                          cfg_trn_pending,
    output                              cfg_pm_wake,

    input  [7:0]                        cfg_function_status,
    input                           [2:0]    cfg_max_payload,
    input                           [2:0]    cfg_max_read_req,

  // DMA BE - C2S Engine #0
    input                               c2s0_aclk,
    input                               c2s0_tlast,
    input   [CORE_DATA_WIDTH-1:0]       c2s0_tdata,
    input   [CORE_BE_WIDTH-1:0]         c2s0_tkeep,
    input                               c2s0_tvalid,
    output                              c2s0_tready,
    input   [63:0]                      c2s0_tuser,
    output                              c2s0_areset_n,

  //DMA BE - C2S Engine #1
    input                               c2s1_aclk,
    input                               c2s1_tlast,
    input   [CORE_DATA_WIDTH-1:0]       c2s1_tdata,
    input   [CORE_BE_WIDTH-1:0]         c2s1_tkeep,
    input                               c2s1_tvalid,
    output                              c2s1_tready,
    input   [63:0]                      c2s1_tuser,
    output                              c2s1_areset_n,

  //DMA BE - C2S Engine #2
    input                               c2s2_aclk,
    input                               c2s2_tlast,
    input   [CORE_DATA_WIDTH-1:0]       c2s2_tdata,
    input   [CORE_BE_WIDTH-1:0]         c2s2_tkeep,
    input                               c2s2_tvalid,
    output                              c2s2_tready,
    input   [63:0]                      c2s2_tuser,
    output                              c2s2_areset_n,

  //DMA BE - C2S Engine #3
    input                               c2s3_aclk,
    input                               c2s3_tlast,
    input   [CORE_DATA_WIDTH-1:0]       c2s3_tdata,
    input   [CORE_BE_WIDTH-1:0]         c2s3_tkeep,
    input                               c2s3_tvalid,
    output                              c2s3_tready,
    input   [63:0]                      c2s3_tuser,
    output                              c2s3_areset_n,

  //DMA BE - S2C Engine #0
    input                               s2c0_aclk,
    output                              s2c0_tlast,
    output  [CORE_DATA_WIDTH-1:0]       s2c0_tdata,
    output  [CORE_BE_WIDTH-1:0]         s2c0_tkeep,
    output                              s2c0_tvalid,
    input                               s2c0_tready,
    output   [63:0]                     s2c0_tuser,
    output                              s2c0_areset_n,


  //DMA BE - S2C Engine #1
    input                               s2c1_aclk,
    output                              s2c1_tlast,
    output  [CORE_DATA_WIDTH-1:0]       s2c1_tdata,
    output  [CORE_BE_WIDTH-1:0]         s2c1_tkeep,
    output                              s2c1_tvalid,
    input                               s2c1_tready,
    output   [63:0]                     s2c1_tuser,
    output                              s2c1_areset_n,

  //DMA BE - S2C Engine #2
    input                               s2c2_aclk,
    output                              s2c2_tlast,
    output  [CORE_DATA_WIDTH-1:0]       s2c2_tdata,
    output  [CORE_BE_WIDTH-1:0]         s2c2_tkeep,
    output                              s2c2_tvalid,
    input                               s2c2_tready,
    output   [63:0]                     s2c2_tuser,
    output                              s2c2_areset_n,

  //DMA BE - S2C Engine #3
    input                               s2c3_aclk,
    output                              s2c3_tlast,
    output  [CORE_DATA_WIDTH-1:0]       s2c3_tdata,
    output  [CORE_BE_WIDTH-1:0]         s2c3_tkeep,
    output                              s2c3_tvalid,
    input                               s2c3_tready,
    output   [63:0]                     s2c3_tuser,
    output                              s2c3_areset_n,
    
  //DMA BE - AXI target interface 
    input                               t_areset_n,
    input                               t_aclk,
    output                              t_awvalid,
    input                               t_awready,
    output  [31:0]                      t_awaddr,
    output  [3:0]                       t_awlen,
    output  [2:0]                       t_awregion,
    output  [2:0]                       t_awsize,

    output                              t_wvalid,
    input                               t_wready,
    output  [CORE_DATA_WIDTH-1:0]       t_wdata,
    output  [CORE_BE_WIDTH-1:0]         t_wstrb,
    output                              t_wlast,

    input                               t_bvalid,
    output                              t_bready,
    input   [1:0]                       t_bresp,

    output                              t_arvalid,
    input                               t_arready,
    output  [31:0]                      t_araddr,
    output  [3:0]                       t_arlen,
    output  [2:0]                       t_arregion,
    output  [2:0]                       t_arsize,

    input                               t_rvalid,
    output                              t_rready,
    input   [CORE_DATA_WIDTH-1:0]       t_rdata,
    input   [1:0]                       t_rresp,
    input                               t_rlast
);


// -------------------
// -- Local Signals --
// -------------------

  localparam  NUM_S2C = 4;
  localparam  NUM_C2S = 4;

wire                                reset;
reg                                 d_user_rst_n;
reg                                 user_rst_n;

wire                                mgmt_ch_infinite;
wire                                mgmt_cd_infinite;


wire    [(NUM_S2C*64)-1:0]          s2c_cfg_constants;
wire    [(NUM_C2S*64)-1:0]          c2s_cfg_constants;

// Configuration Interrupts
wire    [31:0]                      mgmt_interrupt;
reg                                 mgmt_msix_fm;

reg     [2:0]                       mgmt_max_payload_size;
reg     [2:0]                       mgmt_max_rd_req_size;
reg     [15:0]                      mgmt_cfg_id;

wire    [7:0]                       mgmt_ch_credits;
wire    [11:0]                      mgmt_cd_credits;

reg                                 mgmt_cpl_timeout_disable;
reg     [3:0]                       mgmt_cpl_timeout_value;
wire    [7:0]                       mgmt_clk_period_in_ns;

wire                                err_cpl_to_closed_tag;
wire                                err_cpl_timeout;
wire                                cpl_tag_active;

reg                                 mgmt_mst_en;
reg                                 mgmt_msi_en;
reg                                 mgmt_msix_en;

wire [31:0]                         mgmt_pcie_version;
wire [31:0]                         mgmt_user_version;
wire                                cfg_interrupt;

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// from NWL DMA - xil_pcie_wrapper

// Hold core in reset whenever hard core reset is asserted or link is down
assign reset = user_reset | ~user_lnk_up | (fc_sel != 3'b000);

// Synchronize reset to user_clk
always @(posedge user_clk or posedge reset)
begin
    if (reset == 1'b1)
    begin
        d_user_rst_n  <= 1'b0;
        user_rst_n    <= 1'b0;
    end
    else
    begin
        d_user_rst_n  <= 1'b1;
        user_rst_n    <= d_user_rst_n;
    end
end


assign mgmt_pcie_version = 32'h10EE_0101;
assign mgmt_user_version = 32'h0000_0000;

// ------------
// Flow Control

// Set to report Receive Buffer Available Space

assign mgmt_ch_infinite = 1'b1;
assign mgmt_cd_infinite = 1'b1;

assign mgmt_ch_credits  = fc_cplh;
assign mgmt_cd_credits  = fc_cpld;


// ------------------------
// Configuration Read/Write

// Ports not used
assign cfg_mgmt_di                       = 32'h0;
assign cfg_mgmt_byte_en                  = 4'h0;
assign cfg_mgmt_dwaddr                   = 10'h0;
assign cfg_mgmt_wr_en                    = 1'b0;
assign cfg_mgmt_rd_en                    = 1'b0;


// --------------------
// Configuration Errors

always @(posedge user_clk or negedge user_rst_n)
begin
    if (user_rst_n == 1'b0)
    begin
        cfg_err_cpl_timeout         <= 1'b0;
        cfg_err_cpl_unexpect        <= 1'b0;
        cfg_err_posted              <= 1'b0;
    end
    else
    begin
        // Assert cfg_err_posted so message response rather than completion response is used
        cfg_err_cpl_timeout         <=                          err_cpl_timeout;
        cfg_err_cpl_unexpect        <=  err_cpl_to_closed_tag;
        cfg_err_posted              <= (err_cpl_to_closed_tag | err_cpl_timeout);
    end
end

assign cfg_err_cor                  = 1'b0;
assign cfg_err_ur                   = 1'b0;
assign cfg_err_ecrc                 = 1'b0;
assign cfg_err_cpl_abort            = 1'b0;
assign cfg_err_locked               = 1'b0;

// Header for completion error response (unused)
//   If used, the following info should be put here from
//   taken from the error non-posted TLP
//   [47:41] Lower Address
//   [40:29] Byte Count
//   [28:26] TC
//   [25:24] Attr
//   [23:8] Requester ID
//   [7:0] Tag
assign cfg_err_tlp_cpl_header       = 48'h0;


// --------------------
// Configuration Status

  assign cfg_interrupt_int = {3'b000, cfg_interrupt};

always @(posedge user_clk or negedge user_rst_n)
begin
    if (user_rst_n == 1'b0)
    begin
        cfg_turnoff_ok              <= 1'b0;
        cfg_trn_pending             <= 1'b0;

        mgmt_mst_en                 <= 1'b0;
        mgmt_msi_en                 <= 1'b0;
        mgmt_msix_en                <= 1'b0;
        mgmt_msix_fm                <= 1'b0;
        mgmt_max_payload_size       <= 3'b000;
        mgmt_max_rd_req_size        <= 3'b000;
        mgmt_cfg_id                 <= 16'h0;

        mgmt_cpl_timeout_disable    <= 1'b0;
        mgmt_cpl_timeout_value      <= 4'h0;
    end
    else
    begin
        if (cfg_to_turnoff & ~cfg_trn_pending) // Turn off request and no completions pending
            cfg_turnoff_ok <= 1'b1;
        else
            cfg_turnoff_ok <= 1'b0;

        cfg_trn_pending             <= cpl_tag_active;

        mgmt_mst_en                 <= cfg_function_status[2];  // Bus Master Enable
        mgmt_msi_en                 <= cfg_interrupt_msi_enable[0];
        mgmt_msix_en                <= cfg_interrupt_msix_enable[0];
        mgmt_msix_fm                <= cfg_interrupt_msixfm;
        mgmt_max_payload_size       <= cfg_max_payload; 
        mgmt_max_rd_req_size        <= cfg_max_read_req;
        mgmt_cfg_id                 <= 16'h0; 

        mgmt_cpl_timeout_disable    <= 1'b0;  
        mgmt_cpl_timeout_value      <= 4'h0;  
    end
end

assign mgmt_clk_period_in_ns = clk_period_in_ns;  // Back-End is 250MHz for 5G and 2.5G

assign cfg_pm_wake                  = 1'b0;

assign mgmt_interrupt = 32'd0;


genvar i;

generate for (i=0; i<NUM_C2S; i=i+1)
begin : gen_c2s_constants
    // Configure C2S DMA Engine(s)
    assign c2s_cfg_constants[          (64*i)+ 0] = 1'b0;        // Reserved; was use sequence/continue functionality
    assign c2s_cfg_constants[          (64*i)+ 1] = 1'b1;        // 1 == Support 32/64-bit system addresses; 0 == 32-bit address support only
    assign c2s_cfg_constants[          (64*i)+ 2] = 1'b1;        // 1 == Support 32/64-bit descriptor pointer system addresses; 0 == 32-bit address support only (Block DMA Only)
    assign c2s_cfg_constants[          (64*i)+ 3] = 1'b0;        // 1 == Enable increased command overlapping (Block DMA Only); 0 == Don't overlap
    assign c2s_cfg_constants[(64*i)+ 7:(64*i)+ 4] = 4'h0;        // Reserved
    assign c2s_cfg_constants[(64*i)+14:(64*i)+ 8] = 7'd32;       // Address space implemented on the card for this engine == 2^DMA_DEST_ADDR_WIDTH (2^32 = 4GB)
    assign c2s_cfg_constants[          (64*i)+15] = 1'b0;        // Reserved
    assign c2s_cfg_constants[(64*i)+21:(64*i)+16] = 6'h0;        // Implemented byte count width; 0 selects maximum supported DMA engine value
    assign c2s_cfg_constants[(64*i)+23:(64*i)+22] = 2'h0;        // Reserved
    assign c2s_cfg_constants[(64*i)+27:(64*i)+24] = 4'h0;        // Implemented channel width; 0 == only 1 channel
    assign c2s_cfg_constants[(64*i)+31:(64*i)+28] = 4'h0;        // Reserved
    assign c2s_cfg_constants[(64*i)+38:(64*i)+32] = 7'd64;       // Implemented user status width; 64 == max value
    assign c2s_cfg_constants[          (64*i)+39] = 1'b0;        // Reserved
    assign c2s_cfg_constants[(64*i)+46:(64*i)+40] = 7'h0;        // Implemented user control width; 0 == not used; not supported for C2S Engines
    assign c2s_cfg_constants[          (64*i)+47] = 1'b0;        // Set to disable descriptor update writes
    assign c2s_cfg_constants[(64*i)+63:(64*i)+48] = 16'h0;       // Reserved
end
endgenerate

generate for (i=0; i<NUM_S2C; i=i+1)
begin : gen_s2c_constants
    // Configure S2C DMA Engine(s)
    assign s2c_cfg_constants[          (64*i)+ 0] = 1'b0;        // Reserved; was use sequence/continue functionality
    assign s2c_cfg_constants[          (64*i)+ 1] = 1'b1;        // 1 == Support 32/64-bit system addresses; 0 == 32-bit address support only
    assign s2c_cfg_constants[          (64*i)+ 2] = 1'b1;        // 1 == Support 32/64-bit descriptor pointer system addresses; 0 == 32-bit address support only (Block DMA Only)
    assign s2c_cfg_constants[          (64*i)+ 3] = 1'b0;        // 1 == Enable increased command overlapping (Block DMA Only); 0 == Don't overlap
    assign s2c_cfg_constants[(64*i)+ 7:(64*i)+ 4] = 4'h0;        // Reserved
    assign s2c_cfg_constants[(64*i)+14:(64*i)+ 8] = 7'd32;       // Address space implemented on the card for this engine == 2^DMA_DEST_ADDR_WIDTH (2^32 = 4GB)
    assign s2c_cfg_constants[          (64*i)+15] = 1'b0;        // Reserved
    assign s2c_cfg_constants[(64*i)+21:(64*i)+16] = 6'h0;        // Implemented byte count width; 0 selects maximum supported DMA engine value
    assign s2c_cfg_constants[(64*i)+23:(64*i)+22] = 2'h0;        // Reserved
    assign s2c_cfg_constants[(64*i)+27:(64*i)+24] = 4'h0;        // Implemented channel width; 0 == only 1 channel
    assign s2c_cfg_constants[(64*i)+31:(64*i)+28] = 4'h0;        // Reserved
    assign s2c_cfg_constants[(64*i)+38:(64*i)+32] = 7'h0;        // Implemented user status width; 0 == not used
    assign s2c_cfg_constants[          (64*i)+39] = 1'b0;        // Reserved
    assign s2c_cfg_constants[(64*i)+46:(64*i)+40] = 7'd64;       // Implemented user control width; 64 == maximum width
    assign s2c_cfg_constants[          (64*i)+47] = 1'b0;        // Set to disable descriptor update writes
    assign s2c_cfg_constants[(64*i)+63:(64*i)+48] = 16'h0;       // Reserved
end
endgenerate


// ------------
// DMA Back End

dma_back_end_axi dma_back_end_axi (

    .rst_n                          (user_rst_n ),
    .clk                            (user_clk   ),
    .testmode                       (1'b0       ),        
  
    .s_axis_rq_tlast                ( s_axis_rq_tlast ),
    .s_axis_rq_tdata                ( s_axis_rq_tdata ),
    .s_axis_rq_tuser                ( s_axis_rq_tuser ),
    .s_axis_rq_tkeep                ( s_axis_rq_tkeep ),
    .s_axis_rq_tready               ( s_axis_rq_tready[0] ),
    .s_axis_rq_tvalid               ( s_axis_rq_tvalid ),

    .m_axis_rc_tdata                ( m_axis_rc_tdata ),
    .m_axis_rc_tuser                ( m_axis_rc_tuser ),
    .m_axis_rc_tlast                ( m_axis_rc_tlast ),
    .m_axis_rc_tkeep                ( m_axis_rc_tkeep ),
    .m_axis_rc_tvalid               ( m_axis_rc_tvalid ),
    .m_axis_rc_tready               ( m_axis_rc_tready ),

    .m_axis_cq_tdata                ( m_axis_cq_tdata ),
    .m_axis_cq_tuser                ( m_axis_cq_tuser ),
    .m_axis_cq_tlast                ( m_axis_cq_tlast ),
    .m_axis_cq_tkeep                ( m_axis_cq_tkeep ),
    .m_axis_cq_tvalid               ( m_axis_cq_tvalid ),
    .m_axis_cq_tready               ( m_axis_cq_tready ),

    .s_axis_cc_tdata                ( s_axis_cc_tdata ),
    .s_axis_cc_tuser                ( s_axis_cc_tuser ),
    .s_axis_cc_tlast                ( s_axis_cc_tlast ),
    .s_axis_cc_tkeep                ( s_axis_cc_tkeep ),
    .s_axis_cc_tvalid               ( s_axis_cc_tvalid ),
    .s_axis_cc_tready               ( s_axis_cc_tready ),

    .mgmt_mst_en                    (mgmt_mst_en  ),
    .mgmt_msi_en                    (mgmt_msi_en  ),
    .mgmt_msix_en                   (mgmt_msix_en ),

    .mgmt_msix_table_offset         (32'h6000 ),
    .mgmt_msix_pba_offset           (32'h7000 ),
    .mgmt_msix_function_mask        (mgmt_msix_fm ),
    
    .mgmt_max_payload_size          (mgmt_max_payload_size ),
    .mgmt_max_rd_req_size           (mgmt_max_rd_req_size  ),
    .mgmt_clk_period_in_ns          (mgmt_clk_period_in_ns ),
    .mgmt_pcie_version              (mgmt_pcie_version     ),  // I
    .mgmt_user_version              (mgmt_user_version     ),  // I
    .mgmt_cfg_id                    (mgmt_cfg_id           ),
    .mgmt_interrupt                 (mgmt_interrupt        ),
    .user_interrupt                 (user_interrupt        ),

    .cfg_interrupt_int              (cfg_interrupt         ),
    .cfg_interrupt_sent             (cfg_interrupt_sent    ),
    .cfg_interrupt_msi_int          (cfg_interrupt_msi_int ),
    .cfg_interrupt_msi_sent         (cfg_interrupt_msi_sent),


    .mgmt_ch_infinite               (mgmt_ch_infinite ),
    .mgmt_cd_infinite               (mgmt_cd_infinite ),
    .mgmt_ch_credits                (mgmt_ch_credits  ),
    .mgmt_cd_credits                (mgmt_cd_credits  ),

    .mgmt_cpl_timeout_disable       (mgmt_cpl_timeout_disable ),
    .mgmt_cpl_timeout_value         (mgmt_cpl_timeout_value   ),

    .err_pkt_poison                 (                      ),
    .err_pkt_ur                     (                      ),
    .err_cpl_to_closed_tag          (err_cpl_to_closed_tag ),
    .err_cpl_timeout                (err_cpl_timeout       ),
    .err_pkt_header                 (                      ),
    .cpl_tag_active                 (cpl_tag_active        ),
    
    .m_aclk                         (user_clk),
    .m_areset_n                     (~user_reset),
    .m_awvalid                      (1'b0),
    .m_awready                      (),
    .m_awaddr                       (16'd0),
    .m_wvalid                       (1'b0),
    .m_wready                       (m_wready),
    .m_wdata                        ('d0),
    .m_wstrb                        ('d0),
    .m_bvalid                       (),
    .m_bready                       (1'b0),
    .m_bresp                        (),
    .m_arvalid                      (1'b0),
    .m_arready                      (),
    .m_araddr                       ('d0),
    .m_rvalid                       (),
    .m_rready                       (1'b0),
    .m_rdata                        (),
    .m_rresp                        (),
    .m_interrupt                    (), 
  
    .c2s_cfg_constants              (c2s_cfg_constants ),

    .c2s_areset_n                   ({c2s3_areset_n, c2s2_areset_n, c2s1_areset_n, c2s0_areset_n}),
    .c2s_aclk                       ({c2s2_aclk, c2s2_aclk, c2s1_aclk,c2s0_aclk}               ),
    .c2s_fifo_addr_n                ({NUM_C2S{1'b1}}),
    .c2s_arvalid                    (),
    .c2s_arready                    ({NUM_C2S{1'b1}}),
    .c2s_araddr                     (),
    .c2s_arlen                      (),
    .c2s_arsize                     (),
    .c2s_rvalid                     ({c2s3_tvalid, c2s2_tvalid, c2s1_tvalid, c2s0_tvalid}),
    .c2s_rready                     ({c2s3_tready, c2s2_tready, c2s1_tready, c2s0_tready}),
    .c2s_rdata                      ({c2s3_tdata, c2s2_tdata, c2s1_tdata, c2s0_tdata}),
    .c2s_rresp                      ({NUM_C2S{2'd0}}),
    .c2s_rlast                      ({c2s3_tlast, c2s2_tlast, c2s1_tlast, c2s0_tlast}),
    .c2s_ruserstatus                ({c2s3_tuser, c2s2_tuser, c2s1_tuser, c2s0_tuser}),
    .c2s_ruserstrb                  ({c2s3_tkeep, c2s2_tkeep, c2s1_tkeep, c2s0_tkeep}),  
    
    .s2c_cfg_constants              (s2c_cfg_constants             ),
    .s2c_areset_n                   ({s2c3_areset_n, s2c2_areset_n, s2c1_areset_n,s2c0_areset_n} ), 
    .s2c_aclk                       ({s2c3_aclk, s2c2_aclk, s2c1_aclk, s2c0_aclk}       ),
    .s2c_fifo_addr_n                ({NUM_S2C{1'b1}}),
    .s2c_awvalid                    (),
    .s2c_awready                    ({NUM_S2C{1'b1}}),
    .s2c_awaddr                     (), 
    .s2c_awlen                      (),
    .s2c_awusereop                  (),
    .s2c_awsize                     (),
    .s2c_wvalid                     ({s2c3_tvalid, s2c2_tvalid, s2c1_tvalid, s2c0_tvalid}),
    .s2c_wready                     ({s2c3_tready, s2c2_tready, s2c1_tready, s2c0_tready}),
    .s2c_wdata                      ({s2c3_tdata, s2c2_tdata, s2c1_tdata, s2c0_tdata}),
    .s2c_wstrb                      ({s2c3_tkeep, s2c2_tkeep, s2c1_tkeep, s2c0_tkeep}),
    .s2c_wlast                      (),
    .s2c_wusereop                   ({s2c3_tlast, s2c2_tlast, s2c1_tlast, s2c0_tlast}),
    .s2c_wusercontrol               ({s2c3_tuser, s2c2_tuser, s2c1_tuser, s2c0_tuser}),
    .s2c_bvalid                     ({NUM_S2C{1'b0}}),
    .s2c_bready                     (),
    .s2c_bresp                      ({NUM_S2C{2'd0}}),
    
    .t_areset_n                     (t_areset_n                     ),
    .t_aclk                         (t_aclk                         ),

    .t_awvalid                      (t_awvalid                      ),
    .t_awready                      (t_awready                      ),
    .t_awregion                     (t_awregion                     ),
    .t_awaddr                       (t_awaddr                       ),
    .t_awlen                        (t_awlen                        ),
    .t_awsize                       (t_awsize                       ),

    .t_wvalid                       (t_wvalid                       ),
    .t_wready                       (t_wready                       ),
    .t_wdata                        (t_wdata                        ),
    .t_wstrb                        (t_wstrb                        ),
    .t_wlast                        (t_wlast                        ),

    .t_bvalid                       (t_bvalid                       ),
    .t_bready                       (t_bready                       ),
    .t_bresp                        (t_bresp                        ),

    .t_arvalid                      (t_arvalid                      ),
    .t_arready                      (t_arready                      ),
    .t_arregion                     (t_arregion                     ),
    .t_araddr                       (t_araddr                       ),
    .t_arlen                        (t_arlen                        ),
    .t_arsize                       (t_arsize                       ),

    .t_rvalid                       (t_rvalid                       ),
    .t_rready                       (t_rready                       ),
    .t_rdata                        (t_rdata                        ),
    .t_rresp                        (t_rresp                        ),
    .t_rlast                        (t_rlast                        )
);

endmodule
