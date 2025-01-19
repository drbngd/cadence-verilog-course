module multiplexor_test;

    parameter WIDTH = 5;
    reg [WIDTH-1:0] in0;
    reg [WIDTH-1:0] in1;
    reg sel;    
    wire [WIDTH-1:0] mux_out;

    // Instantiate the multiplexor
    multiplexor #(WIDTH) uut (
        .sel(sel),
        .in0(in0),
        .in1(in1),
        .mux_out(mux_out)
    );

    // Testbench stimulus
    initial begin
        $display("Starting multiplexor testbench");
        $monitor($time, " sel = %b, in0 = %b, in1 = %b, mux_out = %b", sel, in0, in1, mux_out);

        // Initialize inputs
        in0 = 5'b00001;
        in1 = 5'b11111;

        // Test case 1: sel = 0
        sel = 1'b0;
        #10; // Wait for 10 time units

        // Test case 2: sel = 1
        sel = 1'b1;
        #10; // Wait for 10 time units

        // Test case 3: Change inputs while sel = 0
        sel = 1'b0;
        in0 = 5'b10101;
        #10; // Wait for 10 time units

        // Test case 4: Change inputs while sel = 1
        sel = 1'b1;
        in1 = 5'b01010;
        #10; // Wait for 10 time units

        $display("Testbench completed.");
        $finish;
    end

endmodule