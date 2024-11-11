module ControlUnit (
    input [6:0] opcode,

    output logic [2:0] ALUOp,
    output logic ALUSrc,
    output logic PCtoRegSrc,
    output logic [2:0] Immtype,
    output logic RDSrc,
    output logic MemtoReg,
    output logic MenWrite,
    output logic MemRead,
    output logic RegWrite,
    output logic [1:0] Branch,
    output logic RegWrite_f,            //for float
    output logic ALUSel_f,              //select which alu
    output logic Memoryin_f             //select float or origin to memory
);

always_comb begin
    case (opcode)
        7'b0110011: begin   //R-type
            ALUOp = 3'd0;
            ALUSrc = 1'b1;
            PCtoRegSrc = 1'b0;
            Immtype = 3'd5;
            RDSrc = 1'b0;
            MemtoReg = 1'b1;
            MenWrite = 1'b0;
            MemRead = 1'b0;
            RegWrite = 1'b1;
            Branch = 2'd0;
            RegWrite_f = 1'b0;
            ALUSel_f = 1'b1;
            Memoryin_f = 1'b1;
        end
        7'b0000011:begin    //load
            ALUOp = 3'd6;
            ALUSrc = 1'b0;
            PCtoRegSrc = 1'b0;
            Immtype = 3'd0;
            RDSrc = 1'b0;
            MemtoReg = 1'b0;
            MenWrite = 1'b0;
            MemRead = 1'b1;
            RegWrite = 1'b1;
            Branch = 2'd0;
            RegWrite_f = 1'b0;
            ALUSel_f = 1'b1;
            Memoryin_f = 1'b1;
        end
        7'b0010011:begin    //I-type computation
            ALUOp = 3'd1;
            ALUSrc = 1'b0;
            PCtoRegSrc = 1'b0;
            Immtype = 3'd0;
            RDSrc = 1'b0;
            MemtoReg = 1'b1;
            MenWrite = 1'b0;
            MemRead = 1'b0;
            RegWrite = 1'b1;
            Branch = 2'd0;
            RegWrite_f = 1'b0;
            ALUSel_f = 1'b1;
            Memoryin_f = 1'b1;
        end
        7'b1100111:begin    //JALR
            ALUOp = 3'd6;
            ALUSrc = 1'b0;
            PCtoRegSrc = 1'b0;
            Immtype = 3'd0;
            RDSrc = 1'b1;
            MemtoReg = 1'b1;
            MenWrite = 1'b0;
            MemRead = 1'b0;
            RegWrite = 1'b1;
            Branch = 2'd1;
            RegWrite_f = 1'b0;
            ALUSel_f = 1'b1;
            Memoryin_f = 1'b1;
        end
        7'b0100011:begin    //store
            ALUOp = 3'd6;
            ALUSrc = 1'b0;
            PCtoRegSrc = 1'b0;
            Immtype = 3'd1;
            RDSrc = 1'b0;
            MemtoReg = 1'b0;
            MenWrite = 1'b1;
            MemRead = 1'b0;
            RegWrite = 1'b0;
            Branch = 2'd0;
            RegWrite_f = 1'b0;
            ALUSel_f = 1'b1;
            Memoryin_f = 1'b1;
        end
        7'b1100011:begin    //B-type(BEQ, BNE...)
            ALUOp = 3'd2;
            ALUSrc = 1'b1;
            PCtoRegSrc = 1'b1;
            Immtype = 3'd2;
            RDSrc = 1'b1;
            MemtoReg = 1'b0;
            MenWrite = 1'b0;
            MemRead = 1'b0;
            RegWrite = 1'b0;
            Branch = 2'd2;
            RegWrite_f = 1'b0;
            ALUSel_f = 1'b1;
            Memoryin_f = 1'b1;
        end
        7'b0010111:begin    //AUIPC
            ALUOp = 3'd6;
            ALUSrc = 1'b0;
            PCtoRegSrc = 1'b1;
            Immtype = 3'd3;
            RDSrc = 1'b1;
            MemtoReg = 1'b1;
            MenWrite = 1'b0;
            MemRead = 1'b0;
            RegWrite = 1'b1;
            Branch = 2'd0;
            RegWrite_f = 1'b0;
            ALUSel_f = 1'b1;
            Memoryin_f = 1'b1;
        end
        7'b0110111:begin    //LUI
            ALUOp = 3'd3;
            ALUSrc = 1'b0;
            PCtoRegSrc = 1'b0;
            Immtype = 3'd3;
            RDSrc = 1'b0;
            MemtoReg = 1'b1;
            MenWrite = 1'b0;
            MemRead = 1'b0;
            RegWrite = 1'b1;
            Branch = 2'd0;
            RegWrite_f = 1'b0;
            ALUSel_f = 1'b1;
            Memoryin_f = 1'b1;
        end
        7'b1101111:begin    //JAL
            ALUOp = 3'd6;
            ALUSrc = 1'b0;
            PCtoRegSrc = 1'b0;
            Immtype = 3'd4;
            RDSrc = 1'b1;
            MemtoReg = 1'b1;
            MenWrite = 1'b0;
            MemRead = 1'b0;
            RegWrite = 1'b1;
            Branch = 2'd3;
            RegWrite_f = 1'b0;
            ALUSel_f = 1'b1;
            Memoryin_f = 1'b1;
        end
        7'b1110011:begin    //CSR
            ALUOp = 3'd4;
            ALUSrc = 1'b0;
            PCtoRegSrc = 1'b0;
            Immtype = 3'd0;
            RDSrc = 1'b0;
            MemtoReg = 1'b1;
            MenWrite = 1'b0;
            MemRead = 1'b0;
            RegWrite = 1'b1;
            Branch = 2'd0;
            RegWrite_f = 1'b0;
            ALUSel_f = 1'b1;
            Memoryin_f = 1'b1;
        end
        7'b0000111:begin    //FLW
            ALUOp = 3'd6;
            ALUSrc = 1'b0;
            PCtoRegSrc = 1'b0;
            Immtype = 3'd0;
            RDSrc = 1'b0;
            MemtoReg = 1'b0;
            MenWrite = 1'b0;
            MemRead = 1'b1;
            RegWrite = 1'b0;
            Branch = 2'd0;
            RegWrite_f = 1'b1;
            ALUSel_f = 1'b0;
            Memoryin_f = 1'b1;
        end
        7'b0100111:begin   //FSW
            ALUOp = 3'd6;
            ALUSrc = 1'b0;
            PCtoRegSrc = 1'b0;
            Immtype = 3'd1;
            RDSrc = 1'b0;
            MemtoReg = 1'b0;
            MenWrite = 1'b1;
            MemRead = 1'b0;
            RegWrite = 1'b0;
            Branch = 2'd0;
            RegWrite_f = 1'b0;
            ALUSel_f = 1'b0;
            Memoryin_f = 1'b0;
        end
        7'b1010011:begin    //FADD.S and FSUB.S
            ALUOp = 3'd5;
            ALUSrc = 1'b0;
            PCtoRegSrc = 1'b0;
            Immtype = 3'd0;
            RDSrc = 1'b0;
            MemtoReg = 1'b1;
            MenWrite = 1'b0;
            MemRead = 1'b0;
            RegWrite = 1'b0;
            Branch = 2'd0;
            RegWrite_f = 1'b1;
            ALUSel_f = 1'b0;
            Memoryin_f = 1'b1;
        end
        default: begin
            ALUOp = 3'd6;
            ALUSrc = 1'b0;
            PCtoRegSrc = 1'b0;
            Immtype = 3'd0;
            RDSrc = 1'b0;
            MemtoReg = 1'b0;
            MenWrite = 1'b0;
            MemRead = 1'b0;
            RegWrite = 1'b0;
            Branch = 2'd0;
            RegWrite_f = 1'b0;
            ALUSel_f = 1'b1;
            Memoryin_f = 1'b1;
        end
    endcase
end

endmodule