///////////////////////////////////////////////////////////////////////////////////////////////////
// Company: <Name>
//
// File: get_data.v
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

module get_data(
    input wire clk,
    input wire res,
    input wire write_en0,
    input wire right_addr,
    input wire [31:0] pwdata,
    output reg [31:0] data
    );
    wire write_en = write_en0 & right_addr;
    always @(posedge clk) begin
        //if (~res) begin
        //    data <= 0;
        //end
        if (write_en) 
            data <= pwdata;
    end

endmodule

