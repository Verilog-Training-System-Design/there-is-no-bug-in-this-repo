module ForwardingUnit (         //add new float number judgement
    input [4:0] read_reg1_addr,
    input [4:0] read_reg2_addr,
    input [4:0] MEM_write_addr,
    input MEM_RegWrite,
    input [4:0] WB_write_addr,
    input WB_RegWrite,

    output logic [1:0] forwarding_r1_sel,                 // 0 : rd1, 1 : forward from MEM, 2 : forward from WB
    output logic [1:0] forwarding_r2_sel,

    // input [4:0] frd1_addr,
    // input [4:0] frd2_addr,
    // input [4:0] MEM_f_write_addr,
    input MEM_f_RegWrite,
    // input [4:0] WB_f_write_addr,
    input WB_f_RegWrite,
    // input EXE_is_float,
    // input MEM_is_float,
    // input WB_is_float,

    output logic [1:0] forwarding_fr1_sel,
    output logic [1:0] forwarding_fr2_sel
);

always_comb begin
    if(MEM_RegWrite && read_reg1_addr == MEM_write_addr)
        forwarding_r1_sel = 2'd1;
    else if(WB_RegWrite && read_reg1_addr == WB_write_addr)
        forwarding_r1_sel = 2'd2;
    else
        forwarding_r1_sel = 2'd0;
end

always_comb begin
    if(MEM_RegWrite && read_reg2_addr == MEM_write_addr)
        forwarding_r2_sel = 2'd1;
    else if(WB_RegWrite && read_reg2_addr == WB_write_addr)
        forwarding_r2_sel = 2'd2;
    else 
        forwarding_r2_sel = 2'd0;
end

always_comb begin
    if(MEM_f_RegWrite && read_reg1_addr == MEM_write_addr)
        forwarding_fr1_sel = 2'd1;
    else if(WB_f_RegWrite && read_reg1_addr == WB_write_addr)
        forwarding_fr1_sel = 2'd2;
    else
        forwarding_fr1_sel = 2'd0;
end

always_comb begin
    if(MEM_f_RegWrite && read_reg2_addr == MEM_write_addr)
        forwarding_fr2_sel = 2'd1;
    else if(WB_f_RegWrite && read_reg2_addr == WB_write_addr)
        forwarding_fr2_sel = 2'd2;
    else
        forwarding_fr2_sel = 2'd0;
end
endmodule