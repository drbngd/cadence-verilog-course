module register #(parameter WIDTH = 8) (
    input wire [7:0] data_in, // 8-bit input data
    input load,               // Load enable signal
    input clk,                // Clock signal
    input rst,                // Synchronous reset (active high)
    output reg [7:0] data_out // 8-bit output data
);

    always @(posedge clk) begin
        if (rst) begin
            data_out <= 8'b0;   // Reset the output to 0
        end else if (load) begin
            data_out <= data_in; // Load input data to output
        end
        // If neither rst nor load is high, retain the current value of data_out
    end

endmodule
