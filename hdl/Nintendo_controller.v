// Nintendo_controller.v
module Controller(
input PCLK,                 // clock
input PRESERN,              // system reset
//APB3 BUS INTERFACE
input PSEL,                 // peripheral select
input PENABLE,              // distinguishes access phase
output wire PREADY,         // peripheral ready signal
output wire PSLVERR,        // error signal
input PWRITE,               // read/write control bit
input [7:0] PADDR,          // IO address
input wire [31:0] PWDATA,   // (processor) bus is writing data to
                            // this device 32 bits
output reg [31:0] PRDATA,   // (processor) bus is reading data from this device

// *** Your Code (inputs & outputs)
output reg latch,
output reg clock,
input data
);

assign PSLVERR = 0;                                                     //assumes no error generation
assign PREADY = 1;                                                      //assumes zero wait
wire read_enable = (~PWRITE && PSEL) && (PADDR == 8'd4);                //decode APB3 read cycle

// ****** Your code ******

reg count;

always @(posedge PCLK) begin
    if (~PRESERN)
        count <= 1'b0;
    else 
        count <= ~count;
end

assign clk_en = (count == 1);

reg [7:0] data_in;
reg [3:0] read_count;
reg start, finish;

always @(posedge PCLK) begin
    if (finish == 1) begin
        PRDATA[31:8] <= 24'd0;
        PRDATA[7:0] <= data_in;
        finish <= 0;
        start <= 1;
        data_in <= 8'd0;
    end
end

always @(posedge PCLK) begin
    if (~PRESERN) begin
        latch <= 0;
        clock <= 0;
        start <= 1;
        finish <= 0;
        data_in <= 8'd0;
        read_count <= 4'd0;
    end
    else begin
        if (clk_en) begin
            if (start == 1) begin
                // latch the first data 
                latch <= 1;
                start <= 0;
            end
            else if (read_count == 4'd7) begin
                // latches the last data 
                clock <= 1;
                finish <= 1;
            end
            else begin
                // latch data 
                clock <= 1;
            end
        end
        else if (latch == 1) begin
            clock <= 0;
            data_in[7] <= data_in[6];
            data_in[6] <= data_in[5];
            data_in[5] <= data_in[4];
            data_in[4] <= data_in[3];
            data_in[3] <= data_in[2];
            data_in[2] <= data_in[1]; 
            data_in[1] <= data_in[0];
            data_in[0] <= data;
            read_count <= read_count + 1;
        end
        else 
            clock <= 0;
    end
end

endmodule