`include "../include/AXI_define.svh"
module SRAM_wrapper (
	input 								ACLK,
	input 								ARESETn,

	// //READ ADDRESS1
	// input [`AXI_IDS_BITS-1:0] 			ARID_S,
	// input [`AXI_ADDR_BITS-1:0] 			ARADDR_S,
	// input [`AXI_LEN_BITS-1:0] 			ARLEN_S,
	// input [`AXI_SIZE_BITS-1:0] 			ARSIZE_S,
	// input [1:0] 						ARBURST_S,
	// input 								ARVALID_S,
	// output logic 						ARREADY_S,
    RA.Slave S_AR,
	
	// //READ DATA1
	// output logic [`AXI_IDS_BITS-1:0] 	RID_S,
	// output logic [`AXI_DATA_BITS-1:0] 	RDATA_S,
	// output logic [1:0] 					RRESP_S,
	// output logic 						RLAST_S,
	// output logic 						RVALID_S,
	// input 								RREADY_S,
    R.Slave S_R,

	// //WRITE ADDRESS
	// input [`AXI_IDS_BITS-1:0] 			AWID_S,
	// input [`AXI_ADDR_BITS-1:0] 			AWADDR_S,
	// input [`AXI_LEN_BITS-1:0] 			AWLEN_S,
	// input [`AXI_SIZE_BITS-1:0] 			AWSIZE_S,
	// input [1:0] 						AWBURST_S,
	// input 								AWVALID_S,
	// output logic 						AWREADY_S,
    WA.Slave S_AW,
	
	// //WRITE DATA
	// input [`AXI_DATA_BITS-1:0] 			WDATA_S,
	// input [`AXI_STRB_BITS-1:0] 			WSTRB_S,
	// input 								WLAST_S,
	// input 								WVALID_S,
	// output logic 						WREADY_S,
    W.Slave S_W,

	// //WRITE RESPONSE
	// output logic [`AXI_IDS_BITS-1:0] 	BID_S,
	// output logic [1:0] 					BRESP_S,
	// output logic 						BVALID_S,
	// input 								BREADY_S
    B.Slave S_B
);
// logic late_rst;

// always_ff @( posedge ACLK or negedge ARESETn ) begin 
//     if(~ARESETn)
//         late_rst <= ARESETn;
//     else 
//         late_rst <= ARESETn;
// end

logic CEB;
logic WEB;
logic [31:0] BWEB;
logic [13:0] A, address, address_4;
logic [`AXI_DATA_BITS-1:0] DI;
logic [`AXI_DATA_BITS-1:0] DO, DO_temp, RDATA_reg;

assign CEB = 1'b0;
assign DI = S_W.WDATA;

logic [1:0] stage, next_stage;
localparam  idle = 2'b0,
            read_data = 2'b01,
            write_data = 2'b10,
            write_response = 2'b11;
// logic [2:0] stage, next_stage;
// localparam  idle = 3'b0000,
//             read_address = 3'b001,
//             read_data = 3'b010,
//             write_address = 3'b011,
//             write_data = 3'b100,
//             write_response = 3'b101;


logic [`AXI_IDS_BITS-1:0] ARID_reg;
logic [`AXI_IDS_BITS-1:0] AWID_reg;
logic [`AXI_LEN_BITS-1:0] arlen, awlen;
logic [`AXI_LEN_BITS-1:0] counter;
// logic RVALID_reg;
// logic ceb;

assign S_R.RID_S = (S_AR.ARVALID & S_AR.ARREADY) ? S_AR.ARID_S : ARID_reg;
// assign RDATA_S = (RVALID_S & RVALID_reg) ? RDATA_reg : DO;
assign S_R.RDATA = (S_R.RVALID & S_R.RREADY) ? DO : RDATA_reg;
// assign RDATA_S = DO;
assign S_R.RRESP = `AXI_RESP_OKAY;
assign S_R.RLAST = ((stage == read_data) && (counter == arlen)); 
assign S_B.BID_S = (S_AW.AWVALID & S_AW.AWREADY) ? S_AW.AWID_S : AWID_reg;
assign S_B.BRESP = `AXI_RESP_OKAY;

always_ff @( posedge ACLK or negedge ARESETn ) begin
    if(~ARESETn)
        RDATA_reg <= `AXI_DATA_BITS'b0;
    else 
        RDATA_reg <= (S_R.RVALID & S_R.RREADY) ? DO : RDATA_reg;
end

// always_ff @( posedge ACLK or negedge ARESETn ) begin 
//     if(~ARESETn)
//         RVALID_reg <= 1'b0;
//     else
//         RVALID_reg <= RVALID_S;
// end

always_ff @( posedge ACLK or negedge ARESETn ) begin 
    if(~ARESETn)begin
        arlen <= `AXI_LEN_BITS'b0;
        awlen <= `AXI_LEN_BITS'b0;
    end
    else begin
        if(S_AR.ARVALID & S_AR.ARREADY)
            arlen <= S_AR.ARLEN;
        else 
            arlen <= arlen;
        
        if(S_AW.AWVALID & S_AW.AWREADY)
            awlen <= S_AW.AWLEN;
        else
            awlen <= awlen;
    end
end

always_ff @( posedge ACLK or negedge ARESETn ) begin
    if(~ARESETn)begin
        address <= 14'b0;
        address_4 <= 14'b0;
        counter <= `AXI_LEN_BITS'b0;
    end 
    else if(stage == idle)begin
        if(S_AR.ARVALID & S_AR.ARREADY)begin
            address <= S_AR.ARADDR[15:2];
            address_4 <= S_AR.ARADDR[15:2] + 14'b1;
        end
        else if(S_AW.AWADDR & S_AW.AWADDR)begin
            address <= S_AW.AWADDR[15:2];
        end
    end
    else if(stage == read_data)begin
        if(S_R.RVALID & S_R.RREADY) begin           //in read data state and not read the end, increase address to get next data
            address <= address + 14'b1;
            address_4 <= address_4 + 14'b1;
            if(counter == arlen)begin
                counter <= `AXI_LEN_BITS'b0;
            end
            else begin
                counter <= counter + `AXI_LEN_BITS'b1;
            end
        end
    end
    else if(stage == write_data)begin
        if(S_W.WVALID & S_W.WREADY)begin
            address <= address + 14'b1;
        end
    end
end

// store read address and write address's id and len
always_ff @( posedge ACLK or negedge ARESETn ) begin
    if(~ARESETn)begin
        ARID_reg <= `AXI_IDS_BITS'b0;
        AWID_reg <= `AXI_IDS_BITS'b0;
    end 
    else begin
        if(S_AR.ARVALID & S_AR.ARREADY)begin
            ARID_reg <= S_AR.ARID_S;
        end  
        else begin
            ARID_reg <= ARID_reg;
        end
        if (S_AW.AWVALID & S_AW.AWREADY) begin
            AWID_reg <= S_AW.AWID_S;
        end
        else begin
            AWID_reg <= AWID_reg;
        end
    end
end

//FSM for slave to switch channel

always_ff @( posedge ACLK or negedge ARESETn) begin 
    if(~ARESETn)
        stage <= idle;
    else 
        stage <= next_stage;
end

always_comb begin
    case (stage)
        idle : begin
            if(S_AW.AWVALID & S_AW.AWREADY)
                next_stage = write_data;
            else if(S_AR.ARVALID & S_AR.ARREADY)
                next_stage = read_data;
            else
                next_stage = idle;
        end
        read_data : begin
            if(S_R.RVALID & S_R.RREADY & S_R.RLAST)
                next_stage = idle;
            else 
                next_stage = read_data;
        end
        write_data : begin
            if(S_W.WVALID & S_W.WREADY & S_W.WLAST)
                next_stage = write_response;
            else 
                next_stage = write_data;
        end
        write_response : begin
            if(S_B.BVALID & S_B.BREADY)
                next_stage = idle;
            else 
                next_stage = write_response;
        end
    endcase    
end

always_comb begin
    case (stage)
        idle : begin
            S_AR.ARREADY = ~S_AW.AWVALID;         //I change here then prog1 become right
            S_R.RVALID = 1'b0;
            S_AW.AWREADY = 1'b1;
            S_W.WREADY = 1'b0;
            S_B.BVALID = 1'b0;
            A = (S_AW.AWVALID & S_AW.AWREADY) ? S_AW.AWADDR[15:2] : (S_AR.ARVALID & S_AR.ARREADY) ? S_AR.ARADDR[15:2] : 14'd0;
            // A = (AWVALID_S) ? AWADDR_S[15:2] : ARADDR_S[15:2];
            // RDATA_S = RDATA_S;
        end
        read_data : begin
            S_AR.ARREADY = 1'b0;
            S_R.RVALID = 1'b1;
            S_AW.AWREADY = 1'b0;
            S_W.WREADY = 1'b0;
            S_B.BVALID = 1'b0;
            // A = address;
            A = (S_R.RVALID & S_R.RREADY & S_R.RLAST) ? address : (S_R.RVALID & S_R.RREADY) ? address_4 : address;
            // RDATA_S = DO;
        end
        write_data : begin
            S_AR.ARREADY = 1'b0;
            S_R.RVALID = 1'b0;
            S_AW.AWREADY = 1'b0;
            S_W.WREADY = 1'b1;
            S_B.BVALID = 1'b0;
            // A = address;
            A = address;
            // RDATA_S = RDATA_S;
        end
        write_response : begin
            S_AR.ARREADY = 1'b0;
            S_R.RVALID = 1'b0;
            S_AW.AWREADY = 1'b0;
            S_W.WREADY = 1'b0;
            S_B.BVALID = 1'b1;
            A = 14'b0;
            // RDATA_S = RDATA_S;
        end
    endcase
end

//write data
always_comb begin
    WEB = 1'b0;
    case (S_W.WSTRB)
        `AXI_STRB_BITS'b1110 :          //1110
            BWEB = 32'hffffff00;
        `AXI_STRB_BITS'b1101 :         //1101
            BWEB = 32'hffff00ff;
        `AXI_STRB_BITS'b1011 :          //1011
            BWEB = 32'hff00ffff;
        `AXI_STRB_BITS'b0111 :
            BWEB = 32'h00ffffff;
        `AXI_STRB_BITS'b0011 :
            BWEB = 32'h0000ffff;
        `AXI_STRB_BITS'b1100 :
            BWEB = 32'hffff0000;
        `AXI_STRB_BITS'b0000 :
            BWEB = 32'h00000000;
        default : begin
            WEB = 1'b1;
            BWEB = 32'hffffffff;
        end
    endcase
end

  TS1N16ADFPCLLLVTA512X45M4SWSHOD i_SRAM (
    .SLP(1'b0),
    .DSLP(1'b0),
    .SD(1'b0),
    .PUDELAY(),
    .CLK(ACLK),
	.CEB(CEB),
	.WEB(WEB),
    .A(A),
	.D(DI),
    .BWEB(BWEB),
    .RTSEL(2'b01),
    .WTSEL(2'b01),
    .Q(DO)
);

endmodule

