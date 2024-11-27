`include "../include/AXI_define.svh"
module SRAM_wrapper (
	input 								ACLK,
	input 								ARESETn,

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
	input 								BREADY_S
);
// logic late_rst;

// always_ff @( posedge ACLK or negedge ARESETn ) begin 
//     if(~ARESETn)
//         late_rst <= ARESETn;
//     else 
//         late_rst <= ARESETn;
// end

// logic CEB;
logic WEB;
logic [31:0] BWEB;
logic [13:0] A, address, address_4;
logic [`AXI_DATA_BITS-1:0] DI;
logic [`AXI_DATA_BITS-1:0] DO, DO_temp, RDATA_reg;

assign CEB = 1'b0;
assign DI = WDATA_S;

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


// logic [`AXI_IDS_BITS-1:0] ARID_reg;
// logic [`AXI_LEN_BITS-1:0] ARLEN_reg;
// logic [`AXI_IDS_BITS-1:0] AWID_reg;
// logic [`AXI_LEN_BITS-1:0] AWLEN_reg;
logic [`AXI_LEN_BITS-1:0] arlen, awlen;
logic [`AXI_LEN_BITS-1:0] counter;
// logic RVALID_reg;
logic ceb;

assign RID_S = (ARVALID_S & ARREADY_S) ? ARID_S : RID_S;
// assign RDATA_S = (RVALID_S & RVALID_reg) ? RDATA_reg : DO;
assign RDATA_S = DO;
assign RRESP_S = `AXI_RESP_OKAY;
assign RLAST_S = ((stage == read_data) && (counter == arlen)); 
assign BID_S = (AWVALID_S & AWREADY_S) ? AWID_S : BID_S;
assign BRESP_S = `AXI_RESP_OKAY;

// always_ff @( posedge ACLK or negedge ARESETn ) begin
//     if(~ARESETn)
//         RDATA_reg <= `AXI_DATA_BITS'b0;
//     else 
//         RDATA_reg <= (RVALID_S & ~RVALID_reg) ? DO : RDATA_reg;
// end

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
        if(ARVALID_S & ARREADY_S)
            arlen <= ARLEN_S;
        else 
            arlen <= arlen;
        
        if(AWVALID_S & AWREADY_S)
            awlen <= AWLEN_S;
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
        if(ARVALID_S & ARREADY_S)begin
            address <= ARADDR_S[15:2];
            address_4 <= ARADDR_S[15:2] + 14'b1;
        end
        else if(AWVALID_S & AWREADY_S)begin
            address <= AWADDR_S[15:2];
        end
    end
    else if(stage == read_data)begin
        if(RVALID_S & RREADY_S) begin           //in read data state and not read the end, increase address to get next data
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
        if(WVALID_S & WREADY_S)begin
            address <= address + 14'b1;
        end
    end
end

//store read address and write address's id and len
// always_ff @( posedge clk or negedge rst ) begin
//     if(~rst)begin
//         ARID_reg <= `AXI_IDS_BITS'b0;
//         ARLEN_reg <= `AXI_LEN_BITS'b0;
//         AWID_reg <= `AXI_IDS_BITS'b0;
//         AWLEN_reg <= `AXI_LEN_BITS'b0;
//     end 
//     else begin
//         if(ARVALID & ARREADY)begin
//             ARID_reg <= ARID;
//             ARLEN_reg <= ARLEN;
//         end  
//         else begin
//             ARID_reg <= ARID_reg;
//             ARLEN_reg <= ARLEN_reg;
//         end
//         if (AWVALID & AWREADY) begin
//             AWID_reg <= AWID;
//             AWLEN_reg <= AWLEN;
//         end
//         else begin
//             AWID_reg <= AWID_reg;
//             AWLEN_reg <= AWLEN_reg;
//         end
//     end
// end

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
            if(AWVALID_S & AWREADY_S)
                next_stage = write_data;
            else if(ARVALID_S & ARREADY_S)
                next_stage = read_data;
            else
                next_stage = idle;
        end
        read_data : begin
            if(RVALID_S & RREADY_S & RLAST_S)
                next_stage = idle;
            else 
                next_stage = read_data;
        end
        write_data : begin
            if(WVALID_S & WREADY_S & WLAST_S)
                next_stage = write_response;
            else 
                next_stage = write_data;
        end
        write_response : begin
            if(BVALID_S & BREADY_S)
                next_stage = idle;
            else 
                next_stage = write_response;
        end
    endcase    
end

always_comb begin
    case (stage)
        idle : begin
            ARREADY_S = ~AWVALID_S;         //I change here then prog1 become right
            RVALID_S = 1'b0;
            AWREADY_S = 1'b1;
            WREADY_S = 1'b0;
            BVALID_S = 1'b0;
            A = (AWVALID_S) ? AWADDR_S[15:2] : ARADDR_S[15:2];
            // RDATA_S = RDATA_S;
        end
        read_data : begin
            ARREADY_S = 1'b0;
            RVALID_S = 1'b1;
            AWREADY_S = 1'b0;
            WREADY_S = 1'b0;
            BVALID_S = 1'b0;
            // A = address;
            A = (RVALID_S & RREADY_S & RLAST_S) ? address : (RVALID_S & RREADY_S) ? address_4 : address;
            // RDATA_S = DO;
        end
        write_data : begin
            ARREADY_S = 1'b0;
            RVALID_S = 1'b0;
            AWREADY_S = 1'b0;
            WREADY_S = 1'b1;
            BVALID_S = 1'b0;
            // A = address;
            A = address;
            // RDATA_S = RDATA_S;
        end
        write_response : begin
            ARREADY_S = 1'b0;
            RVALID_S = 1'b0;
            AWREADY_S = 1'b0;
            WREADY_S = 1'b0;
            BVALID_S = 1'b1;
            A = 14'b0;
            // RDATA_S = RDATA_S;
        end
    endcase
end

//write data
always_comb begin
    WEB = 1'b0;
    case (WSTRB_S)
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

