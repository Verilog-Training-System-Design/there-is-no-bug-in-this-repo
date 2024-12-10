`include "CPU_wrapper.sv"
`include "SRAM_wrapper.sv"
`include "./AXI/AXI.sv"
`include "DRAM_wrapper.sv"
`include "DMA_wrapper.sv"
`include "WDT_wrapper.sv"
`include "ROM_wrapper.sv"
`include "./AXI/interface.sv"

module top (
    input clk,
    input clk2,
    input rst,
    input rst2,
    input [31:0] ROM_out,
    output logic ROM_read,
    output logic ROM_enable,
    output logic [11:0] ROM_address,

    output logic [3:0] DRAM_WEn,
    output logic DRAM_RASn,
    output logic DRAM_CASn,
	output logic DRAM_CSn,
    output logic [10:0] DRAM_A,
    output logic [31:0] DRAM_D,
    input DRAM_valid,
    input [31:0] DRAM_Q       				
);
RA wire_M0_AR();
R  wire_M0_R();

RA wire_M1_AR();
R  wire_M1_R();
WA wire_M1_AW();
W  wire_M1_W();
B wire_M1_B();

RA wire_M2_AR();
R  wire_M2_R();
WA wire_M2_AW();
W  wire_M2_W();
B wire_M2_B();

RA wire_ROM_AR();
R  wire_ROM_R();
WA wire_ROM_AW();
W  wire_ROM_W();
B wire_ROM_B();

RA wire_IM_AR();
R  wire_IM_R();
WA wire_IM_AW();
W  wire_IM_W();
B wire_IM_B();

RA wire_DM_AR();
R  wire_DM_R();
WA wire_DM_AW();
W  wire_DM_W();
B wire_DM_B();

RA wire_DMA_AR();
R  wire_DMA_R();
WA wire_DMA_AW();
W  wire_DMA_W();
B wire_DMA_B();

RA wire_WDT_AR();
R  wire_WDT_R();
WA wire_WDT_AW();
W  wire_WDT_W();
B wire_WDT_B();

RA wire_DRAM_AR();
R  wire_DRAM_R();
WA wire_DRAM_AW();
W  wire_DRAM_W();
B wire_DRAM_B();

//parameter
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

		//DMA master
	//WRITE ADDRESS
	logic [`AXI_ID_BITS-1:0] w_AWID_M2;
	logic [`AXI_ADDR_BITS-1:0] w_AWADDR_M2;
	logic [`AXI_LEN_BITS-1:0] w_AWLEN_M2;
	logic [`AXI_SIZE_BITS-1:0] w_AWSIZE_M2;
	logic [1:0] w_AWBURST_M2;
	logic w_AWVALID_M2;
	logic w_AWREADY_M2;

	//WRITE DATA
	logic [`AXI_DATA_BITS-1:0] w_WDATA_M2;
	logic [`AXI_STRB_BITS-1:0] w_WSTRB_M2;
	logic w_WLAST_M2;
	logic w_WVALID_M2;
	logic w_WREADY_M2;

	//WRITE RESPONSE
	logic [`AXI_ID_BITS-1:0] w_BID_M2;
	logic [1:0] w_BRESP_M2;
	logic w_BVALID_M2;
	logic w_BREADY_M2;

	//READ ADDRESS1
	logic [`AXI_ID_BITS-1:0] w_ARID_M2;
	logic [`AXI_ADDR_BITS-1:0] w_ARADDR_M2;
	logic [`AXI_LEN_BITS-1:0] w_ARLEN_M2;
	logic [`AXI_SIZE_BITS-1:0] w_ARSIZE_M2;
	logic [1:0] w_ARBURST_M2;
	logic w_ARVALID_M2;
	logic w_ARREADY_M2;

	//READ DATA1
	logic [`AXI_ID_BITS-1:0] w_RID_M2;
	logic [`AXI_DATA_BITS-1:0] w_RDATA_M2;
	logic [1:0] w_RRESP_M2;
	logic w_RLAST_M2;
	logic w_RVALID_M2;
	logic w_RREADY_M2;

	//MASTER INTERFACE FOR SLAVES
	//ROM slave
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


	//IM slave
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


	//DM slave
	//READ ADDRESS2
	logic [`AXI_IDS_BITS-1:0] w_ARID_S2;
	logic [`AXI_ADDR_BITS-1:0] w_ARADDR_S2;
	logic [`AXI_LEN_BITS-1:0] w_ARLEN_S2;
	logic [`AXI_SIZE_BITS-1:0] w_ARSIZE_S2;
	logic [1:0] w_ARBURST_S2;
	logic w_ARVALID_S2;
	logic w_ARREADY_S2;

	//READ DATA2
	logic [`AXI_IDS_BITS-1:0] w_RID_S2;
	logic [`AXI_DATA_BITS-1:0] w_RDATA_S2;
	logic [1:0] w_RRESP_S2;
	logic w_RLAST_S2;
	logic w_RVALID_S2;
	logic w_RREADY_S2;

	//WRITE ADDRESS2
	logic [`AXI_IDS_BITS-1:0] w_AWID_S2;
	logic [`AXI_ADDR_BITS-1:0] w_AWADDR_S2;
	logic [`AXI_LEN_BITS-1:0] w_AWLEN_S2;
	logic [`AXI_SIZE_BITS-1:0] w_AWSIZE_S2;
	logic [1:0] w_AWBURST_S2;
	logic w_AWVALID_S2;
	logic w_AWREADY_S2;

	//WRITE DATA2
	logic [`AXI_DATA_BITS-1:0] w_WDATA_S2;
	logic [`AXI_STRB_BITS-1:0] w_WSTRB_S2;
	logic w_WLAST_S2;
	logic w_WVALID_S2;
	logic w_WREADY_S2;

	//WRITE RESPONSE2
	logic [`AXI_IDS_BITS-1:0] w_BID_S2;
	logic [1:0] w_BRESP_S2;
	logic w_BVALID_S2;
	logic w_BREADY_S2;


	//DMA slave
	//READ ADDRESS3
	logic [`AXI_IDS_BITS-1:0] w_ARID_S3;
	logic [`AXI_ADDR_BITS-1:0] w_ARADDR_S3;
	logic [`AXI_LEN_BITS-1:0] w_ARLEN_S3;
	logic [`AXI_SIZE_BITS-1:0] w_ARSIZE_S3;
	logic [1:0] w_ARBURST_S3;
	logic w_ARVALID_S3;
	logic w_ARREADY_S3;

	//READ DATA3
	logic [`AXI_IDS_BITS-1:0] w_RID_S3;
	logic [`AXI_DATA_BITS-1:0] w_RDATA_S3;
	logic [1:0] w_RRESP_S3;
	logic w_RLAST_S3;
	logic w_RVALID_S3;
	logic w_RREADY_S3;

	//WRITE ADDRESS3
	logic [`AXI_IDS_BITS-1:0] w_AWID_S3;
	logic [`AXI_ADDR_BITS-1:0] w_AWADDR_S3;
	logic [`AXI_LEN_BITS-1:0] w_AWLEN_S3;
	logic [`AXI_SIZE_BITS-1:0] w_AWSIZE_S3;
	logic [1:0] w_AWBURST_S3;
	logic w_AWVALID_S3;
	logic w_AWREADY_S3;

	//WRITE DATA3
	logic [`AXI_DATA_BITS-1:0] w_WDATA_S3;
	logic [`AXI_STRB_BITS-1:0] w_WSTRB_S3;
	logic w_WLAST_S3;
	logic w_WVALID_S3;
	logic w_WREADY_S3;

	//WRITE RESPONSE3
	logic [`AXI_IDS_BITS-1:0] w_BID_S3;
	logic [1:0] w_BRESP_S3;
	logic w_BVALID_S3;
	logic w_BREADY_S3;

	//WDT slave
	//READ ADDRESS4
	logic [`AXI_IDS_BITS-1:0] w_ARID_S4;
	logic [`AXI_ADDR_BITS-1:0] w_ARADDR_S4;
	logic [`AXI_LEN_BITS-1:0] w_ARLEN_S4;
	logic [`AXI_SIZE_BITS-1:0] w_ARSIZE_S4;
	logic [1:0] w_ARBURST_S4;
	logic w_ARVALID_S4;
	logic w_ARREADY_S4;

	//READ DATA4
	logic [`AXI_IDS_BITS-1:0] w_RID_S4;
	logic [`AXI_DATA_BITS-1:0] w_RDATA_S4;
	logic [1:0] w_RRESP_S4;
	logic w_RLAST_S4;
	logic w_RVALID_S4;
	logic w_RREADY_S4;

	//WRITE ADDRESS4
	logic [`AXI_IDS_BITS-1:0] w_AWID_S4;
	logic [`AXI_ADDR_BITS-1:0] w_AWADDR_S4;
	logic [`AXI_LEN_BITS-1:0] w_AWLEN_S4;
	logic [`AXI_SIZE_BITS-1:0] w_AWSIZE_S4;
	logic [1:0] w_AWBURST_S4;
	logic w_AWVALID_S4;
	logic w_AWREADY_S4;

	//WRITE DATA4
	logic [`AXI_DATA_BITS-1:0] w_WDATA_S4;
	logic [`AXI_STRB_BITS-1:0] w_WSTRB_S4;
	logic w_WLAST_S4;
	logic w_WVALID_S4;
	logic w_WREADY_S4;

	//WRITE RESPONSE4
	logic [`AXI_IDS_BITS-1:0] w_BID_S4;
	logic [1:0] w_BRESP_S4;
	logic w_BVALID_S4;
	logic w_BREADY_S4;


	//DRAM slave
	//READ ADDRESS5
	logic [`AXI_IDS_BITS-1:0] w_ARID_S5;
	logic [`AXI_ADDR_BITS-1:0] w_ARADDR_S5;
	logic [`AXI_LEN_BITS-1:0] w_ARLEN_S5;
	logic [`AXI_SIZE_BITS-1:0] w_ARSIZE_S5;
	logic [1:0] w_ARBURST_S5;
	logic w_ARVALID_S5;
	logic w_ARREADY_S5;

	//READ DATA5
	logic [`AXI_IDS_BITS-1:0] w_RID_S5;
	logic [`AXI_DATA_BITS-1:0] w_RDATA_S5;
	logic [1:0] w_RRESP_S5;
	logic w_RLAST_S5;
	logic w_RVALID_S5;
	logic w_RREADY_S5;

	//WRITE ADDRESS5
	logic [`AXI_IDS_BITS-1:0] w_AWID_S5;
	logic [`AXI_ADDR_BITS-1:0] w_AWADDR_S5;
	logic [`AXI_LEN_BITS-1:0] w_AWLEN_S5;
	logic [`AXI_SIZE_BITS-1:0] w_AWSIZE_S5;
	logic [1:0] w_AWBURST_S5;
	logic w_AWVALID_S5;
	logic w_AWREADY_S5;

	//WRITE DATA5
	logic [`AXI_DATA_BITS-1:0] w_WDATA_S5;
	logic [`AXI_STRB_BITS-1:0] w_WSTRB_S5;
	logic w_WLAST_S5;
	logic w_WVALID_S5;
	logic w_WREADY_S5;

	//WRITE RESPONSE5
	logic [`AXI_IDS_BITS-1:0] w_BID_S5;
	logic [1:0] w_BRESP_S5;
	logic w_BVALID_S5;
	logic w_BREADY_S5;

	//others 
	wire w_DMA_interrupt;
	wire w_WDT_timeout;

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

    // //READ ADDRESS0
	// .ARID_M0(w_ARID_M0),
	// .ARADDR_M0(w_ARADDR_M0),
	// .ARLEN_M0(w_ARLEN_M0),
	// .ARSIZE_M0(w_ARSIZE_M0),
	// .ARBURST_M0(w_ARBURST_M0),
	// .ARVALID_M0(w_ARVALID_M0),
	// .ARREADY_M0(w_ARREADY_M0),

    // //READ DATA0
	// .RID_M0(w_RID_M0),
	// .RDATA_M0(w_RDATA_M0),
	// .RRESP_M0(w_RRESP_M0),
	// .RLAST_M0(w_RLAST_M0),
	// .RVALID_M0(w_RVALID_M0),
	// .RREADY_M0(w_RREADY_M0),


    // //WRITE ADDRESS
	// .AWID_M1(w_AWID_M1),
	// .AWADDR_M1(w_AWADDR_M1),
	// .AWLEN_M1(w_AWLEN_M1),
	// .AWSIZE_M1(w_AWSIZE_M1),
	// .AWBURST_M1(w_AWBURST_M1),
	// .AWVALID_M1(w_AWVALID_M1),
	// .AWREADY_M1(w_AWREADY_M1),

    // //WRITE DATA
	// .WDATA_M1(w_WDATA_M1),
	// .WSTRB_M1(w_WSTRB_M1),
	// .WLAST_M1(w_WLAST_M1),
	// .WVALID_M1(w_WVALID_M1),
	// .WREADY_M1(w_WREADY_M1),

    // //WRITE RESPONSE
	// .BID_M1(w_BID_M1),
	// .BRESP_M1(w_BRESP_M1),
	// .BVALID_M1(w_BVALID_M1),
	// .BREADY_M1(w_BREADY_M1),

    // //READ ADDRESS1
	// .ARID_M1(w_ARID_M1),
	// .ARADDR_M1(w_ARADDR_M1),
	// .ARLEN_M1(w_ARLEN_M1),
	// .ARSIZE_M1(w_ARSIZE_M1),
	// .ARBURST_M1(w_ARBURST_M1),
	// .ARVALID_M1(w_ARVALID_M1),
	// .ARREADY_M1(w_ARREADY_M1),

    // //READ DATA1
	// .RID_M1(w_RID_M1),
	// .RDATA_M1(w_RDATA_M1),
	// .RRESP_M1(w_RRESP_M1),
	// .RLAST_M1(w_RLAST_M1),
	// .RVALID_M1(w_RVALID_M1),
	// .RREADY_M1(w_RREADY_M1),

	.M0_AR(wire_M0_AR),
	.M0_R(wire_M0_R),

	.M1_AR(wire_M1_AR),
	.M1_R(wire_M1_R),
	.M1_AW(wire_M1_AW),
	.M1_W(wire_M1_W),
	.M1_B(wire_M1_B),
	.DMA_interrupt(w_DMA_interrupt),
	.WDT_timeout(w_WDT_timeout)
);

SRAM_wrapper IM1(
	.ACLK(clk),
	.ARESETn(~rst),

		//READ ADDRESS
	// .ARID_S(w_ARID_S1),
	// .ARADDR_S(w_ARADDR_S1),
	// .ARLEN_S(w_ARLEN_S1),
	// .ARSIZE_S(w_ARSIZE_S1),
	// .ARBURST_S(w_ARBURST_S1),
	// .ARVALID_S(w_ARVALID_S1),
	// .ARREADY_S(w_ARREADY_S1),
	.S_AR(wire_IM_AR),
	// 	//READ DATA
	// .RID_S(w_RID_S1),
	// .RDATA_S(w_RDATA_S1),
	// .RRESP_S(w_RRESP_S1),
	// .RLAST_S(w_RLAST_S1),
	// .RVALID_S(w_RVALID_S1),
	// .RREADY_S(w_RREADY_S1),
	.S_R(wire_IM_R),

	// 	//WRITE ADDRESS
	// .AWID_S(w_AWID_S1),
	// .AWADDR_S(w_AWADDR_S1),
	// .AWLEN_S(w_AWLEN_S1),
	// .AWSIZE_S(w_AWSIZE_S1),
	// .AWBURST_S(w_AWBURST_S1),
	// .AWVALID_S(w_AWVALID_S1),
	// .AWREADY_S(w_AWREADY_S1),
	.S_AW(wire_IM_AW),

	// 	//WRITE DATA
	// .WDATA_S(w_WDATA_S1),
	// .WSTRB_S(w_WSTRB_S1),
	// .WLAST_S(w_WLAST_S1),
	// .WVALID_S(w_WVALID_S1),
	// .WREADY_S(w_WREADY_S1),
	.S_W(wire_IM_W),

	// 	//WRITE RESPONSE
	// .BID_S(w_BID_S1),
	// .BRESP_S(w_BRESP_S1),
	// .BVALID_S(w_BVALID_S1),
	// .BREADY_S(w_BREADY_S1)
	.S_B(wire_IM_B)
);

SRAM_wrapper DM1(
	.ACLK(clk),
	.ARESETn(~rst),

	// 	//READ ADDRESS1
	// .ARID_S(w_ARID_S2),
	// .ARADDR_S(w_ARADDR_S2),
	// .ARLEN_S(w_ARLEN_S2),
	// .ARSIZE_S(w_ARSIZE_S2),
	// .ARBURST_S(w_ARBURST_S2),
	// .ARVALID_S(w_ARVALID_S2),
	// .ARREADY_S(w_ARREADY_S2),
	.S_AR(wire_DM_AR),

	// 	//READ DATA2
	// .RID_S(w_RID_S2),
	// .RDATA_S(w_RDATA_S2),
	// .RRESP_S(w_RRESP_S2),
	// .RLAST_S(w_RLAST_S2),
	// .RVALID_S(w_RVALID_S2),
	// .RREADY_S(w_RREADY_S2),
	.S_R(wire_DM_R),

	// 	//WRITE ADDRESS
	// .AWID_S(w_AWID_S2),
	// .AWADDR_S(w_AWADDR_S2),
	// .AWLEN_S(w_AWLEN_S2),
	// .AWSIZE_S(w_AWSIZE_S2),
	// .AWBURST_S(w_AWBURST_S2),
	// .AWVALID_S(w_AWVALID_S2),
	// .AWREADY_S(w_AWREADY_S2),
	.S_AW(wire_DM_AW),

	// 	//WRITE DATA
	// .WDATA_S(w_WDATA_S2),
	// .WSTRB_S(w_WSTRB_S2),
	// .WLAST_S(w_WLAST_S2),
	// .WVALID_S(w_WVALID_S2),
	// .WREADY_S(w_WREADY_S2),
	.S_W(wire_DM_W),

	// 	//WRITE RESPONSE
	// .BID_S(w_BID_S2),
	// .BRESP_S(w_BRESP_S2),
	// .BVALID_S(w_BVALID_S2),
	// .BREADY_S(w_BREADY_S2)
	.S_B(wire_DM_B)
);

AXI axi(
	.ACLK(clk),
	.ARESETn(~rst),

		//SLAVE INTERFACE FOR MASTERS

	// 	//WRITE ADDRESS
	// .AWID_M1(w_AWID_M1),
	// .AWADDR_M1(w_AWADDR_M1),
	// .AWLEN_M1(w_AWLEN_M1),
	// .AWSIZE_M1(w_AWSIZE_M1),
	// .AWBURST_M1(w_AWBURST_M1),
	// .AWVALID_M1(w_AWVALID_M1),
	// .AWREADY_M1(w_AWREADY_M1),

	// 	//WRITE DATA
	// .WDATA_M1(w_WDATA_M1),
	// .WSTRB_M1(w_WSTRB_M1),
	// .WLAST_M1(w_WLAST_M1),
	// .WVALID_M1(w_WVALID_M1),
	// .WREADY_M1(w_WREADY_M1),

	// 	//WRITE RESPONSE
	// .BID_M1(w_BID_M1),
	// .BRESP_M1(w_BRESP_M1),
	// .BVALID_M1(w_BVALID_M1),
	// .BREADY_M1(w_BREADY_M1),
	.M1_AW(wire_M1_AW),
	.M1_W(wire_M1_W),
	.M1_B(wire_M1_B),
	.M1_AR(wire_M1_AR),
	.M1_R(wire_M1_R),

	// 	//READ ADDRESS0
	// .ARID_M0(w_ARID_M0),
	// .ARADDR_M0(w_ARADDR_M0),
	// .ARLEN_M0(w_ARLEN_M0),
	// .ARSIZE_M0(w_ARSIZE_M0),
	// .ARBURST_M0(w_ARBURST_M0),
	// .ARVALID_M0(w_ARVALID_M0),
	// .ARREADY_M0(w_ARREADY_M0),

	// 	//READ DATA0
	// .RID_M0(w_RID_M0),
	// .RDATA_M0(w_RDATA_M0),
	// .RRESP_M0(w_RRESP_M0),
	// .RLAST_M0(w_RLAST_M0),
	// .RVALID_M0(w_RVALID_M0),
	// .RREADY_M0(w_RREADY_M0),
	// .M0_AW(),
	// .M0_W(),
	// .M0_B(),
	.M0_AR(wire_M0_AR),
	.M0_R(wire_M0_R),

	// 	//READ ADDRESS1
	// .ARID_M1(w_ARID_M1),
	// .ARADDR_M1(w_ARADDR_M1),
	// .ARLEN_M1(w_ARLEN_M1),
	// .ARSIZE_M1(w_ARSIZE_M1),
	// .ARBURST_M1(w_ARBURST_M1),
	// .ARVALID_M1(w_ARVALID_M1),
	// .ARREADY_M1(w_ARREADY_M1),

	// 	//READ DATA1
	// .RID_M1(w_RID_M1),
	// .RDATA_M1(w_RDATA_M1),
	// .RRESP_M1(w_RRESP_M1),
	// .RLAST_M1(w_RLAST_M1),
	// .RVALID_M1(w_RVALID_M1),
	// .RREADY_M1(w_RREADY_M1),

	// //M2 DMA
	// //READ ADDRESS
	// .ARID_M2(w_ARID_M2),
	// .ARADDR_M2(w_ARADDR_M2),
	// .ARLEN_M2(w_ARLEN_M2),
	// .ARSIZE_M2(w_ARSIZE_M2),
	// .ARBURST_M2(w_ARBURST_M2),
	// .ARVALID_M2(w_ARVALID_M2),
	// .ARREADY_M2(w_ARREADY_M2),

	// 	//READ DATA
	// .RID_M2(w_RID_M2),
	// .RDATA_M2(w_RDATA_M2),
	// .RRESP_M2(w_RRESP_M2),
	// .RLAST_M2(w_RLAST_M2),
	// .RVALID_M2(w_RVALID_M2),
	// .RREADY_M2(w_RREADY_M2),

	// 	//WRITE ADDRESS
	// .AWID_M2(w_AWID_M2),
	// .AWADDR_M2(w_AWADDR_M2),
	// .AWLEN_M2(w_AWLEN_M2),
	// .AWSIZE_M2(w_AWSIZE_M2),
	// .AWBURST_M2(w_AWBURST_M2),
	// .AWVALID_M2(w_AWVALID_M2),
	// .AWREADY_M2(w_AWREADY_M2),

	// 	//WRITE DATA
	// .WDATA_M2(w_WDATA_M2),
	// .WSTRB_M2(w_WSTRB_M2),
	// .WLAST_M2(w_WLAST_M2),
	// .WVALID_M2(w_WVALID_M2),
	// .WREADY_M2(w_WREADY_M2),

	// 	//WRITE RESPONSE
	// .BID_M2(w_BID_M2),
	// .BRESP_M2(w_BRESP_M2),
	// .BVALID_M2(w_BVALID_M2),
	// .BREADY_M2(w_BREADY_M2),
	.M2_AW(wire_M2_AW),
	.M2_W(wire_M2_W),
	.M2_B(wire_M2_B),
	.M2_AR(wire_M2_AR),
	.M2_R(wire_M2_R),


		//MASTER INTERFACE FOR SLAVES
		//WRITE ADDRESS0
	// .AWID_S0(w_AWID_S0),
	// .AWADDR_S0(w_AWADDR_S0),
	// .AWLEN_S0(w_AWLEN_S0),
	// .AWSIZE_S0(w_AWSIZE_S0),
	// .AWBURST_S0(w_AWBURST_S0),
	// .AWVALID_S0(w_AWVALID_S0),
	// .AWREADY_S0(w_AWREADY_S0),

	// 	//WRITE DATA0
	// .WDATA_S0(w_WDATA_S0),
	// .WSTRB_S0(w_WSTRB_S0),
	// .WLAST_S0(w_WLAST_S0),
	// .WVALID_S0(w_WVALID_S0),
	// .WREADY_S0(w_WREADY_S0),

	// 	//WRITE RESPONSE0
	// .BID_S0(w_BID_S0),
	// .BRESP_S0(w_BRESP_S0),
	// .BVALID_S0(w_BVALID_S0),
	// .BREADY_S0(w_BREADY_S0),

	// 	//WRITE ADDRESS1
	// .AWID_S1(w_AWID_S1),
	// .AWADDR_S1(w_AWADDR_S1),
	// .AWLEN_S1(w_AWLEN_S1),
	// .AWSIZE_S1(w_AWSIZE_S1),
	// .AWBURST_S1(w_AWBURST_S1),
	// .AWVALID_S1(w_AWVALID_S1),
	// .AWREADY_S1(w_AWREADY_S1),

	// 	//WRITE DATA1
	// .WDATA_S1(w_WDATA_S1),
	// .WSTRB_S1(w_WSTRB_S1),
	// .WLAST_S1(w_WLAST_S1),
	// .WVALID_S1(w_WVALID_S1),
	// .WREADY_S1(w_WREADY_S1),

	// 	//WRITE RESPONSE1
	// .BID_S1(w_BID_S1),
	// .BRESP_S1(w_BRESP_S1),
	// .BVALID_S1(w_BVALID_S1),
	// .BREADY_S1(w_BREADY_S1),

	// 	//READ ADDRESS0
	// .ARID_S0(w_ARID_S0),
	// .ARADDR_S0(w_ARADDR_S0),
	// .ARLEN_S0(w_ARLEN_S0),
	// .ARSIZE_S0(w_ARSIZE_S0),
	// .ARBURST_S0(w_ARBURST_S0),
	// .ARVALID_S0(w_ARVALID_S0),
	// .ARREADY_S0(w_ARREADY_S0),

	// 	//READ DATA0
	// .RID_S0(w_RID_S0),
	// .RDATA_S0(w_RDATA_S0),
	// .RRESP_S0(w_RRESP_S0),
	// .RLAST_S0(w_RLAST_S0),
	// .RVALID_S0(w_RVALID_S0),
	// .RREADY_S0(w_RREADY_S0),
	.S0_AW(wire_ROM_AW),
	.S0_W(wire_ROM_W),
	.S0_B(wire_ROM_B),
	.S0_AR(wire_ROM_AR),
	.S0_R(wire_ROM_R),

	// 	//READ ADDRESS1
	// .ARID_S1(w_ARID_S1),
	// .ARADDR_S1(w_ARADDR_S1),
	// .ARLEN_S1(w_ARLEN_S1),
	// .ARSIZE_S1(w_ARSIZE_S1),
	// .ARBURST_S1(w_ARBURST_S1),
	// .ARVALID_S1(w_ARVALID_S1),
	// .ARREADY_S1(w_ARREADY_S1),

	// 	//READ DATA1
	// .RID_S1(w_RID_S1),
	// .RDATA_S1(w_RDATA_S1),
	// .RRESP_S1(w_RRESP_S1),
	// .RLAST_S1(w_RLAST_S1),
	// .RVALID_S1(w_RVALID_S1),
	// .RREADY_S1(w_RREADY_S1),
	.S1_AW(wire_IM_AW),
	.S1_W(wire_IM_W),
	.S1_B(wire_IM_B),
	.S1_AR(wire_IM_AR),
	.S1_R(wire_IM_R),

	// //S2 DM
	// //READ ADDRESS2
	// .ARID_S2(w_ARID_S2),
	// .ARADDR_S2(w_ARADDR_S2),
	// .ARLEN_S2(w_ARLEN_S2),
	// .ARSIZE_S2(w_ARSIZE_S2),
	// .ARBURST_S2(w_ARBURST_S2),
	// .ARVALID_S2(w_ARVALID_S2),
	// .ARREADY_S2(w_ARREADY_S2),

	// 	//READ DATA2
	// .RID_S2(w_RID_S2),
	// .RDATA_S2(w_RDATA_S2),
	// .RRESP_S2(w_RRESP_S2),
	// .RLAST_S2(w_RLAST_S2),
	// .RVALID_S2(w_RVALID_S2),
	// .RREADY_S2(w_RREADY_S2),

	// 	//WRITE ADDRESS2
	// .AWID_S2(w_AWID_S2),
	// .AWADDR_S2(w_AWADDR_S2),
	// .AWLEN_S2(w_AWLEN_S2),
	// .AWSIZE_S2(w_AWSIZE_S2),
	// .AWBURST_S2(w_AWBURST_S2),
	// .AWVALID_S2(w_AWVALID_S2),
	// .AWREADY_S2(w_AWREADY_S2),

	// 	//WRITE DATA2
	// .WDATA_S2(w_WDATA_S2),
	// .WSTRB_S2(w_WSTRB_S2),
	// .WLAST_S2(w_WLAST_S2),
	// .WVALID_S2(w_WVALID_S2),
	// .WREADY_S2(w_WREADY_S2),

	// 	//WRITE RESPONSE2
	// .BID_S2(w_BID_S2),
	// .BRESP_S2(w_BRESP_S2),
	// .BVALID_S2(w_BVALID_S2),
	// .BREADY_S2(w_BREADY_S2),

	.S2_AW(wire_DM_AW),
	.S2_W(wire_DM_W),
	.S2_B(wire_DM_B),
	.S2_AR(wire_DM_AR),
	.S2_R(wire_DM_R),

	// //S3 DMA
	// //READ ADDRESS3
	// .ARID_S3(w_ARID_S3),
	// .ARADDR_S3(w_ARADDR_S3),
	// .ARLEN_S3(w_ARLEN_S3),
	// .ARSIZE_S3(w_ARSIZE_S3),
	// .ARBURST_S3(w_ARBURST_S3),
	// .ARVALID_S3(w_ARVALID_S3),
	// .ARREADY_S3(w_ARREADY_S3),

	// 	//READ DATA3
	// .RID_S3(w_RID_S3),
	// .RDATA_S3(w_RDATA_S3),
	// .RRESP_S3(w_RRESP_S3),
	// .RLAST_S3(w_RLAST_S3),
	// .RVALID_S3(w_RVALID_S3),
	// .RREADY_S3(w_RREADY_S3),

	// 	//WRITE ADDRESS3
	// .AWID_S3(w_AWID_S3),
	// .AWADDR_S3(w_AWADDR_S3),
	// .AWLEN_S3(w_AWLEN_S3),
	// .AWSIZE_S3(w_AWSIZE_S3),
	// .AWBURST_S3(w_AWBURST_S3),
	// .AWVALID_S3(w_AWVALID_S3),
	// .AWREADY_S3(w_AWREADY_S3),

	// 	//WRITE DATA3
	// .WDATA_S3(w_WDATA_S3),
	// .WSTRB_S3(w_WSTRB_S3),
	// .WLAST_S3(w_WLAST_S3),
	// .WVALID_S3(w_WVALID_S3),
	// .WREADY_S3(w_WREADY_S3),

	// 	//WRITE RESPONSE3
	// .BID_S3(w_BID_S3),
	// .BRESP_S3(w_BRESP_S3),
	// .BVALID_S3(w_BVALID_S3),
	// .BREADY_S3(w_BREADY_S3),

	.S3_AW(wire_DMA_AW),
	.S3_W(wire_DMA_W),
	.S3_B(wire_DMA_B),
	.S3_AR(wire_DMA_AR),
	.S3_R(wire_DMA_R),

	// //S4 WDT
	// //READ ADDRESS4
	// .ARID_S4(w_ARID_S4),
	// .ARADDR_S4(w_ARADDR_S4),
	// .ARLEN_S4(w_ARLEN_S4),
	// .ARSIZE_S4(w_ARSIZE_S4),
	// .ARBURST_S4(w_ARBURST_S4),
	// .ARVALID_S4(w_ARVALID_S4),
	// .ARREADY_S4(w_ARREADY_S4),

	// 	//READ DATA4
	// .RID_S4(w_RID_S4),
	// .RDATA_S4(w_RDATA_S4),
	// .RRESP_S4(w_RRESP_S4),
	// .RLAST_S4(w_RLAST_S4),
	// .RVALID_S4(w_RVALID_S4),
	// .RREADY_S4(w_RREADY_S4),

	// 	//WRITE ADDRESS4
	// .AWID_S4(w_AWID_S4),
	// .AWADDR_S4(w_AWADDR_S4),
	// .AWLEN_S4(w_AWLEN_S4),
	// .AWSIZE_S4(w_AWSIZE_S4),
	// .AWBURST_S4(w_AWBURST_S4),
	// .AWVALID_S4(w_AWVALID_S4),
	// .AWREADY_S4(w_AWREADY_S4),

	// 	//WRITE DATA4
	// .WDATA_S4(w_WDATA_S4),
	// .WSTRB_S4(w_WSTRB_S4),
	// .WLAST_S4(w_WLAST_S4),
	// .WVALID_S4(w_WVALID_S4),
	// .WREADY_S4(w_WREADY_S4),

	// 	//WRITE RESPONSE4
	// .BID_S4(w_BID_S4),
	// .BRESP_S4(w_BRESP_S4),
	// .BVALID_S4(w_BVALID_S4),
	// .BREADY_S4(w_BREADY_S4),

	.S4_AW(wire_WDT_AW),
	.S4_W(wire_WDT_W),
	.S4_B(wire_WDT_B),
	.S4_AR(wire_WDT_AR),
	.S4_R(wire_WDT_R),

	// //S5 DRAM
	// //READ ADDRESS5
	// .ARID_S5(w_ARID_S5),
	// .ARADDR_S5(w_ARADDR_S5),
	// .ARLEN_S5(w_ARLEN_S5),
	// .ARSIZE_S5(w_ARSIZE_S5),
	// .ARBURST_S5(w_ARBURST_S5),
	// .ARVALID_S5(w_ARVALID_S5),
	// .ARREADY_S5(w_ARREADY_S5),

	// 	//READ DATA5
	// .RID_S5(w_RID_S5),
	// .RDATA_S5(w_RDATA_S5),
	// .RRESP_S5(w_RRESP_S5),
	// .RLAST_S5(w_RLAST_S5),
	// .RVALID_S5(w_RVALID_S5),
	// .RREADY_S5(w_RREADY_S5),

	// 	//WRITE ADDRESS5
	// .AWID_S5(w_AWID_S5),
	// .AWADDR_S5(w_AWADDR_S5),
	// .AWLEN_S5(w_AWLEN_S5),
	// .AWSIZE_S5(w_AWSIZE_S5),
	// .AWBURST_S5(w_AWBURST_S5),
	// .AWVALID_S5(w_AWVALID_S5),
	// .AWREADY_S5(w_AWREADY_S5),

	// 	//WRITE DATA5
	// .WDATA_S5(w_WDATA_S5),
	// .WSTRB_S5(w_WSTRB_S5),
	// .WLAST_S5(w_WLAST_S5),
	// .WVALID_S5(w_WVALID_S5),
	// .WREADY_S5(w_WREADY_S5),

	// 	//WRITE RESPONSE5
	// .BID_S5(w_BID_S5),
	// .BRESP_S5(w_BRESP_S5),
	// .BVALID_S5(w_BVALID_S5),
	// .BREADY_S5(w_BREADY_S5)

	.S5_AW(wire_DRAM_AW),
	.S5_W(wire_DRAM_W),
	.S5_B(wire_DRAM_B),
	.S5_AR(wire_DRAM_AR),
	.S5_R(wire_DRAM_R)
);

 DRAM_wrapper dram(
    .clk(clk),
    .rst(~rst),
    
    // //READ ADDRESS1
	// .ARID_S(w_ARID_S5),
	// .ARADDR_S(w_ARADDR_S5),
	// .ARLEN_S(w_ARLEN_S5),
	// .ARSIZE_S(w_ARSIZE_S5),
	// .ARBURST_S(w_ARBURST_S5),
	// .ARVALID_S(w_ARVALID_S5),
	// .ARREADY_S(w_ARREADY_S5),
	.S_AR(wire_DRAM_AR),
	
	// //READ DATA1
	// .RID_S(w_RID_S5),
	// .RDATA_S(w_RDATA_S5),
	// .RRESP_S(w_RRESP_S5),
	// .RLAST_S(w_RLAST_S5),
	// .RVALID_S(w_RVALID_S5),
	// .RREADY_S(w_RREADY_S5),
	.S_R(wire_DRAM_R),

	// //WRITE ADDRESS
	// .AWID_S(w_AWID_S5),
	// .AWADDR_S(w_AWADDR_S5),
	// .AWLEN_S(w_AWLEN_S5),
	// .AWSIZE_S(w_AWSIZE_S5),
	// .AWBURST_S(w_AWBURST_S5),
	// .AWVALID_S(w_AWVALID_S5),
	// .AWREADY_S(w_AWREADY_S5),
	.S_AW(wire_DRAM_AW),

	// //WRITE DATA
	// .WDATA_S(w_WDATA_S5),
	// .WSTRB_S(w_WSTRB_S5),
	// .WLAST_S(w_WLAST_S5),
	// .WVALID_S(w_WVALID_S5),
	// .WREADY_S(w_WREADY_S5),
	.S_W(wire_DRAM_W),

	// //WRITE RESPONSE
	// .BID_S(w_BID_S5),
	// .BRESP_S(w_BRESP_S5),
	// .BVALID_S(w_BVALID_S5),
	// .BREADY_S(w_BREADY_S5),
	.S_B(wire_DRAM_B),

	.DRAM_CSn(DRAM_CSn),
    .DRAM_WEn(DRAM_WEn),
    .DRAM_RASn(DRAM_RASn),
    .DRAM_CASn(DRAM_CASn),
    .DRAM_A(DRAM_A),
    .DRAM_D(DRAM_D),
	.DRAM_valid(DRAM_valid),
    .DRAM_Q(DRAM_Q)
);

 DMA_wrapper  dma(
        .clk(clk),
		.rst(~rst),
      //Slave port
      //READ ADDRESS1
        // .ARID_S(w_ARID_S3),
        // .ARADDR_S(w_ARADDR_S3),
        // .ARLEN_S(w_ARLEN_S3),
        // .ARSIZE_S(w_ARSIZE_S3),
        // .ARBURST_S(w_ARBURST_S3),
        // .ARVALID_S(w_ARVALID_S3),
        // .ARREADY_S(w_ARREADY_S3),
		.S_AR(wire_DMA_AR),

    //   //READ DATA1
    //     .RID_S(w_RID_S3),
	// 	.RDATA_S(w_RDATA_S3),
    //     .RRESP_S(w_RRESP_S3),
    //     .RLAST_S(w_RLAST_S3),
    //     .RVALID_S(w_RVALID_S3),
    //     .RREADY_S(w_RREADY_S3),
		.S_R(wire_DMA_R),

    //   //WRITE ADDRESS
    //     .AWID_S(w_AWID_S3),
    //     .AWADDR_S(w_AWADDR_S3),
    //     .AWLEN_S(w_AWLEN_S3),
    //     .AWSIZE_S(w_AWSIZE_S3),
    //     .AWBURST_S(w_AWBURST_S3),
    //     .AWVALID_S(w_AWVALID_S3),
    //     .AWREADY_S(w_AWREADY_S3),     
		.S_AW(wire_DMA_AW),

    //   //WRITE DATA
    //     .WDATA_S(w_WDATA_S3),
    //     .WSTRB_S(w_WSTRB_S3),
    //     .WLAST_S(w_WLAST_S3),
    //     .WVALID_S(w_WVALID_S3),
    //     .WREADY_S(w_WREADY_S3), 
		.S_W(wire_DMA_W),

    //   //WRITE RESPONSE
    //     .BID_S(w_BID_S3),
    //     .BRESP_S(w_BRESP_S3),
    //     .BVALID_S(w_BVALID_S3),
    //     .BREADY_S(w_BREADY_S3),
		.S_B(wire_DMA_B),

      //Master port    
      //WRITE ADDRESS
        // .AWID_M2(w_AWID_M2)        ,
        // .AWADDR_M2(w_AWADDR_M2)      ,
        // .AWLEN_M2(w_AWLEN_M2)       ,
        // .AWSIZE_M2(w_AWSIZE_M2)      ,
        // .AWBURST_M2(w_AWBURST_M2)     ,
        // .AWVALID_M2(w_AWVALID_M2)     ,
        // .AWREADY_M2(w_AWREADY_M2)     ,  
		.M_AW(wire_M2_AW),

    //   //WRITE DATA
    //     .WDATA_M2(w_WDATA_M2)       ,
    //     .WSTRB_M2(w_WSTRB_M2)       ,
    //     .WLAST_M2(w_WLAST_M2)       ,
    //     .WVALID_M2(w_WVALID_M2)      ,
    //     .WREADY_M2(w_WREADY_M2)      ,  
		.M_W(wire_M2_W),

    //   //WRITE RESPONSE
    //     .BID_M2(w_BID_M2)         ,
    //     .BRESP_M2(w_BRESP_M2)       ,
    //     .BVALID_M2(w_BVALID_M2)      ,
    //     .BREADY_M2(w_BREADY_M2)      ,  
		.M_B(wire_M2_B),

    //   //READ ADDRESS1
    //     .ARID_M2(w_ARID_M2)        ,
    //     .ARADDR_M2(w_ARADDR_M2)      ,
    //     .ARLEN_M2(w_ARLEN_M2)       ,
    //     .ARSIZE_M2(w_ARSIZE_M2)      ,
    //     .ARBURST_M2(w_ARBURST_M2)     ,
    //     .ARVALID_M2(w_ARVALID_M2)     ,
    //     .ARREADY_M2(w_ARREADY_M2)     ,  
		.M_AR(wire_M2_AR),

    //   //READ DATA1
    //     .RID_M2(w_RID_M2)         ,
    //     .RDATA_M2(w_RDATA_M2)       ,
    //     .RRESP_M2(w_RRESP_M2)       ,
    //     .RLAST_M2(w_RLAST_M2)       ,
    //     .RVALID_M2(w_RVALID_M2)      ,
    //     .RREADY_M2(w_RREADY_M2)      ,	
		.M_R(wire_M2_R),

      //DMA Interrupt
        .DMA_interrupt(w_DMA_interrupt)        
    );

 ROM_wrapper rom(
        .ACLK(clk), 
		.ARESETn(~rst),
    //   //AXI Waddr
    //     .S_AWID(w_AWID_S0),    
    //     .S_AWAddr(w_AWADDR_S0),  
    //     .S_AWLen(w_AWLEN_S0),   
    //     .S_AWSize(w_AWSIZE_S0),  
    //     .S_AWBurst(w_AWBURST_S0), 
    //     .S_AWValid(w_AWVALID_S0), 
    //     .S_AWReady(w_AWREADY_S0),
		.S_AW(wire_ROM_AW),

    //   //AXI Wdata     
    //     .S_WData(w_WDATA_S0),   
    //     .S_WStrb(w_WSTRB_S0),   
    //     .S_WLast(w_WLAST_S0),   
    //     .S_WValid(w_WVALID_S0),  
    //     .S_WReady(w_WREADY_S0),
		.S_W(wire_ROM_W),


    //   //AXI Wresp
    //     .S_BID(w_BID_S0),
    //     .S_BResp(w_BRESP_S0),
    //     .S_BValid(w_BVALID_S0),
    //     .S_BReady(w_BREADY_S0),        
		.S_B(wire_ROM_B),

    //   //AXI Raddr
    //     .S_ARID(w_ARID_S0),    
    //     .S_ARAddr(w_ARADDR_S0),  
    //     .S_ARLen(w_ARLEN_S0),   
    //     .S_ARSize(w_ARSIZE_S0),  
    //     .S_ARBurst(w_ARBURST_S0), 
    //     .S_ARValid(w_ARVALID_S0), 
    //     .S_ARReady(w_ARREADY_S0),
		.S_AR(wire_ROM_AR),

    //   //AXI Rdata   
    //     .S_RID(w_RID_S0),         
    //     .S_RData(w_RDATA_S0),   
    //     .S_RResp(w_RRESP_S0),   
    //     .S_RLast(w_RLAST_S0),   
    //     .S_RValid(w_RVALID_S0),  
    //     .S_RReady(w_RREADY_S0),
		.S_R(wire_ROM_R),

      //ROM for testbanch
        .ROM_out(ROM_out),
        .ROM_read(ROM_read),
        .ROM_enable(ROM_enable),
        .Rom_address(ROM_address)
    );

 WDT_wrapper wdt(
    //WDT Module
    .clk(clk), 
	.rst(~rst),
    .clk2(clk2), 
	.rst2(~rst2),
    .WTO(w_WDT_timeout),
    //need to revise to interface
    // //READ ADDRESS1
    // .S_ARID  	(w_ARID_S4),
    // .S_ARAddr		(w_ARADDR_S4),
    // .S_ARLen 		(w_ARLEN_S4),
    // .S_ARSize		(w_ARSIZE_S4),
    // .S_ARBurst		(w_ARBURST_S4),
    // .S_ARValid		(w_ARVALID_S4),
    // .S_ARReady		(w_ARREADY_S4),
	.S_AR(wire_WDT_AR),


    // //READ DATA1
    // .S_RID   	(w_RID_S4),
    // .S_RData 		(w_RDATA_S4),
    // .S_RResp		(w_RRESP_S4),
    // .S_RLast		(w_RLAST_S4),
    // .S_RValid		(w_RVALID_S4),
    // .S_RReady		(w_RREADY_S4),
	.S_R(wire_WDT_R),


    // //WRITE ADDRESS
    // .S_AWID   	(w_AWID_S4),
    // .S_AWAddr 		(w_AWADDR_S4),
    // .S_AWLen  		(w_AWLEN_S4),
    // .S_AWSize 		(w_AWSIZE_S4),
    // .S_AWBurst		(w_AWBURST_S4),
    // .S_AWValid		(w_AWVALID_S4),
    // .S_AWReady		(w_AWREADY_S4),
	.S_AW(wire_WDT_AW),
    
    // //WRITE DATA
    // .S_WData 		(w_WDATA_S4),
    // .S_WStrb 		(w_WSTRB_S4),
    // .S_WLast 		(w_WLAST_S4),
    // .S_WValid		(w_WVALID_S4),
    // .S_WReady		(w_WREADY_S4),
	.S_W(wire_WDT_W),
    
    // //WRITE RESPONSE
    // .S_BID	(w_BID_S4),
    // .S_BResp		(w_BRESP_S4),
    // .S_BValid		(w_BVALID_S4),
    // .S_BReady		(w_BREADY_S4) 
	.S_B(wire_WDT_B)   
  );

endmodule