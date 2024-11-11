`include "../include/AXI_define.svh"
`include "../src/AXI/Arbiter.sv"

module ReadData (
    input clk,
    input rst,
    //M0	
    output logic [`AXI_ID_BITS-1:0] RID_M0,
	output logic [`AXI_DATA_BITS-1:0] RDATA_M0,
	output logic [1:0] RRESP_M0,
	output logic RLAST_M0,
	output logic RVALID_M0,
	input RREADY_M0,

    //M1
    output logic [`AXI_ID_BITS-1:0] RID_M1,
	output logic [`AXI_DATA_BITS-1:0] RDATA_M1,
	output logic [1:0] RRESP_M1,
	output logic RLAST_M1,
	output logic RVALID_M1,
	input RREADY_M1,

    //S0
    input [`AXI_IDS_BITS-1:0] RID_S0,
	input [`AXI_DATA_BITS-1:0] RDATA_S0,
	input [1:0] RRESP_S0,
	input RLAST_S0,
	input RVALID_S0,
	output logic RREADY_S0,

    //S1
    input [`AXI_IDS_BITS-1:0] RID_S1,
	input [`AXI_DATA_BITS-1:0] RDATA_S1,
	input [1:0] RRESP_S1,
	input RLAST_S1,
	input RVALID_S1,
	output logic RREADY_S1,

    //S2
    input [`AXI_IDS_BITS-1:0] RID_S2,
	input [`AXI_DATA_BITS-1:0] RDATA_S2,
	input [1:0] RRESP_S2,
	input RLAST_S2,
	input RVALID_S2,
	output logic RREADY_S2
);

logic [`AXI_ID_BITS-1:0] RID;
logic [`AXI_DATA_BITS-1:0] RDATA;
logic [1:0] RRESP;
logic RLAST;
logic RVALID;
logic RREADY;

assign RID_M0 = RID;
assign RDATA_M0 = RDATA;
assign RRESP_M0 = RRESP;
assign RLAST_M0 = RLAST;

assign RID_M1 = RID;
assign RDATA_M1 = RDATA;
assign RRESP_M1 = RRESP;
assign RLAST_M1 = RLAST;

logic lock_S0, lock_S1, lock_S2;
logic [3:0] master;
logic [2:0] slave;

always_ff @( posedge clk or negedge rst) begin
    if(~rst)begin
        lock_S0 <= 1'b0;
        lock_S1 <= 1'b0;
        lock_S2 <= 1'b0;
    end
    else begin
        if(lock_S0 & RREADY & RLAST_S0)
            lock_S0 <= 1'b0;
        else if(RVALID_S0 & ~RVALID_S1 & ~RVALID_S2 & ~RREADY)
            lock_S0 <= 1'b1;
        else 
            lock_S0 <= lock_S0;
        
        if(lock_S1 & RREADY & RLAST_S1)
            lock_S1 <= 1'b0;
        else if(RVALID_S1 & ~lock_S0 & ~RVALID_S2 & ~RREADY)
            lock_S1 <= 1'b1;
        else 
            lock_S1 <= lock_S1;

        if(lock_S2 & RREADY & RLAST_S2)
            lock_S2 <= 1'b0;
        else if(RVALID_S2 & ~lock_S0 & ~lock_S1 & ~RREADY)
            lock_S2 <= 1'b1;
        else 
            lock_S2 <= lock_S2;
    end
end

always_comb begin
    if((RVALID_S2 & ~lock_S0 & ~lock_S1) | lock_S2)
        slave = 3'b100;
    else if((RVALID_S1 & ~lock_S0) | lock_S1)
        slave = 3'b010;
    else  if(RVALID_S0 | lock_S0)
        slave = 3'b001;
    else
        slave = 3'b000;
end

always_comb begin
    case(slave)
        3'b001 : begin
            master = RID_S0[`AXI_IDS_BITS-1:`AXI_ID_BITS];
            RID = RID_S0[`AXI_ID_BITS-1:0];
            RDATA = RDATA_S0;
            RRESP = RRESP_S0;
            RLAST = RLAST_S0;
            RVALID = RVALID_S0;
            RREADY_S0 = RVALID_S0 & RREADY;
            RREADY_S1 = 1'b0;
            RREADY_S2 = 1'b0;
        end
        3'b010 : begin
            master = RID_S1[`AXI_IDS_BITS-1:`AXI_ID_BITS];
            RID = RID_S1[`AXI_ID_BITS-1:0];
            RDATA = RDATA_S1;
            RRESP = RRESP_S1;
            RLAST = RLAST_S1;
            RVALID = RVALID_S1;
            RREADY_S1 = RVALID_S1 & RREADY;
            RREADY_S0 = 1'b0;
            RREADY_S2 = 1'b0;
        end
        3'b100 : begin
            master = RID_S2[`AXI_IDS_BITS-1:`AXI_ID_BITS];
            RID = RID_S2[`AXI_ID_BITS-1:0];
            RDATA = RDATA_S2;
            RRESP = RRESP_S2;
            RLAST = RLAST_S2;
            RVALID = RVALID_S2;
            RREADY_S2 = RVALID_S2 & RREADY;
            RREADY_S0 = 1'b0;
            RREADY_S1 = 1'b0;
        end
        default : begin
            master = 4'b0;
            RID = `AXI_ID_BITS'b0;
            RDATA = `AXI_ADDR_BITS'b0;
            RRESP = 2'b0;
            RLAST = 1'b0;
            RVALID = 1'b0;
            RREADY_S0 = 1'b0;
            RREADY_S1 = 1'b0;
            RREADY_S2 = 1'b0;
        end
    endcase
end

always_comb begin
    case (master)
        4'b0001 : begin
            RVALID_M0 = RVALID;
            RVALID_M1 = 1'b0;
            RREADY = RREADY_M0;
        end
        4'b0010 : begin
            RVALID_M0 = 1'b0;
            RVALID_M1 = RVALID;
            RREADY = RREADY_M1;
        end
        default : begin
            RVALID_M0 = 1'b0;
            RVALID_M1 = 1'b0;
            RREADY = 1'b1;          //ready before valid
        end
    endcase
end

endmodule