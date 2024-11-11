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
	input 								BREADY_S
);

DRAM i_DRAM(
    .CK(),
    .Q(),
    .RST(),
    .CSn(),
    .WEn(),
    .RASn(),
    .CASn(),
    .A(),
    .D(),
    .VALID()
); 

endmodule