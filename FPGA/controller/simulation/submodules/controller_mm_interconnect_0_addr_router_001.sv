// (C) 2001-2013 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// (C) 2001-2013 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// $Id: //acds/rel/13.1/ip/merlin/altera_merlin_router/altera_merlin_router.sv.terp#5 $
// $Revision: #5 $
// $Date: 2013/09/30 $
// $Author: perforce $

// -------------------------------------------------------
// Merlin Router
//
// Asserts the appropriate one-hot encoded channel based on 
// either (a) the address or (b) the dest id. The DECODER_TYPE
// parameter controls this behaviour. 0 means address decoder,
// 1 means dest id decoder.
//
// In the case of (a), it also sets the destination id.
// -------------------------------------------------------

`timescale 1 ns / 1 ns

module controller_mm_interconnect_0_addr_router_001_default_decode
  #(
     parameter DEFAULT_CHANNEL = 2,
               DEFAULT_WR_CHANNEL = -1,
               DEFAULT_RD_CHANNEL = -1,
               DEFAULT_DESTID = 14 
   )
  (output [80 - 76 : 0] default_destination_id,
   output [24-1 : 0] default_wr_channel,
   output [24-1 : 0] default_rd_channel,
   output [24-1 : 0] default_src_channel
  );

  assign default_destination_id = 
    DEFAULT_DESTID[80 - 76 : 0];

  generate begin : default_decode
    if (DEFAULT_CHANNEL == -1) begin
      assign default_src_channel = '0;
    end
    else begin
      assign default_src_channel = 24'b1 << DEFAULT_CHANNEL;
    end
  end
  endgenerate

  generate begin : default_decode_rw
    if (DEFAULT_RD_CHANNEL == -1) begin
      assign default_wr_channel = '0;
      assign default_rd_channel = '0;
    end
    else begin
      assign default_wr_channel = 24'b1 << DEFAULT_WR_CHANNEL;
      assign default_rd_channel = 24'b1 << DEFAULT_RD_CHANNEL;
    end
  end
  endgenerate

endmodule


module controller_mm_interconnect_0_addr_router_001
(
    // -------------------
    // Clock & Reset
    // -------------------
    input clk,
    input reset,

    // -------------------
    // Command Sink (Input)
    // -------------------
    input                       sink_valid,
    input  [94-1 : 0]    sink_data,
    input                       sink_startofpacket,
    input                       sink_endofpacket,
    output                      sink_ready,

    // -------------------
    // Command Source (Output)
    // -------------------
    output                          src_valid,
    output reg [94-1    : 0] src_data,
    output reg [24-1 : 0] src_channel,
    output                          src_startofpacket,
    output                          src_endofpacket,
    input                           src_ready
);

    // -------------------------------------------------------
    // Local parameters and variables
    // -------------------------------------------------------
    localparam PKT_ADDR_H = 49;
    localparam PKT_ADDR_L = 36;
    localparam PKT_DEST_ID_H = 80;
    localparam PKT_DEST_ID_L = 76;
    localparam PKT_PROTECTION_H = 84;
    localparam PKT_PROTECTION_L = 82;
    localparam ST_DATA_W = 94;
    localparam ST_CHANNEL_W = 24;
    localparam DECODER_TYPE = 0;

    localparam PKT_TRANS_WRITE = 52;
    localparam PKT_TRANS_READ  = 53;

    localparam PKT_ADDR_W = PKT_ADDR_H-PKT_ADDR_L + 1;
    localparam PKT_DEST_ID_W = PKT_DEST_ID_H-PKT_DEST_ID_L + 1;



    // -------------------------------------------------------
    // Figure out the number of bits to mask off for each slave span
    // during address decoding
    // -------------------------------------------------------
    localparam PAD0 = log2ceil(64'h1800 - 64'h1000); 
    localparam PAD1 = log2ceil(64'h2000 - 64'h1800); 
    localparam PAD2 = log2ceil(64'h2010 - 64'h2000); 
    localparam PAD3 = log2ceil(64'h2020 - 64'h2010); 
    localparam PAD4 = log2ceil(64'h2030 - 64'h2020); 
    localparam PAD5 = log2ceil(64'h2040 - 64'h2030); 
    localparam PAD6 = log2ceil(64'h2050 - 64'h2040); 
    localparam PAD7 = log2ceil(64'h2060 - 64'h2050); 
    localparam PAD8 = log2ceil(64'h2070 - 64'h2060); 
    localparam PAD9 = log2ceil(64'h2080 - 64'h2070); 
    localparam PAD10 = log2ceil(64'h2090 - 64'h2080); 
    localparam PAD11 = log2ceil(64'h20a0 - 64'h2090); 
    localparam PAD12 = log2ceil(64'h20b0 - 64'h20a0); 
    localparam PAD13 = log2ceil(64'h20c0 - 64'h20b0); 
    localparam PAD14 = log2ceil(64'h20d0 - 64'h20c0); 
    localparam PAD15 = log2ceil(64'h20e0 - 64'h20d0); 
    localparam PAD16 = log2ceil(64'h20f0 - 64'h20e0); 
    localparam PAD17 = log2ceil(64'h2100 - 64'h20f0); 
    localparam PAD18 = log2ceil(64'h2110 - 64'h2100); 
    localparam PAD19 = log2ceil(64'h2120 - 64'h2110); 
    localparam PAD20 = log2ceil(64'h2130 - 64'h2120); 
    localparam PAD21 = log2ceil(64'h2140 - 64'h2138); 
    localparam PAD22 = log2ceil(64'h2148 - 64'h2140); 
    // -------------------------------------------------------
    // Work out which address bits are significant based on the
    // address range of the slaves. If the required width is too
    // large or too small, we use the address field width instead.
    // -------------------------------------------------------
    localparam ADDR_RANGE = 64'h2148;
    localparam RANGE_ADDR_WIDTH = log2ceil(ADDR_RANGE);
    localparam OPTIMIZED_ADDR_H = (RANGE_ADDR_WIDTH > PKT_ADDR_W) ||
                                  (RANGE_ADDR_WIDTH == 0) ?
                                        PKT_ADDR_H :
                                        PKT_ADDR_L + RANGE_ADDR_WIDTH - 1;

    localparam RG = RANGE_ADDR_WIDTH-1;
    localparam REAL_ADDRESS_RANGE = OPTIMIZED_ADDR_H - PKT_ADDR_L;

      reg [PKT_ADDR_W-1 : 0] address;
      always @* begin
        address = {PKT_ADDR_W{1'b0}};
        address [REAL_ADDRESS_RANGE:0] = sink_data[OPTIMIZED_ADDR_H : PKT_ADDR_L];
      end   

    // -------------------------------------------------------
    // Pass almost everything through, untouched
    // -------------------------------------------------------
    assign sink_ready        = src_ready;
    assign src_valid         = sink_valid;
    assign src_startofpacket = sink_startofpacket;
    assign src_endofpacket   = sink_endofpacket;
    wire [PKT_DEST_ID_W-1:0] default_destid;
    wire [24-1 : 0] default_src_channel;




    // -------------------------------------------------------
    // Write and read transaction signals
    // -------------------------------------------------------
    wire read_transaction;
    assign read_transaction  = sink_data[PKT_TRANS_READ];


    controller_mm_interconnect_0_addr_router_001_default_decode the_default_decode(
      .default_destination_id (default_destid),
      .default_wr_channel   (),
      .default_rd_channel   (),
      .default_src_channel  (default_src_channel)
    );

    always @* begin
        src_data    = sink_data;
        src_channel = default_src_channel;
        src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = default_destid;

        // --------------------------------------------------
        // Address Decoder
        // Sets the channel and destination ID based on the address
        // --------------------------------------------------

    // ( 0x1000 .. 0x1800 )
    if ( {address[RG:PAD0],{PAD0{1'b0}}} == 14'h1000   ) begin
            src_channel = 24'b00000000000000000000100;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 14;
    end

    // ( 0x1800 .. 0x2000 )
    if ( {address[RG:PAD1],{PAD1{1'b0}}} == 14'h1800   ) begin
            src_channel = 24'b00000000000000000000001;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 20;
    end

    // ( 0x2000 .. 0x2010 )
    if ( {address[RG:PAD2],{PAD2{1'b0}}} == 14'h2000   ) begin
            src_channel = 24'b10000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 17;
    end

    // ( 0x2010 .. 0x2020 )
    if ( {address[RG:PAD3],{PAD3{1'b0}}} == 14'h2010   ) begin
            src_channel = 24'b01000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 10;
    end

    // ( 0x2020 .. 0x2030 )
    if ( {address[RG:PAD4],{PAD4{1'b0}}} == 14'h2020   ) begin
            src_channel = 24'b00100000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 21;
    end

    // ( 0x2030 .. 0x2040 )
    if ( {address[RG:PAD5],{PAD5{1'b0}}} == 14'h2030   ) begin
            src_channel = 24'b00010000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 0;
    end

    // ( 0x2040 .. 0x2050 )
    if ( {address[RG:PAD6],{PAD6{1'b0}}} == 14'h2040   ) begin
            src_channel = 24'b00001000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 2;
    end

    // ( 0x2050 .. 0x2060 )
    if ( {address[RG:PAD7],{PAD7{1'b0}}} == 14'h2050   ) begin
            src_channel = 24'b00000100000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 23;
    end

    // ( 0x2060 .. 0x2070 )
    if ( {address[RG:PAD8],{PAD8{1'b0}}} == 14'h2060   ) begin
            src_channel = 24'b00000010000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 1;
    end

    // ( 0x2070 .. 0x2080 )
    if ( {address[RG:PAD9],{PAD9{1'b0}}} == 14'h2070   ) begin
            src_channel = 24'b00000001000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 3;
    end

    // ( 0x2080 .. 0x2090 )
    if ( {address[RG:PAD10],{PAD10{1'b0}}} == 14'h2080   ) begin
            src_channel = 24'b00000000100000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 4;
    end

    // ( 0x2090 .. 0x20a0 )
    if ( {address[RG:PAD11],{PAD11{1'b0}}} == 14'h2090   ) begin
            src_channel = 24'b00000000010000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 7;
    end

    // ( 0x20a0 .. 0x20b0 )
    if ( {address[RG:PAD12],{PAD12{1'b0}}} == 14'h20a0   ) begin
            src_channel = 24'b00000000001000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 15;
    end

    // ( 0x20b0 .. 0x20c0 )
    if ( {address[RG:PAD13],{PAD13{1'b0}}} == 14'h20b0   ) begin
            src_channel = 24'b00000000000100000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 9;
    end

    // ( 0x20c0 .. 0x20d0 )
    if ( {address[RG:PAD14],{PAD14{1'b0}}} == 14'h20c0  && read_transaction  ) begin
            src_channel = 24'b00000000000010000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 11;
    end

    // ( 0x20d0 .. 0x20e0 )
    if ( {address[RG:PAD15],{PAD15{1'b0}}} == 14'h20d0   ) begin
            src_channel = 24'b00000000000001000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 12;
    end

    // ( 0x20e0 .. 0x20f0 )
    if ( {address[RG:PAD16],{PAD16{1'b0}}} == 14'h20e0   ) begin
            src_channel = 24'b00000000000000100000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 13;
    end

    // ( 0x20f0 .. 0x2100 )
    if ( {address[RG:PAD17],{PAD17{1'b0}}} == 14'h20f0  && read_transaction  ) begin
            src_channel = 24'b00000000000000010000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 6;
    end

    // ( 0x2100 .. 0x2110 )
    if ( {address[RG:PAD18],{PAD18{1'b0}}} == 14'h2100  && read_transaction  ) begin
            src_channel = 24'b00000000000000001000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 5;
    end

    // ( 0x2110 .. 0x2120 )
    if ( {address[RG:PAD19],{PAD19{1'b0}}} == 14'h2110   ) begin
            src_channel = 24'b00000000000000000100000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 8;
    end

    // ( 0x2120 .. 0x2130 )
    if ( {address[RG:PAD20],{PAD20{1'b0}}} == 14'h2120  && read_transaction  ) begin
            src_channel = 24'b00000000000000000010000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 16;
    end

    // ( 0x2138 .. 0x2140 )
    if ( {address[RG:PAD21],{PAD21{1'b0}}} == 14'h2138   ) begin
            src_channel = 24'b00000000000000000000010;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 19;
    end

    // ( 0x2140 .. 0x2148 )
    if ( {address[RG:PAD22],{PAD22{1'b0}}} == 14'h2140  && read_transaction  ) begin
            src_channel = 24'b00000000000000000001000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 22;
    end

end


    // --------------------------------------------------
    // Ceil(log2()) function
    // --------------------------------------------------
    function integer log2ceil;
        input reg[65:0] val;
        reg [65:0] i;

        begin
            i = 1;
            log2ceil = 0;

            while (i < val) begin
                log2ceil = log2ceil + 1;
                i = i << 1;
            end
        end
    endfunction

endmodule


