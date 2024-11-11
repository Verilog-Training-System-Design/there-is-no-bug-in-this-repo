`include "../include/AXI_define.svh"

module WriteResp (
    input clk,
    input rst,

    //M1
    output logic [`AXI_ID_BITS-1:0] BID_M1,
	output logic [1:0] BRESP_M1,
	output logic BVALID_M1,
	input BREADY_M1,

    //S0
    input [`AXI_IDS_BITS-1:0] BID_S0,
	input [1:0] BRESP_S0,
	input BVALID_S0,
	output logic BREADY_S0,

    //S1
    input [`AXI_IDS_BITS-1:0] BID_S1,
	input [1:0] BRESP_S1,
	input BVALID_S1,
	output logic BREADY_S1,

    //S2
    input [`AXI_IDS_BITS-1:0] BID_S2,
	input [1:0] BRESP_S2,
	input BVALID_S2,
	output logic BREADY_S2
);

logic [`AXI_ID_BITS-1:0] BID;
logic [1:0] BRESP;
logic BVALID;
logic BREADY;
logic lock_S0, lock_S1, lock_S2;
logic [3:0] master;
logic [2:0] slave;

assign BID_M1 = BID;
assign BRESP_M1 = BRESP;

always_ff @( posedge clk or negedge rst) begin
    if(~rst)begin
        lock_S0 <= 1'b0;
        lock_S1 <= 1'b0;
        lock_S2 <= 1'b0;
    end
    else begin
        if(lock_S0 & BREADY)
            lock_S0 <= 1'b0;
        else if(BVALID_S0 & ~BVALID_S1 & ~BVALID_S2 & ~BREADY)
            lock_S0 <= 1'b1;
        else 
            lock_S0 <= lock_S0;
        
        if(lock_S1 & BREADY)
            lock_S1 <= 1'b0;
        else if(~lock_S0 & BVALID_S1 & ~BVALID_S2 & ~BREADY)
            lock_S1 <= 1'b1;
        else 
            lock_S1 <= lock_S1;

        if(lock_S2 & BREADY)
            lock_S2 <= 1'b0;
        else if(~lock_S0 & ~lock_S1 & BVALID_S2 & ~BREADY)
            lock_S2 <= 1'b1;
        else 
            lock_S2 <= lock_S2;
    end
end

always_comb begin
    if((~lock_S0 & ~lock_S1 & BVALID_S2) | lock_S2)
        slave = 3'b100;
    else if((~lock_S0 & BVALID_S1) | lock_S1)
        slave = 3'b010;
    else if(BVALID_S0 | lock_S0)
        slave = 3'b001;
    else
        slave = 3'b000;
end

always_comb begin
    case (slave)
        3'b001 : begin
            master = BID_S0[`AXI_IDS_BITS-1:`AXI_ID_BITS];
            BRESP = BRESP_S0;
            BID = BID_S0[`AXI_ID_BITS-1:0];
            BRESP = BRESP_S0;
            BVALID = BVALID_S0;
            BREADY_S0 = BVALID_S0 & BREADY;
            BREADY_S1 = 1'b0;
            BREADY_S2 = 1'b0;
        end
        3'b010 : begin
            master = BID_S1[`AXI_IDS_BITS-1:`AXI_ID_BITS];
            BRESP = BRESP_S1;
            BID = BID_S1[`AXI_ID_BITS-1:0];
            BRESP = BRESP_S1;
            BVALID = BVALID_S1;
            BREADY_S0 = 1'b0;
            BREADY_S1 = BVALID_S1 & BREADY;
            BREADY_S2 = 1'b0;
        end
        3'b100 : begin
            master = BID_S2[`AXI_IDS_BITS-1:`AXI_ID_BITS];
            BRESP = BRESP_S2;
            BID = BID_S2[`AXI_ID_BITS-1:0];
            BRESP = BRESP_S2;
            BVALID = BVALID_S2;
            BREADY_S0 = 1'b0;
            BREADY_S1 = 1'b0;
            BREADY_S2 = BVALID_S2 & BREADY;
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
        end
    endcase
end

always_comb begin
    case (master)
        4'b0010 : begin
            BREADY = BREADY_M1;
            BVALID_M1 = BVALID;
        end
        default : begin
            BREADY = 1'b1;
            BVALID_M1 = 1'b0;
        end 
    endcase
end

endmodule