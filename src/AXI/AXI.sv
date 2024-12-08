`include "../include/AXI_define.svh"
`include "../src/AXI/ReadAddr.sv"
`include "../src/AXI/ReadData.sv"
`include "../src/AXI/WriteAddr.sv"
`include "../src/AXI/WriteData.sv"
`include "../src/AXI/WriteResp.sv"
// `include "../src/AXI/Default_Slave.sv"

	// WA.Master M1_AW,
	// W.Master M1_W,
	// B.Master M1_B,
	// RA.Master M1_AR,
	// R.Master M1_R,
module AXI(

	input ACLK,
	input ARESETn,

	//SLAVE INTERFACE FOR MASTERS
	
	// //WRITE ADDRESS
	// input [`AXI_ID_BITS-1:0] AWID_M1,
	// input [`AXI_ADDR_BITS-1:0] AWADDR_M1,
	// input [`AXI_LEN_BITS-1:0] AWLEN_M1,
	// input [`AXI_SIZE_BITS-1:0] AWSIZE_M1,
	// input [1:0] AWBURST_M1,
	// input AWVALID_M1,
	// output logic AWREADY_M1,
	WA.Master M1_AW,
	
	// //WRITE DATA
	// input [`AXI_DATA_BITS-1:0] WDATA_M1,
	// input [`AXI_STRB_BITS-1:0] WSTRB_M1,
	// input WLAST_M1,
	// input WVALID_M1,
	// output logic WREADY_M1,
	W.Master M1_W,
	
	// //WRITE RESPONSE
	// output logic [`AXI_ID_BITS-1:0] BID_M1,
	// output logic [1:0] BRESP_M1,
	// output logic BVALID_M1,
	// input BREADY_M1,
	B.Master M1_B,

	// //READ ADDRESS0
	// input [`AXI_ID_BITS-1:0] ARID_M0,
	// input [`AXI_ADDR_BITS-1:0] ARADDR_M0,
	// input [`AXI_LEN_BITS-1:0] ARLEN_M0,
	// input [`AXI_SIZE_BITS-1:0] ARSIZE_M0,
	// input [1:0] ARBURST_M0,
	// input ARVALID_M0,
	// output logic ARREADY_M0,
	RA.Master M0_AR,
	
	// //READ DATA0
	// output logic [`AXI_ID_BITS-1:0] RID_M0,
	// output logic [`AXI_DATA_BITS-1:0] RDATA_M0,
	// output logic [1:0] RRESP_M0,
	// output logic RLAST_M0,
	// output logic RVALID_M0,
	// input RREADY_M0,
	R.Master M0_R,
	
	// //READ ADDRESS1
	// input [`AXI_ID_BITS-1:0] ARID_M1,
	// input [`AXI_ADDR_BITS-1:0] ARADDR_M1,
	// input [`AXI_LEN_BITS-1:0] ARLEN_M1,
	// input [`AXI_SIZE_BITS-1:0] ARSIZE_M1,
	// input [1:0] ARBURST_M1,
	// input ARVALID_M1,
	// output logic ARREADY_M1,
	RA.Master M1_AR,
	
	// //READ DATA1
	// output logic [`AXI_ID_BITS-1:0] RID_M1,
	// output logic [`AXI_DATA_BITS-1:0] RDATA_M1,
	// output logic [1:0] RRESP_M1,
	// output logic RLAST_M1,
	// output logic RVALID_M1,
	// input RREADY_M1,
	R.Master M1_R,

	// //DMA
	// //READ ADDRESS1
	// input [`AXI_ID_BITS-1:0] ARID_M2,
	// input [`AXI_ADDR_BITS-1:0] ARADDR_M2,
	// input [`AXI_LEN_BITS-1:0] ARLEN_M2,
	// input [`AXI_SIZE_BITS-1:0] ARSIZE_M2,
	// input [1:0] ARBURST_M2,
	// input ARVALID_M2,
	// output logic ARREADY_M2,

	// //READ DAT21
	// output logic [`AXI_ID_BITS-1:0] RID_M2,
	// output logic [`AXI_DATA_BITS-1:0] RDATA_M2,
	// output logic [1:0] RRESP_M2,
	// output logic RLAST_M2,
	// output logic RVALID_M2,
	// input RREADY_M2,

	// //WRITE ADDRESS
	// input [`AXI_ID_BITS-1:0] AWID_M2,
	// input [`AXI_ADDR_BITS-1:0] AWADDR_M2,
	// input [`AXI_LEN_BITS-1:0] AWLEN_M2,
	// input [`AXI_SIZE_BITS-1:0] AWSIZE_M2,
	// input [1:0] AWBURST_M2,
	// input AWVALID_M2,
	// output logic AWREADY_M2,
	
	// //WRITE DATA
	// input [`AXI_DATA_BITS-1:0] WDATA_M2,
	// input [`AXI_STRB_BITS-1:0] WSTRB_M2,
	// input WLAST_M2,
	// input WVALID_M2,
	// output logic WREADY_M2,
	
	// //WRITE RESPONSE
	// output logic [`AXI_ID_BITS-1:0] BID_M2,
	// output logic [1:0] BRESP_M2,
	// output logic BVALID_M2,
	// input BREADY_M2,
	WA.Master M2_AW,
	W.Master M2_W,
	B.Master M2_B,
	RA.Master M2_AR,
	R.Master M2_R,

	//MASTER INTERFACE FOR SLAVES
	// //WRITE ADDRESS0
	// output logic [`AXI_IDS_BITS-1:0] AWID_S0,
	// output logic [`AXI_ADDR_BITS-1:0] AWADDR_S0,
	// output logic [`AXI_LEN_BITS-1:0] AWLEN_S0,
	// output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S0,
	// output logic [1:0] AWBURST_S0,
	// output logic AWVALID_S0,
	// input AWREADY_S0,
	
	// //WRITE DATA0
	// output logic [`AXI_DATA_BITS-1:0] WDATA_S0,
	// output logic [`AXI_STRB_BITS-1:0] WSTRB_S0,
	// output logic WLAST_S0,
	// output logic WVALID_S0,
	// input WREADY_S0,
	
	// //WRITE RESPONSE0
	// input [`AXI_IDS_BITS-1:0] BID_S0,
	// input [1:0] BRESP_S0,
	// input BVALID_S0,
	// output logic BREADY_S0,
	WA.Slave S0_AW,
	W.Slave S0_W,
	B.Slave S0_B,
	RA.Slave S0_AR,
	R.Slave S0_R,

	// //WRITE ADDRESS1
	// output logic [`AXI_IDS_BITS-1:0] AWID_S1,
	// output logic [`AXI_ADDR_BITS-1:0] AWADDR_S1,
	// output logic [`AXI_LEN_BITS-1:0] AWLEN_S1,
	// output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S1,
	// output logic [1:0] AWBURST_S1,
	// output logic AWVALID_S1,
	// input AWREADY_S1,
	
	// //WRITE DATA1
	// output logic [`AXI_DATA_BITS-1:0] WDATA_S1,
	// output logic [`AXI_STRB_BITS-1:0] WSTRB_S1,
	// output logic WLAST_S1,
	// output logic WVALID_S1,
	// input WREADY_S1,
	
	// //WRITE RESPONSE1
	// input [`AXI_IDS_BITS-1:0] BID_S1,
	// input [1:0] BRESP_S1,
	// input BVALID_S1,
	// output logic BREADY_S1,
	
	// //READ ADDRESS0
	// output logic [`AXI_IDS_BITS-1:0] ARID_S0,
	// output logic [`AXI_ADDR_BITS-1:0] ARADDR_S0,
	// output logic [`AXI_LEN_BITS-1:0] ARLEN_S0,
	// output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S0,
	// output logic [1:0] ARBURST_S0,
	// output logic ARVALID_S0,
	// input ARREADY_S0,
	
	// //READ DATA0
	// input [`AXI_IDS_BITS-1:0] RID_S0,
	// input [`AXI_DATA_BITS-1:0] RDATA_S0,
	// input [1:0] RRESP_S0,
	// input RLAST_S0,
	// input RVALID_S0,
	// output logic RREADY_S0,
	
	// //READ ADDRESS1
	// output logic [`AXI_IDS_BITS-1:0] ARID_S1,
	// output logic [`AXI_ADDR_BITS-1:0] ARADDR_S1,
	// output logic [`AXI_LEN_BITS-1:0] ARLEN_S1,
	// output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S1,
	// output logic [1:0] ARBURST_S1,
	// output logic ARVALID_S1,
	// input ARREADY_S1,
	
	// //READ DATA1
	// input [`AXI_IDS_BITS-1:0] RID_S1,
	// input [`AXI_DATA_BITS-1:0] RDATA_S1,
	// input [1:0] RRESP_S1,
	// input RLAST_S1,
	// input RVALID_S1,
	// output logic RREADY_S1,
	WA.Slave S1_AW,
	W.Slave S1_W,
	B.Slave S1_B,
	RA.Slave S1_AR,
	R.Slave S1_R,

	// //DM slave
	// //READ ADDRESS
	// output logic [`AXI_IDS_BITS-1:0] ARID_S2,
	// output logic [`AXI_ADDR_BITS-1:0] ARADDR_S2,
	// output logic [`AXI_LEN_BITS-1:0] ARLEN_S2,
	// output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S2,
	// output logic [1:0] ARBURST_S2,
	// output logic ARVALID_S2,
	// input ARREADY_S2,
	
	// //READ DATA
	// input [`AXI_IDS_BITS-1:0] RID_S2,
	// input [`AXI_DATA_BITS-1:0] RDATA_S2,
	// input [1:0] RRESP_S2,
	// input RLAST_S2,
	// input RVALID_S2,
	// output logic RREADY_S2,

	// //WRITE ADDRESS
	// output logic [`AXI_IDS_BITS-1:0] AWID_S2,
	// output logic [`AXI_ADDR_BITS-1:0] AWADDR_S2,
	// output logic [`AXI_LEN_BITS-1:0] AWLEN_S2,
	// output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S2,
	// output logic [1:0] AWBURST_S2,
	// output logic AWVALID_S2,
	// input AWREADY_S2,
	
	// //WRITE DATA
	// output logic [`AXI_DATA_BITS-1:0] WDATA_S2,
	// output logic [`AXI_STRB_BITS-1:0] WSTRB_S2,
	// output logic WLAST_S2,
	// output logic WVALID_S2,
	// input WREADY_S2,
	
	// //WRITE RESPONSE
	// input [`AXI_IDS_BITS-1:0] BID_S2,
	// input [1:0] BRESP_S2,
	// input BVALID_S2,
	// output logic BREADY_S2,
	WA.Slave S2_AW,
	W.Slave S2_W,
	B.Slave S2_B,
	RA.Slave S2_AR,
	R.Slave S2_R,

	// //DMA slave
	// //READ ADDRESS
	// output logic [`AXI_IDS_BITS-1:0] ARID_S3,
	// output logic [`AXI_ADDR_BITS-1:0] ARADDR_S3,
	// output logic [`AXI_LEN_BITS-1:0] ARLEN_S3,
	// output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S3,
	// output logic [1:0] ARBURST_S3,
	// output logic ARVALID_S3,
	// input ARREADY_S3,
	
	// //READ DATA
	// input [`AXI_IDS_BITS-1:0] RID_S3,
	// input [`AXI_DATA_BITS-1:0] RDATA_S3,
	// input [1:0] RRESP_S3,
	// input RLAST_S3,
	// input RVALID_S3,
	// output logic RREADY_S3,

	// //WRITE ADDRESS
	// output logic [`AXI_IDS_BITS-1:0] AWID_S3,
	// output logic [`AXI_ADDR_BITS-1:0] AWADDR_S3,
	// output logic [`AXI_LEN_BITS-1:0] AWLEN_S3,
	// output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S3,
	// output logic [1:0] AWBURST_S3,
	// output logic AWVALID_S3,
	// input AWREADY_S3,
	
	// //WRITE DATA
	// output logic [`AXI_DATA_BITS-1:0] WDATA_S3,
	// output logic [`AXI_STRB_BITS-1:0] WSTRB_S3,
	// output logic WLAST_S3,
	// output logic WVALID_S3,
	// input WREADY_S3,
	
	// //WRITE RESPONSE
	// input [`AXI_IDS_BITS-1:0] BID_S3,
	// input [1:0] BRESP_S3,
	// input BVALID_S3,
	// output logic BREADY_S3,
	WA.Slave S3_AW,
	W.Slave S3_W,
	B.Slave S3_B,
	RA.Slave S3_AR,
	R.Slave S3_R,

	// //WDT slave
	// //READ ADDRESS
	// output logic [`AXI_IDS_BITS-1:0] ARID_S4,
	// output logic [`AXI_ADDR_BITS-1:0] ARADDR_S4,
	// output logic [`AXI_LEN_BITS-1:0] ARLEN_S4,
	// output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S4,
	// output logic [1:0] ARBURST_S4,
	// output logic ARVALID_S4,
	// input ARREADY_S4,
	
	// //READ DATA
	// input [`AXI_IDS_BITS-1:0] RID_S4,
	// input [`AXI_DATA_BITS-1:0] RDATA_S4,
	// input [1:0] RRESP_S4,
	// input RLAST_S4,
	// input RVALID_S4,
	// output logic RREADY_S4,

	// //WRITE ADDRESS
	// output logic [`AXI_IDS_BITS-1:0] AWID_S4,
	// output logic [`AXI_ADDR_BITS-1:0] AWADDR_S4,
	// output logic [`AXI_LEN_BITS-1:0] AWLEN_S4,
	// output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S4,
	// output logic [1:0] AWBURST_S4,
	// output logic AWVALID_S4,
	// input AWREADY_S4,
	
	// //WRITE DATA
	// output logic [`AXI_DATA_BITS-1:0] WDATA_S4,
	// output logic [`AXI_STRB_BITS-1:0] WSTRB_S4,
	// output logic WLAST_S4,
	// output logic WVALID_S4,
	// input WREADY_S4,
	
	// //WRITE RESPONSE
	// input [`AXI_IDS_BITS-1:0] BID_S4,
	// input [1:0] BRESP_S4,
	// input BVALID_S4,
	// output logic BREADY_S4,
	WA.Slave S4_AW,
	W.Slave S4_W,
	B.Slave S4_B,
	RA.Slave S4_AR,
	R.Slave S4_R,

	// //DRAM slave
	// //READ ADDRESS
	// output logic [`AXI_IDS_BITS-1:0] ARID_S5,
	// output logic [`AXI_ADDR_BITS-1:0] ARADDR_S5,
	// output logic [`AXI_LEN_BITS-1:0] ARLEN_S5,
	// output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S5,
	// output logic [1:0] ARBURST_S5,
	// output logic ARVALID_S5,
	// input ARREADY_S5,
	
	// //READ DATA
	// input [`AXI_IDS_BITS-1:0] RID_S5,
	// input [`AXI_DATA_BITS-1:0] RDATA_S5,
	// input [1:0] RRESP_S5,
	// input RLAST_S5,
	// input RVALID_S5,
	// output logic RREADY_S5,

	// //WRITE ADDRESS
	// output logic [`AXI_IDS_BITS-1:0] AWID_S5,
	// output logic [`AXI_ADDR_BITS-1:0] AWADDR_S5,
	// output logic [`AXI_LEN_BITS-1:0] AWLEN_S5,
	// output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S5,
	// output logic [1:0] AWBURST_S5,
	// output logic AWVALID_S5,
	// input AWREADY_S5,
	
	// //WRITE DATA
	// output logic [`AXI_DATA_BITS-1:0] WDATA_S5,
	// output logic [`AXI_STRB_BITS-1:0] WSTRB_S5,
	// output logic WLAST_S5,
	// output logic WVALID_S5,
	// input WREADY_S5,
	
	// //WRITE RESPONSE
	// input [`AXI_IDS_BITS-1:0] BID_S5,
	// input [1:0] BRESP_S5,
	// input BVALID_S5,
	// output logic BREADY_S5
	WA.Slave S5_AW,
	W.Slave S5_W,
	B.Slave S5_B,
	RA.Slave S5_AR,
	R.Slave S5_R
);
    //---------- you should put your design here ----------//

//master 
//M0 instruction master
//read

//M1 data master
//read and write

//M2 DMA masetr
//read and write

//slave
//ROM
//read

//IM
//read and write

//DM
//read and write

//DMA
//read and write

//WDT
//read and write

//DRAM
//read and write

ReadAddr read_address(
	.clk(ACLK),
	.rst(ARESETn),

	    //M0
	// .ARID_M0(ARID_M0),
	// .ARADDR_M0(ARADDR_M0),
	// .ARLEN_M0(ARLEN_M0),
	// .ARSIZE_M0(ARSIZE_M0),
	// .ARBURST_M0(ARBURST_M0),
	// .ARVALID_M0(ARVALID_M0),
	// .ARREADY_M0(ARREADY_M0),
	.M0_AR(M0_AR),

	    //M1
	// .ARID_M1(ARID_M1),
	// .ARADDR_M1(ARADDR_M1),
	// .ARLEN_M1(ARLEN_M1),
	// .ARSIZE_M1(ARSIZE_M1),
	// .ARBURST_M1(ARBURST_M1),
	// .ARVALID_M1(ARVALID_M1),
	// .ARREADY_M1(ARREADY_M1),
	.M1_AR(M1_AR),

	// 	//M2 DMA
	// .ARID_M2(ARID_M2),
	// .ARADDR_M2(ARADDR_M2),
	// .ARLEN_M2(ARLEN_M2),
	// .ARSIZE_M2(ARSIZE_M2),
	// .ARBURST_M2(ARBURST_M2),
	// .ARVALID_M2(ARVALID_M2),
	// .ARREADY_M2(ARREADY_M2),
	.M2_AR(M2_AR),

	//     //S0
	// .ARID_S0(ARID_S0),
	// .ARADDR_S0(ARADDR_S0),
	// .ARLEN_S0(ARLEN_S0),
	// .ARSIZE_S0(ARSIZE_S0),
	// .ARBURST_S0(ARBURST_S0),
	// .ARVALID_S0(ARVALID_S0),
	// .ARREADY_S0(ARREADY_S0),
	.S0_AR(S0_AR),

	//     //S1
	// .ARID_S1(ARID_S1),
	// .ARADDR_S1(ARADDR_S1),
	// .ARLEN_S1(ARLEN_S1),
	// .ARSIZE_S1(ARSIZE_S1),
	// .ARBURST_S1(ARBURST_S1),
	// .ARVALID_S1(ARVALID_S1),
	// .ARREADY_S1(ARREADY_S1),
	.S1_AR(S1_AR),

	//     //S2
	// .ARID_S2(ARID_S2),
	// .ARADDR_S2(ARADDR_S2),
	// .ARLEN_S2(ARLEN_S2),
	// .ARSIZE_S2(ARSIZE_S2),
	// .ARBURST_S2(ARBURST_S2),
	// .ARVALID_S2(ARVALID_S2),
	// .ARREADY_S2(ARREADY_S2),
	.S2_AR(S2_AR),

	//     //S3
	// .ARID_S3(ARID_S3),
	// .ARADDR_S3(ARADDR_S3),
	// .ARLEN_S3(ARLEN_S3),
	// .ARSIZE_S3(ARSIZE_S3),
	// .ARBURST_S3(ARBURST_S3),
	// .ARVALID_S3(ARVALID_S3),
	// .ARREADY_S3(ARREADY_S3),
	.S3_AR(S3_AR),

	//     //S4
	// .ARID_S4(ARID_S4),
	// .ARADDR_S4(ARADDR_S4),
	// .ARLEN_S4(ARLEN_S4),
	// .ARSIZE_S4(ARSIZE_S4),
	// .ARBURST_S4(ARBURST_S4),
	// .ARVALID_S4(ARVALID_S4),
	// .ARREADY_S4(ARREADY_S4),
	.S4_AR(S4_AR),

	//     //S5
	// .ARID_S5(ARID_S5),
	// .ARADDR_S5(ARADDR_S5),
	// .ARLEN_S5(ARLEN_S5),
	// .ARSIZE_S5(ARSIZE_S5),
	// .ARBURST_S5(ARBURST_S5),
	// .ARVALID_S5(ARVALID_S5),
	// .ARREADY_S5(ARREADY_S5)
	.S5_AR(S5_AR)
);

ReadData read_data(
	.clk(ACLK),
	.rst(ARESETn),
	//     //M0	
	// .RID_M0(RID_M0),
	// .RDATA_M0(RDATA_M0),
	// .RRESP_M0(RRESP_M0),
	// .RLAST_M0(RLAST_M0),
	// .RVALID_M0(RVALID_M0),
	// .RREADY_M0(RREADY_M0),
	.M0_R(M0_R),

	//     //M1
	// .RID_M1(RID_M1),
	// .RDATA_M1(RDATA_M1),
	// .RRESP_M1(RRESP_M1),
	// .RLAST_M1(RLAST_M1),
	// .RVALID_M1(RVALID_M1),
	// .RREADY_M1(RREADY_M1),
	.M1_R(M1_R),

	//     //M2 DMA
	// .RID_M2(RID_M2),
	// .RDATA_M2(RDATA_M2),
	// .RRESP_M2(RRESP_M2),
	// .RLAST_M2(RLAST_M2),
	// .RVALID_M2(RVALID_M2),
	// .RREADY_M2(RREADY_M2),
	.M2_R(M2_R),
	
	//     //S0
	// .RID_S0(RID_S0),
	// .RDATA_S0(RDATA_S0),
	// .RRESP_S0(RRESP_S0),
	// .RLAST_S0(RLAST_S0),
	// .RVALID_S0(RVALID_S0),
	// .RREADY_S0(RREADY_S0),
	.S0_R(S0_R),

	//     //S1
	// .RID_S1(RID_S1),
	// .RDATA_S1(RDATA_S1),
	// .RRESP_S1(RRESP_S1),
	// .RLAST_S1(RLAST_S1),
	// .RVALID_S1(RVALID_S1),
	// .RREADY_S1(RREADY_S1),
	.S1_R(S1_R),

	//     //S2
	// .RID_S2(RID_S2),
	// .RDATA_S2(RDATA_S2),
	// .RRESP_S2(RRESP_S2),
	// .RLAST_S2(RLAST_S2),
	// .RVALID_S2(RVALID_S2),
	// .RREADY_S2(RREADY_S2),
	.S2_R(S2_R),

	//     //S3
	// .RID_S3(RID_S3),
	// .RDATA_S3(RDATA_S3),
	// .RRESP_S3(RRESP_S3),
	// .RLAST_S3(RLAST_S3),
	// .RVALID_S3(RVALID_S3),
	// .RREADY_S3(RREADY_S3),
	.S3_R(S3_R),

	//     //S4
	// .RID_S4(RID_S4),
	// .RDATA_S4(RDATA_S4),
	// .RRESP_S4(RRESP_S4),
	// .RLAST_S4(RLAST_S4),
	// .RVALID_S4(RVALID_S4),
	// .RREADY_S4(RREADY_S4),
	.S4_R(S4_R),

	//     //S5
	// .RID_S5(RID_S5),
	// .RDATA_S5(RDATA_S5),
	// .RRESP_S5(RRESP_S5),
	// .RLAST_S5(RLAST_S5),
	// .RVALID_S5(RVALID_S5),
	// .RREADY_S5(RREADY_S5)
	.S5_R(S5_R)

);

WriteAddr write_address(
.clk(ACLK),
.rst(ARESETn),

//     //M1
// .AWID_M1(AWID_M1),
// .AWADDR_M1(AWADDR_M1),
// .AWLEN_M1(AWLEN_M1),
// .AWSIZE_M1(AWSIZE_M1),
// .AWBURST_M1(AWBURST_M1),
// .AWVALID_M1(AWVALID_M1),
// .AWREADY_M1(AWREADY_M1),
.M1_AW(M1_AW),

// 	//M2
// .AWID_M2(AWID_M2),
// .AWADDR_M2(AWADDR_M2),
// .AWLEN_M2(AWLEN_M2),
// .AWSIZE_M2(AWSIZE_M2),
// .AWBURST_M2(AWBURST_M2),
// .AWVALID_M2(AWVALID_M2),
// .AWREADY_M2(AWREADY_M2),
.M2_AW(M2_AW),
	
//     //S0
// .AWID_S0(AWID_S0),
// .AWADDR_S0(AWADDR_S0),
// .AWLEN_S0(AWLEN_S0),
// .AWSIZE_S0(AWSIZE_S0),
// .AWBURST_S0(AWBURST_S0),
// .AWVALID_S0(AWVALID_S0),
// .AWREADY_S0(AWREADY_S0),
.S0_AW(S0_AW),

//     //S1
// .AWID_S1(AWID_S1),
// .AWADDR_S1(AWADDR_S1),
// .AWLEN_S1(AWLEN_S1),
// .AWSIZE_S1(AWSIZE_S1),
// .AWBURST_S1(AWBURST_S1),
// .AWVALID_S1(AWVALID_S1),
// .AWREADY_S1(AWREADY_S1),
.S1_AW(S1_AW),

//     //S2
// .AWID_S2(AWID_S2),
// .AWADDR_S2(AWADDR_S2),
// .AWLEN_S2(AWLEN_S2),
// .AWSIZE_S2(AWSIZE_S2),
// .AWBURST_S2(AWBURST_S2),
// .AWVALID_S2(AWVALID_S2),
// .AWREADY_S2(AWREADY_S2),
.S2_AW(S2_AW),

// 	//S3
// .AWID_S3(AWID_S3),
// .AWADDR_S3(AWADDR_S3),
// .AWLEN_S3(AWLEN_S3),
// .AWSIZE_S3(AWSIZE_S3),
// .AWBURST_S3(AWBURST_S3),
// .AWVALID_S3(AWVALID_S3),
// .AWREADY_S3(AWREADY_S3),
.S3_AW(S3_AW),

// 	//S4
// .AWID_S4(AWID_S4),
// .AWADDR_S4(AWADDR_S4),
// .AWLEN_S4(AWLEN_S4),
// .AWSIZE_S4(AWSIZE_S4),
// .AWBURST_S4(AWBURST_S4),
// .AWVALID_S4(AWVALID_S4),
// .AWREADY_S4(AWREADY_S4),
.S4_AW(S4_AW),

// 	//S5
// .AWID_S5(AWID_S5),
// .AWADDR_S5(AWADDR_S5),
// .AWLEN_S5(AWLEN_S5),
// .AWSIZE_S5(AWSIZE_S5),
// .AWBURST_S5(AWBURST_S5),
// .AWVALID_S5(AWVALID_S5),
// .AWREADY_S5(AWREADY_S5)
.S5_AW(S5_AW)
);

WriteData write_data(
.clk(ACLK),
.rst(ARESETn),
//     //M1
// .WDATA_M1(WDATA_M1),
// .WSTRB_M1(WSTRB_M1),
// .WLAST_M1(WLAST_M1),
// .WVALID_M1(WVALID_M1),
// .WREADY_M1(WREADY_M1),
.M1_W(M1_W),

//     //M2
// .WDATA_M2(WDATA_M2),
// .WSTRB_M2(WSTRB_M2),
// .WLAST_M2(WLAST_M2),
// .WVALID_M2(WVALID_M2),
// .WREADY_M2(WREADY_M2),
.M2_W(M2_W),

//     //S0
.AWID_S0(S0_AW.AWID_S),
.AWVALID_S0(S0_AW.AWVALID),
// .WDATA_S0(WDATA_S0),
// .WSTRB_S0(WSTRB_S0),
// .WLAST_S0(WLAST_S0),
// .WVALID_S0(WVALID_S0),
// .WREADY_S0(WREADY_S0),
.S0_W(S0_W),
//     //S1
.AWID_S1(S1_AW.AWID_S),
.AWVALID_S1(S1_AW.AWVALID),
// .WDATA_S1(WDATA_S1),
// .WSTRB_S1(WSTRB_S1),
// .WLAST_S1(WLAST_S1),
// .WVALID_S1(WVALID_S1),
// .WREADY_S1(WREADY_S1),
.S1_W(S1_W),
//     //S2
.AWID_S2(S2_AW.AWID_S),
.AWVALID_S2(S2_AW.AWVALID),
// .WDATA_S2(WDATA_S2),
// .WSTRB_S2(WSTRB_S2),
// .WLAST_S2(WLAST_S2),
// .WVALID_S2(WVALID_S2),
// .WREADY_S2(WREADY_S2),
.S2_W(S2_W),
//     //S3
.AWID_S3(S3_AW.AWID_S),
.AWVALID_S3(S3_AW.AWVALID),
// .WDATA_S3(WDATA_S3),
// .WSTRB_S3(WSTRB_S3),
// .WLAST_S3(WLAST_S3),
// .WVALID_S3(WVALID_S3),
// .WREADY_S3(WREADY_S3),
.S3_W(S3_W),
//     //S4
.AWID_S4(S4_AW.AWID_S),
.AWVALID_S4(S4_AW.AWVALID),
// .WDATA_S4(WDATA_S4),
// .WSTRB_S4(WSTRB_S4),
// .WLAST_S4(WLAST_S4),
// .WVALID_S4(WVALID_S4),
// .WREADY_S4(WREADY_S4),
.S4_W(S4_W),
//     //S5
.AWID_S5(S5_AW.AWID_S),
.AWVALID_S5(S5_AW.AWVALID),
// .WDATA_S5(WDATA_S5),
// .WSTRB_S5(WSTRB_S5),
// .WLAST_S5(WLAST_S5),
// .WVALID_S5(WVALID_S5),
// .WREADY_S5(WREADY_S5)
.S5_W(S5_W)
);

WriteResp write_response(
.clk(ACLK),
.rst(ARESETn),

//     //M1
// .BID_M1(BID_M1),
// .BRESP_M1(BRESP_M1),
// .BVALID_M1(BVALID_M1),
// .BREADY_M1(BREADY_M1),
.M1_B(M1_B),
//     //M2
// .BID_M2(BID_M2),
// .BRESP_M2(BRESP_M2),
// .BVALID_M2(BVALID_M2),
// .BREADY_M2(BREADY_M2),
.M2_B(M2_B),
//     //S0
// .BID_S0(BID_S0),
// .BRESP_S0(BRESP_S0),
// .BVALID_S0(BVALID_S0),
// .BREADY_S0(BREADY_S0),
.S0_B(S0_B),
//     //S1
// .BID_S1(BID_S1),
// .BRESP_S1(BRESP_S1),
// .BVALID_S1(BVALID_S1),
// .BREADY_S1(BREADY_S1),
.S1_B(S1_B),
//     //S2
// .BID_S2(BID_S2),
// .BRESP_S2(BRESP_S2),
// .BVALID_S2(BVALID_S2),
// .BREADY_S2(BREADY_S2),
.S2_B(S2_B),
//     //S3
// .BID_S3(BID_S3),
// .BRESP_S3(BRESP_S3),
// .BVALID_S3(BVALID_S3),
// .BREADY_S3(BREADY_S3),
.S3_B(S3_B),
//     //S4
// .BID_S4(BID_S4),
// .BRESP_S4(BRESP_S4),
// .BVALID_S4(BVALID_S4),
// .BREADY_S4(BREADY_S4),
.S4_B(S4_B),
//     //S5
// .BID_S5(BID_S5),
// .BRESP_S5(BRESP_S5),
// .BVALID_S5(BVALID_S5),
// .BREADY_S5(BREADY_S5)
.S5_B(S5_B)
);

endmodule
