module ImmGen (
    input [31:0] immediate,
    input [3:0] Immtype,

    output logic [31:0] imm
);

always_comb begin
    case(Immtype)
        4'd0 : begin
            imm = {{21{immediate[31]}}, immediate[30:20]}; 
        end
        4'd1 : begin
            imm = {{21{immediate[31]}}, immediate[30:25], immediate[11:8], immediate[7]};
        end
        4'd2 : begin
            imm = {{20{immediate[31]}}, immediate[7], immediate[30:25], immediate[11:8], 1'b0};
        end
        4'd3 : begin
            imm = {immediate[31], immediate[30:20], immediate[19:12], {12{1'b0}}};
        end
        4'd4 : begin
            imm = {{12{immediate[31]}}, immediate[19:12], immediate[20], immediate[30:25], immediate[24:21], 1'b0};
        end
        4'd8 : begin
            imm = {27'b0, immediate[19:15]};
        end
        default : begin
            imm = immediate;
        end
    endcase    
end
    
endmodule

//encode:
// 4'd0 : I-imm
// 4'd1 : S-imm
// 4'd2 : B-imm
// 4'd3 : U-imm
// 4'd4 : J-imm
// 4'd5 : FLW-imm
// 4'd6 : FSW-imm
// 4'd8 : CSR-imm
// default : other