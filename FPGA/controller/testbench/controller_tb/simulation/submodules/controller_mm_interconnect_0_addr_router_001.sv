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
     parameter DEFAULT_CHANNEL = 1,
               DEFAULT_WR_CHANNEL = -1,
               DEFAULT_RD_CHANNEL = -1,
               DEFAULT_DESTID = 18 
   )
  (output [85 - 80 : 0] default_destination_id,
   output [50-1 : 0] default_wr_channel,
   output [50-1 : 0] default_rd_channel,
   output [50-1 : 0] default_src_channel
  );

  assign default_destination_id = 
    DEFAULT_DESTID[85 - 80 : 0];

  generate begin : default_decode
    if (DEFAULT_CHANNEL == -1) begin
      assign default_src_channel = '0;
    end
    else begin
      assign default_src_channel = 50'b1 << DEFAULT_CHANNEL;
    end
  end
  endgenerate

  generate begin : default_decode_rw
    if (DEFAULT_RD_CHANNEL == -1) begin
      assign default_wr_channel = '0;
      assign default_rd_channel = '0;
    end
    else begin
      assign default_wr_channel = 50'b1 << DEFAULT_WR_CHANNEL;
      assign default_rd_channel = 50'b1 << DEFAULT_RD_CHANNEL;
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
    input  [99-1 : 0]    sink_data,
    input                       sink_startofpacket,
    input                       sink_endofpacket,
    output                      sink_ready,

    // -------------------
    // Command Source (Output)
    // -------------------
    output                          src_valid,
    output reg [99-1    : 0] src_data,
    output reg [50-1 : 0] src_channel,
    output                          src_startofpacket,
    output                          src_endofpacket,
    input                           src_ready
);

    // -------------------------------------------------------
    // Local parameters and variables
    // -------------------------------------------------------
    localparam PKT_ADDR_H = 52;
    localparam PKT_ADDR_L = 36;
    localparam PKT_DEST_ID_H = 85;
    localparam PKT_DEST_ID_L = 80;
    localparam PKT_PROTECTION_H = 89;
    localparam PKT_PROTECTION_L = 87;
    localparam ST_DATA_W = 99;
    localparam ST_CHANNEL_W = 50;
    localparam DECODER_TYPE = 0;

    localparam PKT_TRANS_WRITE = 55;
    localparam PKT_TRANS_READ  = 56;

    localparam PKT_ADDR_W = PKT_ADDR_H-PKT_ADDR_L + 1;
    localparam PKT_DEST_ID_W = PKT_DEST_ID_H-PKT_DEST_ID_L + 1;



    // -------------------------------------------------------
    // Figure out the number of bits to mask off for each slave span
    // during address decoding
    // -------------------------------------------------------
    localparam PAD0 = log2ceil(64'h10000 - 64'h0); 
    localparam PAD1 = log2ceil(64'h15000 - 64'h14800); 
    localparam PAD2 = log2ceil(64'h15020 - 64'h15000); 
    localparam PAD3 = log2ceil(64'h15040 - 64'h15020); 
    localparam PAD4 = log2ceil(64'h15060 - 64'h15040); 
    localparam PAD5 = log2ceil(64'h15080 - 64'h15060); 
    localparam PAD6 = log2ceil(64'h150a0 - 64'h15080); 
    localparam PAD7 = log2ceil(64'h150c0 - 64'h150a0); 
    localparam PAD8 = log2ceil(64'h150e0 - 64'h150c0); 
    localparam PAD9 = log2ceil(64'h15100 - 64'h150e0); 
    localparam PAD10 = log2ceil(64'h15120 - 64'h15100); 
    localparam PAD11 = log2ceil(64'h15140 - 64'h15120); 
    localparam PAD12 = log2ceil(64'h15150 - 64'h15140); 
    localparam PAD13 = log2ceil(64'h15160 - 64'h15150); 
    localparam PAD14 = log2ceil(64'h15170 - 64'h15160); 
    localparam PAD15 = log2ceil(64'h15180 - 64'h15170); 
    localparam PAD16 = log2ceil(64'h15190 - 64'h15180); 
    localparam PAD17 = log2ceil(64'h151a0 - 64'h15190); 
    localparam PAD18 = log2ceil(64'h151b0 - 64'h151a0); 
    localparam PAD19 = log2ceil(64'h151c0 - 64'h151b0); 
    localparam PAD20 = log2ceil(64'h151d0 - 64'h151c0); 
    localparam PAD21 = log2ceil(64'h151e0 - 64'h151d0); 
    localparam PAD22 = log2ceil(64'h151f0 - 64'h151e0); 
    localparam PAD23 = log2ceil(64'h15200 - 64'h151f0); 
    localparam PAD24 = log2ceil(64'h15210 - 64'h15200); 
    localparam PAD25 = log2ceil(64'h15220 - 64'h15210); 
    localparam PAD26 = log2ceil(64'h15230 - 64'h15220); 
    localparam PAD27 = log2ceil(64'h15240 - 64'h15230); 
    localparam PAD28 = log2ceil(64'h15250 - 64'h15240); 
    localparam PAD29 = log2ceil(64'h15260 - 64'h15250); 
    localparam PAD30 = log2ceil(64'h15270 - 64'h15260); 
    localparam PAD31 = log2ceil(64'h15280 - 64'h15270); 
    localparam PAD32 = log2ceil(64'h15290 - 64'h15280); 
    localparam PAD33 = log2ceil(64'h152a0 - 64'h15290); 
    localparam PAD34 = log2ceil(64'h152b0 - 64'h152a0); 
    localparam PAD35 = log2ceil(64'h152c0 - 64'h152b0); 
    localparam PAD36 = log2ceil(64'h152d0 - 64'h152c0); 
    localparam PAD37 = log2ceil(64'h152e0 - 64'h152d0); 
    localparam PAD38 = log2ceil(64'h152f0 - 64'h152e0); 
    localparam PAD39 = log2ceil(64'h15300 - 64'h152f0); 
    localparam PAD40 = log2ceil(64'h15310 - 64'h15300); 
    localparam PAD41 = log2ceil(64'h15320 - 64'h15310); 
    localparam PAD42 = log2ceil(64'h15330 - 64'h15320); 
    localparam PAD43 = log2ceil(64'h15340 - 64'h15330); 
    localparam PAD44 = log2ceil(64'h15350 - 64'h15340); 
    localparam PAD45 = log2ceil(64'h15360 - 64'h15350); 
    localparam PAD46 = log2ceil(64'h15370 - 64'h15360); 
    localparam PAD47 = log2ceil(64'h15380 - 64'h15370); 
    localparam PAD48 = log2ceil(64'h15388 - 64'h15380); 
    localparam PAD49 = log2ceil(64'h15390 - 64'h15388); 
    // -------------------------------------------------------
    // Work out which address bits are significant based on the
    // address range of the slaves. If the required width is too
    // large or too small, we use the address field width instead.
    // -------------------------------------------------------
    localparam ADDR_RANGE = 64'h15390;
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
    wire [50-1 : 0] default_src_channel;




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

    // ( 0x0 .. 0x10000 )
    if ( {address[RG:PAD0],{PAD0{1'b0}}} == 17'h0   ) begin
            src_channel = 50'b00000000000000000000000000000000000000000000000010;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 18;
    end

    // ( 0x14800 .. 0x15000 )
    if ( {address[RG:PAD1],{PAD1{1'b0}}} == 17'h14800   ) begin
            src_channel = 50'b00000000000000000000000000000000000000000000000001;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 17;
    end

    // ( 0x15000 .. 0x15020 )
    if ( {address[RG:PAD2],{PAD2{1'b0}}} == 17'h15000   ) begin
            src_channel = 50'b00010000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 8;
    end

    // ( 0x15020 .. 0x15040 )
    if ( {address[RG:PAD3],{PAD3{1'b0}}} == 17'h15020   ) begin
            src_channel = 50'b00001000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 12;
    end

    // ( 0x15040 .. 0x15060 )
    if ( {address[RG:PAD4],{PAD4{1'b0}}} == 17'h15040   ) begin
            src_channel = 50'b00000100000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 16;
    end

    // ( 0x15060 .. 0x15080 )
    if ( {address[RG:PAD5],{PAD5{1'b0}}} == 17'h15060   ) begin
            src_channel = 50'b00000000000000100000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 25;
    end

    // ( 0x15080 .. 0x150a0 )
    if ( {address[RG:PAD6],{PAD6{1'b0}}} == 17'h15080   ) begin
            src_channel = 50'b00000000000000000000100000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 29;
    end

    // ( 0x150a0 .. 0x150c0 )
    if ( {address[RG:PAD7],{PAD7{1'b0}}} == 17'h150a0   ) begin
            src_channel = 50'b00000000000000000000010000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 49;
    end

    // ( 0x150c0 .. 0x150e0 )
    if ( {address[RG:PAD8],{PAD8{1'b0}}} == 17'h150c0   ) begin
            src_channel = 50'b00000000000000000000000000100000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 2;
    end

    // ( 0x150e0 .. 0x15100 )
    if ( {address[RG:PAD9],{PAD9{1'b0}}} == 17'h150e0   ) begin
            src_channel = 50'b00000000000000000000000000000000010000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 47;
    end

    // ( 0x15100 .. 0x15120 )
    if ( {address[RG:PAD10],{PAD10{1'b0}}} == 17'h15100   ) begin
            src_channel = 50'b00000000000000000000000000000000001000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 42;
    end

    // ( 0x15120 .. 0x15140 )
    if ( {address[RG:PAD11],{PAD11{1'b0}}} == 17'h15120   ) begin
            src_channel = 50'b00000000000000000000000000000000000000001000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 39;
    end

    // ( 0x15140 .. 0x15150 )
    if ( {address[RG:PAD12],{PAD12{1'b0}}} == 17'h15140   ) begin
            src_channel = 50'b10000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 15;
    end

    // ( 0x15150 .. 0x15160 )
    if ( {address[RG:PAD13],{PAD13{1'b0}}} == 17'h15150   ) begin
            src_channel = 50'b01000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 9;
    end

    // ( 0x15160 .. 0x15170 )
    if ( {address[RG:PAD14],{PAD14{1'b0}}} == 17'h15160   ) begin
            src_channel = 50'b00100000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 13;
    end

    // ( 0x15170 .. 0x15180 )
    if ( {address[RG:PAD15],{PAD15{1'b0}}} == 17'h15170   ) begin
            src_channel = 50'b00000010000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 10;
    end

    // ( 0x15180 .. 0x15190 )
    if ( {address[RG:PAD16],{PAD16{1'b0}}} == 17'h15180   ) begin
            src_channel = 50'b00000001000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 14;
    end

    // ( 0x15190 .. 0x151a0 )
    if ( {address[RG:PAD17],{PAD17{1'b0}}} == 17'h15190   ) begin
            src_channel = 50'b00000000100000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 7;
    end

    // ( 0x151a0 .. 0x151b0 )
    if ( {address[RG:PAD18],{PAD18{1'b0}}} == 17'h151a0   ) begin
            src_channel = 50'b00000000010000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 11;
    end

    // ( 0x151b0 .. 0x151c0 )
    if ( {address[RG:PAD19],{PAD19{1'b0}}} == 17'h151b0   ) begin
            src_channel = 50'b00000000001000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 23;
    end

    // ( 0x151c0 .. 0x151d0 )
    if ( {address[RG:PAD20],{PAD20{1'b0}}} == 17'h151c0   ) begin
            src_channel = 50'b00000000000100000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 24;
    end

    // ( 0x151d0 .. 0x151e0 )
    if ( {address[RG:PAD21],{PAD21{1'b0}}} == 17'h151d0   ) begin
            src_channel = 50'b00000000000010000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 28;
    end

    // ( 0x151e0 .. 0x151f0 )
    if ( {address[RG:PAD22],{PAD22{1'b0}}} == 17'h151e0   ) begin
            src_channel = 50'b00000000000001000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 27;
    end

    // ( 0x151f0 .. 0x15200 )
    if ( {address[RG:PAD23],{PAD23{1'b0}}} == 17'h151f0   ) begin
            src_channel = 50'b00000000000000010000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 26;
    end

    // ( 0x15200 .. 0x15210 )
    if ( {address[RG:PAD24],{PAD24{1'b0}}} == 17'h15200   ) begin
            src_channel = 50'b00000000000000001000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 21;
    end

    // ( 0x15210 .. 0x15220 )
    if ( {address[RG:PAD25],{PAD25{1'b0}}} == 17'h15210   ) begin
            src_channel = 50'b00000000000000000100000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 22;
    end

    // ( 0x15220 .. 0x15230 )
    if ( {address[RG:PAD26],{PAD26{1'b0}}} == 17'h15220   ) begin
            src_channel = 50'b00000000000000000010000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 19;
    end

    // ( 0x15230 .. 0x15240 )
    if ( {address[RG:PAD27],{PAD27{1'b0}}} == 17'h15230   ) begin
            src_channel = 50'b00000000000000000001000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 20;
    end

    // ( 0x15240 .. 0x15250 )
    if ( {address[RG:PAD28],{PAD28{1'b0}}} == 17'h15240   ) begin
            src_channel = 50'b00000000000000000000001000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 48;
    end

    // ( 0x15250 .. 0x15260 )
    if ( {address[RG:PAD29],{PAD29{1'b0}}} == 17'h15250   ) begin
            src_channel = 50'b00000000000000000000000100000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 4;
    end

    // ( 0x15260 .. 0x15270 )
    if ( {address[RG:PAD30],{PAD30{1'b0}}} == 17'h15260   ) begin
            src_channel = 50'b00000000000000000000000010000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 3;
    end

    // ( 0x15270 .. 0x15280 )
    if ( {address[RG:PAD31],{PAD31{1'b0}}} == 17'h15270   ) begin
            src_channel = 50'b00000000000000000000000001000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 0;
    end

    // ( 0x15280 .. 0x15290 )
    if ( {address[RG:PAD32],{PAD32{1'b0}}} == 17'h15280   ) begin
            src_channel = 50'b00000000000000000000000000010000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 1;
    end

    // ( 0x15290 .. 0x152a0 )
    if ( {address[RG:PAD33],{PAD33{1'b0}}} == 17'h15290   ) begin
            src_channel = 50'b00000000000000000000000000001000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 43;
    end

    // ( 0x152a0 .. 0x152b0 )
    if ( {address[RG:PAD34],{PAD34{1'b0}}} == 17'h152a0   ) begin
            src_channel = 50'b00000000000000000000000000000100000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 44;
    end

    // ( 0x152b0 .. 0x152c0 )
    if ( {address[RG:PAD35],{PAD35{1'b0}}} == 17'h152b0   ) begin
            src_channel = 50'b00000000000000000000000000000010000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 45;
    end

    // ( 0x152c0 .. 0x152d0 )
    if ( {address[RG:PAD36],{PAD36{1'b0}}} == 17'h152c0   ) begin
            src_channel = 50'b00000000000000000000000000000001000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 41;
    end

    // ( 0x152d0 .. 0x152e0 )
    if ( {address[RG:PAD37],{PAD37{1'b0}}} == 17'h152d0   ) begin
            src_channel = 50'b00000000000000000000000000000000100000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 40;
    end

    // ( 0x152e0 .. 0x152f0 )
    if ( {address[RG:PAD38],{PAD38{1'b0}}} == 17'h152e0   ) begin
            src_channel = 50'b00000000000000000000000000000000000100000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 46;
    end

    // ( 0x152f0 .. 0x15300 )
    if ( {address[RG:PAD39],{PAD39{1'b0}}} == 17'h152f0   ) begin
            src_channel = 50'b00000000000000000000000000000000000010000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 38;
    end

    // ( 0x15300 .. 0x15310 )
    if ( {address[RG:PAD40],{PAD40{1'b0}}} == 17'h15300   ) begin
            src_channel = 50'b00000000000000000000000000000000000001000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 36;
    end

    // ( 0x15310 .. 0x15320 )
    if ( {address[RG:PAD41],{PAD41{1'b0}}} == 17'h15310   ) begin
            src_channel = 50'b00000000000000000000000000000000000000100000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 34;
    end

    // ( 0x15320 .. 0x15330 )
    if ( {address[RG:PAD42],{PAD42{1'b0}}} == 17'h15320   ) begin
            src_channel = 50'b00000000000000000000000000000000000000010000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 32;
    end

    // ( 0x15330 .. 0x15340 )
    if ( {address[RG:PAD43],{PAD43{1'b0}}} == 17'h15330   ) begin
            src_channel = 50'b00000000000000000000000000000000000000000100000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 37;
    end

    // ( 0x15340 .. 0x15350 )
    if ( {address[RG:PAD44],{PAD44{1'b0}}} == 17'h15340   ) begin
            src_channel = 50'b00000000000000000000000000000000000000000010000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 35;
    end

    // ( 0x15350 .. 0x15360 )
    if ( {address[RG:PAD45],{PAD45{1'b0}}} == 17'h15350   ) begin
            src_channel = 50'b00000000000000000000000000000000000000000001000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 33;
    end

    // ( 0x15360 .. 0x15370 )
    if ( {address[RG:PAD46],{PAD46{1'b0}}} == 17'h15360   ) begin
            src_channel = 50'b00000000000000000000000000000000000000000000100000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 31;
    end

    // ( 0x15370 .. 0x15380 )
    if ( {address[RG:PAD47],{PAD47{1'b0}}} == 17'h15370   ) begin
            src_channel = 50'b00000000000000000000000000000000000000000000010000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 5;
    end

    // ( 0x15380 .. 0x15388 )
    if ( {address[RG:PAD48],{PAD48{1'b0}}} == 17'h15380   ) begin
            src_channel = 50'b00000000000000000000000000000000000000000000001000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 6;
    end

    // ( 0x15388 .. 0x15390 )
    if ( {address[RG:PAD49],{PAD49{1'b0}}} == 17'h15388  && read_transaction  ) begin
            src_channel = 50'b00000000000000000000000000000000000000000000000100;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 30;
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


