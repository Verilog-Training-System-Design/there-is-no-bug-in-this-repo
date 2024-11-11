`include "../include/AXI_define.svh"

module ReadAddr (
    input                               clk,
    input                               rst,

    //M0
    input [`AXI_ID_BITS-1:0]            ARID_M0,
	input [`AXI_ADDR_BITS-1:0]          ARADDR_M0,
	input [`AXI_LEN_BITS-1:0]           ARLEN_M0,
	input [`AXI_SIZE_BITS-1:0]          ARSIZE_M0,
	input [1:0]                         ARBURST_M0,
	input                               ARVALID_M0,
	output logic                        ARREADY_M0,

    //M1
    input [`AXI_ID_BITS-1:0]            ARID_M1,
	input [`AXI_ADDR_BITS-1:0]          ARADDR_M1,
	input [`AXI_LEN_BITS-1:0]           ARLEN_M1,
	input [`AXI_SIZE_BITS-1:0]          ARSIZE_M1,
	input [1:0]                         ARBURST_M1,
	input                               ARVALID_M1,
	output logic                        ARREADY_M1,

    //S0
    output logic [`AXI_IDS_BITS-1:0]    ARID_S0,
	output logic [`AXI_ADDR_BITS-1:0]   ARADDR_S0,
	output logic [`AXI_LEN_BITS-1:0]    ARLEN_S0,
	output logic [`AXI_SIZE_BITS-1:0]   ARSIZE_S0,
	output logic [1:0]                  ARBURST_S0,
	output logic                        ARVALID_S0,
	input                               ARREADY_S0,

    //S1
    output logic [`AXI_IDS_BITS-1:0]    ARID_S1,
	output logic [`AXI_ADDR_BITS-1:0]   ARADDR_S1,
	output logic [`AXI_LEN_BITS-1:0]    ARLEN_S1,
	output logic [`AXI_SIZE_BITS-1:0]   ARSIZE_S1,
	output logic [1:0]                  ARBURST_S1,
	output logic                        ARVALID_S1,
	input                               ARREADY_S1,

    //S2
    output logic [`AXI_IDS_BITS-1:0]    ARID_S2,
	output logic [`AXI_ADDR_BITS-1:0]   ARADDR_S2,
	output logic [`AXI_LEN_BITS-1:0]    ARLEN_S2,
	output logic [`AXI_SIZE_BITS-1:0]   ARSIZE_S2,
	output logic [1:0]                  ARBURST_S2,
	output logic                        ARVALID_S2,
	input                               ARREADY_S2
);

logic [`AXI_IDS_BITS-1:0]    ARID;
logic [`AXI_ADDR_BITS-1:0]   ARADDR;
logic [`AXI_LEN_BITS-1:0]    ARLEN;
logic [`AXI_SIZE_BITS-1:0]   ARSIZE;
logic [1:0]                  ARBURST;
logic                        ARVALID;
logic                        ARREADY;

logic arvalid_s0t, arvalid_s1t, arvalid_s2t;
logic busy0, busy1, busy2;
logic readys0, readys1, readys2;

assign busy0 = readys0 & ~ARREADY_S0;
assign busy1 = readys1 & ~ARREADY_S1;
assign busy2 = readys2 & ~ARREADY_S2;

assign ARVALID_S0 = busy0 ? 1'b0 : arvalid_s0t;
assign ARVALID_S1 = busy1 ? 1'b0 : arvalid_s1t;
assign ARVALID_S2 = busy2 ? 1'b0 : arvalid_s2t;

always_ff @( posedge clk or negedge rst ) begin 
	if(~rst)begin
		readys0 <= 1'b0;
		readys1 <= 1'b0;
		readys2 <= 1'b0;
	end
	else begin
		readys0 <= ARREADY_S0 ? 1'b1 : readys0;
		readys1 <= ARREADY_S1 ? 1'b1 : readys1;
		readys2 <= ARREADY_S2 ? 1'b1 : readys2;
	end
end

assign ARID_S0 = ARID;
assign ARADDR_S0 = ARADDR;
assign ARLEN_S0 = ARLEN;
assign ARSIZE_S0 = ARSIZE;
assign ARBURST_S0 = ARBURST;

assign ARID_S1 = ARID;
assign ARADDR_S1 = ARADDR;
assign ARLEN_S1 = ARLEN;
assign ARSIZE_S1 = ARSIZE;
assign ARBURST_S1 = ARBURST;

assign ARID_S2 = ARID;
assign ARADDR_S2 = ARADDR;
assign ARLEN_S2 = ARLEN;
assign ARSIZE_S2 = ARSIZE;
assign ARBURST_S2 = ARBURST;

Arbiter RAarbiter(
    .clk(clk),
    .rst(rst),

    //M0 
    .ID_M0(ARID_M0),
	.ADDR_M0(ARADDR_M0),
	.LEN_M0(ARLEN_M0),
	.SIZE_M0(ARSIZE_M0),
	.BURST_M0(ARBURST_M0),
	.VALID_M0(ARVALID_M0),

    .READY_M0(ARREADY_M0),

    //M1
    .ID_M1(ARID_M1),
	.ADDR_M1(ARADDR_M1),
	.LEN_M1 (ARLEN_M1),
	.SIZE_M1(ARSIZE_M1),
	.BURST_M1(ARBURST_M1),
	.VALID_M1(ARVALID_M1),

	.READY_M1(ARREADY_M1),

    //S
    .ID_S(ARID),
	.ADDR_S(ARADDR),
	.LEN_S(ARLEN),
	.SIZE_S(ARSIZE),
	.BURST_S(ARBURST),
	.VALID_S(ARVALID),

	.READY_S(ARREADY)
);

Decoder RADecoder(
    .ADDR(ARADDR),
    .VALID(ARVALID),
    .READY(ARREADY),
    .READY_S0(ARREADY_S0),
    .READY_S1(ARREADY_S1),
    .READY_S2(ARREADY_S2),
    .VALID_S0(arvalid_s0t),          //differ
    .VALID_S1(arvalid_s1t),
    .VALID_S2(arvalid_s2t)
);

endmodule

