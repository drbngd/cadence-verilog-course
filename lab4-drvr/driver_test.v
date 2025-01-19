`timescale 1ns / 1ps

module driver_tb;

    // Testbench parameters
    parameter WIDTH = 8;

    // Testbench signals
    reg [WIDTH-1:0] data_in;
    reg data_en;
    wire [WIDTH-1:0] data_out;

    // Instantiate the driver module
    driver #(.WIDTH(WIDTH)) uut (
        .data_in(data_in),
        .data_en(data_en),
        .data_out(data_out)
    );

    // Task to display signals for debugging
    task display_signals;
        $display("Time=%0t | data_in=%b | data_en=%b | data_out=%b", 
                 $time, data_in, data_en, data_out);
    endtask

    // Test sequence
    initial begin
        $display("Starting testbench...");
        $monitor("Time=%0t | data_in=%b | data_en=%b | data_out=%b", 
                 $time, data_in, data_en, data_out);

        // Test Case 1: data_en = 1, data_in has valid data
        data_in = 8'b10101010;
        data_en = 1'b1;
        #10;  // Wait for 10 time units
        display_signals();

        // Check output
        if (data_out !== data_in) $display("Test Case 1 FAILED");

        // Test Case 2: data_en = 0, output should be high-impedance
        data_en = 1'b0;
        #10;
        display_signals();

        // Check output
        if (data_out !== {WIDTH{1'bz}}) $display("Test Case 2 FAILED");

        // Test Case 3: Change data_in while data_en = 1
        data_en = 1'b1;
        data_in = 8'b11001100;
        #10;
        display_signals();

        // Check output
        if (data_out !== data_in) $display("Test Case 3 FAILED");

        // Test Case 4: Change data_in while data_en = 0
        data_en = 1'b0;
        data_in = 8'b11111111;
        #10;
        display_signals();

        // Check output
        if (data_out !== {WIDTH{1'bz}}) $display("Test Case 4 FAILED");

        // End simulation
        $display("Testbench completed.");
        $finish;
    end

endmodule
