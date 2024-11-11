`include "../include/AXI_define.svh"

module Default_Slave (
	input 								clk,
	input 								rst,

	//READ ADDRESS1
	input [`AXI_IDS_BITS-1:0] 			ARID_S2,
	input [`AXI_ADDR_BITS-1:0] 			ARADDR_S2,
	input [`AXI_LEN_BITS-1:0] 			ARLEN_S2,
	input [`AXI_SIZE_BITS-1:0] 			ARSIZE_S2,
	input [1:0] 						ARBURST_S2,
	input 								ARVALID_S2,
	output logic 						ARREADY_S2,
	
	//READ DATA1
	output logic [`AXI_IDS_BITS-1:0] 	RID_S2,
	output logic [`AXI_DATA_BITS-1:0] 	RDATA_S2,
	output logic [1:0] 					RRESP_S2,
	output logic 						RLAST_S2,
	output logic 						RVALID_S2,
	input 								RREADY_S2,

	//WRITE ADDRESS
	input [`AXI_IDS_BITS-1:0] 			AWID_S2,
	input [`AXI_ADDR_BITS-1:0] 			AWADDR_S2,
	input [`AXI_LEN_BITS-1:0] 			AWLEN_S2,
	input [`AXI_SIZE_BITS-1:0] 			AWSIZE_S2,
	input [1:0] 						AWBURST_S2,
	input 								AWVALID_S2,
	output logic 						AWREADY_S2,
	
	//WRITE DATA
	input [`AXI_DATA_BITS-1:0] 			WDATA_S2,
	input [`AXI_STRB_BITS-1:0] 			WSTRB_S2,
	input 								WLAST_S2,
	input 								WVALID_S2,
	output logic 						WREADY_S2,
	
	//WRITE RESPONSE
	output logic [`AXI_IDS_BITS-1:0] 	BID_S2,
	output logic [1:0] 					BRESP_S2,
	output logic 						BVALID_S2,
	input 								BREADY_S2
);

logic [13:0] address, address_4;
logic [`AXI_LEN_BITS-1:0] arlen, counter;
logic [1:0] stage, next_stage;
localparam  idle = 2'b00,
            read_data = 2'b01,
            write_data = 2'b10,
            write_response = 2'b11;

assign RRESP_S2 = `AXI_RESP_DECERR;
assign RDATA_S2 = `AXI_ADDR_BITS'b0;
assign RID_S2 = (ARVALID_S2 & ARREADY_S2) ? ARID_S2 : RID_S2;
assign RLAST_S2 = (stage == read_data) && (counter == arlen);

assign BRESP_S2 = `AXI_RESP_DECERR;
assign BID_S2 = (AWVALID_S2 & AWREADY_S2) ? AWID_S2 : BID_S2;
// assign RLAST_S2 = (RVALID_S2 & RREADY_S2) ? 1'b1 : 1'b0;

always_ff @( posedge clk or negedge rst ) begin
    if(~rst)begin
        address <= 14'b0;
        address_4 <= 14'b0;
        counter <= `AXI_LEN_BITS'b0;
    end 
    else if(stage == idle)begin
        if(ARVALID_S2 & ARREADY_S2)begin
            address <= ARADDR_S2[15:2];
            address_4 <= ARADDR_S2[15:2] + 14'b1;
        end
        else if(AWVALID_S2 & AWREADY_S2)begin
            address <= AWADDR_S2[15:2];
        end
    end
    else if(stage == read_data)begin
        if(RVALID_S2 & RREADY_S2) begin           //in read data state and not read the end, increase address to get next data
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
        if(WVALID_S2 & WREADY_S2)begin
            address <= address + 14'b1;
        end
    end
end

always_ff @( posedge clk or negedge rst ) begin 
    if(~rst)
        arlen <= `AXI_LEN_BITS'b0;
    else 
        if(ARVALID_S2 & ARREADY_S2)
            arlen <= ARLEN_S2;
        else 
            arlen <= arlen;
end

// always_ff @( posedge clk or negedge rst ) begin
//     if(~rst)
//         RLAST_S2 <= 1'b0;
//     else if(ARREADY_S2 & ARVALID_S2)
// end

always_ff @( posedge clk or negedge rst ) begin
    if(~rst)
        stage <= idle;
    else 
        stage <= next_stage;
end

always_comb begin
    case (stage)
        idle : begin
            if(ARVALID_S2 & ARREADY_S2)
                next_stage = read_data;
            else if(AWVALID_S2 & AWREADY_S2)
                next_stage = write_data;
            else 
                next_stage = idle;
        end
        read_data : begin
            if(RVALID_S2 & RREADY_S2 & RLAST_S2)
                next_stage = idle;
            else 
                next_stage = read_data;
        end
        write_data : begin
            if(WVALID_S2 & WREADY_S2 & WLAST_S2)
                next_stage = write_response;
            else 
                next_stage = write_data;
        end
        write_response : begin
            if(BVALID_S2 & BREADY_S2)
                next_stage = idle;
            else 
                next_stage = write_response;
        end
    endcase
end

always_comb begin
    case (stage)
        idle : begin
            ARREADY_S2 = ~AWVALID_S2;
            RVALID_S2 = 1'b0;
            AWREADY_S2 = 1'b1;
            WREADY_S2 = 1'b0;
            BVALID_S2 = 1'b0;
        end
        read_data : begin
            ARREADY_S2 = 1'b0;
            RVALID_S2 = 1'b1;
            AWREADY_S2 = 1'b0;
            WREADY_S2 = 1'b0;
            BVALID_S2 = 1'b0;
        end
        write_data : begin
            ARREADY_S2 = 1'b0;
            RVALID_S2 = 1'b0;
            AWREADY_S2 = 1'b0;
            WREADY_S2 = 1'b1;
            BVALID_S2 = 1'b0;
        end
        write_response : begin
            ARREADY_S2 = 1'b0;
            RVALID_S2 = 1'b0;
            AWREADY_S2 = 1'b0;
            WREADY_S2 = 1'b0;
            BVALID_S2 = 1'b1;
        end
    endcase    
end

endmodule