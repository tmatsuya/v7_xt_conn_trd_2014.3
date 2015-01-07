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
// File       : hdr_crc_checker.v
//
//-----------------------------------------------------------------------------
//

`timescale 1ps / 1ps

module hdr_crc_checker #
(
   parameter CNT_WIDTH  = 16,
   parameter DATA_WIDTH = 64,
   parameter STRB_WIDTH = DATA_WIDTH/8
)

(
    input                       clk,
    input                       reset,
    input                       enable_check,
    input                       tvalid_in,
    input                       tlast_in,
    input      [DATA_WIDTH-1:0] tdata_in,
    input      [STRB_WIDTH-1:0] tkeep_in,
    output                      tready_out,
    input      [CNT_WIDTH-1:0]  check_length,

    output reg                  error_flag 
); 

localparam SOP_DETECT          = 1'b0,
           EOP_DETECT          = 1'b1;

reg                     fsm_state = SOP_DETECT;
wire                    valid_beat;
wire                    tsop;
reg                     tsop_d1 = 'd0;
wire [31:0]             calc_crc_out;
reg  [31:0]             expected_crc_reg = 'd0;
reg                     crc_mismatch;
reg  [15:0]             expected_seq_num = 'h0;
wire [DATA_WIDTH-1:0]   expected_data;
reg  [DATA_WIDTH-1:0]   tx_data_c = 'b0;
reg  [15:0]             tx_pkt_length = 'b0;
reg                     tx_data_valid_c = 'b0;
reg  [STRB_WIDTH-1:0]   tx_data_strobe_c = 'b0;
reg                     tx_data_last_c = 'b0;
reg                     data_mismatch_0 = 'b0;
reg                     data_mismatch_1 = 'b0;
reg  [STRB_WIDTH/2-1:0] i = 0;
wire [STRB_WIDTH:0]     tstrb_i;
reg  [15:0]             byte_cnt_c = 'b0;
wire [5:0]              expected_byte_cnt_at_eop;
reg  [15:0]             pkt_len_latched = 'b0;
reg                     len_mismatch_hdr_1 = 'b0;
reg                     len_mismatch_hdr_2 = 'b0;
reg                     len_mismatch_sw = 'b0;


assign valid_beat = tvalid_in && tready_out;

// FSM to detect Start of every packet

always@(posedge clk)
begin
  if (reset || !enable_check)
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

//********************************************************************
// Looking for CRC MISMATCH:
// The S/W driver computes CRC32 on the first four bytes of
// every packet and inserts that value in the next four bytes.
// Hence, expected CRC is taken from 5th to 8th bytes of the data
// in SOP cycle.
// CRC is calculated on data only if data_valid is asserted.
// Start of a packet resets the CRC calculation
// crc_out is available 1 clock cycle after the data is presented
//*******************************************************************/

crc32_D32_wrapper crc32_i
(
   .clk        (clk),
   .reset      (tsop), 
   .data_valid (tsop),
   .data       ({tdata_in[7:0],tdata_in[15:8],tdata_in[23:16],tdata_in[31:24]}),
   .crc_out    (calc_crc_out)
);

 always @ (posedge clk)
 begin
  if(tsop)
    expected_crc_reg <= tdata_in[63:32];
 end

 always @ (posedge clk)
 begin
   if(reset || !enable_check)
    tsop_d1 <= 1'b0;
   else if(valid_beat)
    tsop_d1 <= tsop;
   else
    tsop_d1 <= tsop_d1;
 end

  always @ (posedge clk)
  begin
    if(reset || !enable_check)
      crc_mismatch <= 1'b0;
    else if(tsop_d1 && valid_beat && (calc_crc_out != expected_crc_reg)) 
      crc_mismatch <= 1'b1;
  end

assign tready_out = 1'b1;

//********************************************************************************************************
// Looking for DATA MISMATCH:
// The Checker compares transmitted data against the expected data.
// The expected data has the following pattern.
// The first 8 bytes of the packet contain Length info in the first 2 bytes
// and a 2 byte tag, followed by 4 byte expected CRC pattern. The rest of 
// the bytes in first DW will have the tag repeated for 24 times(32 Bytes/Cycle - 8 bytes of header).
// All subsequent DW have the tag number repeated 16 times. 
// The tag num is obtained from the 3rd and 4th bytes of the packet.
//*******************************************************************************************************/

 always @ (posedge clk)
 begin
  if(tsop)
    expected_seq_num <= tdata_in[31:16];
 end
  
  assign expected_data = {STRB_WIDTH/2{expected_seq_num}};
  
  always @ (posedge clk)
  begin
    tx_data_c         <= tdata_in;
    tx_data_valid_c   <= tvalid_in;
    tx_data_strobe_c  <= tkeep_in;
    tx_data_last_c    <= tlast_in;
    tx_pkt_length     <= check_length;
  end  

  // The data comparison is spilt over two processes to help with timing. 
  always @ (posedge clk) 
  begin
    if (!enable_check ) begin
        data_mismatch_0 <= 1'b0;
    end else if (tx_data_valid_c && tsop_d1 && (DATA_WIDTH == 'd256)) begin
      if (tx_data_c[DATA_WIDTH/2-1:64] != {expected_data[DATA_WIDTH/2-1:64]}) begin
        data_mismatch_0 <= 1'b1;
      end    
    end else if (tx_data_valid_c && tx_data_last_c) begin
      for (i= 0; i <STRB_WIDTH/2; i= i+1) begin  
        if (tx_data_strobe_c[i]  == 1 && tx_data_c[(i*8)+:8] != expected_data[(i*8)+:8]) begin
          data_mismatch_0 <= 1'b1; 
        end  
      end
    end else if (!tsop_d1 && tx_data_valid_c) begin
      if (tx_data_c[DATA_WIDTH/2-1:0] != expected_data[DATA_WIDTH/2-1:0]) begin    
        data_mismatch_0 <= 1'b1;  
      end  
    end 
    
  end  
  
  always @ (posedge clk) 
  begin
    if (!enable_check) begin
        data_mismatch_1 <= 1'b0;
    end else if (tx_data_valid_c && tx_data_last_c) begin
      for (i= STRB_WIDTH/2; i <STRB_WIDTH; i= i+1) begin  
        if (tx_data_strobe_c[i]  == 1 && tx_data_c[(i*8)+:8] != expected_data[(i*8)+:8]) begin
          data_mismatch_1 <= 1'b1; 
        end  
      end
    end else if (tx_data_valid_c) begin
      if (tx_data_c[DATA_WIDTH-1:DATA_WIDTH/2] != expected_data[DATA_WIDTH-1:DATA_WIDTH/2]) begin    
        data_mismatch_1 <= 1'b1;  
      end  
    end 
    
  end  

/********************************************************************************************************
  // Looking for PACKET LENGTH MISMATCH:
  // check - 1: Packet Length present in the header is same as Software programmed Length
  // check - 2: Number of bytes in the packet match the packet length value present in the header.
********************************************************************************************************/

  assign tstrb_i = tx_data_strobe_c + 1;
 
  // Byte count allows to check the actual payload length
  always @(posedge clk)
  begin
    if (reset)
      byte_cnt_c <= 0;
    else if (tx_data_valid_c && byte_cnt_c == 0)
      byte_cnt_c <= tx_data_c[15:0] - STRB_WIDTH;
    else if (tx_data_valid_c && byte_cnt_c < STRB_WIDTH)
      byte_cnt_c <= 0;
    else if (tx_data_valid_c)
      byte_cnt_c <= byte_cnt_c - STRB_WIDTH;
  end

  always @(posedge clk)
  begin
    if (reset)
      pkt_len_latched <= 'h0;
    else if(tsop_d1 && tx_data_valid_c)
      pkt_len_latched <= tx_data_c[15:0];
  end

  assign expected_byte_cnt_at_eop = (tx_data_valid_c && tx_data_last_c) ?
                                    ((tx_data_strobe_c == {STRB_WIDTH{1'b1}}) ? STRB_WIDTH : (pkt_len_latched%STRB_WIDTH)) : 'd0;
    always@(posedge clk)
    begin
    if(!enable_check)
        len_mismatch_hdr_1 <= 1'b0;
    // check - 2: Number of bytes in the packet match the packet length value present in the header (part 1 for timing).
    else if(tx_data_valid_c && tx_data_last_c && (byte_cnt_c > STRB_WIDTH))
        len_mismatch_hdr_1 <= 1'b1;
    end

    always@(posedge clk)
    begin
    if(!enable_check)
        len_mismatch_hdr_2 <= 1'b0;
    // check - 2: Number of bytes in the packet match the packet length value present in the header (part 2 for timing).
    else if(tx_data_valid_c && tx_data_last_c && (expected_byte_cnt_at_eop != byte_cnt_c))
        len_mismatch_hdr_2 <= 1'b1;
    end

  always@(posedge clk)
  begin
  if(!enable_check)
      len_mismatch_sw <= 1'b0;
  // check - 1: Packet Length present in the header is same as Software programmed Length
  else if (tx_data_valid_c && (byte_cnt_c == 0) && (tx_data_c[15:0] != tx_pkt_length))
      len_mismatch_sw <= 1'b1;
  end

  // data_mismatch is a sticky bit. The software polls this
  // register at regular intervals. 
  // This bit is set only when enable_check is 1
  always @ (posedge clk)
  begin
    error_flag <= crc_mismatch || data_mismatch_0 || data_mismatch_1 || len_mismatch_sw || len_mismatch_hdr_1 || len_mismatch_hdr_2;
  end


endmodule
