module CSR (
    input clk, 
    input rst,

    input [2:0] funct3,
    input [6:0] funct7,
    input [1:0] CSR_type,
    
    input [31:0] rs1_data,
    input [31:0] imm,

    input [11:0] csr_addr,
    input CSR_write,
    input im_stall,
    input dm_stall,

    input [31:0] pc,
    
    input timeout,                  //WDT timeout       timer interrupt
    input interrupt,                //DMA interrupt     external interrupt
    output logic [31:0] CSR_data,
    output logic [31:0] CSR_retpc,
    output logic [31:0] CSR_ISR_pc, //when interrupt happen, CPU get to this address and deal with interrupt(this homework hardwire to 0x0001_0000)

    output logic CSR_stall,
    output logic CSR_interrupt,     //interrupt happen
    output logic CSR_reset,         //WDT timeout reset
    output logic CSR_ret            //return from trap in Machine Mode
);
localparam [4:0]  MIE = 5'd3,
                  MPIE = 5'd7,
                  MPP = 5'd11,            //2 bits
                  MTIP = 5'd7,
                  MEIP = 5'd11,
                  MTIE = 5'd7,
                  MEIE = 5'd11;

logic [31:0] mcycle, mcycleh, minstret, minstreth;
logic [31:0] mstatus, mepc, mip, mie;

assign CSR_reset = timeout;         //WDT reset
assign CSR_retpc = mepc;
assign CSR_ISR_pc = 32'h00010000;
assign CSR_ret = ((funct3 == 3'd0) & (funct7 == 7'b0011000) & (CSR_write)) ? 1'b1 : 1'b0;
assign CSR_interrupt = interrupt & mstatus[MIE] & mie[MEIE] & mip[MEIP];        //there is trap, mstatus there is a trap in the cpu, mie there is a trap other trap can't cause trap, mip there is a trap waiting
assign mip[MTIP] = (mie[MTIE]) ? timeout : 1'b0;
assign mip[MEIP] = (mie[MEIE]) ? interrupt : 1'b0;

//counting cycles and instruction counts
always_ff @( posedge clk or negedge rst ) begin 
    if(~rst)begin
        {mcycleh, mcycle} <= 64'd0;
        {minstreth, minstret} <= 64'd0;
    end
    else begin
        {mcycleh, mcycle} <= {mcycleh, mcycle} + 64'd1;
        if({mcycleh, mcycle} > 1 & ~im_stall & ~dm_stall)begin
            case(CSR_type) 
                2'd0 : {minstreth, minstret} <= {minstreth, minstret} - 64'd1;
                2'd1 : {minstreth, minstret} <= {minstreth, minstret};
                default : {minstreth, minstret} <= {minstreth, minstret} + 64'd1;
            endcase
        end
    end
end

//setting each register (mstatus, mie, mepc)
always_ff @( posedge clk or negedge rst ) begin 
    if(~rst)begin
        {mstatus, mepc, mie} <= 96'd0;
    end
    else if((funct3 == 3'd0) & CSR_write)begin
        if(funct7 == 7'b0011000)begin           //mret      interrupt return
            mstatus[MIE] <= mstatus[MPIE];
            mstatus[MPIE] <= 1'b1;
            mstatus[MPP+:2] <= 2'b11;
        end
        else begin                              //wfi       wait from interrupt
            mepc <= pc + 32'h4;

        end
    end
    else if(interrupt & ~im_stall & ~dm_stall) begin    //external interrupt is taken
        mstatus[MPIE] <= (mip[MEIP]) ? mstatus[MIE] : mstatus[MPIE];
        mstatus[MIE] <= (mip[MEIP]) ? 1'b0 : mstatus[MIE];
        mstatus[MPP+:2] <= (mip[MEIP]) ? 2'b11 : mstatus[MPP+:2];
    end
    else if(timeout & ~im_stall & ~dm_stall)begin       //timer interrupt is taken
        mstatus[MPIE] <= (mip[MTIP]) ? mstatus[MIE] : mstatus[MPIE];
        mstatus[MIE] <= (mip[MTIP]) ? 1'b0 : mstatus[MIE];
        mstatus[MPP+:2] <= (mip[MTIP]) ? 2'b11 : mstatus[MPP+:2];
    end
    else begin              //CSR instructions
        if(~im_stall & ~dm_stall & CSR_write)begin
            case (csr_addr)
                12'h300 : begin                         //mstatus
                    case (funct3)
                        3'b001 : begin          //CSRRW
                            mstatus[MIE] <= rs1_data[MIE];
                            mstatus[MPIE] <= rs1_data[MPIE];
                            mstatus[MPP+:2] <= rs1_data[MPP+:2];
                        end
                        3'b010 : begin          //CSRRS
                            if(rs1_data == 32'b0)
                                mstatus <= mstatus;
                            else begin
                                mstatus[MIE] <= mstatus[MIE] | rs1_data[MIE];
                                mstatus[MPIE] <= mstatus[MPIE] | rs1_data[MPIE];
                                mstatus[MPP+:2] <= mstatus[MPP+:2] | rs1_data[MPP+:2];
                            end
                        end
                        3'b011 : begin          //CSRRC
                            if(rs1_data == 32'b0)
                                mstatus <= mstatus;
                            else begin
                                mstatus[MIE] <= mstatus[MIE] & ~rs1_data[MIE];
                                mstatus[MPIE] <= mstatus[MPIE] & ~rs1_data[MPIE];
                                mstatus[MPP+:2] <= mstatus[MPP+:2] & ~rs1_data[MPP+:2];
                            end
                        end
                        3'b101 : begin          //CSRRWI
                            mstatus[MIE] <= imm[MIE];
                            mstatus[MPIE] <= imm[MPIE];
                            mstatus[MPP+:2] <= imm[MPP+:2];
                        end
                        3'b110 : begin          //CSRRSI
                            if(imm == 32'b0)
                                mstatus <= mstatus;
                            else begin
                                mstatus[MIE] <= mstatus[MIE] | imm[MIE];
                                mstatus[MPIE] <= mstatus[MPIE] | imm[MPIE];
                                mstatus[MPP+:2] <= mstatus[MPP+:2] | imm[MPP+:2];
                            end
                        end
                        3'b111 : begin          //CSRRCI
                            if(imm == 32'b0)
                                mstatus <= mstatus;
                            else begin
                                mstatus[MIE] <= mstatus[MIE] & ~imm[MIE];
                                mstatus[MPIE] <= mstatus[MPIE] & ~imm[MPIE];
                                mstatus[MPP+:2] <= mstatus[MPP+:2] & ~imm[MPP+:2];
                            end
                        end
                        default:
                            mstatus <= mstatus;
                    endcase
                end
                12'h304 : begin                         //mie
                    case (funct3)
                        3'b001 : begin          //CSRRW
                            mie[MIE] <= rs1_data[MIE];
                            mie[MPIE] <= rs1_data[MPIE];
                            mie[MPP+:2] <= rs1_data[MPP+:2];
                        end
                        3'b010 : begin          //CSRRS
                            if(rs1_data == 32'b0)
                                mie <= mie;
                            else begin
                                mie[MIE] <= mie[MIE] | rs1_data[MIE];
                                mie[MPIE] <= mie[MPIE] | rs1_data[MPIE];
                                mie[MPP+:2] <= mie[MPP+:2] | rs1_data[MPP+:2];
                            end
                        end
                        3'b011 : begin          //CSRRC
                            if(rs1_data == 32'b0)
                                mie <= mie;
                            else begin
                                mie[MIE] <= mie[MIE] & ~rs1_data[MIE];
                                mie[MPIE] <= mie[MPIE] & ~rs1_data[MPIE];
                                mie[MPP+:2] <= mie[MPP+:2] & ~rs1_data[MPP+:2];
                            end
                        end
                        3'b101 : begin          //CSRRWI
                            mie[MIE] <= imm[MIE];
                            mie[MPIE] <= imm[MPIE];
                            mie[MPP+:2] <= imm[MPP+:2];
                        end
                        3'b110 : begin          //CSRRSI
                            if(imm == 32'b0)
                                mie <= mie;
                            else begin
                                mie[MIE] <= mie[MIE] | imm[MIE];
                                mie[MPIE] <= mie[MPIE] | imm[MPIE];
                                mie[MPP+:2] <= mie[MPP+:2] | imm[MPP+:2];
                            end
                        end
                        3'b111 : begin          //CSRRCI
                            if(imm == 32'b0)
                                mie <= mie;
                            else begin
                                mie[MIE] <= mie[MIE] & ~imm[MIE];
                                mie[MPIE] <= mie[MPIE] & ~imm[MPIE];
                                mie[MPP+:2] <= mie[MPP+:2] & ~imm[MPP+:2];
                            end
                        end
                        default:
                            mie <= mie;
                    endcase
                end
                12'h344 : begin                         //mepc
                    case (funct3)
                        3'b001 : begin          //CSRRW
                            mepc[MIE] <= rs1_data[MIE];
                            mepc[MPIE] <= rs1_data[MPIE];
                            mepc[MPP+:2] <= rs1_data[MPP+:2];
                        end
                        3'b010 : begin          //CSRRS
                            if(rs1_data == 32'b0)
                                mepc <= mepc;
                            else begin
                                mepc[MIE] <= mepc[MIE] | rs1_data[MIE];
                                mepc[MPIE] <= mepc[MPIE] | rs1_data[MPIE];
                                mepc[MPP+:2] <= mepc[MPP+:2] | rs1_data[MPP+:2];
                            end
                        end
                        3'b011 : begin          //CSRRC
                            if(rs1_data == 32'b0)
                                mepc <= mepc;
                            else begin
                                mepc[MIE] <= mepc[MIE] & ~rs1_data[MIE];
                                mepc[MPIE] <= mepc[MPIE] & ~rs1_data[MPIE];
                                mepc[MPP+:2] <= mepc[MPP+:2] & ~rs1_data[MPP+:2];
                            end
                        end
                        3'b101 : begin          //CSRRWI
                            mepc[MIE] <= imm[MIE];
                            mepc[MPIE] <= imm[MPIE];
                            mepc[MPP+:2] <= imm[MPP+:2];
                        end
                        3'b110 : begin          //CSRRSI
                            if(imm == 32'b0)
                                mepc <= mepc;
                            else begin
                                mepc[MIE] <= mepc[MIE] | imm[MIE];
                                mepc[MPIE] <= mepc[MPIE] | imm[MPIE];
                                mepc[MPP+:2] <= mepc[MPP+:2] | imm[MPP+:2];
                            end
                        end
                        3'b111 : begin          //CSRRCI
                            if(imm == 32'b0)
                                mepc <= mepc;
                            else begin
                                mepc[MIE] <= mepc[MIE] & ~imm[MIE];
                                mepc[MPIE] <= mepc[MPIE] & ~imm[MPIE];
                                mepc[MPP+:2] <= mepc[MPP+:2] & ~imm[MPP+:2];
                            end
                        end
                        default:
                            mepc <= mepc;
                    endcase
                end
                default: begin
                    mstatus <= mstatus;
                    mie <= mie;
                    mepc <= mepc;
                end
            endcase
        end
    end
end

//setting CSR output data
always_comb begin 
    case (csr_addr)
        12'h300 : CSR_data = mstatus;
        12'h304 : CSR_data = mie;
        12'h305 : CSR_data = 32'h00010000;
        12'h341 : CSR_data = mepc;
        12'h344 : CSR_data = mip;
        12'hb00 : CSR_data = mcycle;
        12'hb80 : CSR_data = mcycleh;
        12'hb02 : CSR_data = minstret;
        12'hb82 : CSR_data = minstreth;
        default : CSR_data = 32'h0;
    endcase
end

//csr stall condition when pending for interrupt('wfi' instruction)
always_ff @( posedge clk or negedge rst ) begin
    if(~rst)begin
        CSR_stall <= 1'b0;
    end
    else if(~dm_stall & ~im_stall)begin
        if((funct7 == 7'b0001000) & (funct3 == 3'b000) & CSR_write)begin        //wfi wait for interrupt (when DMA is moving data from DRAM to ROM) see /prog4/boot.c
            CSR_stall <= mip[MEIP];                         //there is a trap not deal with yet
        end
        else if(CSR_interrupt) begin                                            //move to isr to tackle with trap
            CSR_stall <= 1'b0;                     
        end         
    end
end

endmodule

//mie : there is a trap not dealing with yet and other trap can't occur
//mip : there is a trap waiting to tackle
//mstatus : inside cpu each status
