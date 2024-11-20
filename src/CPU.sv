`include "Program_counter.sv"
`include "Adder.sv"
`include "Mux2to1.sv"
`include "IFID_reg.sv"
`include "HazardDetectUnit.sv"
`include "Regfile.sv"
`include "ImmGen.sv"
`include "ControlUnit.sv"
`include "Mux3to1.sv"
`include "IDEXE_reg.sv"
`include "ALU.sv"
`include "ALUCtrl.sv"
`include "ForwardingUnit.sv"
`include "BranchCtrl.sv"
`include "EXEMEM_reg.sv"
`include "MEMWB_reg.sv"
`include "Regfile_f.sv"
`include "ALU_f.sv"


module CPU (
    input clk,
    input rst,
    input [31:0] IM_instr,
    input [31:0] DM_DO,
    input IM_stall,
    input DM_stall,

    output logic [31:0] progcnt_out,
    output logic DM_WEB,
    output logic [3:0] DM_BWEB,
    output logic [31:0] DM_addr,
    output logic [31:0] DM_DI,
    output logic DM_write,

    input DMA_interrupt,
    input WDT_timeout
);

//IF wire
wire PC_write_enable;       //PC write or not
wire [31:0] PC_in;
wire [31:0] pc_4;

wire ifid_flush;
wire ctrl_flush;
wire [1:0] w_csr_type;

//ID wire 
wire [31:0] id_pc;
wire [4:0] rd_r1;
wire [4:0] rd_r2;
wire [6:0] op;
wire [4:0] wr_addr;
wire [31:0] imm;
wire [2:0] fun3;
wire [6:0] fun7;
// wire is_float;
wire [31:0] rd_r1_data;
wire [31:0] rd_r2_data;
wire [31:0] frd_r1_data;
wire [31:0] frd_r2_data;
wire [31:0] immedi;

wire [2:0] id_ALUOp;
wire id_ALUSrc;
wire id_PCtoRegSrc;
wire [3:0] id_Immtype;
wire id_RDSrc;
wire id_MemtoReg;
wire id_MenWrite;
wire id_MemRead;
wire id_RegWrite;
wire id_f_RegWrite;
wire id_ALUSel_f;
wire id_store_into;
wire [1:0] id_Branch;
wire IFID_write;
wire id_csr_write;

//EXE wire
wire interrupt;
wire [31:0] exe_pc_out;
wire [31:0] exe_rd_reg1_data;
wire [31:0] exe_rd_reg2_data;
wire [31:0] exe_frd1_data;
wire [31:0] exe_frd2_data;
wire [4:0] exe_write_addr;
// wire [4:0] exe_f_write_addr;
wire [2:0] exe_funct3;
wire [6:0] exe_funct7;
wire [31:0] alu_out;
wire [31:0] falu_out;
wire [31:0] exe_imm;
wire [1:0] exe_csr_type;

wire [4:0] exe_rd_r1_addr;
wire [4:0] exe_rd_r2_addr;
// wire [4:0] exe_frd1_addr;
// wire [4:0] exe_frd2_addr;

wire [1:0] exe_branchCtrl;
// wire exe_is_float;
wire exe_store_into;

wire [31:0] pc_imm;

wire [2:0] exe_ALUOp;
wire exe_ALUSrc;
wire exe_PCtoRegSrc;
wire exe_RDSrc;
wire exe_MemtoReg;
wire exe_MenWrite;
wire exe_MemRead;
wire exe_RegWrite;
wire exe_f_RegWrite;
wire exe_ALUSel_f;
wire [1:0] exe_Branch;
wire exe_zero_flag;
wire exe_csr_write;

//MEM wire
wire [31:0] mem_ALU_out;
wire [4:0] mem_write_addr;
// wire [4:0] mem_f_write_addr;
wire [2:0] mem_funct3;
wire [31:0] mem_rd_data;

wire mem_RDSrc;
wire mem_MemtoReg;
wire [3:0] mem_MemWrite;
wire mem_MemRead;
wire mem_RegWrite;
wire mem_f_RegWrite;
// wire mem_is_float;
//WB wire
wire [4:0] wb_write_addr;
// wire [4:0] wb_f_write_addr;
wire [31:0] wb_write_data;

wire wb_RegWrite;
wire wb_f_RegWrite;
// wire wb_is_float;

//IF stage

Program_counter PC(
.clk(clk),
.reset(rst),
.Write_en(PC_write_enable),
.pc_in(PC_in),
.im_stall(IM_stall),
.dm_stall(DM_stall), 

.pc_out(progcnt_out)
);

Adder IF_adder(
.in1(progcnt_out),
.in2(32'h4),

.out(pc_4)
);

Mux3to1 IF_pc_mux3(
.A(pc_4),
.B(pc_imm),
.C({alu_out[31:1],1'b0}),
.sel(exe_branchCtrl),

.D(PC_in)
);

IFID_reg IFID_pipe(
.clk(clk),
.reset(rst),
.IFID_flush(ifid_flush),
.instruction(IM_instr),
.pc(progcnt_out),
.IFID_write(IFID_write),
.im_stall(IM_stall),
.dm_stall(DM_stall),

.ID_pc_out(id_pc),
.read_reg1(rd_r1),
.read_reg2(rd_r2),
.opcode(op),
.write_addr(wr_addr),
.immediate(imm),
.funct3(fun3),
.funct7(fun7)
// .is_float(is_float)
);

//IF control

HazardDetectUnit Hazard(
.EXE_MemRead(exe_MemRead),
.read_reg1_addr(rd_r1),
.read_reg2_addr(rd_r2),
.EXE_write_addr(exe_write_addr),
// .EXE_f_write_addr(exe_f_write_addr),
.Branch_Ctrl(exe_branchCtrl),
// .ID_is_float(is_float),
// .EXE_is_float(exe_is_float),

.IFID_write(IFID_write),
.PC_write_en(PC_write_enable),
.IFID_flush(ifid_flush),
.Control_flush(ctrl_flush),
.CSR_type(w_csr_type)
);

//IF control end

//IF stage end

wire [63:0] w_instr_cnt;
wire [63:0] w_cycle;

//ID stage 

Regfile_f Register_file_float(
.clk(clk),
.reset(rst),
.frd_reg1_addr(rd_r1),
.frd_reg2_addr(rd_r2),
.w_freg_addr(wb_write_addr),
.w_f_data(wb_write_data),
.RegWrite_f(wb_f_RegWrite),

.frd_reg1_data(frd_r1_data),
.frd_reg2_data(frd_r2_data)
);


Regfile Regster_file(
.clk(clk),
.reset(rst),
.rd_reg1_addr(rd_r1),
.rd_reg2_addr(rd_r2),
.w_reg_addr(wb_write_addr),
.w_data(wb_write_data),
.RegWrite(wb_RegWrite),

.rd_reg1_data(rd_r1_data),
.rd_reg2_data(rd_r2_data)
);

ImmGen Immediate_Generator(
.immediate(imm),
.Immtype(id_Immtype),

.imm(immedi)
);

IDEXE_reg IDEXE_pipe(
.clk(clk),
.reset(rst),
.rd_reg1_data(rd_r1_data),
.rd_reg2_data(rd_r2_data),
.frd1_data(frd_r1_data),
.frd2_data(frd_r2_data),
.write_addr(wr_addr),
// .f_write_addr(wr_addr),
.funct3(fun3),
.funct7(fun7),
.ID_pc_in(id_pc),
.rd_r1_addr(rd_r1),
.rd_r2_addr(rd_r2),
// .frd1_addr(rd_r1),
// .frd2_addr(rd_r2),
.imme(immedi),
//signal
.Control_flush(ctrl_flush),
.ALUOp(id_ALUOp),
.ALUSrc(id_ALUSrc),
.PCtoRegSrc(id_PCtoRegSrc),
.RDSrc(id_RDSrc),
.MemtoReg(id_MemtoReg),
.MenWrite(id_MenWrite),
.MemRead(id_MemRead),
.RegWrite(id_RegWrite),
.RegWrite_f(id_f_RegWrite),
.ALUSel_f(id_ALUSel_f),
.Branch(id_Branch),
.CSR_type(w_csr_type),
// .is_float(is_float),
.Memoryin_f(id_store_into),
.im_stall(IM_stall),
.dm_stall(DM_stall),
.CSRsel(id_csr_write),

.EXE_pc_out(exe_pc_out),
.EXE_rd_reg1_data(exe_rd_reg1_data),
.EXE_rd_reg2_data(exe_rd_reg2_data),
.EXE_frd1_data(exe_frd1_data),
.EXE_frd2_data(exe_frd2_data),
.EXE_write_addr(exe_write_addr),
// .EXE_f_write_addr(exe_f_write_addr),
.EXE_funct3(exe_funct3),
.EXE_funct7(exe_funct7),
.EXE_rd_r1_addr(exe_rd_r1_addr),
.EXE_rd_r2_addr(exe_rd_r2_addr),
// .EXE_frd1_addr(exe_frd1_addr),
// .EXE_frd2_addr(exe_frd2_addr),
.EXE_immediate(exe_imm),
.EXE_CSR_type(exe_csr_type),
// .instr_cnt(w_instr_cnt),
// .cycle(w_cycle),

//signal
.EXE_ALUOp(exe_ALUOp),
.EXE_ALUSrc(exe_ALUSrc),
.EXE_PCtoRegSrc(exe_PCtoRegSrc),
.EXE_RDSrc(exe_RDSrc),
.EXE_MemtoReg(exe_MemtoReg),
.EXE_MenWrite(exe_MenWrite),
.EXE_MemRead(exe_MemRead),
.EXE_RegWrite(exe_RegWrite),
.EXE_f_RegWrite(exe_f_RegWrite),
.EXE_ALUSel_f(exe_ALUSel_f),
.EXE_Branch(exe_Branch),
.EXE_Memoryin_f(exe_store_into),
.EXE_CSRSel(exe_csr_write)
// .EXE_is_float(exe_is_float)
);

//ID control

ControlUnit CtrlUnit(
.opcode(op),

.ALUOp(id_ALUOp),
.ALUSrc(id_ALUSrc),
.PCtoRegSrc(id_PCtoRegSrc),
.Immtype(id_Immtype),
.RDSrc(id_RDSrc),
.MemtoReg(id_MemtoReg),
.MenWrite(id_MenWrite),
.MemRead(id_MemRead),
.RegWrite(id_RegWrite),
.Branch(id_Branch),
.RegWrite_f(id_f_RegWrite),
.ALUSel_f(id_ALUSel_f),
.Memoryin_f(id_store_into),
.CSRsel(id_csr_write)
);

//ID control end

//ID stage end

//EXE stage
wire [31:0] exe_pc_4;
wire [31:0] pc_to_reg;

wire [31:0] alu1;
wire [31:0] rs2_fin;
wire [31:0] alu2;
wire [31:0] falu1;
wire [31:0] falu2;
wire [31:0] final_alu;
wire [31:0] final_result;
wire [31:0] exe_memory_in;

wire [4:0] alu_ctrl;
wire [1:0] falu_ctrl;
wire [1:0] forward_r1_sel;
wire [1:0] forward_r2_sel;
wire [1:0] forward_fr1_sel;
wire [1:0] forward_fr2_sel;

Mux3to1 float_1_sel(            //forwarding
.A(exe_frd1_data),
.B(mem_rd_data),
.C(wb_write_data),
.sel(forward_fr1_sel),

.D(falu1)
);

Mux3to1 float_2_sel(            //forwarding
.A(exe_frd2_data),
.B(mem_rd_data),
.C(wb_write_data),
.sel(forward_fr2_sel),

.D(falu2)
);


Adder PC_imm_adder(
.in1(exe_pc_out),
.in2(exe_imm),

.out(pc_imm)
);

Adder PC_4_adder(
.in1(exe_pc_out),
.in2(32'h4),

.out(exe_pc_4)
);

Mux2to1 EXE_PC_mux2(
.A(pc_imm),
.B(exe_pc_4),
.sel(exe_PCtoRegSrc),

.C(pc_to_reg)
);

Mux3to1 rs1_mux3(
.A(exe_rd_reg1_data),
.B(mem_rd_data),
.C(wb_write_data),
.sel(forward_r1_sel),

.D(alu1)
);

Mux3to1 rs2_mux3(
.A(exe_rd_reg2_data),
.B(mem_rd_data),
.C(wb_write_data),
.sel(forward_r2_sel),

.D(rs2_fin)
);

Mux2to1 imm_mux2(
.A(rs2_fin),
.B(exe_imm),
.sel(exe_ALUSrc),

.C(alu2)
);

Mux2to1 f_data_in(                  //for store : select which data to store into memeory
.A(rs2_fin),
.B(falu2),
.sel(exe_store_into),

.C(exe_memory_in)
);

ALU_f alu_f(
.float1(falu1),
.float2(falu2),
.operand(falu_ctrl),

.float_ans(falu_out)
);

ALU alu(
.in1(alu1),
.in2(alu2),
.control(alu_ctrl),
.instr_cnt(w_instr_cnt),
.cycle(w_cycle),

.out(alu_out),
.zero(exe_zero_flag)
);

Mux2to1 alu_or_aluf(
.A(alu_out),
.B(falu_out),
.sel(exe_ALUSel_f),

.C(final_alu)
);

CSR csr(
    input .clk(clk),
    input .rst(rst),

    input [2:0] .funct3(),
    input [6:0] .funct7(),
    input [1:0] .CSR_type(),
    
    input [4:0] .rd(),
    input [31:0] .rs1_data(),
    input [31:0] .EXE_immediate(),

    input [11:0] .csr_addr(),
    input .CSR_write(),
    input .im_stall(),
    input .dm_stall(),

    input [31:0] .pc(),
    
    input .timeout(),
    input .interrupt(),
    output logic [31:0] .CSR_data(),
    output logic [31:0] .CSR_retpc(),
    output logic [31:0] .CSR_ISR_pc(),

    output logic .CSR_stall(),
    output logic .CSR_interrupt(),
    output logic .CSR_reset(),
    output logic .CSR_re()t
);

assign final_result = (EXE_CSRSel & (EXE_write_addr != 5'b0)) ?  : final_alu;

//EXE control 

ALUCtrl alu_contrl(
.funct3(exe_funct3),
.funct7(exe_funct7),
.ALUOp(exe_ALUOp),
.CSRimm({exe_funct7,exe_rd_r2_addr}),

.ALUContrl(alu_ctrl),
.FALUControl(falu_ctrl)
);

ForwardingUnit Forwarding(
.read_reg1_addr(exe_rd_r1_addr),
.read_reg2_addr(exe_rd_r2_addr),
.MEM_write_addr(mem_write_addr),
.MEM_RegWrite(mem_RegWrite),
.WB_write_addr(wb_write_addr),
.WB_RegWrite(wb_RegWrite),

.forwarding_r1_sel(forward_r1_sel),
.forwarding_r2_sel(forward_r2_sel),

// .frd1_addr(exe_frd1_addr),
// .frd2_addr(exe_frd2_addr),
// .MEM_f_write_addr(mem_f_write_addr),
.MEM_f_RegWrite(mem_f_RegWrite),
// .WB_f_write_addr(wb_f_write_addr),
.WB_f_RegWrite(wb_f_RegWrite),
// .EXE_is_float(exe_is_float),
// .MEM_is_float(mem_is_float),
// .WB_is_float(wb_is_float),

.forwarding_fr1_sel(forward_fr1_sel),
.forwarding_fr2_sel(forward_fr2_sel)
);

BranchCtrl branch_ctrl(
.branch(exe_Branch),
.zero(exe_zero_flag),

.bCtrl(exe_branchCtrl)
);

//EXE control end

//EXE stage end

//MEM stage
wire [31:0] mem_pc;
wire [31:0] mem_memory_in;
wire [31:0] mem_R_aluout;

Mux2to1 mem_mux2(
.A(mem_pc),
.B(mem_R_aluout),
.sel(mem_RDSrc),

.C(mem_rd_data)
);

assign DM_addr = mem_ALU_out;
assign DM_WEB = mem_MemRead;
assign DM_DI = mem_memory_in;
assign DM_BWEB = mem_MemWrite;

EXEMEM_reg EXEMEM_pipe(
.clk(clk),
.reset(rst),
.ALU_out(alu_out),                      //for address
.EXE_R_ALUout(final_result),
.EXE_write_addr(exe_write_addr),
// .EXE_f_write_addr(exe_f_write_addr),
.EXE_funct3(exe_funct3),
.EXE_pc(pc_to_reg),
.EXE_memory_in(exe_memory_in),

.EXE_RDSrc(exe_RDSrc),
.EXE_MemtoReg(exe_MemtoReg),
.EXE_MenWrite(exe_MenWrite),
.EXE_MemRead(exe_MemRead),
.EXE_RegWrite(exe_RegWrite),
.EXE_f_RegWrite(exe_f_RegWrite),
.im_stall(IM_stall),
.dm_stall(DM_stall),
// .EXE_is_float(exe_is_float),

.MEM_ALU_out(mem_ALU_out),              //for address
.MEM_R_ALUout(mem_R_aluout),
.MEM_write_addr(mem_write_addr),
// .MEM_f_write_addr(mem_f_write_addr),
.MEM_funct3(mem_funct3),
.MEM_pc(mem_pc),
.MEM_memory_in(mem_memory_in),

.MEM_RDSrc(mem_RDSrc),
.MEM_MemtoReg(mem_MemtoReg),
.MEM_MemWrite(mem_MemWrite),
.MEM_write_signal(DM_write),
.MEM_MemRead(mem_MemRead),
.MEM_RegWrite(mem_RegWrite),
.MEM_f_RegWrite(mem_f_RegWrite)
// .MEM_is_float(mem_is_float)
);

//MEM stage end

//WB stage
wire [31:0] wb_rd_data;
wire [31:0] wb_data_memory;

wire wb_MemtoReg;

Mux2to1 wb_mux2(
.A(wb_rd_data),
.B(wb_data_memory),
.sel(wb_MemtoReg),

.C(wb_write_data)
);

MEMWB_reg MEMWB_pipe(
.clk(clk),
.reset(rst),
.MEM_rd_data(mem_rd_data),
.MEM_data_memory(DM_DO),
.MEM_funct3(mem_funct3),
.MEM_write_addr(mem_write_addr),
// .MEM_f_write_addr(mem_f_write_addr),

.MEM_RegWrite(mem_RegWrite),
.MEM_f_RegWrite(mem_f_RegWrite),
.MEM_MemtoReg(mem_MemtoReg),
.im_stall(IM_stall),
.dm_stall(DM_stall),
// .MEM_is_float(mem_is_float),

.WB_rd_data(wb_rd_data),
.WB_data_memory(wb_data_memory),
.WB_write_addr(wb_write_addr),
// .WB_f_write_addr(wb_f_write_addr),

.WB_RegWrite(wb_RegWrite),
.WB_MemtoReg(wb_MemtoReg),
.WB_f_RegWrite(wb_f_RegWrite)
// .WB_is_float(wb_is_float)
);

//WB stage end

endmodule