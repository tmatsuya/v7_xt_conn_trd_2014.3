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
// File       : crc32_D32_wrapper.v
//
//-----------------------------------------------------------------------------
//

//*******************************************************************************/
// Uses the Easics CRC function to calculate the CRC of a data packet.  

`timescale 1ps / 1ps

module crc32_D32_wrapper
(
   input               clk,         
   input               reset,            // Resets the CRC calculation 
   input               data_valid,       // CRC calculated only if this signal is asserted
   input      [31:0]   data,             // Data on which CRC has to be calculated 
   output reg [31:0]   crc_out = 'd0     // CRC over the packet available 1 clock cycle after DWORD is presented   
);

localparam CRC_INIT = 32'hFFFFFFFF;

reg  [31:0] crc_in = 32'hFFFF_FFFF;

`include "crc_calc_functions.v"

// crc_in is reset to 32'FFFF_FFFF at the start of a new packet
// or when the system is reset.In all other cases it is assigned  
// the current crc_out value and is used as feedback to calculate
// CRC on the next data word.

always @(reset , crc_out)
begin
  if (reset)
    crc_in <= CRC_INIT;
  else
    crc_in <= crc_out;
end

always @(posedge clk)
begin
  if (data_valid)
    crc_out <= nextCRC32_D32(data,crc_in);
end

endmodule
