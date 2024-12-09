module MEMWB_reg (
    input clk,
    input reset,
    input [31:0] MEM_rd_data,
    input [31:0] MEM_data_memory,
    input [2:0] MEM_funct3,
    input [4:0] MEM_write_addr,

    input MEM_RegWrite,
    input MEM_MemtoReg,
    input MEM_f_RegWrite,
    input im_stall,
    input dm_stall,
    input CSR_stall,
    input CSR_reset,

    output logic [31:0] WB_rd_data,
    output logic [31:0] WB_data_memory,
    output logic [4:0] WB_write_addr,

    output logic WB_RegWrite,
    output logic WB_MemtoReg,
    output logic WB_f_RegWrite
);

always_ff @( posedge clk or negedge reset) begin
    if(~reset)begin
        WB_rd_data <= 32'h0;
        WB_data_memory <= 32'h0;
        WB_write_addr <= 5'd0;
        WB_RegWrite <= 1'b0;
        WB_MemtoReg <= 1'b0;
        WB_f_RegWrite <= 1'b0;
    end
    else if(CSR_reset)begin
        WB_rd_data <= 32'h0;
        WB_data_memory <= 32'h0;
        WB_write_addr <= 5'd0;
        WB_RegWrite <= 1'b0;
        WB_MemtoReg <= 1'b0;
        WB_f_RegWrite <= 1'b0;
    end
    else if(im_stall | dm_stall | CSR_stall)begin
        WB_rd_data <= WB_rd_data;
        WB_data_memory <= WB_data_memory;
        WB_write_addr <= WB_write_addr;
        WB_RegWrite <= WB_RegWrite;
        WB_MemtoReg <= WB_MemtoReg;
        WB_f_RegWrite <= WB_f_RegWrite;
    end
    else begin
        if((MEM_f_RegWrite | MEM_RegWrite) & !MEM_MemtoReg)begin
            // case (MEM_funct3)
            //     3'd0 : WB_data_memory <= {{24{MEM_data_memory[7]}}, MEM_data_memory[7:0]}; //LB
            //     3'd1 : WB_data_memory <= {{16{MEM_data_memory[15]}}, MEM_data_memory[15:0]}; //LH
            //     3'd2 : WB_data_memory <= MEM_data_memory; //LW FLW
            //     3'd5 : WB_data_memory <= {{16{1'b0}}, MEM_data_memory[15:0]}; //LHU     //LHU跟LBU funt3文件上是相反的
            //     3'd4 : WB_data_memory <= {{24{1'b0}}, MEM_data_memory[7:0]}; //LBU
            //     default: WB_data_memory <= MEM_data_memory;
            // endcase
            case (MEM_funct3)
                3'd0 : begin            //LB
                    case(MEM_rd_data[1:0])
                        2'd0 : begin
                            WB_data_memory <= {{24{MEM_data_memory[7]}}, MEM_data_memory[7:0]}; //LB
                        end
                        2'd1 : begin
                            WB_data_memory <= {{24{MEM_data_memory[15]}}, MEM_data_memory[15:8]}; //LB
                        end
                        2'd2 : begin
                            WB_data_memory <= {{24{MEM_data_memory[23]}}, MEM_data_memory[23:16]}; //LB
                        end
                        2'd3 : begin
                            WB_data_memory <= {{24{MEM_data_memory[31]}}, MEM_data_memory[31:24]}; //LB
                        end
                    endcase
                    // WB_data_memory <= {{24{MEM_data_memory[{MEM_data_memory[1:0], 3'b0} + 5'd7]}}, MEM_data_memory[{MEM_data_memory[1:0], 3'b0}+:8]}; //LB
                end
                3'd1 : begin
                    case(MEM_rd_data[1])
                        1'd0 : begin
                            WB_data_memory <= {{16{MEM_data_memory[15]}},MEM_data_memory[15:0]}; //LH
                        end
                        1'd1 : begin
                            WB_data_memory <= {{16{MEM_data_memory[31]}},MEM_data_memory[31:16]}; //LH
                        end
                    endcase
                end 
                // WB_data_memory <= {{16{MEM_data_memory[{ MEM_data_memory[1], 4'b0} + 5'd15]}},MEM_data_memory[{ MEM_data_memory[1], 4'b0}+:16]}; //LH
                3'd2 : WB_data_memory <= MEM_data_memory; //LW FLW
                3'd5 : begin            //LHU
                    case(MEM_rd_data[1])
                        1'd0 : begin
                            WB_data_memory <= {{16{1'b0}}, MEM_data_memory[15:0]};
                        end
                        1'd1 : begin
                            WB_data_memory <= {{16{1'b0}}, MEM_data_memory[31:16]};
                        end
                    endcase
                    // WB_data_memory <= {{16{1'b0}}, MEM_data_memory[{ MEM_data_memory[1], 4'b0}+:16]}; //LHU     //LHU跟LBU funt3文件上是相反的
                end
                3'd4 : begin            //LBU
                    case(MEM_rd_data[1:0])
                        2'd0 : begin
                            WB_data_memory <= {{24{1'b0}}, MEM_data_memory[7:0]}; //LBU
                        end
                        2'd1 : begin
                            WB_data_memory <= {{24{1'b0}}, MEM_data_memory[15:8]}; //LBU
                        end
                        2'd2 : begin
                            WB_data_memory <= {{24{1'b0}}, MEM_data_memory[23:16]}; //LBU
                        end
                        2'd3 : begin
                            WB_data_memory <= {{24{1'b0}}, MEM_data_memory[31:24]}; //LBU
                        end
                    endcase
                    // WB_data_memory <= {{24{1'b0}},MEM_data_memory[{MEM_data_memory[1:0], 3'b0}+:8]}; //LBU
                end
                default: WB_data_memory <= MEM_data_memory;
            endcase
        end
        WB_rd_data <= MEM_rd_data;
        WB_write_addr <= MEM_write_addr;
        WB_RegWrite <= MEM_RegWrite;
        WB_f_RegWrite <= MEM_f_RegWrite;
        WB_MemtoReg <= MEM_MemtoReg;
    end
end

endmodule
