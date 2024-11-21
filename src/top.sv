`include "CPU_wrapper.sv"
`include "SRAM_wrapper.sv"
`include "./AXI/AXI.sv"
`include "DRAM_wrapper.sv"

module top (
    input clk,
    input clk2,
    input rst,
    input rst2,
    input [31:0] ROM_out,
    output logic ROM_read,
    output logic ROM_enable,
    output logic [11:0] ROM_address,
    output logic DRAM_CSn,
    output logic [3:0] DRAM_WEn,
    output logic DRAM_RASn,
    output logic DRAM_CASn,
    output logic [10:0] DRAM_A,
    output logic [31:0] DRAM_D,
    input DRAM_valid,
    input [31:0] DRAM_Q       				
);

//WRITE ADDRESS
logic [`AXI_ID_BITS-1:0] w_AWID_M1;
logic [`AXI_ADDR_BITS-1:0] w_AWADDR_M1;
logic [`AXI_LEN_BITS-1:0] w_AWLEN_M1;
logic [`AXI_SIZE_BITS-1:0] w_AWSIZE_M1;
logic [1:0] w_AWBURST_M1;
logic w_AWVALID_M1;
logic w_AWREADY_M1;

//WRITE DATA
logic [`AXI_DATA_BITS-1:0] w_WDATA_M1;
logic [`AXI_STRB_BITS-1:0] w_WSTRB_M1;
logic w_WLAST_M1;
logic w_WVALID_M1;
logic w_WREADY_M1;

//WRITE RESPONSE
logic [`AXI_ID_BITS-1:0] w_BID_M1;
logic [1:0] w_BRESP_M1;
logic w_BVALID_M1;
logic w_BREADY_M1;

//READ ADDRESS0
logic [`AXI_ID_BITS-1:0] w_ARID_M0;
logic [`AXI_ADDR_BITS-1:0] w_ARADDR_M0;
logic [`AXI_LEN_BITS-1:0] w_ARLEN_M0;
logic [`AXI_SIZE_BITS-1:0] w_ARSIZE_M0;
logic [1:0] w_ARBURST_M0;
logic w_ARVALID_M0;
logic w_ARREADY_M0;

//READ DATA0
logic [`AXI_ID_BITS-1:0] w_RID_M0;
logic [`AXI_DATA_BITS-1:0] w_RDATA_M0;
logic [1:0] w_RRESP_M0;
logic w_RLAST_M0;
logic w_RVALID_M0;
logic w_RREADY_M0;

//READ ADDRESS1
logic [`AXI_ID_BITS-1:0] w_ARID_M1;
logic [`AXI_ADDR_BITS-1:0] w_ARADDR_M1;
logic [`AXI_LEN_BITS-1:0] w_ARLEN_M1;
logic [`AXI_SIZE_BITS-1:0] w_ARSIZE_M1;
logic [1:0] w_ARBURST_M1;
logic w_ARVALID_M1;
logic w_ARREADY_M1;

//READ DATA1
logic [`AXI_ID_BITS-1:0] w_RID_M1;
logic [`AXI_DATA_BITS-1:0] w_RDATA_M1;
logic [1:0] w_RRESP_M1;
logic w_RLAST_M1;
logic w_RVALID_M1;
logic w_RREADY_M1;

//MASTER INTERFACE FOR SLAVES
//WRITE ADDRESS0
logic [`AXI_IDS_BITS-1:0] w_AWID_S0;
logic [`AXI_ADDR_BITS-1:0] w_AWADDR_S0;
logic [`AXI_LEN_BITS-1:0] w_AWLEN_S0;
logic [`AXI_SIZE_BITS-1:0] w_AWSIZE_S0;
logic [1:0] w_AWBURST_S0;
logic w_AWVALID_S0;
logic w_AWREADY_S0;

//WRITE DATA0
logic [`AXI_DATA_BITS-1:0] w_WDATA_S0;
logic [`AXI_STRB_BITS-1:0] w_WSTRB_S0;
logic w_WLAST_S0;
logic w_WVALID_S0;
logic w_WREADY_S0;

//WRITE RESPONSE0
logic [`AXI_IDS_BITS-1:0] w_BID_S0;
logic [1:0] w_BRESP_S0;
logic w_BVALID_S0;
logic w_BREADY_S0;

//WRITE ADDRESS1
logic [`AXI_IDS_BITS-1:0] w_AWID_S1;
logic [`AXI_ADDR_BITS-1:0] w_AWADDR_S1;
logic [`AXI_LEN_BITS-1:0] w_AWLEN_S1;
logic [`AXI_SIZE_BITS-1:0] w_AWSIZE_S1;
logic [1:0] w_AWBURST_S1;
logic w_AWVALID_S1;
logic w_AWREADY_S1;

//WRITE DATA1
logic [`AXI_DATA_BITS-1:0] w_WDATA_S1;
logic [`AXI_STRB_BITS-1:0] w_WSTRB_S1;
logic w_WLAST_S1;
logic w_WVALID_S1;
logic w_WREADY_S1;

//WRITE RESPONSE1
logic [`AXI_IDS_BITS-1:0] w_BID_S1;
logic [1:0] w_BRESP_S1;
logic w_BVALID_S1;
logic w_BREADY_S1;

//READ ADDRESS0
logic [`AXI_IDS_BITS-1:0] w_ARID_S0;
logic [`AXI_ADDR_BITS-1:0] w_ARADDR_S0;
logic [`AXI_LEN_BITS-1:0] w_ARLEN_S0;
logic [`AXI_SIZE_BITS-1:0] w_ARSIZE_S0;
logic [1:0] w_ARBURST_S0;
logic w_ARVALID_S0;
logic w_ARREADY_S0;

//READ DATA0
logic [`AXI_IDS_BITS-1:0] w_RID_S0;
logic [`AXI_DATA_BITS-1:0] w_RDATA_S0;
logic [1:0] w_RRESP_S0;
logic w_RLAST_S0;
logic w_RVALID_S0;
logic w_RREADY_S0;

//READ ADDRESS1
logic [`AXI_IDS_BITS-1:0] w_ARID_S1;
logic [`AXI_ADDR_BITS-1:0] w_ARADDR_S1;
logic [`AXI_LEN_BITS-1:0] w_ARLEN_S1;
logic [`AXI_SIZE_BITS-1:0] w_ARSIZE_S1;
logic [1:0] w_ARBURST_S1;
logic w_ARVALID_S1;
logic w_ARREADY_S1;

//READ DATA1
logic [`AXI_IDS_BITS-1:0] w_RID_S1;
logic [`AXI_DATA_BITS-1:0] w_RDATA_S1;
logic [1:0] w_RRESP_S1;
logic w_RLAST_S1;
logic w_RVALID_S1;
logic w_RREADY_S1;

// logic late_reset;

// always_ff @( posedge clk or posedge rst ) begin 
// 	if(rst)
// 		late_reset <= rst;
// 	else 
// 		late_reset <= rst;
// end

CPU_wrapper CPU(
.ACLK(clk),
.ARESETn(~rst),

    // //WRITE ADDRESS
    // output logic [`AXI_ID_BITS-1:0]         AWID_M0        ,
    // output logic [`AXI_ADDR_BITS-1:0]       AWADDR_M0      ,
    // output logic [`AXI_LEN_BITS-1:0]        AWLEN_M0       ,
    // output logic [`AXI_SIZE_BITS-1:0]       AWSIZE_M0      ,
    // output logic [1:0]                      AWBURST_M0     ,
    // output logic                            AWVALID_M0     ,
    // input                                   AWREADY_M0     ,

    // //WRITE DATA
    // output logic [`AXI_DATA_BITS-1:0]       WDATA_M0       ,
    // output logic [`AXI_STRB_BITS-1:0]       WSTRB_M0       ,
    // output logic                            WLAST_M0       ,
    // output logic                            WVALID_M0      ,
    // input                                   WREADY_M0      ,

    // //WRITE RESPONSE
    // input [`AXI_ID_BITS-1:0]                BID_M0         ,
    // input [1:0]                             BRESP_M0       ,
    // input                                   BVALID_M0      ,
    // output logic                            BREADY_M0      ,

    //READ ADDRESS0
.ARID_M0(w_ARID_M0),
.ARADDR_M0(w_ARADDR_M0),
.ARLEN_M0(w_ARLEN_M0),
.ARSIZE_M0(w_ARSIZE_M0),
.ARBURST_M0(w_ARBURST_M0),
.ARVALID_M0(w_ARVALID_M0),
.ARREADY_M0(w_ARREADY_M0),

    //READ DATA0
.RID_M0(w_RID_M0),
.RDATA_M0(w_RDATA_M0),
.RRESP_M0(w_RRESP_M0),
.RLAST_M0(w_RLAST_M0),
.RVALID_M0(w_RVALID_M0),
.RREADY_M0(w_RREADY_M0),


    //WRITE ADDRESS
.AWID_M1(w_AWID_M1),
.AWADDR_M1(w_AWADDR_M1),
.AWLEN_M1(w_AWLEN_M1),
.AWSIZE_M1(w_AWSIZE_M1),
.AWBURST_M1(w_AWBURST_M1),
.AWVALID_M1(w_AWVALID_M1),
.AWREADY_M1(w_AWREADY_M1),

    //WRITE DATA
.WDATA_M1(w_WDATA_M1),
.WSTRB_M1(w_WSTRB_M1),
.WLAST_M1(w_WLAST_M1),
.WVALID_M1(w_WVALID_M1),
.WREADY_M1(w_WREADY_M1),

    //WRITE RESPONSE
.BID_M1(w_BID_M1),
.BRESP_M1(w_BRESP_M1),
.BVALID_M1(w_BVALID_M1),
.BREADY_M1(w_BREADY_M1),

    //READ ADDRESS1
.ARID_M1(w_ARID_M1),
.ARADDR_M1(w_ARADDR_M1),
.ARLEN_M1(w_ARLEN_M1),
.ARSIZE_M1(w_ARSIZE_M1),
.ARBURST_M1(w_ARBURST_M1),
.ARVALID_M1(w_ARVALID_M1),
.ARREADY_M1(w_ARREADY_M1),

    //READ DATA1
.RID_M1(w_RID_M1),
.RDATA_M1(w_RDATA_M1),
.RRESP_M1(w_RRESP_M1),
.RLAST_M1(w_RLAST_M1),
.RVALID_M1(w_RVALID_M1),
.RREADY_M1(w_RREADY_M1)
);

SRAM_wrapper IM1(
.ACLK(clk),
.ARESETn(~rst),

	//READ ADDRESS1
.ARID_S(w_ARID_S0),
.ARADDR_S(w_ARADDR_S0),
.ARLEN_S(w_ARLEN_S0),
.ARSIZE_S(w_ARSIZE_S0),
.ARBURST_S(w_ARBURST_S0),
.ARVALID_S(w_ARVALID_S0),
.ARREADY_S(w_ARREADY_S0),
	
	//READ DATA1
.RID_S(w_RID_S0),
.RDATA_S(w_RDATA_S0),
.RRESP_S(w_RRESP_S0),
.RLAST_S(w_RLAST_S0),
.RVALID_S(w_RVALID_S0),
.RREADY_S(w_RREADY_S0),

	//WRITE ADDRESS
.AWID_S(w_AWID_S0),
.AWADDR_S(w_AWADDR_S0),
.AWLEN_S(w_AWLEN_S0),
.AWSIZE_S(w_AWSIZE_S0),
.AWBURST_S(w_AWBURST_S0),
.AWVALID_S(w_AWVALID_S0),
.AWREADY_S(w_AWREADY_S0),
	
	//WRITE DATA
.WDATA_S(w_WDATA_S0),
.WSTRB_S(w_WSTRB_S0),
.WLAST_S(w_WLAST_S0),
.WVALID_S(w_WVALID_S0),
.WREADY_S(w_WREADY_S0),
	
	//WRITE RESPONSE
.BID_S(w_BID_S0),
.BRESP_S(w_BRESP_S0),
.BVALID_S(w_BVALID_S0),
.BREADY_S(w_BREADY_S0)
);

SRAM_wrapper DM1(
.ACLK(clk),
.ARESETn(~rst),

	//READ ADDRESS1
.ARID_S(w_ARID_S1),
.ARADDR_S(w_ARADDR_S1),
.ARLEN_S(w_ARLEN_S1),
.ARSIZE_S(w_ARSIZE_S1),
.ARBURST_S(w_ARBURST_S1),
.ARVALID_S(w_ARVALID_S1),
.ARREADY_S(w_ARREADY_S1),
	
	//READ DATA1
.RID_S(w_RID_S1),
.RDATA_S(w_RDATA_S1),
.RRESP_S(w_RRESP_S1),
.RLAST_S(w_RLAST_S1),
.RVALID_S(w_RVALID_S1),
.RREADY_S(w_RREADY_S1),

	//WRITE ADDRESS
.AWID_S(w_AWID_S1),
.AWADDR_S(w_AWADDR_S1),
.AWLEN_S(w_AWLEN_S1),
.AWSIZE_S(w_AWSIZE_S1),
.AWBURST_S(w_AWBURST_S1),
.AWVALID_S(w_AWVALID_S1),
.AWREADY_S(w_AWREADY_S1),
	
	//WRITE DATA
.WDATA_S(w_WDATA_S1),
.WSTRB_S(w_WSTRB_S1),
.WLAST_S(w_WLAST_S1),
.WVALID_S(w_WVALID_S1),
.WREADY_S(w_WREADY_S1),
	
	//WRITE RESPONSE
.BID_S(w_BID_S1),
.BRESP_S(w_BRESP_S1),
.BVALID_S(w_BVALID_S1),
.BREADY_S(w_BREADY_S1)
);

AXI axi(

.ACLK(clk),
.ARESETn(~rst),

	//SLAVE INTERFACE FOR MASTERS
	
	//WRITE ADDRESS
.AWID_M1(w_AWID_M1),
.AWADDR_M1(w_AWADDR_M1),
.AWLEN_M1(w_AWLEN_M1),
.AWSIZE_M1(w_AWSIZE_M1),
.AWBURST_M1(w_AWBURST_M1),
.AWVALID_M1(w_AWVALID_M1),
.AWREADY_M1(w_AWREADY_M1),
	
	//WRITE DATA
.WDATA_M1(w_WDATA_M1),
.WSTRB_M1(w_WSTRB_M1),
.WLAST_M1(w_WLAST_M1),
.WVALID_M1(w_WVALID_M1),
.WREADY_M1(w_WREADY_M1),
	
	//WRITE RESPONSE
.BID_M1(w_BID_M1),
.BRESP_M1(w_BRESP_M1),
.BVALID_M1(w_BVALID_M1),
.BREADY_M1(w_BREADY_M1),

	//READ ADDRESS0
.ARID_M0(w_ARID_M0),
.ARADDR_M0(w_ARADDR_M0),
.ARLEN_M0(w_ARLEN_M0),
.ARSIZE_M0(w_ARSIZE_M0),
.ARBURST_M0(w_ARBURST_M0),
.ARVALID_M0(w_ARVALID_M0),
.ARREADY_M0(w_ARREADY_M0),
	
	//READ DATA0
.RID_M0(w_RID_M0),
.RDATA_M0(w_RDATA_M0),
.RRESP_M0(w_RRESP_M0),
.RLAST_M0(w_RLAST_M0),
.RVALID_M0(w_RVALID_M0),
.RREADY_M0(w_RREADY_M0),
	
	//READ ADDRESS1
.ARID_M1(w_ARID_M1),
.ARADDR_M1(w_ARADDR_M1),
.ARLEN_M1(w_ARLEN_M1),
.ARSIZE_M1(w_ARSIZE_M1),
.ARBURST_M1(w_ARBURST_M1),
.ARVALID_M1(w_ARVALID_M1),
.ARREADY_M1(w_ARREADY_M1),
	
	//READ DATA1
.RID_M1(w_RID_M1),
.RDATA_M1(w_RDATA_M1),
.RRESP_M1(w_RRESP_M1),
.RLAST_M1(w_RLAST_M1),
.RVALID_M1(w_RVALID_M1),
.RREADY_M1(w_RREADY_M1),

	//MASTER INTERFACE FOR SLAVES
	//WRITE ADDRESS0
.AWID_S0(w_AWID_S0),
.AWADDR_S0(w_AWADDR_S0),
.AWLEN_S0(w_AWLEN_S0),
.AWSIZE_S0(w_AWSIZE_S0),
.AWBURST_S0(w_AWBURST_S0),
.AWVALID_S0(w_AWVALID_S0),
.AWREADY_S0(w_AWREADY_S0),
	
	//WRITE DATA0
.WDATA_S0(w_WDATA_S0),
.WSTRB_S0(w_WSTRB_S0),
.WLAST_S0(w_WLAST_S0),
.WVALID_S0(w_WVALID_S0),
.WREADY_S0(w_WREADY_S0),
	
	//WRITE RESPONSE0
.BID_S0(w_BID_S0),
.BRESP_S0(w_BRESP_S0),
.BVALID_S0(w_BVALID_S0),
.BREADY_S0(w_BREADY_S0),
	
	//WRITE ADDRESS1
.AWID_S1(w_AWID_S1),
.AWADDR_S1(w_AWADDR_S1),
.AWLEN_S1(w_AWLEN_S1),
.AWSIZE_S1(w_AWSIZE_S1),
.AWBURST_S1(w_AWBURST_S1),
.AWVALID_S1(w_AWVALID_S1),
.AWREADY_S1(w_AWREADY_S1),
	
	//WRITE DATA1
.WDATA_S1(w_WDATA_S1),
.WSTRB_S1(w_WSTRB_S1),
.WLAST_S1(w_WLAST_S1),
.WVALID_S1(w_WVALID_S1),
.WREADY_S1(w_WREADY_S1),
	
	//WRITE RESPONSE1
.BID_S1(w_BID_S1),
.BRESP_S1(w_BRESP_S1),
.BVALID_S1(w_BVALID_S1),
.BREADY_S1(w_BREADY_S1),
	
	//READ ADDRESS0
.ARID_S0(w_ARID_S0),
.ARADDR_S0(w_ARADDR_S0),
.ARLEN_S0(w_ARLEN_S0),
.ARSIZE_S0(w_ARSIZE_S0),
.ARBURST_S0(w_ARBURST_S0),
.ARVALID_S0(w_ARVALID_S0),
.ARREADY_S0(w_ARREADY_S0),
	
	//READ DATA0
.RID_S0(w_RID_S0),
.RDATA_S0(w_RDATA_S0),
.RRESP_S0(w_RRESP_S0),
.RLAST_S0(w_RLAST_S0),
.RVALID_S0(w_RVALID_S0),
.RREADY_S0(w_RREADY_S0),
	
	//READ ADDRESS1
.ARID_S1(w_ARID_S1),
.ARADDR_S1(w_ARADDR_S1),
.ARLEN_S1(w_ARLEN_S1),
.ARSIZE_S1(w_ARSIZE_S1),
.ARBURST_S1(w_ARBURST_S1),
.ARVALID_S1(w_ARVALID_S1),
.ARREADY_S1(w_ARREADY_S1),
	
	//READ DATA1
.RID_S1(w_RID_S1),
.RDATA_S1(w_RDATA_S1),
.RRESP_S1(w_RRESP_S1),
.RLAST_S1(w_RLAST_S1),
.RVALID_S1(w_RVALID_S1),
.RREADY_S1(w_RREADY_S1)
	
);

 DRAM_wrapper dram(
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
    output logic 						DRAM_WEn,
    output logic 						DRAM_RASn,
    output logic 						DRAM_CASn,
    output logic [10:0] 				DRAM_A,
    output logic [31:0]					DRAM_D,
	input 								DRAM_valid,
    input [31:0]						DRAM_Q
);


endmodule