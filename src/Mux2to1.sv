module Mux2to1 (
    input [31:0] A,
    input [31:0] B,
    input sel,

    output [31:0] C
);

assign C = sel ? A : B;

endmodule