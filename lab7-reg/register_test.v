`timescale 1ns / 1ps

module tb_register;
    // Parameters
    parameter WIDTH = 8;

    // Inputs
    reg [WIDTH-1:0] data_in;
    reg load, clk, rst;

    // Outputs
    wire [WIDTH-1:0] data_out;

    // Instantiate the register module
    register #(.WIDTH(WIDTH)) uut (
        .data_in(data_in),
        .load(load),
        .clk(clk),
        .rst(rst),
        .data_out(data_out)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk; // 10 ns clock period

    // Test sequence
    initial begin
        // Initialize inputs
        data_in = 0;
        load = 0;
        rst = 0;

        // Reset the register
        #10 rst = 1;  // Apply reset
        #10 rst = 0;  // Release reset

        // Test loading data
        #10 data_in = 8'hAA; // Set data_in
        load = 1;            // Enable load
        #10 load = 0;        // Disable load

        // Test retaining data
        #10 data_in = 8'h55; // Change data_in
        #10;                 // Observe that data_out doesn't change

        // Test resetting register
        #10 rst = 1;         // Apply reset
        #10 rst = 0;         // Release reset

        // Test loading new data
        #10 data_in = 8'hFF; // Set new data_in
        load = 1;            // Enable load
        #10 load = 0;        // Disable load

        // End simulation
        #20 $finish;
    end

    // Monitor signals
    initial begin
        $monitor("Time=%0t | rst=%b | load=%b | data_in=%b | data_out=%b",
                 $time, rst, load, data_in, data_out);
    end
endmodule
