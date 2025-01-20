module memory_test;

  parameter AWIDTH = 5; // Address width
  parameter DWIDTH = 8; // Data width

  reg clk;                // Clock signal
  reg wr;                 // Write enable
  reg rd;                 // Read enable
  reg [AWIDTH-1:0] addr;  // Address
  wire [DWIDTH-1:0] data; // Bidirectional data bus
  reg [DWIDTH-1:0] data_in; // Data input for driving data bus
  wire [DWIDTH-1:0] data_out; // Data read from memory

  // Tristate data bus control
  assign data = (wr) ? data_in : {DWIDTH{1'bz}};

  // Instantiate the memory module
  memory #(
    .AWIDTH(AWIDTH),
    .DWIDTH(DWIDTH)
  ) uut (
    .clk(clk),
    .wr(wr),
    .rd(rd),
    .addr(addr),
    .data(data)
  );

  // Clock generation
  always #5 clk = ~clk;

  // Test sequence
  initial begin
    // Initialize signals
    clk = 0;
    wr = 0;
    rd = 0;
    addr = 0;
    data_in = 0;

    // Test 1: Write to memory
    #10;
    wr = 1; addr = 5; data_in = 8'hAA; // Write 0xAA to address 5
    #10;
    wr = 0; // Stop writing

    // Test 2: Read from memory
    #10;
    rd = 1; addr = 5; // Read from address 5
    #10;
    rd = 0; // Stop reading

    // Test 3: Write to a different address
    #10;
    wr = 1; addr = 10; data_in = 8'h55; // Write 0x55 to address 10
    #10;
    wr = 0;

    // Test 4: Read from the new address
    #10;
    rd = 1; addr = 10; // Read from address 10
    #10;
    rd = 0;

    // End simulation
    $display("All tests completed.");
    $finish;
  end

  // Monitor outputs
  initial begin
    $monitor("Time=%0t clk=%b wr=%b rd=%b addr=%h data=%h",
             $time, clk, wr, rd, addr, data);
  end

endmodule
