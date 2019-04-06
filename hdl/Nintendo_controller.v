// Nintendo_controller.v
module Nintendo_Controller(input PCLK,               // clock
                           input PRESERN,            // system reset
                           input PSEL,               // peripheral select
                           input PENABLE,            // distinguishes access phase
                           output wire PREADY,       // peripheral ready signal
                           output wire PSLVERR,      // error signal
                           input PWRITE,             // read/write control bit
                           input [31:0] PADDR,        // IO address
                           input wire [31:0] PWDATA, // (processor) bus is writing data to
                           output reg [31:0] PRDATA, // (processor) bus is reading data from this device
                           output reg latch,                    //    output reg reset,
                                                                //    output reg [5:0] selection
                           input data,
                           output reg clock
);
    
    assign PSLVERR   = 0;                                                       //assumes no error generation
    assign PREADY    = 1;                                                       //assumes zero wait
    wire controller_read_enable = ~PWRITE && PSEL && (PADDR == 32'h40050000);                    //decode APB3 read cycle
    // wire sound_write_en = PENABLE & PSEL & PWRITE & (PADDR == 32'h40050100);
    // wire sound_read_en =  ~PWRITE && PSEL && (PADDR == 32'h40050100);   
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
    
    reg [7:0] data_in;
    reg [2:0] read_count;
    reg start, finish;
    
    assign data_en   = (finish == 0) && (start == 0) && (latch == 0) && (clock == 0);
    assign count_max = (count == 5'd20);
    
    always @(posedge PCLK) begin
        if (~PRESERN) begin
            latch      <= 0;
            clock      <= 0;
            start      <= 1;
            finish     <= 0;
            count      <= 5'd0;
            data_in    <= 8'd0;
            read_count <= 3'd0;
        end
        // else if (sound_read_en) begin
        //     PRDATA[5:0] <= selection[5:0];
        //     PRDATA[6] <= reset;
        //     PRDATA[31:7] <= 25'b0;
        // end
        else if (finish == 1 && controller_read_enable) begin
            PRDATA[31:8] <= 24'd0;
            PRDATA[7:0]  <= data_in;
            finish       <= 0;
            start        <= 1;
            clock        <= 0;
            data_in      <= 8'd0;
        end
        else if (clock_divider_max) begin
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

// always @ (posedge PCLK) 
//     begin
//         if (~PRESERN) begin
//             selection <= 6'b111111;
//             reset <= 0;
//         end    
//         else if (sound_write_en) begin
//             selection <= PWDATA[5:0];
//             reset <= PWDATA[6];
//         end

//     end
endmodule
