// Nintendo_controller.v
module Nintendo_Controller(input PCLK,                 // clock
                           input PRESERN,              // system reset
                           input PSEL,                 // peripheral select
                           input PENABLE,              // distinguishes access phase
                           output wire PREADY,         // peripheral ready signal
                           output wire PSLVERR,        // error signal
                           input PWRITE,               // read/write control bit
                           input [31:0] PADDR,         // IO address
                           input wire [31:0] PWDATA,   // (processor) bus is writing data to
                           output reg [31:0] PRDATA,   // (processor) bus is reading data from this device
                           output wire reset,
                           output wire [5:0] selection,
                           output reg latch,
                           output reg clock,
                           input data);
    
    assign PSLVERR = 0;                                                       //assumes no error generation
    assign PREADY  = 1;                                                       //assumes zero wait
    
    // ****** Your code ******
    
    reg [9:0] clock_divider;
    assign clock_divider_max = (clock_divider == 10'd600);
    
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

    assign reset = sound_reset;
    assign selection[5:0] = sound_selection[5:0];
    
    assign data_en   = (finish == 0) & (start == 0) & (latch == 0) & (clock == 0);
    assign count_max = (count == 5'd20);

    // The comparison of PADDR *must* only utilize the bits lower than PSEL! 
    // Otherwise there will be some I/O pins losing! 
    assign ctrl_read_en   = ~PWRITE & PSEL & (PADDR[11:0] == 12'h000);
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
endmodule
