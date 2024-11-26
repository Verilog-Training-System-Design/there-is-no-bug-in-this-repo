`include "../include/AXI_define.svh"

module WriteData (
	input clk,
	input rst,
    //M1
    input [`AXI_DATA_BITS-1:0] WDATA_M1,
	input [`AXI_STRB_BITS-1:0] WSTRB_M1,
	input WLAST_M1,
	input WVALID_M1,
	output logic WREADY_M1,

	input [`AXI_DATA_BITS-1:0] WDATA_M2,
	input [`AXI_STRB_BITS-1:0] WSTRB_M2,
	input WLAST_M2,
	input WVALID_M2,
	output logic WREADY_M2,

    // S0	ROM
	input [`AXI_IDS_BITS-1:0] AWID_S0,
	input AWVALID_S0,
    output logic [`AXI_DATA_BITS-1:0] WDATA_S0,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S0,
	output logic WLAST_S0,
	output logic WVALID_S0,
	input WREADY_S0,

    //S1	IM
	input [`AXI_IDS_BITS-1:0] AWID_S1,
	input AWVALID_S1,
    output logic [`AXI_DATA_BITS-1:0] WDATA_S1,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S1,
	output logic WLAST_S1,
	output logic WVALID_S1,
	input WREADY_S1,

    //S2	DM
	input [`AXI_IDS_BITS-1:0] AWID_S2,
	input AWVALID_S2,
    output logic [`AXI_DATA_BITS-1:0] WDATA_S2,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S2,
	output logic WLAST_S2,
	output logic WVALID_S2,
	input WREADY_S2,

	//S3	DMA
	input [`AXI_IDS_BITS-1:0] AWID_S3,
	input AWVALID_S3,
    output logic [`AXI_DATA_BITS-1:0] WDATA_S3,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S3,
	output logic WLAST_S3,
	output logic WVALID_S3,
	input WREADY_S3,

	//S4	WDT
	input [`AXI_IDS_BITS-1:0] AWID_S4,
	input AWVALID_S4,
    output logic [`AXI_DATA_BITS-1:0] WDATA_S4,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S4,
	output logic WLAST_S4,
	output logic WVALID_S4,
	input WREADY_S4,

	//S5	DRAM
	input [`AXI_IDS_BITS-1:0] AWID_S5,
	input AWVALID_S5,
    output logic [`AXI_DATA_BITS-1:0] WDATA_S5,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S5,
	output logic WLAST_S5,
	output logic WVALID_S5,
	input WREADY_S5
);

logic WVALID_S0_reg;
logic WVALID_S1_reg;
logic WVALID_S2_reg;
logic WVALID_S3_reg;
logic WVALID_S4_reg;
logic WVALID_S5_reg;
logic [5:0] slave;
logic [3:0] master;
logic [`AXI_IDS_BITS-1:0] ID_reg;

logic [`AXI_DATA_BITS-1:0] WDATA;
logic [`AXI_STRB_BITS-1:0] WSTRB;
logic WLAST;
logic WREADY;
logic WVALID;

assign WDATA_S0 = 32'd0;
assign WSTRB_S0 = `AXI_STRB_BITS'hf;
assign WLAST_S0 = 1'd0;

assign WDATA_S1 = WDATA;
assign WSTRB_S1 = (WVALID_S1) ? WSTRB : `AXI_STRB_BITS'hf;
assign WLAST_S1 = WLAST;

assign WDATA_S2 = WDATA;
assign WSTRB_S2 = (WVALID_S2) ? WSTRB : `AXI_STRB_BITS'hf;
assign WLAST_S2 = WLAST;

assign WDATA_S3 = WDATA;
assign WSTRB_S3 = (WVALID_S3) ? WSTRB : `AXI_STRB_BITS'hf;
assign WLAST_S3 = WLAST;

assign WDATA_S4 = WDATA;
assign WSTRB_S4 = (WVALID_S4) ? WSTRB : `AXI_STRB_BITS'hf;
assign WLAST_S4 = WLAST;

assign WDATA_S5 = WDATA;
assign WSTRB_S5 = (WVALID_S5) ? WSTRB : `AXI_STRB_BITS'hf;
assign WLAST_S5 = WLAST;

assign slave = {(WVALID_S5_reg | AWVALID_S5), (WVALID_S4_reg | AWVALID_S4), (WVALID_S3_reg | AWVALID_S3), (WVALID_S2_reg | AWVALID_S2), (WVALID_S1_reg | AWVALID_S1), (WVALID_S0_reg | AWVALID_S0)};

always_ff @( posedge clk or negedge rst ) begin
	if(~rst)begin
		WVALID_S0_reg <= 1'b0;
		WVALID_S1_reg <= 1'b0;
		WVALID_S2_reg <= 1'b0;
		WVALID_S3_reg <= 1'b0;
		WVALID_S4_reg <= 1'b0;
		WVALID_S5_reg <= 1'b0;
		ID_reg <= `AXI_IDS_BITS'b0;
	end
	else begin
		// if(AWVALID_S0 & ~WREADY)		//since master.sv design after writeaddress is writedata
		// 	WVALID_S0_reg <= AWVALID_S0;
		// else if(WVALID & WREADY & WLAST)
		// 	WVALID_S0_reg <= 1'b0;
		// else 
		// 	WVALID_S0_reg <= WVALID_S0_reg;
		
		if(AWVALID_S1 & ~WREADY)begin
			WVALID_S1_reg <= AWVALID_S1;
			ID_reg <= AWID_S1;
		end
		else if(WVALID & WREADY & WLAST)
			WVALID_S1_reg <= 1'b0;
		else 
			WVALID_S1_reg <= WVALID_S1_reg;

		if(AWVALID_S2 & ~WREADY)begin
			WVALID_S2_reg <= AWVALID_S2;
			ID_reg <= AWID_S2;
		end
		else if(WVALID & WREADY & WLAST)
			WVALID_S2_reg <= 1'b0;
		else 
			WVALID_S2_reg <= WVALID_S2_reg;

		if(AWVALID_S3 & ~WREADY)begin
			WVALID_S3_reg <= AWVALID_S3;
			ID_reg <= AWID_S3;
		end
		else if(WVALID & WREADY & WLAST)
			WVALID_S3_reg <= 1'b0;
		else 
			WVALID_S3_reg <= WVALID_S3_reg;

		if(AWVALID_S4 & ~WREADY)begin
			WVALID_S4_reg <= AWVALID_S4;
			ID_reg <= AWID_S4;
		end
		else if(WVALID & WREADY & WLAST)
			WVALID_S4_reg <= 1'b0;
		else 
			WVALID_S4_reg <= WVALID_S4_reg;

		if(AWVALID_S5 & ~WREADY)begin
			WVALID_S5_reg <= AWVALID_S5;
			ID_reg <= AWID_S5;
		end
		else if(WVALID & WREADY & WLAST)
			WVALID_S5_reg <= 1'b0;
		else 
			WVALID_S5_reg <= WVALID_S5_reg;
	end
end

always_comb begin
	case (slave)
		6'b000001 : begin
			master = {ID_reg[`AXI_IDS_BITS-1:`AXI_ID_BITS]};
			WVALID_S0 = WVALID;
			WVALID_S1 = 1'b0;
			WVALID_S2 = 1'b0;
			WVALID_S3 = 1'b0;
			WVALID_S4 = 1'b0;
			WVALID_S5 = 1'b0;
			WREADY = WREADY_S0;
		end
		6'b000010 : begin
			master = {ID_reg[`AXI_IDS_BITS-1:`AXI_ID_BITS]};
			WVALID_S0 = 1'b0;
			WVALID_S1 = WVALID;
			WVALID_S2 = 1'b0;
			WVALID_S3 = 1'b0;
			WVALID_S4 = 1'b0;
			WVALID_S5 = 1'b0;
			WREADY = WREADY_S1;
		end
		6'b000100 : begin
			master = {ID_reg[`AXI_IDS_BITS-1:`AXI_ID_BITS]};
			WVALID_S0 = 1'b0;
			WVALID_S1 = 1'b0;
			WVALID_S2 = WVALID;
			WVALID_S3 = 1'b0;
			WVALID_S4 = 1'b0;
			WVALID_S5 = 1'b0;
			WREADY = WREADY_S2;
		end 
		6'b001000 : begin
			master = {ID_reg[`AXI_IDS_BITS-1:`AXI_ID_BITS]};
			WVALID_S0 = 1'b0;
			WVALID_S1 = 1'b0;
			WVALID_S2 = 1'b0;
			WVALID_S3 = WVALID;
			WVALID_S4 = 1'b0;
			WVALID_S5 = 1'b0;
			WREADY = WREADY_S3;
		end
		6'b010000 : begin
			master = {ID_reg[`AXI_IDS_BITS-1:`AXI_ID_BITS]};
			WVALID_S0 = 1'b0;
			WVALID_S1 = 1'b0;
			WVALID_S2 = 1'b0;
			WVALID_S3 = 1'b0;
			WVALID_S4 = WVALID;
			WVALID_S5 = 1'b0;
			WREADY = WREADY_S4;
		end
		6'b100000 : begin
			master = {ID_reg[`AXI_IDS_BITS-1:`AXI_ID_BITS]};
			WVALID_S0 = 1'b0;
			WVALID_S1 = 1'b0;
			WVALID_S2 = 1'b0;
			WVALID_S3 = 1'b0;
			WVALID_S4 = 1'b0;
			WVALID_S5 = WVALID;
			WREADY = WREADY_S5;
		end
		default : begin
			master = 4'd0;
			WVALID_S0 = 1'b0;
			WVALID_S1 = 1'b0;
			WVALID_S2 = 1'b0;
			WVALID_S3 = 1'b0;
			WVALID_S4 = 1'b0;
			WVALID_S5 = 1'b0;
			WREADY = 1'b1;
		end
	endcase
end

always_comb begin 
	case(master)
		4'b0010 : begin
			WDATA = WDATA_M1;
			WSTRB = WSTRB_M1;
			WLAST = WLAST_M1;
			WVALID = WVALID_M1;
			WREADY_M1 = WREADY & WVALID_M1;
			WREADY_M2 = 1'd0;
		end
		4'b0100 : begin
			WDATA = WDATA_M2;
			WSTRB = WSTRB_M2;
			WLAST = WLAST_M2;
			WVALID = WVALID_M2;
			WREADY_M1 = 1'd0;
			WREADY_M2 = WREADY & WVALID_M2;
		end
		default : begin
			WDATA = 32'd0;;
			WSTRB = 4'hf;
			WLAST = 1'd0;;
			WVALID = 1'd0;
			WREADY_M1 = 1'd0;
			WREADY_M2 = 1'd0;
		end
	endcase
end

endmodule