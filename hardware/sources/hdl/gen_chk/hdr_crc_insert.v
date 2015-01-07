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
// File       : hdr_crc_insert.v
//
//-----------------------------------------------------------------------------
//
// This module generates 32-bit CRC for each data packet and appends it to 
// the last byte of the packet. Depending on the number of used bytes in the
// last data beat of the packet, the CRC insertion make require one clock cycle
// or two clock cycles. To accomadate insertion of CRC dst_rdy signal to the DMA 
// is deasserted.

`timescale 1ps / 1ps

module hdr_crc_insert #
(
   parameter DATA_WIDTH = 64,
   parameter STRB_WIDTH = DATA_WIDTH/8
)
(

    // System Inputs
    input                             clk,
    input                             reset,

    // DMA Inputs/Outputs
    input                             tvalid_in,
    input                             tlast_in,
    input        [15:0]               tuser_in,
    input        [STRB_WIDTH-1:0]     tkeep_in,
    input        [DATA_WIDTH-1:0]     tdata_in,
    output                            tready_out,

    // FIFO Input/Output
    input                             tready_in,
    output reg  [15:0]                tuser_out,
    output reg  [STRB_WIDTH-1:0]      tkeep_out,
    output      [DATA_WIDTH-1:0]      tdata_out,
    output reg                        tlast_out,
    output reg                        tvalid_out

); 

localparam IDLE                = 3'b000,
           IN_PKT              = 3'b001,
           CALC_CRC_LAST_QWORD = 3'b010,
           INSERT_CRC          = 3'b011;
localparam SOP_DETECT          = 1'b0,
           EOP_DETECT          = 1'b1;

reg                   fsm_state = SOP_DETECT;
reg  [DATA_WIDTH-1:0] data = 'd0;         
reg                   tsop_d1 = 'd0;
wire [31:0]           hdr_crc_32bit;
wire                  valid_beat;
wire                  tsop;
reg                   tready_out_adv;

assign valid_beat = tvalid_in && tready_out;

// FSM to detect Start of every packet

always@(posedge clk)
begin
  if (reset)
    fsm_state  <= SOP_DETECT;
  else
  begin
  case(fsm_state)
  SOP_DETECT:
             begin
               if(valid_beat)
               begin
                 if(tlast_in)
                   fsm_state <= SOP_DETECT;
                 else
                   fsm_state <= EOP_DETECT;
               end
               else
                   fsm_state <= SOP_DETECT;
             end
  EOP_DETECT:
             begin
               if(valid_beat)
               begin
                 if(tlast_in)
                     fsm_state <= SOP_DETECT;
                 else
                     fsm_state <= EOP_DETECT;
               end
               else
                   fsm_state <= EOP_DETECT;
             end
  endcase
  end
end

assign tsop = (valid_beat && (fsm_state == SOP_DETECT));

assign tready_out = tready_in;

always @ (posedge clk)
begin
  if (reset)
    tvalid_out <= 1'b0; 
  else if (!tready_in)
    tvalid_out <= tvalid_out;
  else if (valid_beat)
    tvalid_out <= 1'b1;
  else
    tvalid_out <= 1'b0; 
end  

always @ (posedge clk)
begin
  if (!tready_in)
    data <= data;
  else if (valid_beat)
    data <= tdata_in;
end  

always @ (posedge clk) begin
  if (reset)
    tsop_d1 <= 1'b0; 
  else if (!tready_in)
    tsop_d1 <= tsop_d1; 
  else if (valid_beat)
    tsop_d1 <= tsop;
  else
    tsop_d1 <= 1'b0; 
end  

// 32-bit CRC32 computation 
// The CRC32 module requires the first data bit to be MSB, i.e.,31st bit and
// the last bit to be LSB, i.e., 0th bit.
// But, the crc function used in the driver, reverses the bits of the individual
// bytes that it receives/generates while computing CRC32. So, doing the same here.

crc32_D32_wrapper U_CRC32
(
   .clk        (clk),
   .reset      (tsop), 
   .data_valid (tsop),
   .data       ({tdata_in[7:0],tdata_in[15:8],tdata_in[23:16],tdata_in[31:24]}),
   .crc_out    (hdr_crc_32bit)
);

// CRC32 is computed over the first 32 bits of the packet and CRC value is put in the 
// next 32 bits.

assign tdata_out = tsop_d1 ? {data[DATA_WIDTH-1:64],hdr_crc_32bit,data[31:0]} : data;

// CRC32 wrapper module produces CRC value with a latency of 1 clock cyle.
// Delaying the control signals by 1 clock inorder to align them with data.

always @ (posedge clk)
begin
  if (tready_in)
  begin
      tkeep_out   <= tkeep_in;
      tlast_out   <= tlast_in; 
      tuser_out   <= tuser_in;
  end
end

endmodule
