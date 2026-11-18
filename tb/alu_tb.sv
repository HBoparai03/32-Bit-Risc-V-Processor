
module alu_tb;

    logic [31:0] a;
    logic [31:0] b;
    logic [3:0] alu_op;
    logic [31:0] result;

    // Instantiate the ALU
    alu dut (
        .a(a),
        .b(b),
        .alu_op(alu_op),
        .result(result)
    );

    // Reusable ALU test task
    task automatic test_alu(
        input logic [31:0] test_a,
        input logic [31:0] test_b,
        input logic [3:0] test_op,
        input logic [31:0] expected
    );
        a = test_a;
        b = test_b;
        alu_op = test_op;

        #1;

        if (result !== expected) begin
            $fatal(1,
                "FAILED: op=%b, a=%h, b=%h, expected=%h, got=%h",
                test_op, test_a, test_b, expected, result);
        end

        $display(
            "PASSED: op=%b, a=%h, b=%h, result=%h",
            test_op, test_a, test_b, result
        );
    endtask

    initial begin

        // Arithmetic operations
        test_alu(10, 5, 4'b0000, 15);      // ADD
        test_alu(10, 5, 4'b0001, 5);       // SUB

        // Bitwise operations
        test_alu(12, 10, 4'b0010, 8);     // AND
        test_alu(12, 10, 4'b0011, 14);    // OR
        test_alu(12, 10, 4'b0100, 6);     // XOR

        // Shift operations
        test_alu(5, 2, 4'b0101, 20);      // SLL
        test_alu(20, 2, 4'b0110, 5);      // SRL
        test_alu(-16, 2, 4'b0111, -4);    // SRA

        // Comparison operations
        test_alu(-5, 10, 4'b1000, 1);     // SLT
        test_alu(-5, 10, 4'b1001, 0);     // SLTU

        // Edge cases
        test_alu(32'hFFFFFFFF, 1, 4'b0000, 0);
        test_alu(0, 1, 4'b0001, 32'hFFFFFFFF);
        test_alu(1, 31, 4'b0101, 32'h80000000);
        test_alu(1, 32, 4'b0101, 1);
        test_alu(32'h80000000, 0, 4'b1000, 1);
        test_alu(32'h80000000, 0, 4'b1001, 0);

        $display("All ALU tests passed!");
        $finish;

    end

endmodule
