`include "../include/AXI_define.svh"

module DRAM_wrapper (
    input clk,
    input rst,
    
    //READ ADDRESS1
	input [`AXI_IDS_BITS-1:0] 			ARID_S,
	input [`AXI_ADDR_BITS-1:0] 			ARADDR_S,
	input [`AXI_LEN_BITS-1:0] 			ARLEN_S,
	input [`AXI_SIZE_BITS-1:0] 			ARSIZE_S,
	input [1:0] 						ARBURST_S,
	input 								ARVALID_S,
	output logic 						ARREADY_S,
	
	//READ DATA1
	output logic [`AXI_IDS_BITS-1:0] 	RID_S,
	output logic [`AXI_DATA_BITS-1:0] 	RDATA_S,
	output logic [1:0] 					RRESP_S,
	output logic 						RLAST_S,
	output logic 						RVALID_S,
	input 								RREADY_S,

	//WRITE ADDRESS
	input [`AXI_IDS_BITS-1:0] 			AWID_S,
	input [`AXI_ADDR_BITS-1:0] 			AWADDR_S,
	input [`AXI_LEN_BITS-1:0] 			AWLEN_S,
	input [`AXI_SIZE_BITS-1:0] 			AWSIZE_S,
	input [1:0] 						AWBURST_S,
	input 								AWVALID_S,
	output logic 						AWREADY_S,
	
	//WRITE DATA
	input [`AXI_DATA_BITS-1:0] 			WDATA_S,
	input [`AXI_STRB_BITS-1:0] 			WSTRB_S,
	input 								WLAST_S,
	input 								WVALID_S,
	output logic 						WREADY_S,
	
	//WRITE RESPONSE
	output logic [`AXI_IDS_BITS-1:0] 	BID_S,
	output logic [1:0] 					BRESP_S,
	output logic 						BVALID_S,
	input 								BREADY_S,

	output logic 						DRAM_CSn,
    output logic [3:0]					DRAM_WEn,
    output logic 						DRAM_RASn,
    output logic 						DRAM_CASn,
    output logic [10:0] 				DRAM_A,
    output logic [31:0]					DRAM_D,
	input 								DRAM_valid,
    input [31:0]						DRAM_Q
);

logic [2:0] delay;		//count DRAM delay cycles
logic [10:0] pre_row, cur_row;
logic [9:0] col, col_4;

logic [`AXI_IDS_BITS-1:0] ID_reg;
logic [`AXI_ADDR_BITS-1:0] ADDR_reg;
logic [`AXI_LEN_BITS-1:0] LEN_reg;
logic [`AXI_SIZE_BITS-1:0] SIZE_reg;
logic [1:0] BURST_reg;

logic [1:0] stage, next_stage, pre_stage;
localparam [2:0] idle = 3'b000,
				 precharge = 3'b001,
				 activate = 3'b010,
            	 read_data = 3'b011,
            	 write_data = 3'b100,
            	 write_response = 3'b101;

logic [`AXI_LEN_BITS-1:0] arlen, awlen;
logic [`AXI_LEN_BITS-1:0] counter;

assign RID_S = (ARVALID_S & ARREADY_S) ? ARID_S : RID_S;
assign RDATA_S = DRAM_Q;
assign RRESP_S = `AXI_RESP_OKAY;
assign RLAST_S = ((stage == read_data) && (counter == arlen)); 
assign BID_S = (AWVALID_S & AWREADY_S) ? AWID_S : BID_S;
assign BRESP_S = `AXI_RESP_OKAY;

always_ff @( posedge clk or negedge rst ) begin 
    if(~rst)begin
        arlen <= `AXI_LEN_BITS'b0;
        awlen <= `AXI_LEN_BITS'b0;
    end
    else begin
        if(ARVALID_S & ARREADY_S)
            arlen <= ARLEN_S;
        else 
            arlen <= arlen;
        
        if(AWVALID_S & AWREADY_S)
            awlen <= AWLEN_S;
        else
            awlen <= awlen;
    end
end

//get address(not yet)
always_ff @( posedge clk or negedge rst ) begin
    if(~rst)begin
        address <= 14'b0;
        address_4 <= 14'b0;
        counter <= `AXI_LEN_BITS'b0;
    end 
    else if(stage == idle)begin
        if(ARVALID_S & ARREADY_S)begin
            address <= ARADDR_S[15:2];
            address_4 <= ARADDR_S[15:2] + 14'b1;
        end
        else if(AWVALID_S & AWREADY_S)begin
            address <= AWADDR_S[15:2];
        end
    end
    else if(stage == read_data)begin
        if(RVALID_S & RREADY_S) begin           //in read data state and not read the end, increase address to get next data
            address <= address + 14'b1;
            address_4 <= address_4 + 14'b1;
            if(counter == arlen)begin
                counter <= `AXI_LEN_BITS'b0;
            end
            else begin
                counter <= counter + `AXI_LEN_BITS'b1;
            end
        end
    end
    else if(stage == write_data)begin
        if(WVALID_S & WREADY_S)begin
            address <= address + 14'b1;
        end
    end
end

//precharge 


//FSM for slave to switch channel
always_ff @( posedge clk or negedge rst) begin 
    if(~rst)
        stage <= idle;
    else 
        stage <= next_stage;
end

always_comb begin
    case (stage)
        idle : begin
            if(AWVALID_S & AWREADY_S)
                next_stage = write_data;
            else if(ARVALID_S & ARREADY_S)
                next_stage = read_data;
            else
                next_stage = idle;
        end
        read_data : begin
            if(pre_row == cur_row)begin
				pre_stage = read_data;
                next_stage = set_col;
			end
            else begin 
				pre_stage = read_data;
                next_stage = pre;
			end
        end
        write_data : begin
            if(WVALID_S & WREADY_S & WLAST_S)
                next_stage = write_response;
            else 
                next_stage = write_data;
        end
        write_response : begin
            if(BVALID_S & BREADY_S)
                next_stage = idle;
            else 
                next_stage = write_response;
        end
		act : begin
			
		end
    endcase    
end

always_comb begin
    case (stage)
        idle : begin
            ARREADY_S = ~AWVALID_S;         //I change here then prog1 become right
            RVALID_S = 1'b0;
            AWREADY_S = 1'b1;
            WREADY_S = 1'b0;
            BVALID_S = 1'b0;
            A = (AWVALID_S) ? AWADDR_S[15:2] : ARADDR_S[15:2];
        end
        read_data : begin
            ARREADY_S = 1'b0;
            RVALID_S = 1'b1;
            AWREADY_S = 1'b0;
            WREADY_S = 1'b0;
            BVALID_S = 1'b0;
            A = (RVALID_S & RREADY_S & RLAST_S) ? address : (RVALID_S & RREADY_S) ? address_4 : address;
        end
        write_data : begin
            ARREADY_S = 1'b0;
            RVALID_S = 1'b0;
            AWREADY_S = 1'b0;
            WREADY_S = 1'b1;
            BVALID_S = 1'b0;
            A = address;
        end
        write_response : begin
            ARREADY_S = 1'b0;
            RVALID_S = 1'b0;
            AWREADY_S = 1'b0;
            WREADY_S = 1'b0;
            BVALID_S = 1'b1;
            A = 14'b0;
        end
    endcase
end

endmodule