module HazardDetectUnit (               //add float number judgement
    input EXE_MemRead,
    input [4:0] read_reg1_addr,
    input [4:0] read_reg2_addr,
    input [4:0] EXE_write_addr,
    input [1:0] Branch_Ctrl,
    input CSR_interrupt,
    input CSR_ret,

    output logic IFID_write,            //solve   remind load-use hazard
    output logic PC_write_en,
    output logic IFID_flush,
    output logic Control_flush,
    output logic [1:0] CSR_type
);

always_comb begin
    if(Branch_Ctrl != 2'd0 | CSR_ret)begin           //branch not equ to pc+4, stall two cycles
        PC_write_en = 1'b1;
        IFID_flush = 1'b1;
        Control_flush = 1'b1;
        IFID_write = 1'b1;
    end
    else if((EXE_MemRead && ((read_reg1_addr == EXE_write_addr) || (read_reg2_addr == EXE_write_addr))))begin       //load-use stall one cycle (there're forwarding)
        PC_write_en = 1'b0;
        IFID_flush = 1'b0;
        Control_flush = 1'b1;
        IFID_write = 1'b0;
    end
    else begin
        IFID_write = 1'b1;
        PC_write_en = 1'b1;
        IFID_flush = 1'b0;
        Control_flush = 1'b0;
    end
end

always_comb begin
    if(Branch_Ctrl != 2'd0)begin
        CSR_type = 2'd0;
    end
    else if((EXE_MemRead && ((read_reg1_addr == EXE_write_addr) || (read_reg2_addr == EXE_write_addr))))begin
        CSR_type = 2'd1;
    end
    else begin
        CSR_type = 2'd2;
    end
end

endmodule

//    else if((EXE_MemRead && ((read_reg1_addr == EXE_write_addr) || (read_reg2_addr == EXE_write_addr))) || (EXE_MemRead && ((read_reg1_addr == EXE_f_write_addr) || (read_reg2_addr == EXE_f_write_addr)) && (ID_is_float & EXE_is_float)))begin       //load-use stall one cycle (there're forwarding)
