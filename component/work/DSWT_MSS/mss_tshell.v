module MSS_APB
    (
    ABPS0,
    ABPS1,
    ABPS10,
    ABPS11,
    ABPS2,
    ABPS3,
    ABPS4,
    ABPS5,
    ABPS6,
    ABPS7,
    ABPS8,
    ABPS9,
    ACEFLAGS,
    ADC0,
    ADC1,
    ADC10,
    ADC11,
    ADC2,
    ADC3,
    ADC4,
    ADC5,
    ADC6,
    ADC7,
    ADC8,
    ADC9,
    CALIBIN,
    CALIBOUT,
    CM0,
    CM1,
    CM2,
    CM3,
    CM4,
    CM5,
    CMP0,
    CMP1,
    CMP10,
    CMP11,
    CMP2,
    CMP3,
    CMP4,
    CMP5,
    CMP6,
    CMP7,
    CMP8,
    CMP9,
    DEEPSLEEP,
    DMAREADY,
    EMCAB,
    EMCBYTEN,
    EMCCLK,
    EMCCLKRTN,
    EMCCS0n,
    EMCCS1n,
    EMCDBOE,
    EMCOEN0n,
    EMCOEN1n,
    EMCRDB,
    EMCRWn,
    EMCWDB,
    F2MRESETn,
    FABACETRIG,
    FABINT,
    FABPADDR,
    FABPENABLE,
    FABPRDATA,
    FABPREADY,
    FABPSEL,
    FABPSLVERR,
    FABPWDATA,
    FABPWRITE,
    FABSDD0CLK,
    FABSDD0D,
    FABSDD1CLK,
    FABSDD1D,
    FABSDD2CLK,
    FABSDD2D,
    FCLK,
    GNDTM0,
    GNDTM1,
    GNDTM2,
    GNDVAREF,
    GPI,
    GPO,
    GPOE,
    I2C0BCLK,
    I2C0SCLI,
    I2C0SCLO,
    I2C0SDAI,
    I2C0SDAO,
    I2C0SMBALERTNI,
    I2C0SMBALERTNO,
    I2C0SMBUSNI,
    I2C0SMBUSNO,
    I2C1BCLK,
    I2C1SCLI,
    I2C1SCLO,
    I2C1SDAI,
    I2C1SDAO,
    I2C1SMBALERTNI,
    I2C1SMBALERTNO,
    I2C1SMBUSNI,
    I2C1SMBUSNO,
    LVTTL0,
    LVTTL0EN,
    LVTTL1,
    LVTTL10,
    LVTTL10EN,
    LVTTL11,
    LVTTL11EN,
    LVTTL1EN,
    LVTTL2,
    LVTTL2EN,
    LVTTL3,
    LVTTL3EN,
    LVTTL4,
    LVTTL4EN,
    LVTTL5,
    LVTTL5EN,
    LVTTL6,
    LVTTL6EN,
    LVTTL7,
    LVTTL7EN,
    LVTTL8,
    LVTTL8EN,
    LVTTL9,
    LVTTL9EN,
    M2FRESETn,
    MACCLK,
    MACCLKCCC,
    MACCRSDV,
    MACF2MCRSDV,
    MACF2MMDI,
    MACF2MRXD,
    MACF2MRXER,
    MACM2FMDC,
    MACM2FMDEN,
    MACM2FMDO,
    MACM2FTXD,
    MACM2FTXEN,
    MACMDC,
    MACMDEN,
    MACMDI,
    MACMDO,
    MACRXD,
    MACRXER,
    MACTXD,
    MACTXEN,
    MSSINT,
    MSSPADDR,
    MSSPENABLE,
    MSSPRDATA,
    MSSPREADY,
    MSSPSEL,
    MSSPSLVERR,
    MSSPWDATA,
    MSSPWRITE,
    MSSRESETn,
    PLLLOCK,
    PUFABn,
    PUn,
    RCOSC,
    RXEV,
    SDD0,
    SDD1,
    SDD2,
    SLEEP,
    SPI0CLKI,
    SPI0CLKO,
    SPI0DI,
    SPI0DO,
    SPI0DOE,
    SPI0MODE,
    SPI0SSI,
    SPI0SSO,
    SPI1CLKI,
    SPI1CLKO,
    SPI1DI,
    SPI1DO,
    SPI1DOE,
    SPI1MODE,
    SPI1SSI,
    SPI1SSO,
    SYNCCLKFDBK,
    TM0,
    TM1,
    TM2,
    TM3,
    TM4,
    TM5,
    TXEV,
    UART0CTSn,
    UART0DCDn,
    UART0DSRn,
    UART0DTRn,
    UART0RIn,
    UART0RTSn,
    UART0RXD,
    UART0TXD,
    UART1CTSn,
    UART1DCDn,
    UART1DSRn,
    UART1DTRn,
    UART1RIn,
    UART1RTSn,
    UART1RXD,
    UART1TXD,
    VAREF0,
    VAREF1,
    VAREF2,
    VAREFOUT,
    VCC15GOOD,
    VCC33GOOD,
    VRON,
    WDINT
    );

    /*
    synthesis syn_black_box
    syn_tco1="FCLK->ACEFLAGS[31:0]=5.641"
    syn_tco2="FCLK->DEEPSLEEP=3.492"
    syn_tsu1="DMAREADY[1:0]->FCLK=1.468"
    syn_tco3="FCLK->EMCAB[25:0]=2.672"
    syn_tco4="FCLK->EMCBYTEN[1:0]=4.324"
    syn_tco5="FCLK->EMCCS0n=4.522"
    syn_tco6="FCLK->EMCCS1n=4.554"
    syn_tco7="FCLK->EMCDBOE=2.672"
    syn_tco8="FCLK->EMCOEN0n=4.303"
    syn_tco9="FCLK->EMCOEN1n=4.314"
    syn_tsu2="EMCRDB[15:0]->EMCCLKRTN=0.003"
    syn_tco10="FCLK->EMCRWn=2.924"
    syn_tco11="FCLK->EMCWDB[15:0]=6.91"
    syn_tsu3="FABACETRIG->FCLK=0"
    syn_tsu4="FABINT->FCLK=0.321"
    syn_tsu5="FABPADDR[31:0]->FCLK=0"
    syn_tsu6="FABPENABLE->FCLK=0"
    syn_tco12="FCLK->FABPRDATA[31:0]=3.926"
    syn_tco13="FCLK->FABPREADY=2.712"
    syn_tsu7="FABPSEL->FCLK=0"
    syn_tco14="FCLK->FABPSLVERR=2.859"
    syn_tsu8="FABPWDATA[31:0]->FCLK=0"
    syn_tsu9="FABPWRITE->FCLK=0"
    syn_tsu10="GPI[31:0]->FCLK=0.516"
    syn_tco15="FCLK->GPO[31:0]=4.132"
    syn_tco16="FCLK->GPOE[31:0]=3.908"
    syn_tsu11="I2C0BCLK->FCLK=0"
    syn_tsu12="I2C0SCLI->FCLK=0"
    syn_tco17="FCLK->I2C0SCLO=3.465"
    syn_tsu13="I2C0SDAI->FCLK=0"
    syn_tco18="FCLK->I2C0SDAO=3.368"
    syn_tsu14="I2C0SMBALERTNI->FCLK=0"
    syn_tco19="FCLK->I2C0SMBALERTNO=2.855"
    syn_tsu15="I2C0SMBUSNI->FCLK=0"
    syn_tco20="FCLK->I2C0SMBUSNO=2.916"
    syn_tsu16="I2C1BCLK->FCLK=0"
    syn_tsu17="I2C1SCLI->FCLK=0"
    syn_tco21="FCLK->I2C1SCLO=3.762"
    syn_tsu18="I2C1SDAI->FCLK=0.045"
    syn_tco22="FCLK->I2C1SDAO=3.712"
    syn_tsu19="I2C1SMBALERTNI->FCLK=0"
    syn_tco23="FCLK->I2C1SMBALERTNO=2.5"
    syn_tsu20="I2C1SMBUSNI->FCLK=0"
    syn_tco24="FCLK->I2C1SMBUSNO=2.501"
    syn_tco25="FCLK->M2FRESETn=2.957"
    syn_tsu21="MACCRSDV->MACCLK=0"
    syn_tsu22="MACCRSDV->MACCLKCCC=0"
    syn_tsu23="MACF2MCRSDV->MACCLK=0"
    syn_tsu24="MACF2MCRSDV->MACCLKCCC=0"
    syn_tsu25="MACF2MMDI->FCLK=0"
    syn_tsu26="MACF2MRXD[1:0]->MACCLK=0"
    syn_tsu27="MACF2MRXD[1:0]->MACCLKCCC=0"
    syn_tsu28="MACF2MRXER->MACCLK=0"
    syn_tsu29="MACF2MRXER->MACCLKCCC=0"
    syn_tco26="FCLK->MACM2FMDC=3.861"
    syn_tco27="FCLK->MACM2FMDEN=4.061"
    syn_tco28="FCLK->MACM2FMDO=4.261"
    syn_tco29="FCLK->MACM2FTXD[1:0]=3.912"
    syn_tco30="MACCLK->MACM2FTXD[1:0]=2.855"
    syn_tco31="FCLK->MACM2FTXEN=4.167"
    syn_tco32="MACCLK->MACM2FTXEN=2.843"
    syn_tco33="FCLK->MACMDC=3.198"
    syn_tco34="FCLK->MACMDEN=3.664"
    syn_tsu30="MACMDI->FCLK=0"
    syn_tco35="FCLK->MACMDO=3.524"
    syn_tsu31="MACRXD[1:0]->MACCLK=0"
    syn_tsu32="MACRXD[1:0]->MACCLKCCC=0"
    syn_tsu33="MACRXER->MACCLK=0"
    syn_tsu34="MACRXER->MACCLKCCC=0"
    syn_tco36="FCLK->MACTXD[1:0]=3.24"
    syn_tco37="MACCLK->MACTXD[1:0]=2.596"
    syn_tco38="FCLK->MACTXEN=3.601"
    syn_tco39="MACCLK->MACTXEN=2.745"
    syn_tco40="FCLK->MSSINT[7:0]=5.637"
    syn_tco41="FCLK->MSSPADDR[19:0]=2.679"
    syn_tco42="FCLK->MSSPENABLE=2.474"
    syn_tsu35="MSSPRDATA[31:0]->FCLK=0"
    syn_tsu36="MSSPREADY->FCLK=0"
    syn_tco43="FCLK->MSSPSEL=12.49"
    syn_tsu37="MSSPSLVERR->FCLK=0"
    syn_tco44="FCLK->MSSPWDATA[31:0]=2.71"
    syn_tco45="FCLK->MSSPWRITE=2.456"
    syn_tsu38="MSSRESETn->FCLK=0"
    syn_tsu39="PUn->FCLK=0"
    syn_tsu40="RXEV->FCLK=0"
    syn_tco46="FCLK->SLEEP=3.304"
    syn_tsu41="SPI0CLKI->FCLK=0"
    syn_tco47="FCLK->SPI0CLKO=3.407"
    syn_tsu42="SPI0DI->FCLK=0"
    syn_tco48="FCLK->SPI0DO=4.35"
    syn_tco49="FCLK->SPI0DOE=4.947"
    syn_tco50="FCLK->SPI0MODE=3.423"
    syn_tsu43="SPI0SSI->FCLK=0.858"
    syn_tco51="FCLK->SPI0SSO[7:0]=4.117"
    syn_tsu44="SPI1CLKI->FCLK=0"
    syn_tco52="FCLK->SPI1CLKO=3.548"
    syn_tsu45="SPI1DI->FCLK=0"
    syn_tco53="FCLK->SPI1DO=4.643"
    syn_tco54="FCLK->SPI1DOE=4.318"
    syn_tco55="FCLK->SPI1MODE=4.136"
    syn_tsu46="SPI1SSI->FCLK=0.271"
    syn_tco56="FCLK->SPI1SSO[7:0]=4.904"
    syn_tco57="FCLK->TXEV=4.597"
    syn_tsu47="UART0CTSn->FCLK=0"
    syn_tsu48="UART0DCDn->FCLK=0"
    syn_tsu49="UART0DSRn->FCLK=0"
    syn_tco58="FCLK->UART0DTRn=3.299"
    syn_tsu50="UART0RIn->FCLK=0"
    syn_tco59="FCLK->UART0RTSn=3.349"
    syn_tsu51="UART0RXD->FCLK=0.076"
    syn_tco60="FCLK->UART0TXD=3.571"
    syn_tsu52="UART1CTSn->FCLK=0"
    syn_tsu53="UART1DCDn->FCLK=0"
    syn_tsu54="UART1DSRn->FCLK=0"
    syn_tco61="FCLK->UART1DTRn=3.407"
    syn_tsu55="UART1RIn->FCLK=0"
    syn_tco62="FCLK->UART1RTSn=3.714"
    syn_tsu56="UART1RXD->FCLK=0"
    syn_tco63="FCLK->UART1TXD=3.585"
    syn_tco64="FCLK->WDINT=2.749"
    */

    input ABPS0;
    input ABPS1;
    input ABPS10;
    input ABPS11;
    input ABPS2;
    input ABPS3;
    input ABPS4;
    input ABPS5;
    input ABPS6;
    input ABPS7;
    input ABPS8;
    input ABPS9;
    output [31:0]ACEFLAGS;
    input ADC0;
    input ADC1;
    input ADC10;
    input ADC11;
    input ADC2;
    input ADC3;
    input ADC4;
    input ADC5;
    input ADC6;
    input ADC7;
    input ADC8;
    input ADC9;
    input CALIBIN;
    output CALIBOUT;
    input CM0;
    input CM1;
    input CM2;
    input CM3;
    input CM4;
    input CM5;
    output CMP0;
    output CMP1;
    output CMP10;
    output CMP11;
    output CMP2;
    output CMP3;
    output CMP4;
    output CMP5;
    output CMP6;
    output CMP7;
    output CMP8;
    output CMP9;
    output DEEPSLEEP;
    input [1:0]DMAREADY;
    output [25:0]EMCAB;
    output [1:0]EMCBYTEN;
    output EMCCLK;
    input EMCCLKRTN;
    output EMCCS0n;
    output EMCCS1n;
    output EMCDBOE;
    output EMCOEN0n;
    output EMCOEN1n;
    input [15:0]EMCRDB;
    output EMCRWn;
    output [15:0]EMCWDB;
    input F2MRESETn;
    input FABACETRIG;
    input FABINT;
    input [31:0]FABPADDR;
    input FABPENABLE;
    output [31:0]FABPRDATA;
    output FABPREADY;
    input FABPSEL;
    output FABPSLVERR;
    input [31:0]FABPWDATA;
    input FABPWRITE;
    input FABSDD0CLK;
    input FABSDD0D;
    input FABSDD1CLK;
    input FABSDD1D;
    input FABSDD2CLK;
    input FABSDD2D;
    input FCLK;
    input GNDTM0;
    input GNDTM1;
    input GNDTM2;
    input GNDVAREF;
    input [31:0]GPI;
    output [31:0]GPO;
    output [31:0]GPOE;
    input I2C0BCLK;
    input I2C0SCLI;
    output I2C0SCLO;
    input I2C0SDAI;
    output I2C0SDAO;
    input I2C0SMBALERTNI;
    output I2C0SMBALERTNO;
    input I2C0SMBUSNI;
    output I2C0SMBUSNO;
    input I2C1BCLK;
    input I2C1SCLI;
    output I2C1SCLO;
    input I2C1SDAI;
    output I2C1SDAO;
    input I2C1SMBALERTNI;
    output I2C1SMBALERTNO;
    input I2C1SMBUSNI;
    output I2C1SMBUSNO;
    output LVTTL0;
    input LVTTL0EN;
    output LVTTL1;
    output LVTTL10;
    input LVTTL10EN;
    output LVTTL11;
    input LVTTL11EN;
    input LVTTL1EN;
    output LVTTL2;
    input LVTTL2EN;
    output LVTTL3;
    input LVTTL3EN;
    output LVTTL4;
    input LVTTL4EN;
    output LVTTL5;
    input LVTTL5EN;
    output LVTTL6;
    input LVTTL6EN;
    output LVTTL7;
    input LVTTL7EN;
    output LVTTL8;
    input LVTTL8EN;
    output LVTTL9;
    input LVTTL9EN;
    output M2FRESETn;
    input MACCLK;
    input MACCLKCCC;
    input MACCRSDV;
    input MACF2MCRSDV;
    input MACF2MMDI;
    input [1:0]MACF2MRXD;
    input MACF2MRXER;
    output MACM2FMDC;
    output MACM2FMDEN;
    output MACM2FMDO;
    output [1:0]MACM2FTXD;
    output MACM2FTXEN;
    output MACMDC;
    output MACMDEN;
    input MACMDI;
    output MACMDO;
    input [1:0]MACRXD;
    input MACRXER;
    output [1:0]MACTXD;
    output MACTXEN;
    output [7:0]MSSINT;
    output [19:0]MSSPADDR;
    output MSSPENABLE;
    input [31:0]MSSPRDATA;
    input MSSPREADY;
    output MSSPSEL;
    input MSSPSLVERR;
    output [31:0]MSSPWDATA;
    output MSSPWRITE;
    input MSSRESETn;
    input PLLLOCK;
    output PUFABn;
    input PUn;
    input RCOSC;
    input RXEV;
    output SDD0;
    output SDD1;
    output SDD2;
    output SLEEP;
    input SPI0CLKI;
    output SPI0CLKO;
    input SPI0DI;
    output SPI0DO;
    output SPI0DOE;
    output SPI0MODE;
    input SPI0SSI;
    output [7:0]SPI0SSO;
    input SPI1CLKI;
    output SPI1CLKO;
    input SPI1DI;
    output SPI1DO;
    output SPI1DOE;
    output SPI1MODE;
    input SPI1SSI;
    output [7:0]SPI1SSO;
    input SYNCCLKFDBK;
    input TM0;
    input TM1;
    input TM2;
    input TM3;
    input TM4;
    input TM5;
    output TXEV;
    input UART0CTSn;
    input UART0DCDn;
    input UART0DSRn;
    output UART0DTRn;
    input UART0RIn;
    output UART0RTSn;
    input UART0RXD;
    output UART0TXD;
    input UART1CTSn;
    input UART1DCDn;
    input UART1DSRn;
    output UART1DTRn;
    input UART1RIn;
    output UART1RTSn;
    input UART1RXD;
    output UART1TXD;
    input VAREF0;
    input VAREF1;
    input VAREF2;
    output VAREFOUT;
    output VCC15GOOD;
    output VCC33GOOD;
    input VRON;
    output WDINT;

    parameter ACT_CONFIG = 1'b0;
    parameter ACT_FCLK   = 0;
    parameter ACT_DIE    = "";
    parameter ACT_PKG    = "";

endmodule
