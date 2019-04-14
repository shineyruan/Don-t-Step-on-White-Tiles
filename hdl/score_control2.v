///////////////////////////////////////////////////////////////////////////////////////////////////
// Company: <Name>
//
// File: score_control2.v
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

module get_score( 
    input wire clk,
    input wire res,
    input wire write_en0,
    input wire right_addr,
    input wire [31:0] pwdata,
    input wire animate,
    input wire [9:0] x,
    input wire [8:0] y,
    output wire num,
    input wire [6:0] x1,
    input wire [6:0] x2,
    input wire [6:0] x3
    );
    wire [31:0] data;
    get_data read_sq_info(
        .clk(clk),
        .res(res),
        .write_en0(write_en0),
        .right_addr(right_addr),
        .pwdata(pwdata),
        .data(data)
    );
    reg [31:0] num_data;
    always @(posedge clk) begin
        if (animate) begin
            num_data <= data;
        end
    end
    
    reg[5:0] pos;
    always @(posedge clk) begin
        if (x == 0 && y == 0)
            pos <= 0;
        else if (((y >= 12) & (y < 108)) & ((x == x1) | (x == x2) | (x == x3)))
            pos <= pos + 1;
        else if (x == 600 & ((y >= 12) & (y < 108))) begin
            //begin next line
            if ((y == 24) | (y == 36) | (y == 48) | (y == 60) | (y == 72) | (y == 84) | (y == 96))
                pos <= pos + 1;
            else
                pos <= pos - 3;
        end
    end
    assign num = (x >= x1 - 12) & (x < x3 + 12) & (y >= 12) & (y < 108) & num_data[pos];
endmodule
