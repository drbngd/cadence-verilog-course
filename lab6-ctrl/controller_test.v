`timescale 1ns / 1ps

module controller_tb;

    // Inputs
    reg clk;
    reg rst;
    reg zero;
    reg [2:0] opcode;
    reg [2:0] phase;

    // Outputs
    wire sel;
    wire rd;
    wire ld_ir;
    wire halt;
    wire inc_pc;
    wire ld_ac;
    wire ld_pc;
    wire wr;
    wire data_e;

    // Instantiate the controller module
    controller uut (
        .clk(clk),
        .rst(rst),
        .zero(zero),
        .opcode(opcode),
        .phase(phase),
        .sel(sel),
        .rd(rd),
        .ld_ir(ld_ir),
        .halt(halt),
        .inc_pc(inc_pc),
        .ld_ac(ld_ac),
        .ld_pc(ld_pc),
        .wr(wr),
        .data_e(data_e)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        // Initialize inputs
        rst = 0;
        zero = 0;
        opcode = 3'b000;
        phase = 3'b000;

        // Apply reset
        #10 rst = 1;
        #10 rst = 0;

        // Test each phase and opcode combination
        repeat (8) begin
            phase = phase + 1;
            opcode = 3'b000; // Test HLT first
            #10;
            if (phase == 3'b111)
                zero = 1; // Test zero flag behavior in ALU_OP

            opcode = 3'b010; // Test ADD
            #10;

            opcode = 3'b101; // Test LDA
            #10;

            opcode = 3'b111; // Test JMP
            #10;
        end

        // Finish simulation
        $finish;
    end

    // Monitor output values
    initial begin
        $monitor(
            "Time=%0t, rst=%b, phase=%b, opcode=%b, zero=%b | sel=%b, rd=%b, ld_ir=%b, halt=%b, inc_pc=%b, ld_ac=%b, ld_pc=%b, wr=%b, data_e=%b",
            $time, rst, phase, opcode, zero, sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e
        );
    end

endmodule
