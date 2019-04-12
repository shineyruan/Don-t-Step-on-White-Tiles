// Controller.v
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
                    output wire [9:0] x,         // current pixel x position: 10-bit value: 0-1023
                    output wire [8:0] y,         // current pixel y position: 9-bit value: 0-511
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
    assign is_col = (((x > col1[19:10]) & (x < col1[19:10] + col1[9:0])) | ((x > col1[29:20]) & (x < col1[29:20] + col1[9:0])) |
                    ((x > col2[19:10]) & (x < col2[19:10] + col1[9:0])) | ((x > col2[9:0]) & (x < col1[9:0] + col2[9:0])) | ((x > col2[29:20]) & (x < col2[29:20] + col1[9:0])))? 1 : 0;
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

    assign c = sq1 | sq2 | sq3 | sq4 | sq5;
    assign num = num0 | num1;
    assign sq1_no = (sq1 & (~left_1) & (~right_1));
    assign sq2_no = (sq2 & (~left_2) & (~right_2));
    assign sq3_no = (sq3 & (~left_3) & (~right_3));
    assign sq4_no = (sq4 & (~left_4) & (~right_4));
    assign sq5_no = (sq5 & (~left_5) & (~right_5));
    assign sq_no = sq1_no | sq2_no | sq3_no | sq4_no | sq5_no;
    assign VGA_R = is_col | num | sq_no | (sq1 & left_1) | (sq2 & left_2) | (sq3 & left_3) | (sq4 & left_4) |(sq5 & left_5);
    assign VGA_G = is_col | num | sq_no | (sq1 & right_1)| (sq2 & right_2) | (sq3 & right_3)| (sq4 & right_4)| (sq5 & right_5);
    assign VGA_B = is_col | num | sq_no;
endmodule
