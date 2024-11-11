module ALU (
    input [31:0] in1,
    input [31:0] in2,
    input [4:0] control,
    input [63:0] instr_cnt,
    input [63:0] cycle,

    output logic [31:0] out,
    output logic zero
);

logic [63:0] mul;

always_comb begin
    mul = 64'd0;
    case (control)
        5'd0 : begin
            out = in1 + in2;
            zero = 1'd0;
        end
        5'd1 : begin 
            out = in1 - in2;
            zero = 1'd0;
        end
        5'd2 : begin 
            out = $unsigned(in1) << in2[4:0];
            zero = 1'd0;
        end
        5'd3 : begin 
            out = ($signed(in1) < $signed(in2)) ? 32'd1 : 32'd0;
            zero = 1'd0;
        end
        5'd4 : begin 
            out = ($unsigned(in1) < $unsigned(in2)) ? 32'd1 : 32'd0;
            zero = 1'd0;
        end
        5'd5 : begin 
            out = in1 ^ in2;
            zero = 1'd0;
        end
        5'd6 : begin 
            out = $unsigned($unsigned(in1) >> in2[4:0]);
            zero = 1'd0;
        end
        5'd7 : begin 
            out = $signed($signed(in1) >>> in2[4:0]);           //>>> 特殊語法
            zero = 1'd0;
        end
        5'd8 : begin 
            out = in1 | in2;
            zero = 1'd0;
        end
        5'd9 : begin 
            out = in1 & in2;
            zero = 1'd0;
        end
        5'd10 : begin 
            zero = (in1 == in2) ? 1'b1 : 1'b0;
            out = 32'd0;
        end
        5'd11 : begin 
            zero = (in1 != in2) ? 1'b1 : 1'b0;
            out = 32'd0;
        end
        5'd12 : begin 
            zero = ($signed(in1) < $signed(in2)) ? 1'b1 : 1'b0;
            out = 32'd0;
        end
        5'd13 : begin 
            zero = ($signed(in1) >= $signed(in2)) ? 1'b1 : 1'b0;
            out = 32'd0;
        end
        5'd14 : begin 
            zero = ($unsigned(in1) < $unsigned(in2)) ? 1'b1 : 1'b0;
            out = 32'd0;
        end
        5'd15 : begin
            zero = ($unsigned(in1) >= $unsigned(in2)) ? 1'b1 : 1'b0;
            out = 32'd0;
        end
        5'd16 : begin
            zero = 1'd0;
            out = in2;
        end
        5'd17 : begin
            zero = 1'd0;
            mul = in1*in2;
            out = mul[31:0];
        end
        5'd18 : begin
            zero = 1'd0;
            mul = $signed(in1)*$signed(in2);                //unequal length
            out = mul[63:32];
        end
        5'd19 : begin
            zero = 1'd0;
            mul = $signed({in1})*$signed({1'b0,in2});       //unequal length
            out = mul[63:32];
        end
        5'd20 : begin
            zero = 1'd0;
            mul = $unsigned(in1)*$unsigned(in2);            //unequal length
            out = mul[63:32];
        end
        5'd21 : begin
            zero = 1'd0;
            out = instr_cnt[63:32];
        end
        5'd22 : begin
            zero = 1'd0;
            out = instr_cnt[31:0];
        end
        5'd23 : begin
            zero = 1'd0;
            out = cycle[63:32];
        end
        default : begin
            zero = 1'd0;
            out = cycle[31:0];
        end
    endcase
end
    
endmodule

//  5'b00000     ADD     0
//  5'b00001     SUB     1
//  5'b00010     SLL     2
//  5'b00011     SLT     3
//  5'b00100     SLTU    4
//  5'b00101     XOR     5
//  5'b00110     SRL     6
//  5'b00111     SRA     7
//  5'b01000     OR      8
//  5'b01001     AND     9
//  5'b01010     BEQ     10
//  5'b01011     BNE     11
//  5'b01100     BLT     12
//  5'b01101     BGE     13
//  5'b01110     BLTU    14
//  5'b01111     BGEU    15
//  5'b10000     LUI     16                 //未考慮到
//  5'b10001     MUL     17         lower 32bit
//  5'b10010     MULH    18         upper 32bit s*s
//  5'b10011     MULHSU  19         upper 32bit s*u
//  5'b10100     MULHU   20         upper 32bit u*u
//  5'b10101     RDINSTRETH   21  63-32
//  5'b10110     RDINSTRET    22  31-0
//  5'b10111     RDCYCLEH     23  63-32
//  5'b11000     RDCYCLE      24  31-0
