module ImmGen (
    input [31:0] immediate,
    input [2:0] Immtype,

    output logic [31:0] imm
);

always_comb begin
    case(Immtype)
        3'd0 : begin
            imm = {{21{immediate[31]}}, immediate[30:20]}; 
        end
        3'd1 : begin
            imm = {{21{immediate[31]}}, immediate[30:25], immediate[11:8], immediate[7]};
        end
        3'd2 : begin
            imm = {{20{immediate[31]}}, immediate[7], immediate[30:25], immediate[11:8], 1'b0};
        end
        3'd3 : begin
            imm = {immediate[31], immediate[30:20], immediate[19:12], {12{1'b0}}};
        end
        3'd4 : begin
            imm = {{12{immediate[31]}}, immediate[19:12], immediate[20], immediate[30:25], immediate[24:21], 1'b0};
        end
        default : begin
            imm = immediate;
        end
    endcase    
end
    
endmodule

//encode:
// 3'd0 : I-imm
// 3'd1 : S-imm
// 3'd2 : B-imm
// 3'd3 : U-imm
// 3'd4 : J-imm
// 3'd5 : FLW-imm
// 3'd6 : FSW-imm
// default : other