`timescale 1ns/1ps

module fifo_tb;

    parameter DATA_WIDTH = 8;
    parameter DEPTH = 4; // Small depth for testing
    parameter ADDR_WIDTH = $clog2(DEPTH);

    // Testbench signals
    reg clk, rst;
    reg wr_en, rd_en;
    reg [DATA_WIDTH-1:0] din;
    wire [DATA_WIDTH-1:0] dout;
    wire full, empty;

    // Instantiate the FIFO
    fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .din(din),
        .dout(dout),
        .full(full),
        .empty(empty)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk; // 100 MHz clock

    // Stimulus
    initial begin
        $display("Starting FIFO Test...");
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        din = 0;

        #10;
        rst = 0;

        // Write 4 values
        repeat (4) begin
            @(posedge clk);
            wr_en = 1;
            din = din + 8'h11; // Incrementing data
        end

        @(posedge clk);
        wr_en = 0;

        // Try to write when full (should not write)
        @(posedge clk);
        wr_en = 1;
        din = 8'hFF;

        @(posedge clk);
        wr_en = 0;

        // Read 4 values
        repeat (4) begin
            @(posedge clk);
            rd_en = 1;
        end

        @(posedge clk);
        rd_en = 0;

        // Try to read when empty (should not read)
        @(posedge clk);
        rd_en = 1;

        @(posedge clk);
        rd_en = 0;

        #20;
        $display("FIFO Test Completed.");
        $finish;
    end

endmodule
