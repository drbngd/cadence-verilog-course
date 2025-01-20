`timescale 1ns / 1ps

module alu_test;

    parameter WIDTH = 8;

    reg [WIDTH-1:0] in_a;
    reg [WIDTH-1:0] in_b;
    reg [2:0] opcode;
    wire [WIDTH-1:0] alu_out;
    wire a_is_zero;

    // Instantiate the ALU
    alu #(WIDTH) uut (
        .in_a(in_a),
        .in_b(in_b),
        .opcode(opcode),
        .alu_out(alu_out),
        .a_is_zero(a_is_zero)
    );

    initial begin
        // Monitor output
        $monitor("Time: %0t | opcode: %b | in_a: %d | in_b: %d | alu_out: %d | a_is_zero: %b",
                 $time, opcode, in_a, in_b, alu_out, a_is_zero);

        // Test Cases
        in_a = 8'd0; in_b = 8'd10; opcode = 3'b000; #10; // HLT: Pass A
        in_a = 8'd0; in_b = 8'd20; opcode = 3'b001; #10; // SKZ: Pass A
        in_a = 8'd15; in_b = 8'd10; opcode = 3'b010; #10; // ADD: A + B
        in_a = 8'd15; in_b = 8'd10; opcode = 3'b011; #10; // AND: A & B
        in_a = 8'd15; in_b = 8'd10; opcode = 3'b100; #10; // XOR: A ^ B
        in_a = 8'd15; in_b = 8'd10; opcode = 3'b101; #10; // LDA: Pass B
        in_a = 8'd15; in_b = 8'd10; opcode = 3'b110; #10; // STO: Pass A
        in_a = 8'd15; in_b = 8'd10; opcode = 3'b111; #10; // JMP: Pass A

        // End simulation
        $stop;
    end

endmodule
