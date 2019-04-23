//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Mon Apr 22 20:36:46 2019
// Version: v11.9 SP3 11.9.3.5
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

// DSWT
module DSWT(
    // Inputs
    MSS_RESET_N,
    SPI_1_DI,
    UART_0_RXD,
    UART_1_RXD,
    data,
    // Outputs
    GPIO_0_OUT,
    SPI_1_DO,
    UART_0_TXD,
    UART_1_TXD,
    VGA_B,
    VGA_G,
    VGA_HS_O,
    VGA_R,
    VGA_VS_O,
    clock,
    latch,
    reset,
    selection,
    // Inouts
    SPI_1_CLK,
    SPI_1_SS
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input        MSS_RESET_N;
input        SPI_1_DI;
input        UART_0_RXD;
input        UART_1_RXD;
input        data;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output       GPIO_0_OUT;
output       SPI_1_DO;
output       UART_0_TXD;
output       UART_1_TXD;
output       VGA_B;
output       VGA_G;
output       VGA_HS_O;
output       VGA_R;
output       VGA_VS_O;
output       clock;
output       latch;
output       reset;
output [5:0] selection;
//--------------------------------------------------------------------
// Inout
//--------------------------------------------------------------------
inout        SPI_1_CLK;
inout        SPI_1_SS;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire          clock_net_0;
wire          Core_Control_0_FABINT;
wire   [31:0] CoreAPB3_0_APBmslave0_PADDR;
wire          CoreAPB3_0_APBmslave0_PENABLE;
wire   [31:0] CoreAPB3_0_APBmslave0_PRDATA;
wire          CoreAPB3_0_APBmslave0_PREADY;
wire          CoreAPB3_0_APBmslave0_PSELx;
wire          CoreAPB3_0_APBmslave0_PSLVERR;
wire   [31:0] CoreAPB3_0_APBmslave0_PWDATA;
wire          CoreAPB3_0_APBmslave0_PWRITE;
wire          data;
wire          DSWT_MSS_0_FAB_CLK;
wire          DSWT_MSS_0_M2F_RESET_N;
wire          DSWT_MSS_0_MSS_MASTER_APB_PENABLE;
wire   [31:0] DSWT_MSS_0_MSS_MASTER_APB_PRDATA;
wire          DSWT_MSS_0_MSS_MASTER_APB_PREADY;
wire          DSWT_MSS_0_MSS_MASTER_APB_PSELx;
wire          DSWT_MSS_0_MSS_MASTER_APB_PSLVERR;
wire   [31:0] DSWT_MSS_0_MSS_MASTER_APB_PWDATA;
wire          DSWT_MSS_0_MSS_MASTER_APB_PWRITE;
wire          GPIO_0_OUT_0;
wire          latch_net_0;
wire          MSS_RESET_N;
wire          reset_net_0;
wire   [5:0]  selection_net_0;
wire          SPI_1_CLK;
wire          SPI_1_DI;
wire          SPI_1_DO_net_0;
wire          SPI_1_SS;
wire          UART_0_RXD;
wire          UART_0_TXD_net_0;
wire          UART_1_RXD;
wire          UART_1_TXD_net_0;
wire          VGA_B_net_0;
wire          VGA_G_net_0;
wire          VGA_HS_O_net_0;
wire          VGA_R_net_0;
wire          VGA_VS_O_net_0;
wire          UART_1_TXD_net_1;
wire          UART_0_TXD_net_1;
wire          SPI_1_DO_net_1;
wire          VGA_HS_O_net_1;
wire          VGA_VS_O_net_1;
wire          VGA_R_net_1;
wire          VGA_G_net_1;
wire          VGA_B_net_1;
wire          reset_net_1;
wire          latch_net_1;
wire          clock_net_1;
wire   [5:0]  selection_net_1;
wire          GPIO_0_OUT_0_net_0;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire          GND_net;
wire          VCC_net;
wire   [31:0] IADDR_const_net_0;
wire   [31:0] PRDATAS1_const_net_0;
wire   [31:0] PRDATAS2_const_net_0;
wire   [31:0] PRDATAS3_const_net_0;
wire   [31:0] PRDATAS4_const_net_0;
wire   [31:0] PRDATAS5_const_net_0;
wire   [31:0] PRDATAS6_const_net_0;
wire   [31:0] PRDATAS7_const_net_0;
wire   [31:0] PRDATAS8_const_net_0;
wire   [31:0] PRDATAS9_const_net_0;
wire   [31:0] PRDATAS10_const_net_0;
wire   [31:0] PRDATAS11_const_net_0;
wire   [31:0] PRDATAS12_const_net_0;
wire   [31:0] PRDATAS13_const_net_0;
wire   [31:0] PRDATAS14_const_net_0;
wire   [31:0] PRDATAS15_const_net_0;
wire   [31:0] PRDATAS16_const_net_0;
//--------------------------------------------------------------------
// Bus Interface Nets Declarations - Unequal Pin Widths
//--------------------------------------------------------------------
wire   [31:20]DSWT_MSS_0_MSS_MASTER_APB_PADDR_0_31to20;
wire   [19:0] DSWT_MSS_0_MSS_MASTER_APB_PADDR_0_19to0;
wire   [31:0] DSWT_MSS_0_MSS_MASTER_APB_PADDR_0;
wire   [19:0] DSWT_MSS_0_MSS_MASTER_APB_PADDR;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign GND_net               = 1'b0;
assign VCC_net               = 1'b1;
assign IADDR_const_net_0     = 32'h00000000;
assign PRDATAS1_const_net_0  = 32'h00000000;
assign PRDATAS2_const_net_0  = 32'h00000000;
assign PRDATAS3_const_net_0  = 32'h00000000;
assign PRDATAS4_const_net_0  = 32'h00000000;
assign PRDATAS5_const_net_0  = 32'h00000000;
assign PRDATAS6_const_net_0  = 32'h00000000;
assign PRDATAS7_const_net_0  = 32'h00000000;
assign PRDATAS8_const_net_0  = 32'h00000000;
assign PRDATAS9_const_net_0  = 32'h00000000;
assign PRDATAS10_const_net_0 = 32'h00000000;
assign PRDATAS11_const_net_0 = 32'h00000000;
assign PRDATAS12_const_net_0 = 32'h00000000;
assign PRDATAS13_const_net_0 = 32'h00000000;
assign PRDATAS14_const_net_0 = 32'h00000000;
assign PRDATAS15_const_net_0 = 32'h00000000;
assign PRDATAS16_const_net_0 = 32'h00000000;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign UART_1_TXD_net_1   = UART_1_TXD_net_0;
assign UART_1_TXD         = UART_1_TXD_net_1;
assign UART_0_TXD_net_1   = UART_0_TXD_net_0;
assign UART_0_TXD         = UART_0_TXD_net_1;
assign SPI_1_DO_net_1     = SPI_1_DO_net_0;
assign SPI_1_DO           = SPI_1_DO_net_1;
assign VGA_HS_O_net_1     = VGA_HS_O_net_0;
assign VGA_HS_O           = VGA_HS_O_net_1;
assign VGA_VS_O_net_1     = VGA_VS_O_net_0;
assign VGA_VS_O           = VGA_VS_O_net_1;
assign VGA_R_net_1        = VGA_R_net_0;
assign VGA_R              = VGA_R_net_1;
assign VGA_G_net_1        = VGA_G_net_0;
assign VGA_G              = VGA_G_net_1;
assign VGA_B_net_1        = VGA_B_net_0;
assign VGA_B              = VGA_B_net_1;
assign reset_net_1        = reset_net_0;
assign reset              = reset_net_1;
assign latch_net_1        = latch_net_0;
assign latch              = latch_net_1;
assign clock_net_1        = clock_net_0;
assign clock              = clock_net_1;
assign selection_net_1    = selection_net_0;
assign selection[5:0]     = selection_net_1;
assign GPIO_0_OUT_0_net_0 = GPIO_0_OUT_0;
assign GPIO_0_OUT         = GPIO_0_OUT_0_net_0;
//--------------------------------------------------------------------
// Bus Interface Nets Assignments - Unequal Pin Widths
//--------------------------------------------------------------------
assign DSWT_MSS_0_MSS_MASTER_APB_PADDR_0_31to20 = 12'h0;
assign DSWT_MSS_0_MSS_MASTER_APB_PADDR_0_19to0 = DSWT_MSS_0_MSS_MASTER_APB_PADDR[19:0];
assign DSWT_MSS_0_MSS_MASTER_APB_PADDR_0 = { DSWT_MSS_0_MSS_MASTER_APB_PADDR_0_31to20, DSWT_MSS_0_MSS_MASTER_APB_PADDR_0_19to0 };

//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------Core_Control
Core_Control Core_Control_0(
        // Inputs
        .PCLK      ( DSWT_MSS_0_FAB_CLK ),
        .PRESERN   ( DSWT_MSS_0_M2F_RESET_N ),
        .PSEL      ( CoreAPB3_0_APBmslave0_PSELx ),
        .PENABLE   ( CoreAPB3_0_APBmslave0_PENABLE ),
        .PWRITE    ( CoreAPB3_0_APBmslave0_PWRITE ),
        .data      ( data ),
        .PADDR     ( CoreAPB3_0_APBmslave0_PADDR ),
        .PWDATA    ( CoreAPB3_0_APBmslave0_PWDATA ),
        // Outputs
        .PREADY    ( CoreAPB3_0_APBmslave0_PREADY ),
        .PSLVERR   ( CoreAPB3_0_APBmslave0_PSLVERR ),
        .VGA_HS_O  ( VGA_HS_O_net_0 ),
        .VGA_VS_O  ( VGA_VS_O_net_0 ),
        .VGA_R     ( VGA_R_net_0 ),
        .VGA_G     ( VGA_G_net_0 ),
        .VGA_B     ( VGA_B_net_0 ),
        .reset     ( reset_net_0 ),
        .latch     ( latch_net_0 ),
        .clock     ( clock_net_0 ),
        .FABINT    ( Core_Control_0_FABINT ),
        .PRDATA    ( CoreAPB3_0_APBmslave0_PRDATA ),
        .selection ( selection_net_0 ) 
        );

//--------CoreAPB3   -   Actel:DirectCore:CoreAPB3:4.1.100
CoreAPB3 #( 
        .APB_DWIDTH      ( 32 ),
        .APBSLOT0ENABLE  ( 1 ),
        .APBSLOT1ENABLE  ( 0 ),
        .APBSLOT2ENABLE  ( 0 ),
        .APBSLOT3ENABLE  ( 0 ),
        .APBSLOT4ENABLE  ( 0 ),
        .APBSLOT5ENABLE  ( 0 ),
        .APBSLOT6ENABLE  ( 0 ),
        .APBSLOT7ENABLE  ( 0 ),
        .APBSLOT8ENABLE  ( 0 ),
        .APBSLOT9ENABLE  ( 0 ),
        .APBSLOT10ENABLE ( 0 ),
        .APBSLOT11ENABLE ( 0 ),
        .APBSLOT12ENABLE ( 0 ),
        .APBSLOT13ENABLE ( 0 ),
        .APBSLOT14ENABLE ( 0 ),
        .APBSLOT15ENABLE ( 0 ),
        .FAMILY          ( 18 ),
        .IADDR_OPTION    ( 0 ),
        .MADDR_BITS      ( 16 ),
        .SC_0            ( 0 ),
        .SC_1            ( 0 ),
        .SC_2            ( 0 ),
        .SC_3            ( 0 ),
        .SC_4            ( 0 ),
        .SC_5            ( 0 ),
        .SC_6            ( 0 ),
        .SC_7            ( 0 ),
        .SC_8            ( 0 ),
        .SC_9            ( 0 ),
        .SC_10           ( 0 ),
        .SC_11           ( 0 ),
        .SC_12           ( 0 ),
        .SC_13           ( 0 ),
        .SC_14           ( 0 ),
        .SC_15           ( 0 ),
        .UPR_NIBBLE_POSN ( 3 ) )
CoreAPB3_0(
        // Inputs
        .PRESETN    ( GND_net ), // tied to 1'b0 from definition
        .PCLK       ( GND_net ), // tied to 1'b0 from definition
        .PWRITE     ( DSWT_MSS_0_MSS_MASTER_APB_PWRITE ),
        .PENABLE    ( DSWT_MSS_0_MSS_MASTER_APB_PENABLE ),
        .PSEL       ( DSWT_MSS_0_MSS_MASTER_APB_PSELx ),
        .PREADYS0   ( CoreAPB3_0_APBmslave0_PREADY ),
        .PSLVERRS0  ( CoreAPB3_0_APBmslave0_PSLVERR ),
        .PREADYS1   ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS1  ( GND_net ), // tied to 1'b0 from definition
        .PREADYS2   ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS2  ( GND_net ), // tied to 1'b0 from definition
        .PREADYS3   ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS3  ( GND_net ), // tied to 1'b0 from definition
        .PREADYS4   ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS4  ( GND_net ), // tied to 1'b0 from definition
        .PREADYS5   ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS5  ( GND_net ), // tied to 1'b0 from definition
        .PREADYS6   ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS6  ( GND_net ), // tied to 1'b0 from definition
        .PREADYS7   ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS7  ( GND_net ), // tied to 1'b0 from definition
        .PREADYS8   ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS8  ( GND_net ), // tied to 1'b0 from definition
        .PREADYS9   ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS9  ( GND_net ), // tied to 1'b0 from definition
        .PREADYS10  ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS10 ( GND_net ), // tied to 1'b0 from definition
        .PREADYS11  ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS11 ( GND_net ), // tied to 1'b0 from definition
        .PREADYS12  ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS12 ( GND_net ), // tied to 1'b0 from definition
        .PREADYS13  ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS13 ( GND_net ), // tied to 1'b0 from definition
        .PREADYS14  ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS14 ( GND_net ), // tied to 1'b0 from definition
        .PREADYS15  ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS15 ( GND_net ), // tied to 1'b0 from definition
        .PREADYS16  ( VCC_net ), // tied to 1'b1 from definition
        .PSLVERRS16 ( GND_net ), // tied to 1'b0 from definition
        .PADDR      ( DSWT_MSS_0_MSS_MASTER_APB_PADDR_0 ),
        .PWDATA     ( DSWT_MSS_0_MSS_MASTER_APB_PWDATA ),
        .PRDATAS0   ( CoreAPB3_0_APBmslave0_PRDATA ),
        .PRDATAS1   ( PRDATAS1_const_net_0 ), // tied to 32'h00000000 from definition
        .PRDATAS2   ( PRDATAS2_const_net_0 ), // tied to 32'h00000000 from definition
        .PRDATAS3   ( PRDATAS3_const_net_0 ), // tied to 32'h00000000 from definition
        .PRDATAS4   ( PRDATAS4_const_net_0 ), // tied to 32'h00000000 from definition
        .PRDATAS5   ( PRDATAS5_const_net_0 ), // tied to 32'h00000000 from definition
        .PRDATAS6   ( PRDATAS6_const_net_0 ), // tied to 32'h00000000 from definition
        .PRDATAS7   ( PRDATAS7_const_net_0 ), // tied to 32'h00000000 from definition
        .PRDATAS8   ( PRDATAS8_const_net_0 ), // tied to 32'h00000000 from definition
        .PRDATAS9   ( PRDATAS9_const_net_0 ), // tied to 32'h00000000 from definition
        .PRDATAS10  ( PRDATAS10_const_net_0 ), // tied to 32'h00000000 from definition
        .PRDATAS11  ( PRDATAS11_const_net_0 ), // tied to 32'h00000000 from definition
        .PRDATAS12  ( PRDATAS12_const_net_0 ), // tied to 32'h00000000 from definition
        .PRDATAS13  ( PRDATAS13_const_net_0 ), // tied to 32'h00000000 from definition
        .PRDATAS14  ( PRDATAS14_const_net_0 ), // tied to 32'h00000000 from definition
        .PRDATAS15  ( PRDATAS15_const_net_0 ), // tied to 32'h00000000 from definition
        .PRDATAS16  ( PRDATAS16_const_net_0 ), // tied to 32'h00000000 from definition
        .IADDR      ( IADDR_const_net_0 ), // tied to 32'h00000000 from definition
        // Outputs
        .PREADY     ( DSWT_MSS_0_MSS_MASTER_APB_PREADY ),
        .PSLVERR    ( DSWT_MSS_0_MSS_MASTER_APB_PSLVERR ),
        .PWRITES    ( CoreAPB3_0_APBmslave0_PWRITE ),
        .PENABLES   ( CoreAPB3_0_APBmslave0_PENABLE ),
        .PSELS0     ( CoreAPB3_0_APBmslave0_PSELx ),
        .PSELS1     (  ),
        .PSELS2     (  ),
        .PSELS3     (  ),
        .PSELS4     (  ),
        .PSELS5     (  ),
        .PSELS6     (  ),
        .PSELS7     (  ),
        .PSELS8     (  ),
        .PSELS9     (  ),
        .PSELS10    (  ),
        .PSELS11    (  ),
        .PSELS12    (  ),
        .PSELS13    (  ),
        .PSELS14    (  ),
        .PSELS15    (  ),
        .PSELS16    (  ),
        .PRDATA     ( DSWT_MSS_0_MSS_MASTER_APB_PRDATA ),
        .PADDRS     ( CoreAPB3_0_APBmslave0_PADDR ),
        .PWDATAS    ( CoreAPB3_0_APBmslave0_PWDATA ) 
        );

//--------DSWT_MSS
DSWT_MSS DSWT_MSS_0(
        // Inputs
        .UART_0_RXD  ( UART_0_RXD ),
        .UART_1_RXD  ( UART_1_RXD ),
        .SPI_1_DI    ( SPI_1_DI ),
        .MSS_RESET_N ( MSS_RESET_N ),
        .MSSPREADY   ( DSWT_MSS_0_MSS_MASTER_APB_PREADY ),
        .MSSPSLVERR  ( DSWT_MSS_0_MSS_MASTER_APB_PSLVERR ),
        .FABINT      ( Core_Control_0_FABINT ),
        .MSSPRDATA   ( DSWT_MSS_0_MSS_MASTER_APB_PRDATA ),
        // Outputs
        .UART_0_TXD  ( UART_0_TXD_net_0 ),
        .UART_1_TXD  ( UART_1_TXD_net_0 ),
        .SPI_1_DO    ( SPI_1_DO_net_0 ),
        .MSSPSEL     ( DSWT_MSS_0_MSS_MASTER_APB_PSELx ),
        .MSSPENABLE  ( DSWT_MSS_0_MSS_MASTER_APB_PENABLE ),
        .MSSPWRITE   ( DSWT_MSS_0_MSS_MASTER_APB_PWRITE ),
        .M2F_RESET_N ( DSWT_MSS_0_M2F_RESET_N ),
        .FAB_CLK     ( DSWT_MSS_0_FAB_CLK ),
        .MSSPADDR    ( DSWT_MSS_0_MSS_MASTER_APB_PADDR ),
        .MSSPWDATA   ( DSWT_MSS_0_MSS_MASTER_APB_PWDATA ),
        .GPIO_0_OUT  ( GPIO_0_OUT_0 ),
        // Inouts
        .SPI_1_CLK   ( SPI_1_CLK ),
        .SPI_1_SS    ( SPI_1_SS ) 
        );


endmodule
