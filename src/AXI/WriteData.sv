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

    //S0
	input AWVALID_S0,
    output logic [`AXI_DATA_BITS-1:0] WDATA_S0,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S0,
	output logic WLAST_S0,
	output logic WVALID_S0,
	input WREADY_S0,

    //S1
	input AWVALID_S1,
    output logic [`AXI_DATA_BITS-1:0] WDATA_S1,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S1,
	output logic WLAST_S1,
	output logic WVALID_S1,
	input WREADY_S1,

    //S2
	input AWVALID_S2,
    output logic [`AXI_DATA_BITS-1:0] WDATA_S2,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S2,
	output logic WLAST_S2,
	output logic WVALID_S2,
	input WREADY_S2
);

logic WVALID_S0_reg;
logic WVALID_S1_reg;
logic WVALID_S2_reg;
logic [2:0] slave;

logic [`AXI_DATA_BITS-1:0] WDATA;
logic [`AXI_STRB_BITS-1:0] WSTRB;
logic WLAST;
logic WREADY;
logic WVALID;

assign WDATA = WDATA_M1;
assign WSTRB = WSTRB_M1;
assign WLAST = WLAST_M1;
assign WVALID = WVALID_M1;
assign WREADY_M1 = WREADY & WVALID_M1;

// assign WDATA_S0 = WDATA_M1;
// assign WSTRB_S0 = (WVALID_S0) ? WSTRB_M1 : `AXI_STRB_BITS'hf;
// assign WLAST_S0 = WLAST_M1;

// assign WDATA_S1 = WDATA_M1;
// assign WSTRB_S1 = (WVALID_S1) ? WSTRB_M1 : `AXI_STRB_BITS'hf;
// assign WLAST_S1 = WLAST_M1;

// assign WDATA_S2 = WDATA_M1;
// assign WSTRB_S2 = (WVALID_S2) ? WSTRB_M1 : `AXI_STRB_BITS'hf;
// assign WLAST_S2 = WLAST_M1;

assign WDATA_S0 = WDATA;
assign WSTRB_S0 = (WVALID_S0) ? WSTRB : `AXI_STRB_BITS'hf;
assign WLAST_S0 = WLAST;

assign WDATA_S1 = WDATA;
assign WSTRB_S1 = (WVALID_S1) ? WSTRB : `AXI_STRB_BITS'hf;
assign WLAST_S1 = WLAST;

assign WDATA_S2 = WDATA;
assign WSTRB_S2 = WSTRB;
assign WLAST_S2 = WLAST;

assign slave = {(WVALID_S2_reg | AWVALID_S2), (WVALID_S1_reg | AWVALID_S1), (WVALID_S0_reg | AWVALID_S0)};

always_ff @( posedge clk or negedge rst ) begin
	if(~rst)begin
		WVALID_S0_reg <= 1'b0;
		WVALID_S1_reg <= 1'b0;
		WVALID_S2_reg <= 1'b0;
	end
	else begin
		if(AWVALID_S0 & ~WREADY)		//since master.sv design after writeaddress is writedata
			WVALID_S0_reg <= AWVALID_S0;
		else if(WVALID & WREADY & WLAST)
			WVALID_S0_reg <= 1'b0;
		else 
			WVALID_S0_reg <= WVALID_S0_reg;
		
		if(AWVALID_S1 & ~WREADY)
			WVALID_S1_reg <= AWVALID_S1;
		else if(WVALID & WREADY & WLAST)
			WVALID_S1_reg <= 1'b0;
		else 
			WVALID_S1_reg <= WVALID_S1_reg;

		if(AWVALID_S2 & ~WREADY)
			WVALID_S2_reg <= AWVALID_S2;
		else if(WVALID & WREADY & WLAST)
			WVALID_S2_reg <= 1'b0;
		else 
			WVALID_S2_reg <= WVALID_S2_reg;
	end
end

always_comb begin
	case (slave)
		3'b001 : begin
			WVALID_S0 = WVALID;
			WVALID_S1 = 1'b0;
			WVALID_S2 = 1'b0;
			WREADY = WREADY_S0;
		end
		3'b010 : begin
			WVALID_S0 = 1'b0;
			WVALID_S1 = WVALID;
			WVALID_S2 = 1'b0;
			WREADY = WREADY_S1;
		end
		3'b100 : begin
			WVALID_S0 = 1'b0;
			WVALID_S1 = 1'b0;
			WVALID_S2 = WVALID;
			WREADY = WREADY_S2;
		end 
		default : begin
			WVALID_S0 = 1'b0;
			WVALID_S1 = 1'b0;
			WVALID_S2 = 1'b0;
			WREADY = 1'b1;
		end
	endcase
end

endmodule