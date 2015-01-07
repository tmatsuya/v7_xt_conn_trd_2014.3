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
(* CORE_GENERATION_INFO = "axilite_system,axilite_system_v1_3,{x_ipproduct=Vivado2014.3,v7_xt_conn_trd=2014.3}" *)
module axilite_system  (
  input user_clk,
  input resetn,

  input [31:0]                     axi4lite_s_awaddr,
  input                            axi4lite_s_awvalid,
  output                            axi4lite_s_awready,
  input [31:0]                     axi4lite_s_wdata,
  input [3:0]                      axi4lite_s_wstrb,
  input                            axi4lite_s_wvalid,
  output                            axi4lite_s_wready,
  output                            axi4lite_s_bvalid,
  input                            axi4lite_s_bready,
  output [1:0]                      axi4lite_s_bresp,
  input [31:0]                     axi4lite_s_araddr,
  output                            axi4lite_s_arready,
  input                            axi4lite_s_arvalid,
  output [31:0]                     axi4lite_s_rdata,
  output [1:0]                      axi4lite_s_rresp,
  input                            axi4lite_s_rready,
  output                            axi4lite_s_rvalid,
  
  output [31:0]                     axilite_m0_awaddr,
  output                            axilite_m0_awvalid,
  input                            axilite_m0_awready,
  output [31:0]                     axilite_m0_wdata,
  output [3:0]                      axilite_m0_wstrb,
  output                            axilite_m0_wvalid,
  input                            axilite_m0_wready,
  input                            axilite_m0_bvalid,
  output                            axilite_m0_bready,
  input [1:0]                      axilite_m0_bresp,
  output [31:0]                     axilite_m0_araddr,
  input                            axilite_m0_arready,
  output                            axilite_m0_arvalid,
  input [31:0]                     axilite_m0_rdata,
  input [1:0]                      axilite_m0_rresp,
  output                            axilite_m0_rready,
  input                            axilite_m0_rvalid,

  output [31:0]                     axilite_m1_awaddr,
  output                            axilite_m1_awvalid,
  input                            axilite_m1_awready,
  output [31:0]                     axilite_m1_wdata,
  output [3:0]                      axilite_m1_wstrb,
  output                            axilite_m1_wvalid,
  input                            axilite_m1_wready,
  input                            axilite_m1_bvalid,
  output                            axilite_m1_bready,
  input [1:0]                      axilite_m1_bresp,
  output [31:0]                     axilite_m1_araddr,
  input                            axilite_m1_arready,
  output                            axilite_m1_arvalid,
  input [31:0]                     axilite_m1_rdata,
  input [1:0]                      axilite_m1_rresp,
  output                            axilite_m1_rready,
  input                            axilite_m1_rvalid,

  output [31:0]                     axilite_m2_awaddr,
  output                            axilite_m2_awvalid,
  input                            axilite_m2_awready,
  output [31:0]                     axilite_m2_wdata,
  output [3:0]                      axilite_m2_wstrb,
  output                            axilite_m2_wvalid,
  input                            axilite_m2_wready,
  input                            axilite_m2_bvalid,
  output                            axilite_m2_bready,
  input [1:0]                      axilite_m2_bresp,
  output [31:0]                     axilite_m2_araddr,
  input                            axilite_m2_arready,
  output                            axilite_m2_arvalid,
  input [31:0]                     axilite_m2_rdata,
  input [1:0]                      axilite_m2_rresp,
  output                            axilite_m2_rready,
  input                            axilite_m2_rvalid,

  output [31:0]                     axilite_m3_awaddr,
  output                            axilite_m3_awvalid,
  input                            axilite_m3_awready,
  output [31:0]                     axilite_m3_wdata,
  output [3:0]                      axilite_m3_wstrb,
  output                            axilite_m3_wvalid,
  input                            axilite_m3_wready,
  input                            axilite_m3_bvalid,
  output                            axilite_m3_bready,
  input [1:0]                      axilite_m3_bresp,
  output [31:0]                     axilite_m3_araddr,
  input                            axilite_m3_arready,
  output                            axilite_m3_arvalid,
  input [31:0]                     axilite_m3_rdata,
  input [1:0]                      axilite_m3_rresp,
  output                            axilite_m3_rready,
  input                            axilite_m3_rvalid,

  output [31:0]                     axilite_m4_awaddr,
  output                            axilite_m4_awvalid,
  input                            axilite_m4_awready,
  output [31:0]                     axilite_m4_wdata,
  output [3:0]                      axilite_m4_wstrb,
  output                            axilite_m4_wvalid,
  input                            axilite_m4_wready,
  input                            axilite_m4_bvalid,
  output                            axilite_m4_bready,
  input [1:0]                      axilite_m4_bresp,
  output [31:0]                     axilite_m4_araddr,
  input                            axilite_m4_arready,
  output                            axilite_m4_arvalid,
  input [31:0]                     axilite_m4_rdata,
  input [1:0]                      axilite_m4_rresp,
  output                            axilite_m4_rready,
  input                            axilite_m4_rvalid

  
);


wire [159 : 0] crossbar_m_axi_awaddr;              
wire [14 : 0]  crossbar_m_axi_awprot;              
wire [4 : 0]   crossbar_m_axi_awvalid;             
wire [4 : 0]   crossbar_m_axi_awready;             
wire [159 : 0] crossbar_m_axi_wdata;               
wire [19 : 0]  crossbar_m_axi_wstrb;               
wire [4 : 0]   crossbar_m_axi_wvalid;              
wire [4 : 0]   crossbar_m_axi_wready;              
wire [9 : 0]   crossbar_m_axi_bresp;               
wire [4 : 0]   crossbar_m_axi_bvalid;              
wire [4 : 0]   crossbar_m_axi_bready;              
wire [159 : 0] crossbar_m_axi_araddr;              
wire [14 : 0]  crossbar_m_axi_arprot;              
wire [4 : 0]   crossbar_m_axi_arvalid;             
wire [4 : 0]   crossbar_m_axi_arready;             
wire [159 : 0] crossbar_m_axi_rdata;               
wire [9 : 0]   crossbar_m_axi_rresp;
wire [4 : 0]   crossbar_m_axi_rvalid;
wire [4 : 0]   crossbar_m_axi_rready;



assign {axilite_m4_awaddr,
        axilite_m3_awaddr,
        axilite_m2_awaddr,
        axilite_m1_awaddr,
        axilite_m0_awaddr} = crossbar_m_axi_awaddr;


assign {axilite_m4_awvalid,
        axilite_m3_awvalid,
        axilite_m2_awvalid,
        axilite_m1_awvalid,
        axilite_m0_awvalid} = crossbar_m_axi_awvalid;

assign  crossbar_m_axi_awready = {axilite_m4_awready,
                                  axilite_m3_awready,
                                  axilite_m2_awready,
                                  axilite_m1_awready,
                                  axilite_m0_awready};

assign {axilite_m4_wdata,
        axilite_m3_wdata,
        axilite_m2_wdata,
        axilite_m1_wdata,
        axilite_m0_wdata} = crossbar_m_axi_wdata;

assign {axilite_m4_wstrb,
        axilite_m3_wstrb,
        axilite_m2_wstrb,
        axilite_m1_wstrb,
        axilite_m0_wstrb} = crossbar_m_axi_wstrb;
        
assign {axilite_m4_wvalid,
        axilite_m3_wvalid,
        axilite_m2_wvalid,
        axilite_m1_wvalid,
        axilite_m0_wvalid} = crossbar_m_axi_wvalid;
        
assign crossbar_m_axi_wready = {axilite_m4_wready,
                                axilite_m3_wready,
                                axilite_m2_wready,
                                axilite_m1_wready,
                                axilite_m0_wready};
        
assign crossbar_m_axi_bresp = {axilite_m4_bresp,
                               axilite_m3_bresp,
                               axilite_m2_bresp,
                               axilite_m1_bresp,
                               axilite_m0_bresp};

assign crossbar_m_axi_bvalid = {axilite_m4_bvalid,
                                axilite_m3_bvalid,
                                axilite_m2_bvalid,
                                axilite_m1_bvalid,
                                axilite_m0_bvalid};

assign {axilite_m4_bready,
        axilite_m3_bready,
        axilite_m2_bready,
        axilite_m1_bready,
        axilite_m0_bready} = crossbar_m_axi_bready;
        
assign {axilite_m4_araddr,
        axilite_m3_araddr,
        axilite_m2_araddr,
        axilite_m1_araddr,
        axilite_m0_araddr} = crossbar_m_axi_araddr;
        
assign {axilite_m4_arvalid,
        axilite_m3_arvalid,
        axilite_m2_arvalid,
        axilite_m1_arvalid,
        axilite_m0_arvalid} = crossbar_m_axi_arvalid;
        
assign crossbar_m_axi_arready = {axilite_m4_arready,
                                 axilite_m3_arready,
                                 axilite_m2_arready,
                                 axilite_m1_arready,
                                 axilite_m0_arready};
                                 
assign crossbar_m_axi_rdata = {axilite_m4_rdata,
                               axilite_m3_rdata,
                               axilite_m2_rdata,
                               axilite_m1_rdata,
                               axilite_m0_rdata};

assign crossbar_m_axi_rresp = {axilite_m4_rresp,
                               axilite_m3_rresp,
                               axilite_m2_rresp,
                               axilite_m1_rresp,
                               axilite_m0_rresp};

assign crossbar_m_axi_rvalid = {axilite_m4_rvalid,
                                axilite_m3_rvalid,
                                axilite_m2_rvalid,
                                axilite_m1_rvalid,
                                axilite_m0_rvalid};

assign {axilite_m4_rready,
        axilite_m3_rready,
        axilite_m2_rready,
        axilite_m1_rready,
        axilite_m0_rready} = crossbar_m_axi_rready;


axi4lite_crossbar axi4lite_system (
  .aclk(user_clk),                    // input wire aclk                                  
  .aresetn(resetn),              // input wire aresetn                                 
  .s_axi_awaddr(axi4lite_s_awaddr),    // input wire [31 : 0] s_axi_awaddr  
  .s_axi_awprot(3'b0),    // input wire [2 : 0] s_axi_awprot                              
  .s_axi_awvalid(axi4lite_s_awvalid),  // input wire [0 : 0] s_axi_awvalid                
  .s_axi_awready(axi4lite_s_awready),  // output wire [0 : 0] s_axi_awready               
  .s_axi_wdata(axi4lite_s_wdata),      // input wire [31 : 0] s_axi_wdata                            
  .s_axi_wstrb(axi4lite_s_wstrb),      // input wire [3 : 0] s_axi_wstrb                           
  .s_axi_wvalid(axi4lite_s_wvalid),    // input wire [0 : 0] s_axi_wvalid                 
  .s_axi_wready(axi4lite_s_wready),    // output wire [0 : 0] s_axi_wready                
  .s_axi_bresp(axi4lite_s_bresp),      // output wire [1 : 0] s_axi_bresp                 
  .s_axi_bvalid(axi4lite_s_bvalid),    // output wire [0 : 0] s_axi_bvalid                
  .s_axi_bready(axi4lite_s_bready),    // input wire [0 : 0] s_axi_bready                 
  .s_axi_araddr(axi4lite_s_araddr),    // input wire [31 : 0] s_axi_araddr  
  .s_axi_arprot(3'b0),    // input wire [2 : 0] s_axi_arprot                              
  .s_axi_arvalid(axi4lite_s_arvalid),  // input wire [0 : 0] s_axi_arvalid                
  .s_axi_arready(axi4lite_s_arready),  // output wire [0 : 0] s_axi_arready               
  .s_axi_rdata(axi4lite_s_rdata),      // output wire [31 : 0] s_axi_rdata                           
  .s_axi_rresp(axi4lite_s_rresp),      // output wire [1 : 0] s_axi_rresp                 
  .s_axi_rvalid(axi4lite_s_rvalid),    // output wire [0 : 0] s_axi_rvalid
  .s_axi_rready(axi4lite_s_rready),    // input wire [0 : 0] s_axi_rready
  .m_axi_awaddr(crossbar_m_axi_awaddr),    // output wire [159 : 0] m_axi_awaddr
  .m_axi_awprot(crossbar_m_axi_awprot),    // output wire [14 : 0] m_axi_awprot
  .m_axi_awvalid(crossbar_m_axi_awvalid),  // output wire [4 : 0] m_axi_awvalid
  .m_axi_awready(crossbar_m_axi_awready),  // input wire [4 : 0] m_axi_awready
  .m_axi_wdata(crossbar_m_axi_wdata),      // output wire [159 : 0] m_axi_wdata
  .m_axi_wstrb(crossbar_m_axi_wstrb),      // output wire [19 : 0] m_axi_wstrb
  .m_axi_wvalid(crossbar_m_axi_wvalid),    // output wire [4 : 0] m_axi_wvalid
  .m_axi_wready(crossbar_m_axi_wready),    // input wire [4 : 0] m_axi_wready
  .m_axi_bresp(crossbar_m_axi_bresp),      // input wire [9 : 0] m_axi_bresp
  .m_axi_bvalid(crossbar_m_axi_bvalid),    // input wire [4 : 0] m_axi_bvalid
  .m_axi_bready(crossbar_m_axi_bready),    // output wire [4 : 0] m_axi_bready
  .m_axi_araddr(crossbar_m_axi_araddr),    // output wire [159 : 0] m_axi_araddr
  .m_axi_arprot(crossbar_m_axi_arprot),    // output wire [14 : 0] m_axi_arprot
  .m_axi_arvalid(crossbar_m_axi_arvalid),  // output wire [4 : 0] m_axi_arvalid
  .m_axi_arready(crossbar_m_axi_arready),  // input wire [4 : 0] m_axi_arready
  .m_axi_rdata(crossbar_m_axi_rdata),      // input wire [159 : 0] m_axi_rdata
  .m_axi_rresp(crossbar_m_axi_rresp),      // input wire [9 : 0] m_axi_rresp
  .m_axi_rvalid(crossbar_m_axi_rvalid),    // input wire [4 : 0] m_axi_rvalid
  .m_axi_rready(crossbar_m_axi_rready)    // output wire [4 : 0] m_axi_rready
);


endmodule

