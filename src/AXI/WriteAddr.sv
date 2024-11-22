`include "../include/AXI_define.svh"
`include "../src/AXI/Decoder.sv"
module WriteAddr (
    input                               clk,
    input                               rst,

    //M1
	input [`AXI_ID_BITS-1:0] AWID_M1,
	input [`AXI_ADDR_BITS-1:0] AWADDR_M1,
	input [`AXI_LEN_BITS-1:0] AWLEN_M1,
	input [`AXI_SIZE_BITS-1:0] AWSIZE_M1,
	input [1:0] AWBURST_M1,
	input AWVALID_M1,
	output logic AWREADY_M1,
	
	//M2	DMA
	input [`AXI_ID_BITS-1:0] AWID_M2,
	input [`AXI_ADDR_BITS-1:0] AWADDR_M2,
	input [`AXI_LEN_BITS-1:0] AWLEN_M2,
	input [`AXI_SIZE_BITS-1:0] AWSIZE_M2,
	input [1:0] AWBURST_M2,
	input AWVALID_M2,
	output logic AWREADY_M2,

    //S0	ROM
	output logic [`AXI_IDS_BITS-1:0] AWID_S0,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S0,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S0,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S0,
	output logic [1:0] AWBURST_S0,
	output logic AWVALID_S0,
	input AWREADY_S0,

    //S1	IM
	output logic [`AXI_IDS_BITS-1:0] AWID_S1,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S1,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S1,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S1,
	output logic [1:0] AWBURST_S1,
	output logic AWVALID_S1,
	input AWREADY_S1,

    //S2	DM
	output logic [`AXI_IDS_BITS-1:0] AWID_S2,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S2,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S2,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S2,
	output logic [1:0] AWBURST_S2,
	output logic AWVALID_S2,
	input AWREADY_S2,

	//S3	DMA
	output logic [`AXI_IDS_BITS-1:0] AWID_S3,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S3,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S3,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S3,
	output logic [1:0] AWBURST_S3,
	output logic AWVALID_S3,
	input AWREADY_S3,

	//S4	WDT
	output logic [`AXI_IDS_BITS-1:0] AWID_S4,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S4,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S4,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S4,
	output logic [1:0] AWBURST_S4,
	output logic AWVALID_S4,
	input AWREADY_S4,

	//S5	DRAM
	output logic [`AXI_IDS_BITS-1:0] AWID_S5,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S5,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S5,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S5,
	output logic [1:0] AWBURST_S5,
	output logic AWVALID_S5,
	input AWREADY_S5
);

logic [`AXI_ID_BITS-1:0]     AWID_M0;
logic [`AXI_ADDR_BITS-1:0]   AWADDR_M0;
logic [`AXI_LEN_BITS-1:0]    AWLEN_M0;
logic [`AXI_SIZE_BITS-1:0]   AWSIZE_M0;
logic [1:0]                  AWBURST_M0;
logic                        AWVALID_M0;

logic [`AXI_IDS_BITS-1:0]    AWID;
logic [`AXI_ADDR_BITS-1:0]   AWADDR;
logic [`AXI_LEN_BITS-1:0]    AWLEN;
logic [`AXI_SIZE_BITS-1:0]   AWSIZE;
logic [1:0]                  AWBURST;
logic                        AWVALID;
logic                        AWREADY;

assign AWID_M0 = `AXI_ID_BITS'b0;
assign AWADDR_M0 = `AXI_ADDR_BITS'b0;
assign AWLEN_M0 = `AXI_LEN_BITS'b0;
assign AWSIZE_M0 = `AXI_SIZE_BITS'b0;
assign AWBURST_M0 = 2'b0;
assign AWVALID_M0 = 1'b0;

assign AWID_S0 = AWID;
assign AWADDR_S0 = AWADDR;
assign AWLEN_S0 = AWLEN;
assign AWSIZE_S0 = AWSIZE;
assign AWBURST_S0 = AWBURST;

assign AWID_S1 = AWID;
assign AWADDR_S1 = AWADDR;
assign AWLEN_S1 = AWLEN;
assign AWSIZE_S1 = AWSIZE;
assign AWBURST_S1 = AWBURST;

assign AWID_S2 = AWID;
assign AWADDR_S2 = AWADDR;
assign AWLEN_S2 = AWLEN;
assign AWSIZE_S2 = AWSIZE;
assign AWBURST_S2 = AWBURST;

assign AWID_S3 = AWID;
assign AWADDR_S3 = AWADDR;
assign AWLEN_S3 = AWLEN;
assign AWSIZE_S3 = AWSIZE;
assign AWBURST_S3 = AWBURST;

assign AWID_S4 = AWID;
assign AWADDR_S4 = AWADDR;
assign AWLEN_S4 = AWLEN;
assign AWSIZE_S4 = AWSIZE;
assign AWBURST_S4 = AWBURST;

assign AWID_S5 = AWID;
assign AWADDR_S5 = AWADDR;
assign AWLEN_S5 = AWLEN;
assign AWSIZE_S5 = AWSIZE;
assign AWBURST_S5 = AWBURST;

Arbiter WAArbiter(
    .clk                 (clk),
    .rst                 (rst),

    //M0 
    .ID_M0               (AWID_M0),
	.ADDR_M0             (AWADDR_M0),
	.LEN_M0              (AWLEN_M0),
	.SIZE_M0             (AWSIZE_M0),
	.BURST_M0            (AWBURST_M0),
	.VALID_M0            (AWVALID_M0),

    .READY_M0            (AWREADY_M0),

    //M1
    .ID_M1               (AWID_M1),
	.ADDR_M1             (AWADDR_M1),
	.LEN_M1              (AWLEN_M1),
	.SIZE_M1             (AWSIZE_M1),
	.BURST_M1            (AWBURST_M1),
	.VALID_M1            (AWVALID_M1),

	.READY_M1            (AWREADY_M1),

	//M2
    .ID_M2               (AWID_M2),
	.ADDR_M2             (AWADDR_M2),
	.LEN_M2              (AWLEN_M2),
	.SIZE_M2             (AWSIZE_M2),
	.BURST_M2            (AWBURST_M2),
	.VALID_M2            (AWVALID_M2),

	.READY_M2            (AWREADY_M2),

    //S
    .ID_S                (AWID),
	.ADDR_S              (AWADDR),
	.LEN_S               (AWLEN),
	.SIZE_S              (AWSIZE),
	.BURST_S             (AWBURST),
	.VALID_S             (AWVALID),

	.READY_S             (AWREADY)
);

Decoder WADecoder(
    .ADDR(AWADDR),
    .VALID(AWVALID),              //the address correctness
    .READY(AWREADY),              //slave take the address
    .READY_S0(AWREADY_S0),
    .READY_S1(AWREADY_S1),
    .READY_S2(AWREADY_S2),
	.READY_S3(AWREADY_S3),
	.READY_S4(AWREADY_S4),
	.READY_S5(AWREADY_S5),

    .VALID_S0(AWVALID_S0),           //axi ready to transfer address to slave
    .VALID_S1(AWVALID_S1),
    .VALID_S2(AWVALID_S2),
	.VALID_S3(AWVALID_S3),
	.VALID_S4(AWVALID_S4),
	.VALID_S5(AWVALID_S5),
);

endmodule

