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
	
    //S0
	output logic [`AXI_IDS_BITS-1:0] AWID_S0,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S0,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S0,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S0,
	output logic [1:0] AWBURST_S0,
	output logic AWVALID_S0,
	input AWREADY_S0,

    //S1
	output logic [`AXI_IDS_BITS-1:0] AWID_S1,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S1,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S1,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S1,
	output logic [1:0] AWBURST_S1,
	output logic AWVALID_S1,
	input AWREADY_S1,

    //S2
	output logic [`AXI_IDS_BITS-1:0] AWID_S2,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S2,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S2,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S2,
	output logic [1:0] AWBURST_S2,
	output logic AWVALID_S2,
	input AWREADY_S2
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
    .VALID_S0(AWVALID_S0),           //axi ready to transfer address to slave
    .VALID_S1(AWVALID_S1),
    .VALID_S2(AWVALID_S2)
);

endmodule

