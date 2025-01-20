module memory #(
  parameter AWIDTH = 5,  // Address width (default is 5)
  parameter DWIDTH = 8   // Data width (default is 8)
)(
  input wire clk,             // Clock signal
  input wire wr,              // Write enable
  input wire rd,              // Read enable
  input wire [AWIDTH-1:0] addr,  // Address input
  inout wire [DWIDTH-1:0] data, // Data input/output for write
);

  // Memory array
  reg [DWIDTH-1:0] mem [(1<<AWIDTH)-1:0]; // Depth: 2^AWIDTH, Width: DWIDTH

  

  // Procedural block for write
  always @(posedge clk)
    if (wr)
      mem[addr] <= data; // Write data to memory at addr

  // Continuous assignment for read
  assign data = (rd) ? mem[addr] : {DWIDTH{1'bz}}; // High-impedance when not reading


endmodule
