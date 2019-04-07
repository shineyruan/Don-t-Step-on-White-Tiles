///////////////////////////////////////////////////////////////////////////////////////////////////
// Company: <Name>
//
// File: score_control.v
// File history:
//      <Revision number>: <Date>: <Comments>
//      <Revision number>: <Date>: <Comments>
//      <Revision number>: <Date>: <Comments>
//
// Description: 
//
// <Description here>
//
// Targeted device: <Family::SmartFusion> <Die::A2F200M3F> <Package::484 FBGA>
// Author: <Name>
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 

//`timescale <time_units> / <precision>

module score_control(    
    input wire PCLK,
    input wire PRESERN,
    input PSEL,
    input PENABLE,
    output wire PSLVERR,
    output wire PREADY,
    input PWRITE,
    input [31:0] PADDR,
    input wire [31:0] PWDATA,
    output reg [31:0] PRDATA,
    output reg num,
    input wire [9:0] x,  // current pixel x position: 10-bit value: 0-1023
    input wire [8:0] y
    );
    wire write_en = PWRITE&PENABLE&PSEL;
    wire [31:0] num_data;   
    get_data read_col2(
        .clk(PCLK),
        .res(PRESERN),
        .write_en0(write_en),
        .right_addr(PADDR[11:0] == 12'h000),
        .pwdata(PWDATA),
        .data(num_data)
    );

    always @(posedge PCLK) begin
        if ((x >= 12) & (y >= 12) & (x < 60) & (y < 60))
            num <= 1;
        else
            num <= 0;
    end
    
    //assign num = ((x >= 10) & (x < 111) & (y > 10) & (y < 110) & num_data[(x/12)])? 1:0;

endmodule

