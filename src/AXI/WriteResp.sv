`include "../include/AXI_define.svh"

module WriteResp (
    input clk,
    input rst,

    //M1
    output logic [`AXI_ID_BITS-1:0] BID_M1,
	output logic [1:0] BRESP_M1,
	output logic BVALID_M1,
	input BREADY_M1,

    //M2    DMA
    output logic [`AXI_ID_BITS-1:0] BID_M2,
	output logic [1:0] BRESP_M2,
	output logic BVALID_M2,
	input BREADY_M2,

    //S0    ROM
    input [`AXI_IDS_BITS-1:0] BID_S0,
	input [1:0] BRESP_S0,
	input BVALID_S0,
	output logic BREADY_S0,

    //S1    IM
    input [`AXI_IDS_BITS-1:0] BID_S1,
	input [1:0] BRESP_S1,
	input BVALID_S1,
	output logic BREADY_S1,

    //S2    DM
    input [`AXI_IDS_BITS-1:0] BID_S2,
	input [1:0] BRESP_S2,
	input BVALID_S2,
	output logic BREADY_S2,

    //S3    DMA
    input [`AXI_IDS_BITS-1:0] BID_S3,
	input [1:0] BRESP_S3,
	input BVALID_S3,
	output logic BREADY_S3,

    //S4    WDT
    input [`AXI_IDS_BITS-1:0] BID_S4,
	input [1:0] BRESP_S4,
	input BVALID_S4,
	output logic BREADY_S4,

    //S5    DRAM
    input [`AXI_IDS_BITS-1:0] BID_S5,
	input [1:0] BRESP_S5,
	input BVALID_S5,
	output logic BREADY_S5
);

logic [`AXI_ID_BITS-1:0] BID;
logic [1:0] BRESP;
logic BVALID;
logic BREADY;
logic lock_S0, lock_S1, lock_S2, lock_S3, lock_S4, lock_S5;
logic [3:0] master;
logic [5:0] slave;

// WDT 4 > DMA 3 > DM 2 > IM 1 > DRAM 5 > ROM 0
always_ff @( posedge clk or negedge rst) begin
    if(~rst)begin
        lock_S0 <= 1'b0;
        lock_S1 <= 1'b0;
        lock_S2 <= 1'b0;
        lock_S3 <= 1'b0;
        lock_S4 <= 1'b0;
        lock_S5 <= 1'b0;
    end
    else begin
        if(lock_S0 & BREADY)
            lock_S0 <= 1'b0;
        else if(BVALID_S0 & ~BVALID_S1 & ~BVALID_S2 & ~BVALID_S3 & ~BVALID_S4 & ~BVALID_S5 & ~BREADY)
            lock_S0 <= 1'b1;
        else 
            lock_S0 <= lock_S0;
        
        if(lock_S5 & BREADY)    
            lock_S5 <= 1'b0;
        else if(~lock_S0 & ~BVALID_S1 & ~BVALID_S2 & ~BVALID_S3 & ~BVALID_S4 & BVALID_S5 & ~BREADY)
            lock_S5 <= 1'b1;
        else 
            lock_S5 <= lock_S5;

        if(lock_S1 & BREADY)
            lock_S1 <= 1'b0;
        else if(~lock_S0 & BVALID_S1 & ~BVALID_S2 & ~BVALID_S3 & ~BVALID_S4 & ~lock_S5 & ~BREADY)
            lock_S1 <= 1'b1;
        else 
            lock_S1 <= lock_S1;

        if(lock_S2 & BREADY)
            lock_S2 <= 1'b0;
        else if(~lock_S0 & ~lock_S1 & BVALID_S2 & ~BVALID_S3 & ~BVALID_S4 & ~lock_S5 & ~BREADY)
            lock_S2 <= 1'b1;
        else 
            lock_S2 <= lock_S2;
        
        if(lock_S3 & BREADY)
            lock_S3 <= 1'b0;
        else if(~lock_S0 & ~lock_S1 & ~lock_S2 & BVALID_S3 & ~BVALID_S4 & ~lock_S5 & ~BREADY)
            lock_S3 <= 1'b1;
        else
            lock_S3 <= lock_S3;

        if(lock_S4 & BREADY)
            lock_S4 <= 1'b0;
        else if(~lock_S0 & ~lock_S1 & ~lock_S2 & ~lock_S3 & BVALID_S4 & ~lock_S5 & ~BREADY)
            lock_S4 <= 1'b1;
        else 
            lock_S4 <= lock_S4;
    end
end

always_comb begin
    if((~lock_S0 & ~lock_S1 & ~lock_S2 & ~lock_S3 & BVALID_S4 & ~lock_S5) | lock_S4)
        slave = 6'b010000;
    else if((~lock_S0 & ~lock_S1 & ~lock_S2 & BVALID_S3 & ~lock_S5) | lock_S3)
        slave = 6'b001000;
    else if((~lock_S0 & ~lock_S1 & BVALID_S2 & ~lock_S5) | lock_S2)
        slave = 6'b000100;
    else if((~lock_S0 & BVALID_S1 & ~lock_S5) | lock_S1)
        slave = 6'b000010;
    else if((~lock_S0 & BVALID_S5) | lock_S5)
        slave = 6'b100000;
    else if(BVALID_S0 | lock_S0)
        slave = 6'b000001;
    else 
        slave = 6'd0;
end

always_comb begin
    case (slave)
        6'b000001 : begin
            master = BID_S0[`AXI_IDS_BITS-1:`AXI_ID_BITS];
            BRESP = BRESP_S0;
            BID = BID_S0[`AXI_ID_BITS-1:0];
            BRESP = BRESP_S0;
            BVALID = BVALID_S0;
            BREADY_S0 = BVALID_S0 & BREADY;
            BREADY_S1 = 1'b0;
            BREADY_S2 = 1'b0;
            BREADY_S3 = 1'b0;
            BREADY_S4 = 1'b0;
            BREADY_S5 = 1'b0;
        end
        6'b000010 : begin
            master = BID_S1[`AXI_IDS_BITS-1:`AXI_ID_BITS];
            BRESP = BRESP_S1;
            BID = BID_S1[`AXI_ID_BITS-1:0];
            BRESP = BRESP_S1;
            BVALID = BVALID_S1;
            BREADY_S0 = 1'b0;
            BREADY_S1 = BVALID_S1 & BREADY;
            BREADY_S2 = 1'b0;
            BREADY_S3 = 1'b0;
            BREADY_S4 = 1'b0;
            BREADY_S5 = 1'b0;
        end
        6'b000100 : begin
            master = BID_S2[`AXI_IDS_BITS-1:`AXI_ID_BITS];
            BRESP = BRESP_S2;
            BID = BID_S2[`AXI_ID_BITS-1:0];
            BRESP = BRESP_S2;
            BVALID = BVALID_S2;
            BREADY_S0 = 1'b0;
            BREADY_S1 = 1'b0;
            BREADY_S2 = BVALID_S2 & BREADY;
            BREADY_S3 = 1'b0;
            BREADY_S4 = 1'b0;
            BREADY_S5 = 1'b0;
        end
        6'b001000 : begin
            master = BID_S3[`AXI_IDS_BITS-1:`AXI_ID_BITS];
            BRESP = BRESP_S3;
            BID = BID_S3[`AXI_ID_BITS-1:0];
            BRESP = BRESP_S3;
            BVALID = BVALID_S3;
            BREADY_S0 = 1'b0;
            BREADY_S1 = 1'b0;
            BREADY_S2 = 1'b0;
            BREADY_S3 = BVALID_S3 & BREADY;
            BREADY_S4 = 1'b0;
            BREADY_S5 = 1'b0;
        end
        6'b010000 : begin
            master = BID_S4[`AXI_IDS_BITS-1:`AXI_ID_BITS];
            BRESP = BRESP_S4;
            BID = BID_S4[`AXI_ID_BITS-1:0];
            BRESP = BRESP_S4;
            BVALID = BVALID_S4;
            BREADY_S0 = 1'b0;
            BREADY_S1 = 1'b0;
            BREADY_S2 = 1'b0;
            BREADY_S3 = 1'b0;
            BREADY_S4 = BVALID_S4 & BREADY;
            BREADY_S5 = 1'b0;
        end
        6'b100000 : begin
            master = BID_S5[`AXI_IDS_BITS-1:`AXI_ID_BITS];
            BRESP = BRESP_S5;
            BID = BID_S5[`AXI_ID_BITS-1:0];
            BRESP = BRESP_S5;
            BVALID = BVALID_S5;
            BREADY_S0 = 1'b0;
            BREADY_S1 = 1'b0;
            BREADY_S2 = 1'b0;
            BREADY_S3 = 1'b0;
            BREADY_S4 = 1'b0;
            BREADY_S5 = BVALID_S5 & BREADY;
        end
        default : begin
            master = 4'b0;
            BRESP = 2'b0;
            BID = `AXI_ID_BITS'b0;
            BRESP = 2'b0;
            BVALID = 1'b0;
            BREADY_S0 = 1'b0;
            BREADY_S1 = 1'b0;
            BREADY_S2 = 1'b0;
            BREADY_S3 = 1'b0;
            BREADY_S4 = 1'b0;
            BREADY_S5 = 1'b0;
        end
    endcase
end

always_comb begin
    case (master)
        4'b0010 : begin
            BID = BID_M1;
            BRESP = BRESP_M1;
            BREADY = BREADY_M1;
            BVALID_M1 = BVALID;
        end
        4'b0100 : begin
            BID = BID_M2;
            BRESP = BRESP_M2;
            BREADY = BREADY_M2;
            BVALID_M2 = BVALID;
        end
        default : begin
            BID = 4'b0;
            BRESP = 2'b0;
            BREADY = 1'b1;
            BVALID_M1 = 1'b0;
            BVALID_M2 = 1'b0;
        end 
    endcase
end

endmodule