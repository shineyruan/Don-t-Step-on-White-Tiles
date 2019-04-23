module MSS_XTLOSC( 
    XTL, 
    CLKOUT );

/* synthesis syn_black_box */
/* synthesis black_box_pad_pin ="XTL" */

    output CLKOUT;
    input  XTL;
endmodule

module MSS_LPXTLOSC( 
    LPXIN, 
    CLKOUT );

/* synthesis syn_black_box */
/* synthesis black_box_pad_pin ="LPXIN" */

    output CLKOUT;
    input  LPXIN;
endmodule

module INBUF_MSS( 
    PAD, 
    Y );

/* synthesis syn_black_box */
/* synthesis black_box_pad_pin ="PAD" */

    input  PAD;
    output Y;

parameter ACT_PIN    = "";
parameter ACT_CONFIG = 1'b0;
endmodule

module OUTBUF_MSS( 
    D, 
    PAD );

/* synthesis syn_black_box */
/* synthesis black_box_pad_pin ="PAD" */

    input  D;
    output PAD;

parameter ACT_PIN    = "";
parameter ACT_CONFIG = 1'b0;
endmodule

module TRIBUFF_MSS( 
    D, 
    E, 
    PAD );

/* synthesis syn_black_box */
/* synthesis black_box_pad_pin ="PAD" */

    input  D;
    input  E;
    output PAD;

parameter ACT_PIN    = "";
parameter ACT_CONFIG = 1'b0;
endmodule

module BIBUF_MSS(
    PAD,
    D, 
    E, 
    Y );

/* synthesis syn_black_box */
/* synthesis black_box_pad_pin ="PAD" */

    inout  PAD;
    input  D;
    input  E;
    output Y;

parameter ACT_PIN    = "";
parameter ACT_CONFIG = 1'b0;
endmodule

module BIBUF_OPEND_MSS(
    PAD, 
    E, 
    Y );

/* synthesis syn_black_box */
/* synthesis black_box_pad_pin ="PAD" */

    inout PAD;
    input E;
    output Y;

parameter ACT_PIN    = "";
parameter ACT_CONFIG = 1'b0;
endmodule

module INBUF_MCCC( 
    PAD, 
    Y );

/* synthesis syn_black_box */
/* synthesis black_box_pad_pin ="PAD" */

    input  PAD;
    output Y;

parameter ACT_PIN    = "";
parameter ACT_CONFIG = 1'b0;
endmodule

module INBUF_LVPECL_MCCC( 
    PADP, 
    PADN, 
    Y );

/* synthesis syn_black_box */
/* synthesis black_box_pad_pin ="PADP, PADN" */

    input  PADP;
    input  PADN;
    output Y;

parameter ACT_PIN    = "";
endmodule

module INBUF_LVDS_MCCC( 
    PADP, 
    PADN, 
    Y );

/* synthesis syn_black_box */
/* synthesis black_box_pad_pin ="PADP, PADN" */

    input  PADP;
    input  PADN;
    output Y;

parameter ACT_PIN    = "";
endmodule

module MSSINT(Y,A);
/* synthesis syn_black_box */
   input A;
   output Y;
endmodule

module MSS_CCC(
       CLKA,
       EXTFB,
       GLA,
       GLAMSS,
       LOCK,
       LOCKMSS,
       CLKB,
       GLB,
       YB,
       CLKC,
       GLC,
       YC,
       MACCLK,
       OADIV,
       OADIVHALF,
       OAMUX,
       BYPASSA,
       DLYGLA,
       DLYGLAMSS,
       DLYGLAFAB,
       OBDIV,
       OBDIVHALF,
       OBMUX,
       BYPASSB,
       DLYGLB,
       OCDIV,
       OCDIVHALF,
       OCMUX,
       BYPASSC,
       DLYGLC,
       FINDIV,
       FBDIV,
       FBDLY,
       FBSEL,
       XDLYSEL,
       GLMUXSEL,
       GLMUXCFG
    );
/* synthesis syn_black_box */
input  CLKA;
input  EXTFB;
output GLA;
output GLAMSS;
output LOCK;
output LOCKMSS;
input  CLKB;
output GLB;
output YB;
input  CLKC;
output GLC;
output YC;
output MACCLK;
input  [4:0] OADIV;
input  OADIVHALF;
input  [2:0] OAMUX;
input  BYPASSA;
input  [4:0] DLYGLA;
input  [4:0] DLYGLAMSS;
input  [4:0] DLYGLAFAB;
input  [4:0] OBDIV;
input  OBDIVHALF;
input  [2:0] OBMUX;
input  BYPASSB;
input  [4:0] DLYGLB;
input  [4:0] OCDIV;
input  OCDIVHALF;
input  [2:0] OCMUX;
input  BYPASSC;
input  [4:0] DLYGLC;
input  [6:0] FINDIV;
input  [6:0] FBDIV;
input  [4:0] FBDLY;
input  [1:0] FBSEL;
input  XDLYSEL;
input  [1:0] GLMUXSEL;
input  [1:0] GLMUXCFG;

    parameter VCOFREQUENCY = 0.0;

endmodule

module MSS_ALL(
       HMADDR,
       HMWDATA,
       HMTRANS,
       HMSIZE,
       HMMASTLOCK,
       HMAHBWRITE,
       HMRDATA,
       HMAHBREADY,
       HMRESP,
       FMADDR,
       FMWDATA,
       FMTRANS,
       FMSIZE,
       FMMASTLOCK,
       FMAHBWRITE,
       FMAHBSEL,
       FMAHBREADY,
       FMRDATA,
       FMREADYOUT,
       FMRESP,
       HMPSEL,
       HMPENABLE,
       HMPWRITE,
       FMPSLVERR,
       HMPREADY,
       HMPSLVERR,
       FMPSEL,
       FMPENABLE,
       FMPWRITE,
       FMPREADY,

       SYNCCLKFDBK,
       CALIBOUT,
       CALIBIN,
       FABINT,
       MSSINT,
       WDINT,
       F2MRESETn,
       DMAREADY,
       RXEV,
       VRON,
       M2FRESETn,
       DEEPSLEEP,
       SLEEP,
       TXEV,
       UART0CTSn,
       UART0DSRn,
       UART0RIn,
       UART0DCDn,
       UART0RTSn,
       UART0DTRn,
       UART1CTSn,
       UART1DSRn,
       UART1RIn,
       UART1DCDn,
       UART1RTSn,
       UART1DTRn,
       I2C0SMBUSNI,
       I2C0SMBALERTNI,
       I2C0BCLK,
       I2C0SMBUSNO,
       I2C0SMBALERTNO,
       I2C1SMBUSNI,
       I2C1SMBALERTNI,
       I2C1BCLK,
       I2C1SMBUSNO,
       I2C1SMBALERTNO,
       MACM2FTXD,
       MACF2MRXD,
       MACM2FTXEN,
       MACF2MCRSDV,
       MACF2MRXER,
       MACF2MMDI,
       MACM2FMDO,
       MACM2FMDEN,
       MACM2FMDC,
       FABSDD0D,
       FABSDD1D,
       FABSDD2D,
       FABSDD0CLK,
       FABSDD1CLK,
       FABSDD2CLK,
       FABACETRIG,
       ACEFLAGS,
       CMP0,
       CMP1,
       CMP2,
       CMP3,
       CMP4,
       CMP5,
       CMP6,
       CMP7,
       CMP8,
       CMP9,
       CMP10,
       CMP11,
       LVTTL0EN,
       LVTTL1EN,
       LVTTL2EN,
       LVTTL3EN,
       LVTTL4EN,
       LVTTL5EN,
       LVTTL6EN,
       LVTTL7EN,
       LVTTL8EN,
       LVTTL9EN,
       LVTTL10EN,
       LVTTL11EN,
       LVTTL0,
       LVTTL1,
       LVTTL2,
       LVTTL3,
       LVTTL4,
       LVTTL5,
       LVTTL6,
       LVTTL7,
       LVTTL8,
       LVTTL9,
       LVTTL10,
       LVTTL11,
       PUFABn,
       VCC15GOOD,
       VCC33GOOD,
       FCLK,
       MACCLKCCC,
       RCOSC,
       MACCLK,
       PLLLOCK,
       MSSRESETn,
       GPI,
       GPO,
       GPOE,
       SPI0DO,
       SPI0DOE,
       SPI0DI,
       SPI0CLKI,
       SPI0CLKO,
       SPI0MODE,
       SPI0SSI,
       SPI0SSO,
       UART0TXD,
       UART0RXD,
       I2C0SDAI,
       I2C0SDAO,
       I2C0SCLI,
       I2C0SCLO,
       SPI1DO,
       SPI1DOE,
       SPI1DI,
       SPI1CLKI,
       SPI1CLKO,
       SPI1MODE,
       SPI1SSI,
       SPI1SSO,
       UART1TXD,
       UART1RXD,
       I2C1SDAI,
       I2C1SDAO,
       I2C1SCLI,
       I2C1SCLO,
       MACTXD,
       MACRXD,
       MACTXEN,
       MACCRSDV,
       MACRXER,
       MACMDI,
       MACMDO,
       MACMDEN,
       MACMDC,
       EMCCLK,
       EMCCLKRTN,
       EMCRDB,
       EMCAB,
       EMCWDB,
       EMCRWn,
       EMCCS0n,
       EMCCS1n,
       EMCOEN0n,
       EMCOEN1n,
       EMCBYTEN,
       EMCDBOE,
       ADC0,
       ADC1,
       ADC2,
       ADC3,
       ADC4,
       ADC5,
       ADC6,
       ADC7,
       ADC8,
       ADC9,
       ADC10,
       ADC11,
       SDD0,
       SDD1,
       SDD2,
       ABPS0,
       ABPS1,
       ABPS2,
       ABPS3,
       ABPS4,
       ABPS5,
       ABPS6,
       ABPS7,
       ABPS8,
       ABPS9,
       ABPS10,
       ABPS11,
       TM0,
       TM1,
       TM2,
       TM3,
       TM4,
       TM5,
       CM0,
       CM1,
       CM2,
       CM3,
       CM4,
       CM5,
       GNDTM0,
       GNDTM1,
       GNDTM2,
       VAREF0,
       VAREF1,
       VAREF2,
       VAREFOUT,
       GNDVAREF,
       PUn
    );
/* synthesis syn_black_box */
output [19:0] HMADDR;
output [31:0] HMWDATA;
output        HMTRANS;
output [1:0]  HMSIZE;
output        HMMASTLOCK;
output        HMAHBWRITE;
input  [31:0] HMRDATA;
input         HMAHBREADY;
input         HMRESP;
input  [31:0] FMADDR;
input  [31:0] FMWDATA;
input         FMTRANS;
input  [1:0]  FMSIZE;
input         FMMASTLOCK;
input         FMAHBWRITE;
input         FMAHBSEL;
input         FMAHBREADY;
output [31:0] FMRDATA;
output        FMREADYOUT;
output        FMRESP;
output        HMPSEL;
output        HMPENABLE;
output        HMPWRITE;
output        FMPSLVERR;
input         HMPREADY;
input         HMPSLVERR;
input         FMPSEL;
input         FMPENABLE;
input         FMPWRITE;
output        FMPREADY;
input  SYNCCLKFDBK;
output CALIBOUT;
input  CALIBIN;
input  FABINT;
output [7:0] MSSINT;
output WDINT;
input  F2MRESETn;
input  [1:0] DMAREADY;
input  RXEV;
input  VRON;
output M2FRESETn;
output DEEPSLEEP;
output SLEEP;
output TXEV;
input  UART0CTSn;
input  UART0DSRn;
input  UART0RIn;
input  UART0DCDn;
output UART0RTSn;
output UART0DTRn;
input  UART1CTSn;
input  UART1DSRn;
input  UART1RIn;
input  UART1DCDn;
output UART1RTSn;
output UART1DTRn;
input  I2C0SMBUSNI;
input  I2C0SMBALERTNI;
input  I2C0BCLK;
output I2C0SMBUSNO;
output I2C0SMBALERTNO;
input  I2C1SMBUSNI;
input  I2C1SMBALERTNI;
input  I2C1BCLK;
output I2C1SMBUSNO;
output I2C1SMBALERTNO;
output [1:0] MACM2FTXD;
input  [1:0] MACF2MRXD;
output MACM2FTXEN;
input  MACF2MCRSDV;
input  MACF2MRXER;
input  MACF2MMDI;
output MACM2FMDO;
output MACM2FMDEN;
output MACM2FMDC;
input  FABSDD0D;
input  FABSDD1D;
input  FABSDD2D;
input  FABSDD0CLK;
input  FABSDD1CLK;
input  FABSDD2CLK;
input  FABACETRIG;
output [31:0] ACEFLAGS;
output CMP0;
output CMP1;
output CMP2;
output CMP3;
output CMP4;
output CMP5;
output CMP6;
output CMP7;
output CMP8;
output CMP9;
output CMP10;
output CMP11;
input  LVTTL0EN;
input  LVTTL1EN;
input  LVTTL2EN;
input  LVTTL3EN;
input  LVTTL4EN;
input  LVTTL5EN;
input  LVTTL6EN;
input  LVTTL7EN;
input  LVTTL8EN;
input  LVTTL9EN;
input  LVTTL10EN;
input  LVTTL11EN;
output LVTTL0;
output LVTTL1;
output LVTTL2;
output LVTTL3;
output LVTTL4;
output LVTTL5;
output LVTTL6;
output LVTTL7;
output LVTTL8;
output LVTTL9;
output LVTTL10;
output LVTTL11;
output PUFABn;
output VCC15GOOD;
output VCC33GOOD;
input  FCLK;
input  MACCLKCCC;
input  RCOSC;
input  MACCLK;
input  PLLLOCK;
input  MSSRESETn;
input  [31:0] GPI;
output [31:0] GPO;
output [31:0] GPOE;
output SPI0DO;
output SPI0DOE;
input  SPI0DI;
input  SPI0CLKI;
output SPI0CLKO;
output SPI0MODE;
input  SPI0SSI;
output [7:0] SPI0SSO;
output UART0TXD;
input  UART0RXD;
input  I2C0SDAI;
output I2C0SDAO;
input  I2C0SCLI;
output I2C0SCLO;
output SPI1DO;
output SPI1DOE;
input  SPI1DI;
input  SPI1CLKI;
output SPI1CLKO;
output SPI1MODE;
input  SPI1SSI;
output [7:0] SPI1SSO;
output UART1TXD;
input  UART1RXD;
input  I2C1SDAI;
output I2C1SDAO;
input  I2C1SCLI;
output I2C1SCLO;
output [1:0] MACTXD;
input  [1:0] MACRXD;
output MACTXEN;
input  MACCRSDV;
input  MACRXER;
input  MACMDI;
output MACMDO;
output MACMDEN;
output MACMDC;
output EMCCLK;
input  EMCCLKRTN;
input  [15:0] EMCRDB;
output [25:0] EMCAB;
output [15:0] EMCWDB;
output EMCRWn;
output EMCCS0n;
output EMCCS1n;
output EMCOEN0n;
output EMCOEN1n;
output [1:0] EMCBYTEN;
output EMCDBOE;
input  ADC0;
input  ADC1;
input  ADC2;
input  ADC3;
input  ADC4;
input  ADC5;
input  ADC6;
input  ADC7;
input  ADC8;
input  ADC9;
input  ADC10;
input  ADC11;
output SDD0;
output SDD1;
output SDD2;
input  ABPS0;
input  ABPS1;
input  ABPS2;
input  ABPS3;
input  ABPS4;
input  ABPS5;
input  ABPS6;
input  ABPS7;
input  ABPS8;
input  ABPS9;
input  ABPS10;
input  ABPS11;
input  TM0;
input  TM1;
input  TM2;
input  TM3;
input  TM4;
input  TM5;
input  CM0;
input  CM1;
input  CM2;
input  CM3;
input  CM4;
input  CM5;
input  GNDTM0;
input  GNDTM1;
input  GNDTM2;
input  VAREF0;
input  VAREF1;
input  VAREF2;
output VAREFOUT;
input  GNDVAREF;
input  PUn;

parameter ACT_CONFIG = 1'b0;
parameter ACT_FCLK   = 0;
parameter ACT_DIE    = "";
parameter ACT_PKG    = "";

endmodule
