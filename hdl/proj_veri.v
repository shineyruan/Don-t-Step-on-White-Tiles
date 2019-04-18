module Core_Control(input PCLK,                  // clock
                    input PRESERN,               // system reset
                    input PSEL,                  // peripheral select
                    input PENABLE,               // distinguishes access phase
                    output wire PREADY,          // peripheral ready signal
                    output wire PSLVERR,         // error signal
                    input PWRITE,                // read/write control bit
                    input [31:0] PADDR,          // IO address
                    input wire [31:0] PWDATA,    // (processor) bus is writing data to
                    output reg [31:0] PRDATA,    // (processor) bus is reading data from this device
                    output wire VGA_HS_O,
                    output wire VGA_VS_O,
                    output wire VGA_R,
                    output wire VGA_G,
                    output wire VGA_B,
                    output wire reset,
                    output wire [5:0] selection,
                    output reg latch,
                    output reg clock,
                    input data,
                    output wire FABINT
                    );
    
    assign PSLVERR = 0;                                                       //assumes no error generation
    assign PREADY  = 1;                                                       //assumes zero wait
    assign FABINT = (x == 635) & (y == 475);
    // ****** Your code ******
    wire [9:0] x;         // current pixel x position: 10-bit value: 0-1023
    wire [8:0] y;         // current pixel y position: 9-bit value: 0-511
    
    reg [9:0] clock_divider;
    assign clock_divider_max = (clock_divider == 10'd150);
    
    always @(posedge PCLK) begin
        if (~PRESERN) begin
            clock_divider <= 10'd0;
        end
        else if (clock_divider_max) begin
            clock_divider <= 0;
        end
        else begin
            clock_divider <= clock_divider + 1;
        end
    end
    
    reg [4:0] count;
    reg [4:0] nextCount;
    
    always @* begin
        nextCount <= count + 1;
    end
    
    reg [7:0] data_in, data_complete;
    reg [2:0] read_count;
    reg start, finish;
    
    reg [5:0] sound_selection;
    reg sound_reset;
    
    assign reset          = sound_reset;
    assign selection[5:0] = sound_selection[5:0];
    
    assign data_en   = (finish == 0) & (start == 0) & (latch == 0) & (clock == 0);
    assign count_max = (count == 5'd20);
    
    // The comparison of PADDR *must* only utilize the bits lower than PSEL!
    // Otherwise there will be some I/O pins losing!
    assign ctrl_read_en   = ~PWRITE & PSEL & (PADDR[11:0] == 12'h024);
    assign sound_write_en = PENABLE & PSEL & PWRITE & (PADDR[11:0] == 12'h100);
    assign sound_read_en  = ~PWRITE & PSEL & (PADDR[11:0] == 12'h100);
    
    
    always @(posedge PCLK) begin
        if (~PRESERN) begin
            sound_selection <= 6'b111111;
            sound_reset     <= 0;
        end
        else begin
            if (sound_write_en) begin
                sound_selection <= PWDATA[5:0];
                sound_reset     <= PWDATA[6];
            end
            else if (sound_read_en) begin
                PRDATA[31:7] <= 25'b0;
                PRDATA[6]    <= sound_reset;
                PRDATA[5:0]  <= sound_selection;
            end
            else if (ctrl_read_en) begin
                PRDATA[31:8] <= 24'd0;
                PRDATA[7:0]  <= data_complete;
            end
        end
    end
                
    always @(posedge PCLK) begin
        if (~PRESERN) begin
            latch         <= 0;
            clock         <= 0;
            start         <= 1;
            finish        <= 0;
            count         <= 5'd0;
            data_in       <= 8'd0;
            data_complete <= 8'd0;
            read_count    <= 3'd0;
        end
        if (finish == 1) begin
            data_complete <= data_in;
            finish        <= 0;
            start         <= 1;
            clock         <= 0;
            data_in       <= 8'd0;
        end
        if (clock_divider_max) begin
            if (start == 1) begin
                // latch the first data
                latch <= 1;
                start <= 0;
            end
            if (latch == 1) begin
                latch <= 0;
            end
            if (clock == 1) begin
                clock <= 0;
            end
            if (data_en) begin
                // latch data
                // data are inverted bits
                clock      <= 1;
                data_in[7] <= data_in[6];
                data_in[6] <= data_in[5];
                data_in[5] <= data_in[4];
                data_in[4] <= data_in[3];
                data_in[3] <= data_in[2];
                data_in[2] <= data_in[1];
                data_in[1] <= data_in[0];
                data_in[0] <= ~data;
                read_count <= read_count + 1;
                
                if (read_count == 3'd7) begin
                    // latch the last data
                    finish     <= 1;
                    read_count <= 3'd0;
                end
            end
        end
    end
      
    assign VGA_write_en = PWRITE & PENABLE & PSEL;
    wire animate;
    vga640x480 display (
    .i_clk(PCLK),
    .i_pix_stb(PCLK),
    .i_rst(PRESERN),
    .o_hs(VGA_HS_O),
    .o_vs(VGA_VS_O),
    .o_x(x),
    .o_y(y),
    .o_animate(animate)
    );
    wire [31:0] col1;
    get_data read_col1(
    .clk(PCLK),
    .res(PRESERN),
    .write_en0(VGA_write_en),
    .right_addr(PADDR[11:0] == 12'h000),
    .pwdata(PWDATA),
    .data(col1)
    );
    wire [31:0] col2;
    get_data read_col2(
    .clk(PCLK),
    .res(PRESERN),
    .write_en0(VGA_write_en),
    .right_addr(PADDR[11:0] == 12'h004),
    .pwdata(PWDATA),
    .data(col2)
    );
    wire [31:0] col3;
    get_data read_col3(
    .clk(PCLK),
    .res(PRESERN),
    .write_en0(VGA_write_en),
    .right_addr(PADDR[11:0] == 12'h038),
    .pwdata(PWDATA),
    .data(col3)
    );
    assign col_length = (y >= 0) & (y < col3);
    assign is_col_y = (((x > col1[19:10]) & (x < col1[19:10] + col1[9:0])) | ((x > col1[29:20]) & (x < col1[29:20] + col1[9:0])) |
                    ((x > col2[19:10]) & (x < col2[19:10] + col1[9:0])) | ((x > col2[9:0]) & (x < col1[9:0] + col2[9:0])) | ((x > col2[29:20]) & (x < col2[29:20] + col1[9:0])))? 1 : 0;
    assign is_col = col_length & is_col_y;
    wire sq1, left_1, right_1;
    get_sq read_sq1(
    .clk(PCLK),
    .res(PRESERN),
    .write_en0(VGA_write_en),
    .right_addr(PADDR[11:0] == 12'h008),
    .pwdata(PWDATA),
    .col1(col1),
    .animate(animate),
    .x(x),
    .y(y),
    .sq(sq1),
    .left_foot(left_1),
    .right_foot(right_1)
    );

    wire sq2, left_2, right_2;
    get_sq read_sq2(
    .clk(PCLK),
    .res(PRESERN),
    .write_en0(VGA_write_en),
    .right_addr(PADDR[11:0] == 12'h00c),
    .pwdata(PWDATA),
    .col1(col1),
    .animate(animate),
    .x(x),
    .y(y),
    .sq(sq2),
    .left_foot(left_2),
    .right_foot(right_2)
    );

    wire sq3, left_3, right_3;
    get_sq read_sq3(
    .clk(PCLK),
    .res(PRESERN),
    .write_en0(VGA_write_en),
    .right_addr(PADDR[11:0] == 12'h010),
    .pwdata(PWDATA),
    .col1(col1),
    .animate(animate),
    .x(x),
    .y(y),
    .sq(sq3),
    .left_foot(left_3),
    .right_foot(right_3)
    );

    wire sq4, left_4, right_4;
    get_sq read_sq4(
    .clk(PCLK),
    .res(PRESERN),
    .write_en0(VGA_write_en),
    .right_addr(PADDR[11:0] == 12'h014),
    .pwdata(PWDATA),
    .col1(col1),
    .animate(animate),
    .x(x),
    .y(y),
    .sq(sq4),
    .left_foot(left_4),
    .right_foot(right_4)
    );

    wire sq5, left_5, right_5;
    get_sq read_sq5(
    .clk(PCLK),
    .res(PRESERN),
    .write_en0(VGA_write_en),
    .right_addr(PADDR[11:0] == 12'h018),
    .pwdata(PWDATA),
    .col1(col1),
    .animate(animate),
    .x(x),
    .y(y),
    .sq(sq5),
    .left_foot(left_5),
    .right_foot(right_5)
    );
    
    wire sq6, left_6, right_6;
    get_sq read_sq6(
    .clk(PCLK),
    .res(PRESERN),
    .write_en0(VGA_write_en),
    .right_addr(PADDR[11:0] == 12'h02c),
    .pwdata(PWDATA),
    .col1(col1),
    .animate(animate),
    .x(x),
    .y(y),
    .sq(sq6),
    .left_foot(left_6),
    .right_foot(right_6)
    );
    wire sq7, left_7, right_7;
    get_sq read_sq7(
    .clk(PCLK),
    .res(PRESERN),
    .write_en0(VGA_write_en),
    .right_addr(PADDR[11:0] == 12'h030),
    .pwdata(PWDATA),
    .col1(col1),
    .animate(animate),
    .x(x),
    .y(y),
    .sq(sq7),
    .left_foot(left_7),
    .right_foot(right_7)
    );

    wire sq8, left_8, right_8;
    get_sq read_sq8(
    .clk(PCLK),
    .res(PRESERN),
    .write_en0(VGA_write_en),
    .right_addr(PADDR[11:0] == 12'h034),
    .pwdata(PWDATA),
    .col1(col1),
    .animate(animate),
    .x(x),
    .y(y),
    .sq(sq8),
    .left_foot(left_8),
    .right_foot(right_8)
    );

    wire num0;
    get_score read_num0(
    .clk(PCLK),
    .res(PRESERN),
    .write_en0(VGA_write_en),
    .right_addr(PADDR[11:0] == 12'h01c),
    .pwdata(PWDATA),
    .animate(animate),
    .x(x),
    .y(y),
    .num(num0),
    .x1(24),
    .x2(36),
    .x3(48)
    );

    wire num1;
    get_score read_num1(
    .clk(PCLK),
    .res(PRESERN),
    .write_en0(VGA_write_en),
    .right_addr(PADDR[11:0] == 12'h020),
    .pwdata(PWDATA),
    .animate(animate),
    .x(x),
    .y(y),
    .num(num1),
    .x1(84),
    .x2(96),
    .x3(108)
    );

    wire num2;
    get_score read_num2(
    .clk(PCLK),
    .res(PRESERN),
    .write_en0(VGA_write_en),
    .right_addr(PADDR[11:0] == 12'h028),
    .pwdata(PWDATA),
    .animate(animate),
    .x(x),
    .y(y),
    .num(num2),
    .x1(144),
    .x2(156),
    .x3(168)
    );
    
    wire h1;
    get_health read_heart1(
    .clk(PCLK),
    .res(PRESERN),
    .write_en0(VGA_write_en),
    .right_addr(PADDR[11:0] == 12'h03c),
    .pwdata(PWDATA),
    .animate(animate),
    .x(x),
    .y(y),
    .h(h1),
    .x0(8),
    .y0(120)
    );

    wire h2;
    get_health read_heart2(
    .clk(PCLK),
    .res(PRESERN),
    .write_en0(VGA_write_en),
    .right_addr(PADDR[11:0] == 12'h040),
    .pwdata(PWDATA),
    .animate(animate),
    .x(x),
    .y(y),
    .h(h2),
    .x0(68),
    .y0(120)
    );

    wire h3;
    get_health read_heart3(
    .clk(PCLK),
    .res(PRESERN),
    .write_en0(VGA_write_en),
    .right_addr(PADDR[11:0] == 12'h044),
    .pwdata(PWDATA),
    .animate(animate),
    .x(x),
    .y(y),
    .h(h3),
    .x0(128),
    .y0(120)
    );

    wire h4;
    get_health read_heart4(
    .clk(PCLK),
    .res(PRESERN),
    .write_en0(VGA_write_en),
    .right_addr(PADDR[11:0] == 12'h048),
    .pwdata(PWDATA),
    .animate(animate),
    .x(x),
    .y(y),
    .h(h4),
    .x0(40),
    .y0(170)
    );

    wire h5;
    get_health read_heart5(
    .clk(PCLK),
    .res(PRESERN),
    .write_en0(VGA_write_en),
    .right_addr(PADDR[11:0] == 12'h04c),
    .pwdata(PWDATA),
    .animate(animate),
    .x(x),
    .y(y),
    .h(h5),
    .x0(100),
    .y0(170)
    );
    assign h = h1 | h2 | h3 | h4 | h5;
    assign num = num0 | num1 | num2;
    assign sq1_no = (sq1 & (~left_1) & (~right_1));
    assign sq2_no = (sq2 & (~left_2) & (~right_2));
    assign sq3_no = (sq3 & (~left_3) & (~right_3));
    assign sq4_no = (sq4 & (~left_4) & (~right_4));
    assign sq5_no = (sq5 & (~left_5) & (~right_5));
    assign sq6_no = (sq6 & (~left_6) & (~right_6));
    assign sq7_no = (sq7 & (~left_7) & (~right_7));
    assign sq8_no = (sq8 & (~left_8) & (~right_8));
    assign sq_no = sq1_no | sq2_no | sq3_no | sq4_no | sq5_no | sq6_no | sq7_no | sq8_no;
    assign VGA_R = h | is_col | num | sq_no | (sq1 & left_1) | (sq2 & left_2) | (sq3 & left_3) | (sq4 & left_4) |(sq5 & left_5) | (sq6 & left_6) | (sq7 & left_7) |(sq8 & left_8);
    assign VGA_G = is_col | num | sq_no | (sq1 & right_1)| (sq2 & right_2) | (sq3 & right_3)| (sq4 & right_4)| (sq5 & right_5) | (sq6 & right_6)| (sq7 & right_7)| (sq8 & right_8);
    assign VGA_B = is_col | num | sq_no;
endmodule