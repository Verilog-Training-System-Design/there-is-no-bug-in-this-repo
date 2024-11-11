`include "../include/AXI_define.svh"
`include "Master.sv"
`include "CPU.sv"
module CPU_wrapper (
    input                                   ACLK            ,
    input                                   ARESETn         ,

    // //WRITE ADDRESS
    // output logic [`AXI_ID_BITS-1:0]         AWID_M0        ,
    // output logic [`AXI_ADDR_BITS-1:0]       AWADDR_M0      ,
    // output logic [`AXI_LEN_BITS-1:0]        AWLEN_M0       ,
    // output logic [`AXI_SIZE_BITS-1:0]       AWSIZE_M0      ,
    // output logic [1:0]                      AWBURST_M0     ,
    // output logic                            AWVALID_M0     ,
    // input                                   AWREADY_M0     ,

    // //WRITE DATA
    // output logic [`AXI_DATA_BITS-1:0]       WDATA_M0       ,
    // output logic [`AXI_STRB_BITS-1:0]       WSTRB_M0       ,
    // output logic                            WLAST_M0       ,
    // output logic                            WVALID_M0      ,
    // input                                   WREADY_M0      ,

    // //WRITE RESPONSE
    // input [`AXI_ID_BITS-1:0]                BID_M0         ,
    // input [1:0]                             BRESP_M0       ,
    // input                                   BVALID_M0      ,
    // output logic                            BREADY_M0      ,

    //READ ADDRESS0
    output logic [`AXI_ID_BITS-1:0]         ARID_M0        ,
    output logic [`AXI_ADDR_BITS-1:0]       ARADDR_M0      ,
    output logic [`AXI_LEN_BITS-1:0]        ARLEN_M0       ,
    output logic [`AXI_SIZE_BITS-1:0]       ARSIZE_M0      ,
    output logic [1:0]                      ARBURST_M0     ,
    output logic                            ARVALID_M0     ,
    input                                   ARREADY_M0     ,

    //READ DATA0
    input [`AXI_ID_BITS-1:0]                RID_M0         ,
    input [`AXI_DATA_BITS-1:0]              RDATA_M0       ,
    input [1:0]                             RRESP_M0       ,
    input                                   RLAST_M0       ,
    input                                   RVALID_M0      ,
    output logic                            RREADY_M0      ,


    //WRITE ADDRESS
    output logic [`AXI_ID_BITS-1:0]         AWID_M1        ,
    output logic [`AXI_ADDR_BITS-1:0]       AWADDR_M1      ,
    output logic [`AXI_LEN_BITS-1:0]        AWLEN_M1       ,
    output logic [`AXI_SIZE_BITS-1:0]       AWSIZE_M1      ,
    output logic [1:0]                      AWBURST_M1     ,
    output logic                            AWVALID_M1     ,
    input                                   AWREADY_M1     ,

    //WRITE DATA
    output logic [`AXI_DATA_BITS-1:0]       WDATA_M1       ,
    output logic [`AXI_STRB_BITS-1:0]       WSTRB_M1       ,
    output logic                            WLAST_M1       ,
    output logic                            WVALID_M1      ,
    input                                   WREADY_M1      ,

    //WRITE RESPONSE
    input [`AXI_ID_BITS-1:0]                BID_M1         ,
    input [1:0]                             BRESP_M1       ,
    input                                   BVALID_M1      ,
    output logic                            BREADY_M1      ,

    //READ ADDRESS1
    output logic [`AXI_ID_BITS-1:0]         ARID_M1        ,
    output logic [`AXI_ADDR_BITS-1:0]       ARADDR_M1      ,
    output logic [`AXI_LEN_BITS-1:0]        ARLEN_M1       ,
    output logic [`AXI_SIZE_BITS-1:0]       ARSIZE_M1      ,
    output logic [1:0]                      ARBURST_M1     ,
    output logic                            ARVALID_M1     ,
    input                                   ARREADY_M1     ,

    //READ DATA1
    input [`AXI_ID_BITS-1:0]                RID_M1         ,
    input [`AXI_DATA_BITS-1:0]              RDATA_M1       ,
    input [1:0]                             RRESP_M1       ,
    input                                   RLAST_M1       ,
    input                                   RVALID_M1      ,
    output logic                            RREADY_M1
);

//WRITE ADDRESS
logic [`AXI_ID_BITS-1:0]         AWID_M0;
logic [`AXI_ADDR_BITS-1:0]       AWADDR_M0;
logic [`AXI_LEN_BITS-1:0]        AWLEN_M0;
logic [`AXI_SIZE_BITS-1:0]       AWSIZE_M0;
logic [1:0]                      AWBURST_M0;
logic                            AWVALID_M0;
logic                            AWREADY_M0;

//WRITE DATA
logic [`AXI_DATA_BITS-1:0]       WDATA_M0;
logic [`AXI_STRB_BITS-1:0]       WSTRB_M0;
logic                            WLAST_M0;
logic                            WVALID_M0;
logic                            WREADY_M0;

//WRITE RESPONSE
logic [`AXI_ID_BITS-1:0]         BID_M0;
logic [1:0]                      BRESP_M0;
logic                            BVALID_M0;
logic                            BREADY_M0;

logic w_read, w_write, w_im_stall, w_dm_stall;
logic [`AXI_STRB_BITS-1:0] w_write_type;
logic [`AXI_ADDR_BITS-1:0] w_addr, w_im_addr;
logic [`AXI_DATA_BITS-1:0] w_data_in, w_data_out, w_im_data_out;
logic late_reset;

assign BVALID_M0 = 1'b0;
assign BRESP_M0 = 2'b0;
assign BID_M0 = `AXI_ID_BITS'b0;

always_ff @( posedge ACLK or negedge ARESETn ) begin        //fulfill vip
    if(~ARESETn)
        late_reset <= ARESETn;
    else 
        late_reset <= ARESETn;
end

CPU cpu(
.clk(ACLK),
.rst(late_reset),

//IF out
.IM_instr(w_im_data_out),
.progcnt_out(w_im_addr),

//MEM out
.DM_DO(w_data_out),
.DM_WEB(w_read),
.DM_BWEB(w_write_type),
.DM_addr(w_addr),
.DM_DI(w_data_in),
.DM_write(w_write),
//stall
.IM_stall(w_im_stall),
.DM_stall(w_dm_stall)
);

// assign w_write = (w_write_type == 4'hf) ? 1'b0 : 1'b1;

Master M0(                          //IM
    .clk(ACLK)                   ,
    .reset(ARESETn)                 ,

    //from cpu
    .READ(1'b1)                 ,
    .WRITE(1'b0)                ,
    .WRITE_TYPE(4'hf)           ,
    .ADDR_IN(w_im_addr)         ,
    .DATA_IN(32'b0)             ,

    //to cpu
    .DATA_OUT(w_im_data_out)    ,
    .STALL(w_im_stall)          ,
    
    // Read address
    .ARID(ARID_M0)              ,
    .ARADDR(ARADDR_M0)          ,
    .ARLEN(ARLEN_M0)            ,
    .ARSIZE(ARSIZE_M0)          ,
    .ARBURST(ARBURST_M0)        ,
    .ARVALID(ARVALID_M0)        ,
    .ARREADY(ARREADY_M0)        ,

    // Read data
    .RID(RID_M0)                ,
    .RDATA(RDATA_M0)            ,
    .RRESP(RRESP_M0)            ,
    .RLAST(RLAST_M0)            ,
    .RVALID(RVALID_M0)          ,
    .RREADY(RREADY_M0)          ,

    //Write address
    .AWID(AWID_M0)              ,
    .AWADDR(AWADDR_M0)          ,
    .AWLEN(AWLEN_M0)            ,
    .AWSIZE(AWSIZE_M0)          ,
    .AWBURST(AWBURST_M0)        ,
    .AWVALID(AWVALID_M0)        ,
    .AWREADY(AWREADY_M0)        ,

    // Write data
    .WDATA(WDATA_M0)            ,
    .WSTRB(WSTRB_M0)            ,
    .WLAST(WLAST_M0)            ,
    .WVALID(WVALID_M0)          ,
    .WREADY(WREADY_M0)          ,

    // Write Response
    .BID(BID_M0)                ,
    .BRESP(BRESP_M0)            ,
    .BVALID(BVALID_M0)          ,
    .BREADY(BREADY_M0)       
);
    

Master M1(                          //DM
    .clk(ACLK)                   ,
    .reset(ARESETn)                 ,

    //from cpu
    .READ(w_read)               ,
    .WRITE(w_write)             ,
    .WRITE_TYPE(w_write_type)   ,
    .ADDR_IN(w_addr)            ,
    .DATA_IN(w_data_in)         ,

    //to cpu
    .DATA_OUT(w_data_out)       ,
    .STALL(w_dm_stall)          ,

    // Read address
    .ARID(ARID_M1)              ,
    .ARADDR(ARADDR_M1)          ,
    .ARLEN(ARLEN_M1)            ,
    .ARSIZE(ARSIZE_M1)          ,
    .ARBURST(ARBURST_M1)        ,
    .ARVALID(ARVALID_M1)        ,
    .ARREADY(ARREADY_M1)        ,

    // Read data
    .RID(RID_M1)                ,
    .RDATA(RDATA_M1)            ,
    .RRESP(RRESP_M1)            ,
    .RLAST(RLAST_M1)            ,
    .RVALID(RVALID_M1)          ,
    .RREADY(RREADY_M1)          ,

    //Write address
    .AWID(AWID_M1)              ,
    .AWADDR(AWADDR_M1)          ,
    .AWLEN(AWLEN_M1)            ,
    .AWSIZE(AWSIZE_M1)          ,
    .AWBURST(AWBURST_M1)        ,
    .AWVALID(AWVALID_M1)        ,
    .AWREADY(AWREADY_M1)        ,

    // Write data
    .WDATA(WDATA_M1)            ,
    .WSTRB(WSTRB_M1)            ,
    .WLAST(WLAST_M1)            ,
    .WVALID(WVALID_M1)          ,
    .WREADY(WREADY_M1)          ,

    // Write Response
    .BID(BID_M1)                ,
    .BRESP(BRESP_M1)            ,
    .BVALID(BVALID_M1)          ,
    .BREADY(BREADY_M1)       
);


endmodule