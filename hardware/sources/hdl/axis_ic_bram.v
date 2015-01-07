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
// File       : axis_ic_bram.v
//
//-----------------------------------------------------------------------------
//

module axis_ic_bram #(
  parameter AXIS_TDATA_WIDTH          = 256,
  parameter AWIDTH                    = 32,
  parameter DWIDTH                    = AXIS_TDATA_WIDTH,
  parameter NUM_PORTS                 = 8
  )(
   // AXI streaming Interface for Write port 
   input  [NUM_PORTS-1:0]              axi_str_wr_tlast,
   input  [(AXIS_TDATA_WIDTH*NUM_PORTS)-1:0]     axi_str_wr_tdata,
   input  [NUM_PORTS-1:0]              axi_str_wr_tvalid,
   input  [(AXIS_TDATA_WIDTH/8*NUM_PORTS)-1:0]  axi_str_wr_tkeep,
   output [NUM_PORTS-1:0]              axi_str_wr_tready,
   input  [NUM_PORTS-1:0]              axi_str_wr_aclk, 

   // AXI streaming Interface for Read port 
   output [NUM_PORTS-1:0]              axi_str_rd_tlast,
   output [(DWIDTH*NUM_PORTS)-1:0]     axi_str_rd_tdata,
   output [NUM_PORTS-1:0]              axi_str_rd_tvalid,
   output [(DWIDTH/8*NUM_PORTS)-1:0]   axi_str_rd_tkeep,
   input  [NUM_PORTS-1:0]              axi_str_rd_tready,
   input  [NUM_PORTS-1:0]              axi_str_rd_aclk, 
    
   input  [NUM_PORTS-1:0]              wr_reset_n, 
   input  [NUM_PORTS-1:0]              rd_reset_n, 

   input                               user_clk, 
   input                               user_reset

);

  // ----------------
  // -- Parameters --
  // ----------------
  
  localparam  AXI_VFIFO_DATA_WIDTH    = AXIS_TDATA_WIDTH;

wire [AXIS_TDATA_WIDTH-1:0]   px_str_rd_tdata [NUM_PORTS-1:0];
wire [(AXIS_TDATA_WIDTH/8)-1:0]   px_str_rd_tkeep [NUM_PORTS-1:0];
wire [AXIS_TDATA_WIDTH-1:0]   px_str_wr_tdata [NUM_PORTS-1:0];
wire [(AXIS_TDATA_WIDTH/8)-1:0]   px_str_wr_tkeep [NUM_PORTS-1:0];

genvar ii;
genvar jj;

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

genvar kk;

  generate
  begin : axis_ic_inst
    for (kk = 0; kk < NUM_PORTS; kk = kk+2)
    begin

  //- Instance of 1x1 Write Stream interconnect
  axis_ic_wr  axis_ic_wr0_inst (
      .ACLK (user_clk),
      .ARESETN (~user_reset),
      .S00_AXIS_ACLK (axi_str_wr_aclk[kk]),
      .S00_AXIS_ARESETN (wr_reset_n[kk]),
      .S00_AXIS_TVALID (axi_str_wr_tvalid[kk]),
      .S00_AXIS_TREADY (axi_str_wr_tready[kk]),
      .S00_AXIS_TDATA (px_str_wr_tdata[kk]),
      .S00_AXIS_TKEEP (px_str_wr_tkeep[kk]),
      .S00_AXIS_TLAST (axi_str_wr_tlast[kk]),
      .M00_AXIS_ACLK (axi_str_rd_aclk[kk]),
      .M00_AXIS_ARESETN (rd_reset_n[kk]),
      .M00_AXIS_TVALID (axi_str_rd_tvalid[kk]),
      .M00_AXIS_TREADY (axi_str_rd_tready[kk]),
      .M00_AXIS_TDATA (px_str_rd_tdata[kk]),
      .M00_AXIS_TKEEP (px_str_rd_tkeep[kk]),
      .M00_AXIS_TLAST (axi_str_rd_tlast[kk])
  );

  //- Instance of 1x1 Read Stream Interconnect
  axis_ic_rd  axis_ic_rd0_inst (
      .ACLK (user_clk),
      .ARESETN (~user_reset),
      .S00_AXIS_ACLK (axi_str_wr_aclk[kk+1]),
      .S00_AXIS_ARESETN (wr_reset_n[kk+1]),
      .S00_AXIS_TVALID (axi_str_wr_tvalid[kk+1]),
      .S00_AXIS_TREADY (axi_str_wr_tready[kk+1]),
      .S00_AXIS_TDATA (px_str_wr_tdata[kk+1]),
      .S00_AXIS_TKEEP (px_str_wr_tkeep[kk+1]),
      .S00_AXIS_TLAST (axi_str_wr_tlast[kk+1]),
      .M00_AXIS_ACLK (axi_str_rd_aclk[kk+1]),
      .M00_AXIS_ARESETN (rd_reset_n[kk+1]),
      .M00_AXIS_TVALID (axi_str_rd_tvalid[kk+1]),
      .M00_AXIS_TREADY (axi_str_rd_tready[kk+1]),
      .M00_AXIS_TDATA (px_str_rd_tdata[kk+1]),
      .M00_AXIS_TLAST (axi_str_rd_tlast[kk+1]),
      .M00_AXIS_TKEEP (px_str_rd_tkeep[kk+1]),
      .M00_FIFO_DATA_COUNT  ()
  );

    end
  end
  endgenerate

endmodule
