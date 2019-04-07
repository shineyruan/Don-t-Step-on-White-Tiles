///////////////////////////////////////////////////////////////////////////////////////////////////
// Company: <Name>
//
// File: sram_control.v
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

module sram_control( 
    input wire PCLK,
    input wire PRESERN,
    input PSEL,
    input PENABLE,
    output wire PSLVERR,
    output reg PREADY,
    input PWRITE,
    input [31:0] PADDR,
    input wire [31:0] PWDATA,
    output reg [31:0] PRDATA,
    output reg wen,
    output reg ren,
    output wire [9:0] WADDR,
    output wire [9:0] RADDR,
    input wire [31:0] RD,
    output reg [31:0] WD
    );
    
    assign PSLVERR = 0;
    wire write_en = PWRITE&PENABLE&PSEL;
    wire read_en = (~PWRITE)&PENABLE&PSEL;

    assign RADDR = PADDR[9:0];
    assign WADDR = PADDR[9:0];
    
    //assign PRDATA = RD;
    //assign WD = PWDATA;
    
    always @(posedge PCLK) begin
        if (write_en) begin
            wen <= 1;
            ren <= 0;
            //PREADY <= (~PREADY);
            //WADDR <= PADDR;
            WD <= PWDATA;
        end else if (read_en) begin
            ren <= 1;
            wen <= 0;
            //RADDR <= PADDR;
            //PREADY <= (~PREADY);
            PRDATA <= RD;
        end else begin
            ren <= 0;    
            wen <= 0;
        end
    end
    assign act = read_en | write_en;
    reg Q1, Q2;
    always @(posedge PCLK) begin
        Q1 <= act;
        Q2 <= Q1;
        PREADY <= Q1;
    end
endmodule

