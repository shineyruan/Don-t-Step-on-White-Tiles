///////////////////////////////////////////////////////////////////////////////////////////////////
// Company: <Name>
//
// File: SoundBoard.v
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

module SoundBoard( 
input PCLK,
input PRESERN,
input PSEL,
input PENABLE,
output wire PREADY,
output wire PSLVERR,
input PWRITE,
input [31:0] PADDR,
input [31:0] PWDATA,
output reg [31:0] PRDATA,
output reg reset,
output reg [5:0] selection
);

assign PSLVERR = 0;
assign PREADY = 1;
wire write_en = PENABLE & PSEL & PWRITE & (PADDR == 32'h40050100);
wire read_en = (~PWRITE) & PSEL & (PADDR == 32'h40050100);

always @ (posedge PCLK) 
    begin
        if (~PRESERN)
            reset <= 0;
        else if (write_en) begin
            selection <= PWDATA[5:0];
            reset <= PWDATA[6];
        end
        else if (read_en) begin
            PRDATA[5:0] <= selection;
            PRDATA[6] <= reset;
            PRDATA[31:7] <= 25'b0;
        end
    end
//<statements>

endmodule

