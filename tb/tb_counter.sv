// Toolchain sanity check -- delete once your real testbenches are in place.
`timescale 1ns/1ps
module tb_counter;
    logic       clk = 0;
    logic       rst_n = 0;
    logic       en = 0;
    logic [7:0] count;

    counter #(.WIDTH(8)) dut (.*);

    always #5 clk = ~clk;

    initial begin
        $dumpfile("build/tb_counter.vcd");
        $dumpvars(0, tb_counter);

        // Drive inputs on the falling edge so they never race the DUT's
        // rising-edge flops.
        repeat (2) @(negedge clk);
        rst_n = 1;
        en    = 1;
        repeat (10) @(negedge clk);
        if (count == 8'd10) $display("PASS: count = %0d", count);
        else                $display("FAIL: count = %0d (expected 10)", count);
        $finish;
    end
endmodule
