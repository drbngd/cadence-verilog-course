module alu #(parameter WIDTH = 8) (
    input wire [WIDTH-1:0] in_a,    // First input operand
    input wire [WIDTH-1:0] in_b,    // Second input operand
    input wire [2:0] opcode,        // 3-bit operation code
    output reg [WIDTH-1:0] alu_out, // ALU output
    output wire a_is_zero           // Indicates if in_a is zero
);

    // Generate a_is_zero asynchronously
    assign a_is_zero = (in_a == 0) ? 1'b1 : 1'b0;

    // Always block for ALU operation
    always @(*) begin
        case (opcode)
            3'b000: alu_out = in_a;            // HLT: Pass A
            3'b001: alu_out = in_a;            // SKZ: Pass A
            3'b010: alu_out = in_a + in_b;     // ADD: Add A and B
            3'b011: alu_out = in_a & in_b;     // AND: Logical AND of A and B
            3'b100: alu_out = in_a ^ in_b;     // XOR: Logical XOR of A and B
            3'b101: alu_out = in_b;            // LDA: Pass B
            3'b110: alu_out = in_a;            // STO: Pass A
            3'b111: alu_out = in_a;            // JMP: Pass A
            default: alu_out = {WIDTH{1'b0}};  // Default case: output 0
        endcase
    end

endmodule
