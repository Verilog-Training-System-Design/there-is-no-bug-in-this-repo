module EXEMEM_reg (
    input clk,
    input reset,
    input [31:0] ALU_out,
    input [31:0] EXE_R_ALUout,
    input [4:0] EXE_write_addr,
    input [2:0] EXE_funct3,
    input [31:0] EXE_pc,
    input [31:0] EXE_memory_in,

    input EXE_RDSrc,
    input EXE_MemtoReg,
    input EXE_MenWrite,
    input EXE_MemRead,
    input EXE_RegWrite,
    input EXE_f_RegWrite,
    input im_stall,
    input dm_stall,
    input CSR_stall,
    input CSR_reset,

    output logic [31:0] MEM_ALU_out,
    output logic [31:0] MEM_R_ALUout,
    output logic [4:0] MEM_write_addr,
    output logic [2:0] MEM_funct3,
    output logic [31:0] MEM_pc,
    output logic [31:0] MEM_memory_in,

    output logic MEM_RDSrc,
    output logic MEM_MemtoReg,
    output logic [3:0] MEM_MemWrite,
    output logic MEM_MemRead,
    output logic MEM_write_signal,
    output logic MEM_RegWrite,
    output logic MEM_f_RegWrite
);

always_ff @( posedge clk or negedge reset) begin
    if(~reset | CSR_reset)begin
        MEM_ALU_out <= 32'h0;
        MEM_R_ALUout <= 32'h0;
        MEM_write_addr <= 5'd0;
        MEM_funct3 <= 3'd0;
        MEM_pc <= 32'd0;
        MEM_memory_in <= 32'd0;
        MEM_RDSrc <= 1'b0;
        MEM_MemtoReg <= 1'b0;
        MEM_MemWrite <= 4'h0;
        MEM_write_signal <= 1'b0;
        MEM_MemRead <= 1'b0;
        MEM_RegWrite <= 1'b0;
        MEM_f_RegWrite <= 1'b0;
    end 
    else if(im_stall  & ~dm_stall & ~CSR_stall) begin
        MEM_write_signal <= 1'b0;
        MEM_MemRead <= 1'b0;
        MEM_MemWrite <= 4'hf;
    end 
    else if(im_stall | dm_stall | CSR_stall) begin
        MEM_ALU_out <= MEM_ALU_out;
        MEM_R_ALUout <= MEM_R_ALUout;
        MEM_write_addr <= MEM_write_addr;
        MEM_funct3 <= MEM_funct3;
        MEM_pc <= MEM_pc;
        MEM_memory_in <= MEM_memory_in;
        MEM_RDSrc <= MEM_RDSrc;
        MEM_MemtoReg <= MEM_MemtoReg;
        MEM_MemWrite <= MEM_MemWrite;
        MEM_MemRead <= MEM_MemRead;
        MEM_write_signal <= MEM_write_signal;
        MEM_RegWrite <= MEM_RegWrite;
        MEM_f_RegWrite <= MEM_f_RegWrite;
    end 
    else begin
        if(EXE_MenWrite)begin                   //store need to move data to corresponding position
        MEM_write_signal <= 1'b1;
            case(EXE_funct3)
                3'b000 : begin      //SB
                    case(ALU_out[1:0])
                        2'd0 : begin
                            MEM_MemWrite <= 4'b1110;
                            MEM_memory_in <= EXE_memory_in;
                        end
                        2'd1 : begin
                            MEM_MemWrite <= 4'b1101;
                            MEM_memory_in <= {16'd0, EXE_memory_in[7:0],8'd0};
                            // MEM_memory_in <= EXE_memory_in << 8;            //move data             ,sign bit could be lost,w
                        end
                        2'd2 : begin
                            MEM_MemWrite <= 4'b1011;
                            MEM_memory_in <= {8'd0, EXE_memory_in[7:0], 16'd0};
                            // MEM_memory_in <= EXE_memory_in << 16;           //sign bit could be lost,w
                        end
                        default : begin
                            MEM_MemWrite <= 4'b0111;
                            MEM_memory_in <= {EXE_memory_in[7:0], 24'd0};
                            // MEM_memory_in <= EXE_memory_in << 24;           //sign bit could be lost,w
                        end
                    endcase
                end
                3'b001 : begin      //SH
                    case (ALU_out[1])
                        1'd0 : begin
                            MEM_MemWrite <= 4'b1100;
                            MEM_memory_in <= EXE_memory_in;
                        end
                        default : begin
                            MEM_MemWrite <= 4'b0011;
                            MEM_memory_in <= {EXE_memory_in[15:0], 16'd0};
                            // MEM_memory_in <= EXE_memory_in << 16;           //sign bit could be lost,w
                        end
                    endcase
                end
                default : begin      //SW FSW
                    MEM_MemWrite <= 4'b0000;
                    MEM_memory_in <= EXE_memory_in;
                end
            endcase
        end
        else begin
            MEM_write_signal <= 1'b0;
            MEM_MemWrite <= 4'b1111;
            MEM_memory_in <= EXE_memory_in;
        end
        MEM_funct3 <= EXE_funct3;
        MEM_ALU_out <= ALU_out;
        MEM_R_ALUout <= EXE_R_ALUout;
        MEM_pc <= EXE_pc;
        MEM_write_addr <= EXE_write_addr;
        MEM_RDSrc <= EXE_RDSrc;
        MEM_MemtoReg <= EXE_MemtoReg;
        MEM_MemRead <= EXE_MemRead;
        MEM_RegWrite <= EXE_RegWrite;
        MEM_f_RegWrite <= EXE_f_RegWrite;
    end
end
endmodule