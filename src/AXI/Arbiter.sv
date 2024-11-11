`include "../include/AXI_define.svh"

module Arbiter(
    input clk,
    input rst,

    //M0 
    input [`AXI_ID_BITS-1:0]            ID_M0,
	input [`AXI_ADDR_BITS-1:0]          ADDR_M0,
	input [`AXI_LEN_BITS-1:0]           LEN_M0,
	input [`AXI_SIZE_BITS-1:0]          SIZE_M0,
	input [1:0]                         BURST_M0,
	input                               VALID_M0,

	output logic                        READY_M0,

    //M1
    input [`AXI_ID_BITS-1:0]            ID_M1,
	input [`AXI_ADDR_BITS-1:0]          ADDR_M1,
	input [`AXI_LEN_BITS-1:0]           LEN_M1,
	input [`AXI_SIZE_BITS-1:0]          SIZE_M1,
	input [1:0]                         BURST_M1,
	input                               VALID_M1,

	output logic                        READY_M1,

    //S
    output logic [`AXI_IDS_BITS-1:0]    ID_S,
	output logic [`AXI_ADDR_BITS-1:0]   ADDR_S,
	output logic [`AXI_LEN_BITS-1:0]    LEN_S,
	output logic [`AXI_SIZE_BITS-1:0]   SIZE_S,
	output logic [1:0]                  BURST_S,
	output logic                        VALID_S,

	input                               READY_S
);

//M1 has higher priority than M0
logic lock_M0, lock_M1;
logic [1:0] stage;

always_ff @( posedge clk or negedge rst ) begin
    if(~rst)begin
        lock_M0 <= 1'b0;
        lock_M1 <= 1'b0;
    end
    else begin
        if(VALID_M0 & READY_S)begin             //M0 finish transfer
            lock_M0 <= 1'b0;             
        end
        else if(VALID_M0 & ~VALID_M1 & ~READY_S)begin   //M0 require
            lock_M0 <= 1'b1;
        end
        else 
            lock_M0 <= lock_M0;

        if(VALID_M1 & READY_S)begin             //M1 finish transfer
            lock_M1 <= 1'b0;
        end
        else if(VALID_M1 & ~lock_M0 & ~READY_S)begin    //M1 require and M0 not occupy
            lock_M1 <= 1'b1;
        end
        else 
            lock_M1 <= lock_M1;
    end
end

always_comb begin           //since M1 > M0 in priority
    if((VALID_M1 & ~lock_M0) | lock_M1) begin
        stage = 2'b10;
    end
    else if(VALID_M0 | lock_M0) begin
        stage = 2'b01;
    end
    else 
        stage = 2'b00;
end

always_comb begin 
    case (stage)
        2'b01 : begin       //M0
            ID_S = {4'b0001, ID_M0};
            ADDR_S = ADDR_M0;
            LEN_S = LEN_M0;
            SIZE_S = SIZE_M0;
            BURST_S = BURST_M0;
            VALID_S = VALID_M0;
            READY_M1 = 1'b0;
            READY_M0 = READY_S & VALID_M0;
        end 
        2'b10 : begin       //M1
            ID_S = {4'b0010, ID_M1};
            ADDR_S = ADDR_M1;
            LEN_S = LEN_M1;
            SIZE_S = SIZE_M1;
            BURST_S = BURST_M1;
            VALID_S = VALID_M1;
            READY_M1 = READY_S & VALID_M1;
            READY_M0 = 1'b0;
        end 
        default : begin
            ID_S = `AXI_IDS_BITS'b0;
            ADDR_S = `AXI_ADDR_BITS'b0;
            LEN_S = `AXI_LEN_BITS'b0;
            SIZE_S = `AXI_SIZE_BITS'b0;
            BURST_S = 2'b0;
            VALID_S = 1'b0;
            READY_M1 = 1'b0;
            READY_M0 = 1'b0;
        end 
    endcase
end

endmodule