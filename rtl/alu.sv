module alu (
    input logic [31:0] a,
    input logic [31:0] b,
    input logic [3:0] alu_op,
    output logic [31:0] result
);

    always_comb begin
        case (alu_op)
            4'b0000: result = a + b;
            4'b0001: result = a - b;
            4'b0010: result = a & b;
            4'b0011: result = a | b;
            4'b0100: result = a ^ b;
            4'b0101: result = a << b[4:0];
            4'b0110: result = a >> b[4:0];
            4'b0111: result = $signed(a) >>> b[4:0];  
            4'b1000: begin
                if ($signed(a) < $signed(b)) begin
                    result = 32'd1;
                end
                else begin
                    result = 32'd0;
                end
            end
            4'b1001: begin
                if (a < b) begin
                    result = 32'd1;
                end
                else begin
                    result = 32'd0;
                end
            end          
            default: result = 32'b0;
        endcase
    end
endmodule