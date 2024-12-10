`include "../include/AXI_define.svh"

module ReadAddr (
    input                               clk,
    input                               rst,

    // //M0
    // input [`AXI_ID_BITS-1:0]            ARID_M0,
	// input [`AXI_ADDR_BITS-1:0]          ARADDR_M0,
	// input [`AXI_LEN_BITS-1:0]           ARLEN_M0,
	// input [`AXI_SIZE_BITS-1:0]          ARSIZE_M0,
	// input [1:0]                         ARBURST_M0,
	// input                               ARVALID_M0,
	// output logic                        ARREADY_M0,
	

    //M1
    // input [`AXI_ID_BITS-1:0]            ARID_M1,
	// input [`AXI_ADDR_BITS-1:0]          ARADDR_M1,
	// input [`AXI_LEN_BITS-1:0]           ARLEN_M1,
	// input [`AXI_SIZE_BITS-1:0]          ARSIZE_M1,
	// input [1:0]                         ARBURST_M1,
	// input                               ARVALID_M1,
	// output logic                        ARREADY_M1,

	// //M2
    // input [`AXI_ID_BITS-1:0]            ARID_M2,
	// input [`AXI_ADDR_BITS-1:0]          ARADDR_M2,
	// input [`AXI_LEN_BITS-1:0]           ARLEN_M2,
	// input [`AXI_SIZE_BITS-1:0]          ARSIZE_M2,
	// input [1:0]                         ARBURST_M2,
	// input                               ARVALID_M2,
	// output logic                        ARREADY_M2,
	RA.Master M0_AR,
	RA.Master M1_AR,
	RA.Master M2_AR,

    // //S0	ROM
    // output logic [`AXI_IDS_BITS-1:0]    ARID_S0,
	// output logic [`AXI_ADDR_BITS-1:0]   ARADDR_S0,
	// output logic [`AXI_LEN_BITS-1:0]    ARLEN_S0,
	// output logic [`AXI_SIZE_BITS-1:0]   ARSIZE_S0,
	// output logic [1:0]                  ARBURST_S0,
	// output logic                        ARVALID_S0,
	// input                               ARREADY_S0,

    // //S1	IM
    // output logic [`AXI_IDS_BITS-1:0]    ARID_S1,
	// output logic [`AXI_ADDR_BITS-1:0]   ARADDR_S1,
	// output logic [`AXI_LEN_BITS-1:0]    ARLEN_S1,
	// output logic [`AXI_SIZE_BITS-1:0]   ARSIZE_S1,
	// output logic [1:0]                  ARBURST_S1,
	// output logic                        ARVALID_S1,
	// input                               ARREADY_S1,

    // //S2	DM
    // output logic [`AXI_IDS_BITS-1:0]    ARID_S2,
	// output logic [`AXI_ADDR_BITS-1:0]   ARADDR_S2,
	// output logic [`AXI_LEN_BITS-1:0]    ARLEN_S2,
	// output logic [`AXI_SIZE_BITS-1:0]   ARSIZE_S2,
	// output logic [1:0]                  ARBURST_S2,
	// output logic                        ARVALID_S2,
	// input                               ARREADY_S2,

	// //S3	DMA
    // output logic [`AXI_IDS_BITS-1:0]    ARID_S3,
	// output logic [`AXI_ADDR_BITS-1:0]   ARADDR_S3,
	// output logic [`AXI_LEN_BITS-1:0]    ARLEN_S3,
	// output logic [`AXI_SIZE_BITS-1:0]   ARSIZE_S3,
	// output logic [1:0]                  ARBURST_S3,
	// output logic                        ARVALID_S3,
	// input                               ARREADY_S3,

	// //S4	WDT
    // output logic [`AXI_IDS_BITS-1:0]    ARID_S4,
	// output logic [`AXI_ADDR_BITS-1:0]   ARADDR_S4,
	// output logic [`AXI_LEN_BITS-1:0]    ARLEN_S4,
	// output logic [`AXI_SIZE_BITS-1:0]   ARSIZE_S4,
	// output logic [1:0]                  ARBURST_S4,
	// output logic                        ARVALID_S4,
	// input                               ARREADY_S4,

	// //S5	DRAM
    // output logic [`AXI_IDS_BITS-1:0]    ARID_S5,
	// output logic [`AXI_ADDR_BITS-1:0]   ARADDR_S5,
	// output logic [`AXI_LEN_BITS-1:0]    ARLEN_S5,
	// output logic [`AXI_SIZE_BITS-1:0]   ARSIZE_S5,
	// output logic [1:0]                  ARBURST_S5,
	// output logic                        ARVALID_S5,
	// input                               ARREADY_S5
	RA.Slave S0_AR,
	RA.Slave S1_AR,
	RA.Slave S2_AR,
	RA.Slave S3_AR,
	RA.Slave S4_AR,
	RA.Slave S5_AR
);

logic [`AXI_IDS_BITS-1:0]    ARID;
logic [`AXI_ADDR_BITS-1:0]   ARADDR;
logic [`AXI_LEN_BITS-1:0]    ARLEN;
logic [`AXI_SIZE_BITS-1:0]   ARSIZE;
logic [1:0]                  ARBURST;
logic                        ARVALID;
logic                        ARREADY;

//for hw2 vip
// logic arvalid_s0t, arvalid_s1t, arvalid_s2t;
// logic busy0, busy1, busy2;
// logic readys0, readys1, readys2;

// assign busy0 = readys0 & ~ARREADY_S0;
// assign busy1 = readys1 & ~ARREADY_S1;
// assign busy2 = readys2 & ~ARREADY_S2;

// assign ARVALID_S0 = busy0 ? 1'b0 : arvalid_s0t;
// assign ARVALID_S1 = busy1 ? 1'b0 : arvalid_s1t;
// assign ARVALID_S2 = busy2 ? 1'b0 : arvalid_s2t;

// always_ff @( posedge clk or negedge rst ) begin 
// 	if(~rst)begin
// 		readys0 <= 1'b0;
// 		readys1 <= 1'b0;
// 		readys2 <= 1'b0;
// 	end
// 	else begin
// 		readys0 <= ARREADY_S0 ? 1'b1 : readys0;
// 		readys1 <= ARREADY_S1 ? 1'b1 : readys1;
// 		readys2 <= ARREADY_S2 ? 1'b1 : readys2;
// 	end
// end

assign S0_AR.ARID_S = ARID;
assign S0_AR.ARADDR = ARADDR;
assign S0_AR.ARLEN = ARLEN;
assign S0_AR.ARSIZE = ARSIZE;
assign S0_AR.ARBURST = ARBURST;

assign S1_AR.ARID_S = ARID;
assign S1_AR.ARADDR = ARADDR;
assign S1_AR.ARLEN = ARLEN;
assign S1_AR.ARSIZE = ARSIZE;
assign S1_AR.ARBURST = ARBURST;

assign S2_AR.ARID_S = ARID;
assign S2_AR.ARADDR = ARADDR;
assign S2_AR.ARLEN = ARLEN;
assign S2_AR.ARSIZE = ARSIZE;
assign S2_AR.ARBURST = ARBURST;

assign S3_AR.ARID_S = ARID;
assign S3_AR.ARADDR = ARADDR;
assign S3_AR.ARLEN = ARLEN;
assign S3_AR.ARSIZE = ARSIZE;
assign S3_AR.ARBURST = ARBURST;

assign S4_AR.ARID_S = ARID;
assign S4_AR.ARADDR = ARADDR;
assign S4_AR.ARLEN = ARLEN;
assign S4_AR.ARSIZE = ARSIZE;
assign S4_AR.ARBURST = ARBURST;

assign S5_AR.ARID_S = ARID;
assign S5_AR.ARADDR = ARADDR;
assign S5_AR.ARLEN = ARLEN;
assign S5_AR.ARSIZE = ARSIZE;
assign S5_AR.ARBURST = ARBURST;

// assign ARID_S1 = ARID;
// assign ARADDR_S1 = ARADDR;
// assign ARLEN_S1 = ARLEN;
// assign ARSIZE_S1 = ARSIZE;
// assign ARBURST_S1 = ARBURST;

// assign ARID_S2 = ARID;
// assign ARADDR_S2 = ARADDR;
// assign ARLEN_S2 = ARLEN;
// assign ARSIZE_S2 = ARSIZE;
// assign ARBURST_S2 = ARBURST;

// assign ARID_S3 = ARID;
// assign ARADDR_S3 = ARADDR;
// assign ARLEN_S3 = ARLEN;
// assign ARSIZE_S3 = ARSIZE;
// assign ARBURST_S3 = ARBURST;

// assign ARID_S4 = ARID;
// assign ARADDR_S4 = ARADDR;
// assign ARLEN_S4 = ARLEN;
// assign ARSIZE_S4 = ARSIZE;
// assign ARBURST_S4 = ARBURST;

// assign ARID_S5 = ARID;
// assign ARADDR_S5 = ARADDR;
// assign ARLEN_S5 = ARLEN;
// assign ARSIZE_S5 = ARSIZE;
// assign ARBURST_S5 = ARBURST;

// logic [5:0] slave;

Arbiter RAarbiter(
    .clk(clk),
    .rst(rst),

    //M0 
    .ID_M0(M0_AR.ARID),
	.ADDR_M0(M0_AR.ARADDR),
	.LEN_M0(M0_AR.ARLEN),
	.SIZE_M0(M0_AR.ARSIZE),
	.BURST_M0(M0_AR.ARBURST),
	.VALID_M0(M0_AR.ARVALID),

    .READY_M0(M0_AR.ARREADY),

    //M1
    .ID_M1(M1_AR.ARID),
	.ADDR_M1(M1_AR.ARADDR),
	.LEN_M1(M1_AR.ARLEN),
	.SIZE_M1(M1_AR.ARSIZE),
	.BURST_M1(M1_AR.ARBURST),
	.VALID_M1(M1_AR.ARVALID),

    .READY_M1(M1_AR.ARREADY),
	// .ID_M1(ARID_M1),
	// .ADDR_M1(ARADDR_M1),
	// .LEN_M1 (ARLEN_M1),
	// .SIZE_M1(ARSIZE_M1),
	// .BURST_M1(ARBURST_M1),
	// .VALID_M1(ARVALID_M1),

	// .READY_M1(ARREADY_M1),

	//M2
	.ID_M2(M2_AR.ARID),
	.ADDR_M2(M2_AR.ARADDR),
	.LEN_M2(M2_AR.ARLEN),
	.SIZE_M2(M2_AR.ARSIZE),
	.BURST_M2(M2_AR.ARBURST),
	.VALID_M2(M2_AR.ARVALID),

    .READY_M2(M2_AR.ARREADY),
    // .ID_M2(ARID_M2),
	// .ADDR_M2(ARADDR_M2),
	// .LEN_M2 (ARLEN_M2),
	// .SIZE_M2(ARSIZE_M2),
	// .BURST_M2(ARBURST_M2),
	// .VALID_M2(ARVALID_M2),

	// .READY_M2(ARREADY_M2),

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
    .READY_S0(S0_AR.ARREADY),
    .READY_S1(S1_AR.ARREADY),
    .READY_S2(S2_AR.ARREADY),
	.READY_S3(S3_AR.ARREADY),
	.READY_S4(S4_AR.ARREADY),
	.READY_S5(S5_AR.ARREADY),
	//for hw2 vip
    // .VALID_S0(arvalid_s0t),
    // .VALID_S1(arvalid_s1t),
    // .VALID_S2(arvalid_s2t)
	.VALID_S0(S0_AR.ARVALID),
    .VALID_S1(S1_AR.ARVALID),
	.VALID_S2(S2_AR.ARVALID),
	.VALID_S3(S3_AR.ARVALID),
	.VALID_S4(S4_AR.ARVALID),
    .VALID_S5(S5_AR.ARVALID)
	// .SLAVE(slave)
);

// always_comb begin 
// 	case (slave)
// 		6'b000001 : begin
// 			ARID_S0 = ARID;
// 			ARADDR_S0 = ARADDR;
// 			ARLEN_S0 = ARLEN;
// 			ARSIZE_S0 = ARSIZE;
// 			ARBURST_S0 = ARBURST;
// 		end
// 		6'b000010 : begin
// 			ARID_S1 = ARID;
// 			ARADDR_S1 = ARADDR;
// 			ARLEN_S1 = ARLEN;
// 			ARSIZE_S1 = ARSIZE;
// 			ARBURST_S1 = ARBURST;
// 		end
// 		6'b000100 : begin
// 			ARID_S2 = ARID;
// 			ARADDR_S2 = ARADDR;
// 			ARLEN_S2 = ARLEN;
// 			ARSIZE_S2 = ARSIZE;
// 			ARBURST_S2 = ARBURST;
// 		end
// 		6'b001000 : begin
// 			ARID_S3 = ARID;
// 			ARADDR_S3 = ARADDR;
// 			ARLEN_S3 = ARLEN;
// 			ARSIZE_S3 = ARSIZE;
// 			ARBURST_S3 = ARBURST;
// 		end
// 		6'b010000 : begin
// 			ARID_S4 = ARID;
// 			ARADDR_S4 = ARADDR;
// 			ARLEN_S4 = ARLEN;
// 			ARSIZE_S4 = ARSIZE;
// 			ARBURST_S4 = ARBURST;
// 		end
// 		6'b100000 : begin
// 			ARID_S5 = ARID;
// 			ARADDR_S5 = ARADDR;
// 			ARLEN_S5 = ARLEN;
// 			ARSIZE_S5 = ARSIZE;
// 			ARBURST_S5 = ARBURST;
// 		end
// 	endcase
// end

endmodule

