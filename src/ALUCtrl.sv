module ALUCtrl (
    input [2:0] funct3,
    input [6:0] funct7,
    input [2:0] ALUOp,
    input [11:0] CSRimm,

    output logic [4:0] ALUContrl,
    output logic [1:0] FALUControl
);

always_comb begin
    FALUControl = 2'd2;
    ALUContrl = 5'b00000;
    case (ALUOp)
        3'd0 : begin                    //R-type
            case(funct7) 
                7'b0000000 : begin
                    case (funct3)
                        3'b000 : ALUContrl = 5'b00000;
                        3'b001 : ALUContrl = 5'b00010;
                        3'b010 : ALUContrl = 5'b00011;
                        3'b011 : ALUContrl = 5'b00100;
                        3'b100 : ALUContrl = 5'b00101;
                        3'b101 : ALUContrl = 5'b00110;
                        3'b110 : ALUContrl = 5'b01000;
                        3'b111 : ALUContrl = 5'b01001;
                    endcase
                end
                7'b0100000 : begin
                    case (funct3)
                        3'b000 : ALUContrl = 5'b00001;
                        3'b101 : ALUContrl = 5'b00111;
                        default: ALUContrl = 5'b00000;
                    endcase
                end
                7'b0000001 : begin
                    case (funct3)
                        3'b000 : ALUContrl = 5'b10001;
                        3'b001 : ALUContrl = 5'b10010;
                        3'b010 : ALUContrl = 5'b10011;
                        default : ALUContrl = 5'b10100;
                    endcase
                end
            endcase
        end
        3'd1 : begin                //I-type
            case (funct3)
                3'b000 : ALUContrl = 5'b00000;
                3'b001 : ALUContrl = 5'b00010;
                3'b010 : ALUContrl = 5'b00011;
                3'b011 : ALUContrl = 5'b00100;
                3'b100 : ALUContrl = 5'b00101;
                3'b101 : begin
                    if(funct7 == 7'b0100000)
                        ALUContrl = 5'b00111;
                    else
                        ALUContrl = 5'b00110;
                end
                3'b110 : ALUContrl = 5'b01000;
                3'b111 : ALUContrl = 5'b01001;
            endcase
        end
        3'd2 : begin                //B-type
            case (funct3)
                3'b000 : ALUContrl = 5'b01010;
                3'b001 : ALUContrl = 5'b01011;
                3'b100 : ALUContrl = 5'b01100;
                3'b101 : ALUContrl = 5'b01101;
                3'b110 : ALUContrl = 5'b01110;
                3'b111 : ALUContrl = 5'b01111;
            endcase
        end
        3'd3 : begin                //LUI
            ALUContrl = 5'b10000;
        end
        3'd4 : begin                //CSR
            case (CSRimm)
                12'b110010000010 : ALUContrl = 5'b10101;
                12'b110000000010 : ALUContrl = 5'b10110;
                12'b110010000000 : ALUContrl = 5'b10111;
                default : ALUContrl = 5'b11000;
            endcase
        end
        3'd5 : begin                //float add and sub
            case(funct7)
                7'b0000000 : FALUControl = 2'd0;
                7'b0000100 : FALUControl = 2'd1;
            endcase
        end
        default :                 //load and store (only +)
            ALUContrl = 5'b00000;
    endcase
end

endmodule


//ALU control signal
//  5'd00000     ADD     0
//  5'd00001     SUB     1
//  5'd00010     SLL     2
//  5'd00011     SLT     3
//  5'd00100     SLTU    4
//  5'd00101     XOR     5
//  5'd00110     SRL     6
//  5'd00111     SRA     7
//  5'd01000     OR      8
//  5'd01001     AND     9
//  5'd01010     BEQ     10
//  5'd01011     BNE     11
//  5'd01100     BLT     12
//  5'd01101     BGE     13
//  5'd01110     BLTU    14
//  5'd01111     BGEU    15
//  5'd10000     LUI     16                 //未考慮到
//  5'd10001     MUL     17         lower 32bit
//  5'd10010     MULH    18         upper 32bit s*s
//  5'd10011     MULHSU  19         upper 32bit s*u
//  5'd10100     MULHU   20         upper 32bit u*u
//  5'b10101     RDINSTRETH     63-32
//  5'b10110     RDINSTRET      31-0
//  5'b10111     RDCYCLEH       63-32
//  5'b11000     RDCYCLE        31-0


