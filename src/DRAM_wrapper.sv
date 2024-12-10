`include "../include/AXI_define.svh"

module DRAM_wrapper (
    input clk,
    input rst,
    
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
	// input 								BREADY_S,
	B.Slave S_B,

	output logic 						DRAM_CSn,
    output logic [3:0]					DRAM_WEn,
    output logic 						DRAM_RASn,
    output logic 						DRAM_CASn,
    output logic [10:0] 				DRAM_A,
    output logic [31:0]					DRAM_D,
	input 								DRAM_valid,
    input [31:0]						DRAM_Q
);

logic [2:0] delay;		//count DRAM delay cycles
logic [`AXI_ADDR_BITS-1:0] ADDR_reg;
logic [`AXI_SIZE_BITS-1:0] SIZE_reg;
logic [1:0] BURST_reg;
logic [`AXI_DATA_BITS-1:0] RDATA_reg;
logic [10:0] row;
logic B_done, write, diffrow_dect;

logic [2:0] stage, next_stage;
localparam [2:0] idle = 3'b000,
				 precharge = 3'b001,		//write response in this stage
				 activate = 3'b010,
            	 read_data = 3'b011,
            	 write_data = 3'b100;

logic [`AXI_LEN_BITS-1:0] arlen, awlen;
logic [`AXI_IDS_BITS-1:0] ARID_reg, AWID_reg;
logic [`AXI_LEN_BITS-1:0] counter;

assign B_done = S_B.BVALID & S_B.BREADY;
assign S_R.RID_S = (S_AR.ARVALID & S_AR.ARREADY) ? S_AR.ARID_S : ARID_reg;
assign S_R.RDATA = ((stage == read_data) & DRAM_valid) ? DRAM_Q : RDATA_reg;
assign S_R.RRESP = `AXI_RESP_OKAY;
assign S_R.RLAST = ((stage == read_data) && (counter == arlen) && (delay == 3'd5)); 
assign S_B.BID_S = (S_AW.AWVALID & S_AW.AWREADY) ? S_AW.AWID_S : AWID_reg;
assign S_B.BRESP = `AXI_RESP_OKAY;

//get size and burst data
always_ff @( posedge clk or negedge rst ) begin 
	if(~rst)begin
		SIZE_reg <= `AXI_SIZE_BITS'd0;
		BURST_reg <= 2'd0;
	end
	else if(S_AR.ARVALID & S_AR.ARREADY)begin
		SIZE_reg <= S_AR.ARSIZE;
		BURST_reg <= S_AR.ARBURST;
	end
	else if(S_AW.AWVALID & S_AW.AWREADY)begin
		SIZE_reg <= S_AW.AWSIZE;
		BURST_reg <= S_AW.AWBURST;
	end
	else begin
		SIZE_reg <= SIZE_reg;
		BURST_reg <= BURST_reg;
	end
end

//keep rdata stable
always_ff @( posedge clk or negedge rst ) begin 
	if(~rst)	
		RDATA_reg <= 32'd0;
	else 
		RDATA_reg <= ((stage == read_data) & DRAM_valid) ? DRAM_Q : RDATA_reg;
end

//get len
always_ff @( posedge clk or negedge rst ) begin 
    if(~rst)begin
        arlen <= `AXI_LEN_BITS'b0;
        awlen <= `AXI_LEN_BITS'b0;
		ARID_reg <= `AXI_IDS_BITS'b0;
		AWID_reg <= `AXI_IDS_BITS'b0;
    end
    else begin
        if(S_AR.ARVALID & S_AR.ARREADY)begin
            arlen <= S_AR.ARLEN;
			ARID_reg <= S_AR.ARID_S;
		end
        else begin 
            arlen <= arlen;
			ARID_reg <= ARID_reg;
		end
        if(S_AW.AWVALID & S_AW.AWREADY)begin
            awlen <= S_AW.AWLEN;
			AWID_reg <= S_AW.AWID_S;
		end
        else begin
            awlen <= awlen;
			AWID_reg <= AWID_reg;
		end
    end
end

//get address
always_ff @( posedge clk or negedge rst ) begin
    if(~rst)begin
		ADDR_reg <= `AXI_ADDR_BITS'd0;
        counter <= `AXI_LEN_BITS'b0;
    end 
    else if(stage == idle)begin
        if(S_AR.ARVALID & S_AR.ARREADY)begin
            ADDR_reg <= S_AR.ARADDR;
        end
        else if(S_AW.AWVALID & S_AW.AWREADY)begin
            ADDR_reg <= S_AW.AWADDR;
        end
    end
    else if(stage == read_data)begin
        if(S_R.RVALID & S_R.RREADY) begin           //in read data state and not read the end, increase address to get next data
            if(counter == arlen)begin
                counter <= `AXI_LEN_BITS'b0;
            end
            else begin
				ADDR_reg <= ADDR_reg + 32'd4;
                counter <= counter + `AXI_LEN_BITS'b1;
            end
        end
    end
    else if(stage == write_data)begin
        if(S_W.WVALID & S_W.WREADY)begin
            ADDR_reg <= ADDR_reg + 32'd4;
        end
    end
end

always_comb begin 
	if((stage == read_data) & (DRAM_A == 11'h3ff) & (counter != arlen))
		diffrow_dect = 1'b1;
	else 
		diffrow_dect = 1'b0;
end

logic ret_flag;
logic delay_done;
assign delay_done = (delay == 3'd5) ? 1'b1 : 1'b0;		//change

always_ff @( posedge clk or negedge rst ) begin 
	if(~rst)
		delay <= 3'd0;
	else if(ret_flag)
		delay <= 3'd0;
	else if(delay == 3'd5) begin
		if (next_stage == read_data) begin
			delay <=  3'd0;			
		end 
		else begin
			delay <=  delay;						
		end
	end
	else 
		delay <= delay + 3'd1;
end

always_ff @( posedge clk or negedge rst) begin 
	if(~rst)
		write <= 1'b0;
	else if(S_AR.ARVALID & S_AR.ARREADY)
		write <= 1'b0;
	else if(S_AW.AWVALID & S_AW.AWREADY)	
		write <= 1'b1;
	else 
		write <= write;
end

//FSM for slave to switch channel
//read
//idle --> activate(get row) --> read_data(get col) --> wait 5 cycles get data --> precharge
//write
//idle --> activate(get row) -->write_data(get col) --> wait 5 cycles --> precharge
always_ff @( posedge clk or negedge rst) begin 
    if(~rst)
        stage <= idle;
    else 
        stage <= next_stage;
end

always_comb begin
    ret_flag = 1'b0;
	case (stage)
        idle : begin
            if(((S_AR.ARVALID & S_AR.ARREADY) | (S_AW.AWVALID & S_AW.AWREADY)) & delay_done)begin
				ret_flag = 1'b1;
				next_stage = activate;
			end
            else
                next_stage = idle;
        end
		activate : begin
			if(delay_done)begin
				if(write)begin
					ret_flag = 1'b1;
					next_stage = write_data;
				end
				else begin
					// ret_flag = 1'b1;
					next_stage = read_data;
				end
			end
			else 
				next_stage = activate;
		end
        read_data : begin
			if(delay_done)begin
				if(S_R.RVALID & S_R.RREADY & S_R.RLAST)begin
					ret_flag = 1'b1;
					next_stage = precharge;
				end
				else if(S_R.RVALID & S_R.RREADY & !diffrow_dect)begin
					ret_flag = 1'b1;
					next_stage = read_data;
				end
				else if(diffrow_dect)begin
					ret_flag = 1'b1;
					next_stage = precharge;
				end
				else 
					next_stage = read_data;
			end
			else 
				next_stage = read_data;
        end
        write_data : begin		//write multiple data??(different row problem)
			if(delay_done)begin
				if(S_W.WVALID & S_W.WREADY & S_W.WLAST)begin
					ret_flag = 1'b1;
            	    next_stage = precharge;
				end
				else 
					next_stage = write_data;
			end
            else 
				next_stage = write_data;
		end
		default : begin
			if(delay_done)begin
				if(counter != `AXI_LEN_BITS'd0)begin
					ret_flag = 1'b1;
					next_stage = activate;
				end
				else begin
					ret_flag = 1'b1;
					next_stage = idle;
				end
			end
			else
				next_stage = precharge;
		end
    endcase    
end

always_ff @( posedge clk or negedge rst) begin 		//store activate row for precharge
	if(~rst)begin
		row <= 11'd0;
	end
	else if(stage == activate)begin
		row <= ADDR_reg[22:12];
	end
	else 
		row <= row;
end

//DRAM signal
//A may need other register to know address
always_comb begin 
	case (stage)
		idle : begin
			DRAM_CASn = 1'd1;
			DRAM_RASn = 1'd1;
			DRAM_WEn = 4'hf;
			DRAM_D = 32'd0;
			DRAM_A = (S_AR.ARREADY & S_AR.ARVALID) ? S_AR.ARADDR[22:12] : ((S_AW.AWVALID & S_AW.AWREADY) ? S_AW.AWADDR[22:12] : 11'd0);
		end
		activate : begin
			DRAM_CASn = 1'd1;
			DRAM_RASn = (delay == 3'd0) ? 1'd0 : 1'd1;
			DRAM_WEn = 4'hf;
			DRAM_D = 32'd0;
			DRAM_A = ADDR_reg[22:12];
		end
		read_data : begin
			DRAM_CASn = (delay == 3'd0) ? 1'd0 : 1'd1;
			DRAM_RASn = 1'd1;
			DRAM_WEn = 4'hf;
			DRAM_D = 32'd0;
			DRAM_A = {1'b0, ADDR_reg[11:2]};
		end
		write_data : begin
			DRAM_CASn = (delay == 3'd0) ? 1'd0 : 1'd1;
			DRAM_RASn = 1'd1;
			DRAM_WEn = (delay == 3'd0) ? S_W.WSTRB : 4'hf;
			DRAM_D = S_W.WDATA;
			DRAM_A = {1'b0, ADDR_reg[11:2]};
		end 
		default : begin
			DRAM_CASn = 1'd1;
			DRAM_RASn = (delay == 3'd0) ? 1'd0 : 1'd1;
			DRAM_WEn = (delay == 3'd0) ? 4'h0 : 4'hf;
			DRAM_D = 32'd0;
			DRAM_A = row;
		end
	endcase
end

//AXI signal
always_comb begin
    case (stage)
        idle : begin
            S_AR.ARREADY = (delay_done) ? ~S_AW.AWVALID : 1'b0;         //if want to write, write first
            S_R.RVALID = 1'b0;
            S_AW.AWREADY = (delay_done) ? 1'b1 : 1'b0;
            S_W.WREADY = 1'b0;
            // BVALID_S = 1'b0;
			DRAM_CSn = 1'b0;
            // A = (AWVALID_S) ? AWADDR_S[15:2] : ARADDR_S[15:2];
        end
		activate : begin
			S_AR.ARREADY = 1'b0;
            S_R.RVALID = 1'b0;
            S_AW.AWREADY = 1'b0;
            S_W.WREADY = 1'b0;
            // BVALID_S = 1'b0;
			DRAM_CSn = 1'b0;
		end
        read_data : begin
            S_AR.ARREADY = 1'b0;
            S_R.RVALID = (delay_done) ? 1'b1 : 1'b0;
            S_AW.AWREADY = 1'b0;
            S_W.WREADY = 1'b0;
            // BVALID_S = 1'b0;
			DRAM_CSn = 1'b0;
            // A = (RVALID_S & RREADY_S & RLAST_S) ? address : (RVALID_S & RREADY_S) ? address_4 : address;
        end
        write_data : begin
            S_AR.ARREADY = 1'b0;
            S_R.RVALID = 1'b0;
            S_AW.AWREADY = 1'b0;
            S_W.WREADY = (delay_done) ? 1'b1 : 1'b0;
            // BVALID_S = 1'b0;
			DRAM_CSn = 1'b0;
            // A = address;
        end
        default : begin
			S_AR.ARREADY = 1'b0;
            S_R.RVALID = 1'b0;
            S_AW.AWREADY = 1'b0;
            S_W.WREADY = 1'b0;
            // BVALID_S = 1'b1;
			DRAM_CSn = 1'b0;
		end
    endcase
end

always_ff @( posedge clk or negedge rst ) begin 
	if(~rst)
		S_B.BVALID <= 1'b0;
	else begin
		if(S_W.WVALID & S_W.WREADY & S_W.WLAST)
			S_B.BVALID <= 1'b1;
		else if(B_done)
			S_B.BVALID <= 1'b0;
		else 
			S_B.BVALID <= S_B.BVALID;
	end
end

endmodule
