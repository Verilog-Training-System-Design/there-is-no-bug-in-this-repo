`include "../include/AXI_define.svh"
//problem: There is may exist reset during instruction
module Master (
    input                                   clk          ,
    input                                   reset        ,

    //from cpu
    input                                   READ         ,
    input                                   WRITE        ,
    input       [`AXI_STRB_BITS-1:0]        WRITE_TYPE   ,
    input       [`AXI_ADDR_BITS-1:0]        ADDR_IN      ,
    input       [`AXI_DATA_BITS-1:0]        DATA_IN      ,

    //to cpu
    output logic [`AXI_DATA_BITS-1:0]       DATA_OUT     ,
    output logic                            STALL        ,

    // Read address
    output logic [`AXI_ID_BITS-1:0]         ARID         ,
    output logic [`AXI_ADDR_BITS-1:0]       ARADDR       ,
    output logic [`AXI_LEN_BITS-1:0]        ARLEN        ,
    output logic [`AXI_SIZE_BITS-1:0]       ARSIZE       ,
    output logic [1:0]                      ARBURST      ,
    output logic                            ARVALID      ,
    input                                   ARREADY      ,
    // Read data
    input       [`AXI_ID_BITS-1:0]          RID          ,
    input       [`AXI_DATA_BITS-1:0]        RDATA        ,
    input       [1:0]                       RRESP        ,
    input                                   RLAST        ,
    input                                   RVALID       ,
    output logic                            RREADY       ,

    //Write address
    output logic [`AXI_ID_BITS-1:0]         AWID         ,
    output logic [`AXI_ADDR_BITS-1:0]       AWADDR       ,
    output logic [`AXI_LEN_BITS-1:0]        AWLEN        ,
    output logic [`AXI_SIZE_BITS-1:0]       AWSIZE       ,
    output logic [1:0]                      AWBURST      ,
    output logic                            AWVALID      ,
    input                                   AWREADY      ,
    // Write data
    output logic [`AXI_DATA_BITS-1:0]       WDATA        ,
    output logic [`AXI_STRB_BITS-1:0]       WSTRB        ,
    output logic                            WLAST        ,
    output logic                            WVALID       ,
    input                                   WREADY       ,

    // Write Response
    input       [`AXI_ID_BITS-1:0]          BID          ,
    input       [1:0]                       BRESP        ,
    input                                   BVALID       ,
    output logic                            BREADY       
);
logic rst, read_reg, write_reg;
logic [`AXI_DATA_BITS-1:0] DATA_BUF;
logic [2:0] master_stage, next_stage;
localparam  idle = 3'd0,
            read_address = 3'd1,
            read_data = 3'd2,
            write_address = 3'd3,
            write_data = 3'd4,
            write_response = 3'd5;

//Read address
assign ARID      = `AXI_ID_BITS'b0;
assign ARADDR    = ADDR_IN;
assign ARLEN     = `AXI_LEN_ONE;
assign ARSIZE    = `AXI_SIZE_WORD;
assign ARBURST   = `AXI_BURST_INC;

//Write address
assign AWID    = `AXI_ID_BITS'b0;
assign AWADDR  = ADDR_IN;
assign AWLEN   = `AXI_LEN_ONE;
assign AWSIZE  = `AXI_SIZE_WORD;
assign AWBURST = `AXI_BURST_INC;

//Write data
assign WDATA = DATA_IN;
assign WSTRB = WRITE_TYPE;
assign WLAST = 1'b1;

always_ff @( posedge clk or negedge reset ) begin           //fulfill vip
    if(~reset)
        rst <= 1'b0;
    else 
        rst <= 1'b1;
end

assign read_reg = (READ & rst);
assign write_reg = (WRITE & rst);

always_comb begin       //make sure DATA_OUT will always get last data
    if(RVALID & RREADY)
        DATA_OUT = RDATA;
    else 
        DATA_OUT = DATA_BUF;
end

//make sure read data won't disappear 
always_ff @( posedge clk or negedge reset) begin 
    if(~reset)
        DATA_BUF <= `AXI_DATA_BITS'h0;
    else if(RVALID & RREADY)
        DATA_BUF <= RDATA;
    else 
        DATA_BUF <= DATA_BUF;
end

always_comb begin       //stage decide
    case (master_stage)
        idle : begin
            if(ARVALID & ARREADY)           //read address before read data
                next_stage = read_data;
            else if(ARVALID)
                next_stage = read_address;
            else begin
                if(AWVALID & AWREADY)
                    next_stage = write_data;
                else if(AWVALID)
                    next_stage = write_address;
                else 
                    next_stage = idle;
            end
        end
        read_address : begin
            if(ARVALID & ARREADY)
                next_stage = read_data;
            else
                next_stage = read_address;
        end
        read_data : begin
            if(RVALID & RREADY & RLAST)
                next_stage = idle;
            else 
                next_stage = read_data; 
        end
        write_address : begin
            if(AWVALID & AWREADY)
                next_stage = write_data;
            else 
                next_stage = write_address; 
        end
        write_data : begin
            if(WVALID & WREADY & WLAST)
                next_stage = write_response;
            else 
                next_stage = write_data; 
        end
        write_response : begin
            if(BVALID & BREADY)
                next_stage = idle;
            else 
                next_stage = write_response;
        end 
        default : begin
            next_stage = idle;
        end
    endcase
end

always_comb begin       //stage behavior
    case (master_stage)
        idle : begin
            STALL = read_reg | write_reg;
            ARVALID = read_reg;         //may exist problem
            RREADY = 1'b0;
            AWVALID = write_reg;        //may exist problem
            WVALID = 1'b0;
            BREADY = 1'b0;
        end
        read_address : begin
            STALL = 1'b1;
            ARVALID = 1'b1;
            RREADY = 1'b0;
            AWVALID = 1'b0;
            WVALID = 1'b0;
            BREADY = 1'b0;
        end
        read_data : begin
            STALL = !(RVALID & RREADY);
            ARVALID = 1'b0;
            RREADY = 1'b1;
            AWVALID = 1'b0;
            WVALID = 1'b0;
            BREADY = 1'b0;
        end
        write_address : begin
            STALL = 1'b1;
            ARVALID = 1'b0;
            RREADY = 1'b0;
            AWVALID = 1'b1;
            WVALID = 1'b0;
            BREADY = 1'b0;
        end
        write_data : begin
            STALL = !(WVALID & WREADY);
            ARVALID = 1'b0;
            RREADY = 1'b0;
            AWVALID = 1'b0;
            WVALID = 1'b1;
            BREADY = 1'b0;
        end
        write_response : begin
            STALL = (read_reg | write_reg);
            ARVALID = 1'b0;
            RREADY = 1'b0;
            AWVALID = 1'b0;
            WVALID = 1'b0;
            BREADY = 1'b1;
        end
        default :begin
            STALL = 1'b0;
            ARVALID = 1'b0;
            RREADY = 1'b0;
            AWVALID = 1'b0;
            WVALID = 1'b0;
            BREADY = 1'b0;
        end
    endcase
end

always_ff @( posedge clk or negedge reset) begin
    if(~reset)
        master_stage <= idle;
    else
        master_stage <= next_stage;
end

endmodule