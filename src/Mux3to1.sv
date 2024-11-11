module Mux3to1 (
    input [31:0] A,
    input [31:0] B,
    input [31:0] C,
    input [1:0] sel,

    output logic [31:0] D
);

always_comb begin
    case (sel)
        2'd0 : D = A;
        2'd1 : D = B;
        2'd2 : D = C;
        default : D = A;
    endcase
end

endmodule