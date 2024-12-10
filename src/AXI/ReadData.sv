`include "../include/AXI_define.svh"
`include "../src/AXI/Arbiter.sv"

module ReadData (
    input clk,
    input rst,
    //M0	
    // output logic [`AXI_ID_BITS-1:0] RID_M0,
	// output logic [`AXI_DATA_BITS-1:0] RDATA_M0,
	// output logic [1:0] RRESP_M0,
	// output logic RLAST_M0,
	// output logic RVALID_M0,
	// input RREADY_M0,
    R.Master M0_R,
    R.Master M1_R,
    R.Master M2_R,

    // //M1
    // output logic [`AXI_ID_BITS-1:0] RID_M1,
	// output logic [`AXI_DATA_BITS-1:0] RDATA_M1,
	// output logic [1:0] RRESP_M1,
	// output logic RLAST_M1,
	// output logic RVALID_M1,
	// input RREADY_M1,

    // //DMA
    // output logic [`AXI_ID_BITS-1:0] RID_M2,
	// output logic [`AXI_DATA_BITS-1:0] RDATA_M2,
	// output logic [1:0] RRESP_M2,
	// output logic RLAST_M2,
	// output logic RVALID_M2,
	// input RREADY_M2,

    // //S0    ROM
    // input [`AXI_IDS_BITS-1:0] RID_S0,
	// input [`AXI_DATA_BITS-1:0] RDATA_S0,
	// input [1:0] RRESP_S0,
	// input RLAST_S0,
	// input RVALID_S0,
	// output logic RREADY_S0,

    // //S1    IM
    // input [`AXI_IDS_BITS-1:0] RID_S1,
	// input [`AXI_DATA_BITS-1:0] RDATA_S1,
	// input [1:0] RRESP_S1,
	// input RLAST_S1,
	// input RVALID_S1,
	// output logic RREADY_S1,

    // //S2    DM
    // input [`AXI_IDS_BITS-1:0] RID_S2,
	// input [`AXI_DATA_BITS-1:0] RDATA_S2,
	// input [1:0] RRESP_S2,
	// input RLAST_S2,
	// input RVALID_S2,
	// output logic RREADY_S2,

    // //S3    DMA
    // input [`AXI_IDS_BITS-1:0] RID_S3,
	// input [`AXI_DATA_BITS-1:0] RDATA_S3,
	// input [1:0] RRESP_S3,
	// input RLAST_S3,
	// input RVALID_S3,
	// output logic RREADY_S3,

    // //S4    WDT
    // input [`AXI_IDS_BITS-1:0] RID_S4,
	// input [`AXI_DATA_BITS-1:0] RDATA_S4,
	// input [1:0] RRESP_S4,
	// input RLAST_S4,
	// input RVALID_S4,
	// output logic RREADY_S4,

    // //S5    DRAM
    // input [`AXI_IDS_BITS-1:0] RID_S5,
	// input [`AXI_DATA_BITS-1:0] RDATA_S5,
	// input [1:0] RRESP_S5,
	// input RLAST_S5,
	// input RVALID_S5,
	// output logic RREADY_S5
    R.Slave S0_R,
    R.Slave S1_R,
    R.Slave S2_R,
    R.Slave S3_R,
    R.Slave S4_R,
    R.Slave S5_R
);

logic [`AXI_ID_BITS-1:0] RID;
logic [`AXI_DATA_BITS-1:0] RDATA;
logic [1:0] RRESP;
logic RLAST;
logic RVALID;
logic RREADY;

assign M0_R.RID = RID;
assign M0_R.RDATA = RDATA;
assign M0_R.RRESP = RRESP;
assign M0_R.RLAST = RLAST;

assign M1_R.RID = RID;
assign M1_R.RDATA = RDATA;
assign M1_R.RRESP = RRESP;
assign M1_R.RLAST = RLAST;

assign M2_R.RID = RID;
assign M2_R.RDATA = RDATA;
assign M2_R.RRESP = RRESP;
assign M2_R.RLAST = RLAST;

// assign RID_M1 = RID;
// assign RDATA_M1 = RDATA;
// assign RRESP_M1 = RRESP;
// assign RLAST_M1 = RLAST;

// assign RID_M2 = RID;
// assign RDATA_M2 = RDATA;
// assign RRESP_M2 = RRESP;
// assign RLAST_M2 = RLAST;

logic lock_S0, lock_S1, lock_S2, lock_S3, lock_S4, lock_S5;         //S4 > S3 > S5 > S2 > S1 > S0
logic [3:0] master;
logic [5:0] slave;

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
        if(lock_S0 & RREADY & S0_R.RLAST)
            lock_S0 <= 1'b0;
        else if(S0_R.RVALID & ~S5_R.RVALID & ~S1_R.RVALID & ~S2_R.RVALID & ~S3_R.RVALID & ~S4_R.RVALID & ~RREADY)
            lock_S0 <= 1'b1;
        else 
            lock_S0 <= lock_S0;
        
        if(lock_S1 & RREADY & S1_R.RLAST)
            lock_S1 <= 1'b0;
        else if(S1_R.RVALID & ~S0_R.RVALID & ~S2_R.RVALID & ~S3_R.RVALID & ~S4_R.RVALID & ~lock_S5 & ~RREADY)
            lock_S1 <= 1'b1;
        else 
            lock_S1 <= lock_S1;

        if(lock_S2 & RREADY & S2_R.RLAST)
            lock_S2 <= 1'b0;
        else if(S2_R.RVALID & ~S0_R.RVALID & ~lock_S1 & ~S3_R.RVALID & ~S4_R.RVALID & ~lock_S5 & ~RREADY)
            lock_S2 <= 1'b1;
        else 
            lock_S2 <= lock_S2;
        
        if(lock_S5 & RREADY & S5_R.RLAST)
            lock_S5 <= 1'b0;
        else if(S5_R.RVALID & ~lock_S1 & ~lock_S2 & ~S3_R.RVALID & ~S4_R.RVALID & ~lock_S0 & ~RREADY)
            lock_S5 <= 1'b1;
        else 
            lock_S5 <= lock_S5;
        
        if(lock_S3 & RREADY & S3_R.RLAST)
            lock_S3 <= 1'b0;
        else if(S3_R.RVALID & ~lock_S0 & ~lock_S1 & ~lock_S2 & ~S4_R.RVALID & ~lock_S5 & ~RREADY)
            lock_S3 <= 1'b1;
        else 
            lock_S3 <= lock_S3;

        if(lock_S4 & RREADY & S4_R.RLAST)
            lock_S4 <= 1'b0;
        else if(S4_R.RVALID & ~lock_S0 & ~lock_S1 & ~lock_S2 & ~lock_S3 & ~lock_S5 & ~RREADY)
            lock_S4 <= 1'b1;
        else 
            lock_S4 <= lock_S4;
    end
end

always_comb begin
    if((S4_R.RVALID & ~lock_S0 & ~lock_S1 & ~lock_S2 & ~lock_S3 & ~lock_S5) | lock_S4)
        slave = 6'b010000;
    else if((S3_R.RVALID & ~lock_S0 & ~lock_S1 & ~lock_S2 & ~lock_S5) | lock_S3)
        slave = 6'b001000;
    else if((S5_R.RVALID & ~lock_S1 & ~lock_S2 & ~lock_S0) | lock_S5)
        slave = 6'b100000;
    else if((S2_R.RVALID & ~lock_S5 & ~lock_S1) | lock_S2)
        slave = 6'b000100;
    else if((S1_R.RVALID & ~lock_S5) | lock_S1)
        slave = 6'b000010;
    else if(S0_R.RVALID | lock_S0)
        slave = 6'b000001;
    else
        slave = 6'd0;
end

always_comb begin
    case(slave)
        6'b000001 : begin
            master = S0_R.RID_S[`AXI_IDS_BITS-1:`AXI_ID_BITS];
            RID = S0_R.RID_S[`AXI_ID_BITS-1:0];
            RDATA = S0_R.RDATA;
            RRESP = S0_R.RRESP;
            RLAST = S0_R.RLAST;
            RVALID = S0_R.RVALID;
            S0_R.RREADY = S0_R.RVALID & RREADY;
            S1_R.RREADY = 1'b0;
            S2_R.RREADY = 1'b0;
            S3_R.RREADY = 1'b0;
            S4_R.RREADY = 1'b0;
            S5_R.RREADY = 1'b0;
        end
        6'b000010 : begin
            master = S1_R.RID_S[`AXI_IDS_BITS-1:`AXI_ID_BITS];
            RID = S1_R.RID_S[`AXI_ID_BITS-1:0];
            RDATA = S1_R.RDATA;
            RRESP = S1_R.RRESP;
            RLAST = S1_R.RLAST;
            RVALID = S1_R.RVALID;
            S1_R.RREADY = S1_R.RVALID & RREADY;
            S0_R.RREADY = 1'b0;
            S2_R.RREADY = 1'b0;
            S3_R.RREADY = 1'b0;
            S4_R.RREADY = 1'b0;
            S5_R.RREADY = 1'b0;
        end
        6'b000100 : begin
            master = S2_R.RID_S[`AXI_IDS_BITS-1:`AXI_ID_BITS];
            RID = S2_R.RID_S[`AXI_ID_BITS-1:0];
            RDATA = S2_R.RDATA;
            RRESP = S2_R.RRESP;
            RLAST = S2_R.RLAST;
            RVALID = S2_R.RVALID;
            S2_R.RREADY = S2_R.RVALID & RREADY;
            S0_R.RREADY = 1'b0;
            S1_R.RREADY = 1'b0;
            S3_R.RREADY = 1'b0;
            S4_R.RREADY = 1'b0;
            S5_R.RREADY = 1'b0;
        end
        6'b001000 : begin
            master = S3_R.RID_S[`AXI_IDS_BITS-1:`AXI_ID_BITS];
            RID = S3_R.RID_S[`AXI_ID_BITS-1:0];
            RDATA = S3_R.RDATA;
            RRESP = S3_R.RRESP;
            RLAST = S3_R.RLAST;
            RVALID = S3_R.RVALID;
            S2_R.RREADY = 1'b0;
            S0_R.RREADY = 1'b0;
            S1_R.RREADY = 1'b0;
            S3_R.RREADY = S3_R.RVALID & RREADY;
            S4_R.RREADY = 1'b0;
            S5_R.RREADY = 1'b0;
        end
        6'b010000 : begin
            master = S4_R.RID_S[`AXI_IDS_BITS-1:`AXI_ID_BITS];
            RID = S4_R.RID_S[`AXI_ID_BITS-1:0];
            RDATA = S4_R.RDATA;
            RRESP = S4_R.RRESP;
            RLAST = S4_R.RLAST;
            RVALID = S4_R.RVALID;
            S2_R.RREADY = 1'b0;
            S0_R.RREADY = 1'b0;
            S1_R.RREADY = 1'b0;
            S3_R.RREADY = 1'b0;
            S4_R.RREADY = S4_R.RVALID & RREADY;
            S5_R.RREADY = 1'b0;
        end
        6'b100000 : begin
            master = S5_R.RID_S[`AXI_IDS_BITS-1:`AXI_ID_BITS];
            RID = S5_R.RID_S[`AXI_ID_BITS-1:0];
            RDATA = S5_R.RDATA;
            RRESP = S5_R.RRESP;
            RLAST = S5_R.RLAST;
            RVALID = S5_R.RVALID;
            S2_R.RREADY = 1'b0;
            S0_R.RREADY = 1'b0;
            S1_R.RREADY = 1'b0;
            S3_R.RREADY = 1'b0;
            S4_R.RREADY = 1'b0;
            S5_R.RREADY = S5_R.RVALID & RREADY;
        end
        default : begin
            master = 4'b0;
            RID = `AXI_ID_BITS'b0;
            RDATA = `AXI_ADDR_BITS'b0;
            RRESP = 2'b0;
            RLAST = 1'b0;
            RVALID = 1'b0;
            S0_R.RREADY = 1'b0;
            S1_R.RREADY = 1'b0;
            S2_R.RREADY = 1'b0;
            S3_R.RREADY = 1'b0;
            S4_R.RREADY = 1'b0;
            S5_R.RREADY = 1'b0;
        end
    endcase
end

always_comb begin
    case (master)
        4'b0001 : begin
            M0_R.RVALID = RVALID;
            M1_R.RVALID = 1'b0;
            M2_R.RVALID = 1'b0;
            RREADY = M0_R.RREADY;
        end
        4'b0010 : begin
            M0_R.RVALID = 1'b0;
            M1_R.RVALID = RVALID;
            M2_R.RVALID = 1'b0;
            RREADY = M1_R.RREADY;
        end
        4'b0100 : begin
            M0_R.RVALID = 1'b0;
            M1_R.RVALID = 1'b0;;
            M2_R.RVALID = RVALID;
            RREADY = M2_R.RREADY;
        end
        default : begin
            M0_R.RVALID = 1'b0;
            M1_R.RVALID = 1'b0;
            M2_R.RVALID = 1'b0;
            RREADY = 1'b0;          //ready before valid
        end
    endcase
end

endmodule