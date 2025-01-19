module multiplexor #(parameter WIDTH = 5) (
    input wire sel,
    input wire [WIDTH-1:0] in0,
    input wire [WIDTH-1:0] in1,
    output wire [WIDTH-1:0] mux_out
);
  assign mux_out = (sel == 1'b0) ? in0 : in1;
endmodule