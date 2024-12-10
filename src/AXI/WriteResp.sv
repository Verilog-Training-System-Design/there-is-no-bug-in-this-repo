`include "../include/AXI_define.svh"

module WriteResp (
    input clk,
    input rst,

    // //M1
    // output logic [`AXI_ID_BITS-1:0] BID_M1,
	// output logic [1:0] BRESP_M1,
	// output logic BVALID_M1,
	// input BREADY_M1,
    B.Master M1_B,
    B.Master M2_B,

    // //M2    DMA
    // output logic [`AXI_ID_BITS-1:0] BID_M2,
	// output logic [1:0] BRESP_M2,
	// output logic BVALID_M2,
	// input BREADY_M2,

    // //S0    ROM
    // input [`AXI_IDS_BITS-1:0] BID_S0,
	// input [1:0] BRESP_S0,
	// input BVALID_S0,
	// output logic BREADY_S0,

    // //S1    IM
    // input [`AXI_IDS_BITS-1:0] BID_S1,
	// input [1:0] BRESP_S1,
	// input BVALID_S1,
	// output logic BREADY_S1,

    // //S2    DM
    // input [`AXI_IDS_BITS-1:0] BID_S2,
	// input [1:0] BRESP_S2,
	// input BVALID_S2,
	// output logic BREADY_S2,

    // //S3    DMA
    // input [`AXI_IDS_BITS-1:0] BID_S3,
	// input [1:0] BRESP_S3,
	// input BVALID_S3,
	// output logic BREADY_S3,

    // //S4    WDT
    // input [`AXI_IDS_BITS-1:0] BID_S4,
	// input [1:0] BRESP_S4,
	// input BVALID_S4,
	// output logic BREADY_S4,

    // //S5    DRAM
    // input [`AXI_IDS_BITS-1:0] BID_S5,
	// input [1:0] BRESP_S5,
	// input BVALID_S5,
	// output logic BREADY_S5
    B.Slave S0_B,
    B.Slave S1_B,
    B.Slave S2_B,
    B.Slave S3_B,
    B.Slave S4_B,
    B.Slave S5_B
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
        else if(S0_B.BVALID & ~S1_B.BVALID & ~S2_B.BVALID & ~S3_B.BVALID & ~S4_B.BVALID & ~S5_B.BVALID & ~BREADY)
            lock_S0 <= 1'b1;
        else 
            lock_S0 <= lock_S0;
        
        if(lock_S5 & BREADY)    
            lock_S5 <= 1'b0;
        else if(~lock_S0 & ~S1_B.BVALID & ~S2_B.BVALID & ~S3_B.BVALID & ~S4_B.BVALID & S5_B.BVALID & ~BREADY)
            lock_S5 <= 1'b1;
        else 
            lock_S5 <= lock_S5;

        if(lock_S1 & BREADY)
            lock_S1 <= 1'b0;
        else if(~lock_S0 & S1_B.BVALID & ~S2_B.BVALID & ~S3_B.BVALID & ~S4_B.BVALID & ~lock_S5 & ~BREADY)
            lock_S1 <= 1'b1;
        else 
            lock_S1 <= lock_S1;

        if(lock_S2 & BREADY)
            lock_S2 <= 1'b0;
        else if(~lock_S0 & ~lock_S1 & S2_B.BVALID & ~S3_B.BVALID & ~S4_B.BVALID & ~lock_S5 & ~BREADY)
            lock_S2 <= 1'b1;
        else 
            lock_S2 <= lock_S2;
        
        if(lock_S3 & BREADY)
            lock_S3 <= 1'b0;
        else if(~lock_S0 & ~lock_S1 & ~lock_S2 & S3_B.BVALID & ~S4_B.BVALID & ~lock_S5 & ~BREADY)
            lock_S3 <= 1'b1;
        else
            lock_S3 <= lock_S3;

        if(lock_S4 & BREADY)
            lock_S4 <= 1'b0;
        else if(~lock_S0 & ~lock_S1 & ~lock_S2 & ~lock_S3 & S4_B.BVALID & ~lock_S5 & ~BREADY)
            lock_S4 <= 1'b1;
        else 
            lock_S4 <= lock_S4;
    end
end

always_comb begin
    if((~lock_S0 & ~lock_S1 & ~lock_S2 & ~lock_S3 & S4_B.BVALID & ~lock_S5) | lock_S4)
        slave = 6'b010000;
    else if((~lock_S0 & ~lock_S1 & ~lock_S2 & S3_B.BVALID & ~lock_S5) | lock_S3)
        slave = 6'b001000;
    else if((~lock_S0 & ~lock_S1 & S2_B.BVALID & ~lock_S5) | lock_S2)
        slave = 6'b000100;
    else if((~lock_S0 & S1_B.BVALID & ~lock_S5) | lock_S1)
        slave = 6'b000010;
    else if((~lock_S0 & S5_B.BVALID) | lock_S5)
        slave = 6'b100000;
    else if(S0_B.BVALID | lock_S0)
        slave = 6'b000001;
    else 
        slave = 6'd0;
end

always_comb begin
    case (slave)
        6'b000001 : begin
            master = S0_B.BID_S[`AXI_IDS_BITS-1:`AXI_ID_BITS];
            BRESP = S0_B.BRESP;
            BID = S0_B.BID_S[`AXI_ID_BITS-1:0];
            BRESP = S0_B.BRESP;
            BVALID = S0_B.BVALID;
            S0_B.BREADY = S0_B.BVALID & BREADY;
            S1_B.BREADY = 1'b0;
            S2_B.BREADY = 1'b0;
            S3_B.BREADY = 1'b0;
            S4_B.BREADY = 1'b0;
            S5_B.BREADY = 1'b0;
        end
        6'b000010 : begin
            master = S1_B.BID_S[`AXI_IDS_BITS-1:`AXI_ID_BITS];
            BRESP = S1_B.BRESP;
            BID = S1_B.BID_S[`AXI_ID_BITS-1:0];
            BRESP = S1_B.BRESP;
            BVALID = S1_B.BVALID;
            S0_B.BREADY = 1'b0;
            S1_B.BREADY = S1_B.BVALID & BREADY;
            S2_B.BREADY = 1'b0;
            S3_B.BREADY = 1'b0;
            S4_B.BREADY = 1'b0;
            S5_B.BREADY = 1'b0;
        end
        6'b000100 : begin
            master = S2_B.BID_S[`AXI_IDS_BITS-1:`AXI_ID_BITS];
            BRESP = S2_B.BRESP;
            BID = S2_B.BID_S[`AXI_ID_BITS-1:0];
            BRESP = S2_B.BRESP;
            BVALID = S2_B.BVALID;
            S0_B.BREADY = 1'b0;
            S1_B.BREADY = 1'b0;
            S2_B.BREADY = S2_B.BVALID & BREADY;
            S3_B.BREADY = 1'b0;
            S4_B.BREADY = 1'b0;
            S5_B.BREADY = 1'b0;
        end
        6'b001000 : begin
            master = S3_B.BID_S[`AXI_IDS_BITS-1:`AXI_ID_BITS];
            BRESP = S3_B.BRESP;
            BID = S3_B.BID_S[`AXI_ID_BITS-1:0];
            BRESP = S3_B.BRESP;
            BVALID = S3_B.BVALID;
            S0_B.BREADY = 1'b0;
            S1_B.BREADY = 1'b0;
            S2_B.BREADY = 1'b0;
            S3_B.BREADY = S3_B.BVALID & BREADY;
            S4_B.BREADY = 1'b0;
            S5_B.BREADY = 1'b0;
        end
        6'b010000 : begin
            master = S4_B.BID_S[`AXI_IDS_BITS-1:`AXI_ID_BITS];
            BRESP = S4_B.BRESP;
            BID = S4_B.BID_S[`AXI_ID_BITS-1:0];
            BRESP = S4_B.BRESP;
            BVALID = S4_B.BVALID;
            S0_B.BREADY = 1'b0;
            S1_B.BREADY = 1'b0;
            S2_B.BREADY = 1'b0;
            S3_B.BREADY = 1'b0;
            S4_B.BREADY = S4_B.BVALID & BREADY;
            S5_B.BREADY = 1'b0;
        end
        6'b100000 : begin
            master = S5_B.BID_S[`AXI_IDS_BITS-1:`AXI_ID_BITS];
            BRESP = S5_B.BRESP;
            BID = S5_B.BID_S[`AXI_ID_BITS-1:0];
            BRESP = S5_B.BRESP;
            BVALID = S5_B.BVALID;
            S0_B.BREADY = 1'b0;
            S1_B.BREADY = 1'b0;
            S2_B.BREADY = 1'b0;
            S3_B.BREADY = 1'b0;
            S4_B.BREADY = 1'b0;
            S5_B.BREADY = S5_B.BVALID & BREADY;
        end
        default : begin
            master = 4'b0;
            BRESP = 2'b0;
            BID = `AXI_ID_BITS'b0;
            BRESP = 2'b0;
            BVALID = 1'b0;
            S0_B.BREADY = 1'b0;
            S1_B.BREADY = 1'b0;
            S2_B.BREADY = 1'b0;
            S3_B.BREADY = 1'b0;
            S4_B.BREADY = 1'b0;
            S5_B.BREADY = 1'b0;
        end
    endcase
end

always_comb begin
    case (master)
        4'b0010 : begin
            M1_B.BID = BID;
            M1_B.BRESP = BRESP;
            BREADY = M1_B.BREADY;
            M1_B.BVALID = BVALID;
            M2_B.BID = 4'b0;
            M2_B.BRESP = 2'b0;
            M2_B.BVALID = 1'b0;
        end
        4'b0100 : begin
            M2_B.BID = BID;
            M2_B.BRESP = BRESP;
            BREADY = M2_B.BREADY;
            M2_B.BVALID = BVALID;
            M1_B.BID = 4'b0;
            M1_B.BRESP = 2'b0;
            M1_B.BVALID = 1'b0;
        end
        default : begin
            M1_B.BID = 4'b0;
            M2_B.BID = 4'b0;
            M1_B.BRESP = 2'b0;
            M2_B.BRESP = 2'b0;
            BREADY = 1'b1;
            M1_B.BVALID = 1'b0;
            M2_B.BVALID = 1'b0;
        end 
    endcase
end

endmodule