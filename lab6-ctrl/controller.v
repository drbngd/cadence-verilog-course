module controller (
    input wire clk,                // Clock signal
    input wire rst,                // Synchronous reset (active high)
    input wire zero,               // Zero flag
    input wire [2:0] opcode,       // 3-bit opcode
    input wire [2:0] phase,        // 3-bit phase input
    output reg sel,                // Function select
    output reg rd,                 // Memory read
    output reg ld_ir,              // Load instruction register
    output reg halt,               // Halt signal
    output reg inc_pc,             // Increment program counter
    output reg ld_ac,              // Load accumulator
    output reg ld_pc,              // Load program counter
    output reg wr,                 // Memory write
    output reg data_e              // Data enable
);

    // Define parameters for opcodes
    localparam [2:0] HLT = 3'b000,
                     SKZ = 3'b001,
                     ADD = 3'b010,
                     AND = 3'b011,
                     XOR = 3'b100,
                     LDA = 3'b101,
                     STO = 3'b110,
                     JMP = 3'b111;

    // Define parameters for phases
    localparam [2:0] INST_ADDR  = 3'b000,
                     INST_FETCH = 3'b001,
                     INST_LOAD  = 3'b010,
                     IDLE       = 3'b011,
                     OP_ADDR    = 3'b100,
                     OP_FETCH   = 3'b101,
                     ALU_OP     = 3'b110,
                     STORE      = 3'b111;

    // Intermediate signal for ALU_OP condition
    wire alu_op = (opcode == ADD || opcode == AND || opcode == XOR || opcode == LDA);

    // Sequential logic
    always @(posedge clk) begin
        if (rst) begin
            // Reset state: Go to INST_ADDR
            sel <= 0;
            rd <= 0;
            ld_ir <= 0;
            halt <= 0;
            inc_pc <= 0;
            ld_ac <= 0;
            ld_pc <= 0;
            wr <= 0;
            data_e <= 0;
        end else begin
            // Case statement for phase
            case (phase)
                INST_ADDR: begin
                    sel <= 1;
                    rd <= 0;
                    ld_ir <= 0;
                    halt <= 0;
                    inc_pc <= 0;
                    ld_ac <= 0;
                    ld_pc <= 0;
                    wr <= 0;
                    data_e <= 0;
                end

                INST_FETCH: begin
                    sel <= 1;
                    rd <= 1;
                    ld_ir <= 0;
                    halt <= 0;
                    inc_pc <= 0;
                    ld_ac <= 0;
                    ld_pc <= 0;
                    wr <= 0;
                    data_e <= 0;
                end

                INST_LOAD: begin
                    sel <= 1;
                    rd <= 1;
                    ld_ir <= 1;
                    halt <= 0;
                    inc_pc <= 0;
                    ld_ac <= 0;
                    ld_pc <= 0;
                    wr <= 0;
                    data_e <= 0;
                end

                IDLE: begin
                    sel <= 1;
                    rd <= 1;
                    ld_ir <= 1;
                    halt <= 0;
                    inc_pc <= 0;
                    ld_ac <= 0;
                    ld_pc <= 0;
                    wr <= 0;
                    data_e <= 0;
                end

                OP_ADDR: begin
                    sel <= 0;
                    rd <= 0;
                    ld_ir <= 0;
                    halt <= (opcode == HLT); // only if opcode is HLT
                    inc_pc <= 1;
                    ld_ac <= 0;
                    ld_pc <= 0;
                    wr <= 0;
                    data_e <= 0;
                end

                OP_FETCH: begin
                    sel <= 0;
                    rd <= alu_op;  // ALU_OP for ADD, AND, XOR, LDA
                    ld_ir <= 0;
                    halt <= 0;
                    inc_pc <= 0;
                    ld_ac <= 0;
                    ld_pc <= 0;
                    wr <= 0;
                    data_e <= 0;
                end

                ALU_OP: begin
                    sel <= 0;
                    rd <= alu_op;  // ALU_OP for ADD, AND, XOR, LDA
                    ld_ir <= 0;
                    halt <= 0;
                    inc_pc <= (opcode == SKZ) && zero;
                    ld_ac <= 0;
                    ld_pc <= (opcode == JMP);
                    wr <= 0;
                    data_e <= (opcode == STO);
                end

                STORE: begin
                    sel <= 0;
                    rd <= alu_op;  // ALU_OP for ADD, AND, XOR, LDA
                    ld_ir <= 0;
                    halt <= 0;
                    inc_pc <= 0;
                    ld_ac <= 0;
                    ld_pc <= 0;
                    wr <= 1;
                    data_e <= 1;
                end

                default: begin
                    // Handle default or unknown phases
                    sel <= 0;
                    rd <= 0;
                    ld_ir <= 0;
                    halt <= 0;
                    inc_pc <= 0;
                    ld_ac <= alu_op;  // ALU_OP for ADD, AND, XOR, LDA
                    ld_pc <= (opcode == JMP);
                    wr <= (opcode == STO);
                    data_e <= (opcode == STO);
                end
            endcase
        end
    end
endmodule
