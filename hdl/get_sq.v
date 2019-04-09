///////////////////////////////////////////////////////////////////////////////////////////////////
// Company: <Name>
//
// File: get_sq.v
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

module get_sq(
    input wire clk,
    input wire res,
    input wire write_en0,
    input wire right_addr,
    input wire [31:0] pwdata,
    input wire [31:0] col1,
    input wire animate,
    input wire [9:0] x,
    input wire [8:0] y,
    output wire sq,
    output reg left_foot,
    output reg right_foot
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
    reg [9:0] top_x, top_y, length;
    always @(posedge clk) begin
        if (animate) begin
            top_x <= data[9:0];
            top_y <= data[19:10];
            length <= data[29:20];
            left_foot <= data[30];
            right_foot <= data[31];
        end
    end
    assign sq = ((y > top_y) & (y < top_y + length) & (x > top_x) & (x < top_x + col1[29:20] - col1[19:10] + col1[9:0]))?1:0;

endmodule

