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

    // //READ ADDRESS0
    // output logic [`AXI_ID_BITS-1:0]         ARID_M0        ,
    // output logic [`AXI_ADDR_BITS-1:0]       ARADDR_M0      ,
    // output logic [`AXI_LEN_BITS-1:0]        ARLEN_M0       ,
    // output logic [`AXI_SIZE_BITS-1:0]       ARSIZE_M0      ,
    // output logic [1:0]                      ARBURST_M0     ,
    // output logic                            ARVALID_M0     ,
    // input                                   ARREADY_M0     ,
    RA.Master M0_AR,

    // //READ DATA0
    // input [`AXI_ID_BITS-1:0]                RID_M0         ,
    // input [`AXI_DATA_BITS-1:0]              RDATA_M0       ,
    // input [1:0]                             RRESP_M0       ,
    // input                                   RLAST_M0       ,
    // input                                   RVALID_M0      ,
    // output logic                            RREADY_M0      ,
    R.Master M0_R,

    // //WRITE ADDRESS
    // output logic [`AXI_ID_BITS-1:0]         AWID_M1        ,
    // output logic [`AXI_ADDR_BITS-1:0]       AWADDR_M1      ,
    // output logic [`AXI_LEN_BITS-1:0]        AWLEN_M1       ,
    // output logic [`AXI_SIZE_BITS-1:0]       AWSIZE_M1      ,
    // output logic [1:0]                      AWBURST_M1     ,
    // output logic                            AWVALID_M1     ,
    // input                                   AWREADY_M1     ,
    WA.Master M1_AW,

    // //WRITE DATA
    // output logic [`AXI_DATA_BITS-1:0]       WDATA_M1       ,
    // output logic [`AXI_STRB_BITS-1:0]       WSTRB_M1       ,
    // output logic                            WLAST_M1       ,
    // output logic                            WVALID_M1      ,
    // input                                   WREADY_M1      ,
    W.Master M1_W,

    //WRITE RESPONSE
    // input [`AXI_ID_BITS-1:0]                BID_M1         ,
    // input [1:0]                             BRESP_M1       ,
    // input                                   BVALID_M1      ,
    // output logic                            BREADY_M1      ,
    B.Master M1_B,

    // //READ ADDRESS1
    // output logic [`AXI_ID_BITS-1:0]         ARID_M1        ,
    // output logic [`AXI_ADDR_BITS-1:0]       ARADDR_M1      ,
    // output logic [`AXI_LEN_BITS-1:0]        ARLEN_M1       ,
    // output logic [`AXI_SIZE_BITS-1:0]       ARSIZE_M1      ,
    // output logic [1:0]                      ARBURST_M1     ,
    // output logic                            ARVALID_M1     ,
    // input                                   ARREADY_M1     ,
    RA.Master M1_AR,


    //READ DATA1
    // input [`AXI_ID_BITS-1:0]                RID_M1         ,
    // input [`AXI_DATA_BITS-1:0]              RDATA_M1       ,
    // input [1:0]                             RRESP_M1       ,
    // input                                   RLAST_M1       ,
    // input                                   RVALID_M1      ,
    // output logic                            RREADY_M1      ,
    R.Master M1_R,

    input                                   DMA_interrupt  ,
    input                                   WDT_timeout
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

logic w_read, w_write, w_im_stall, w_dm_stall, read;
logic [`AXI_STRB_BITS-1:0] w_write_type;
logic [`AXI_ADDR_BITS-1:0] w_addr, w_im_addr;
logic [`AXI_DATA_BITS-1:0] w_data_in, w_data_out, w_im_data_out;
logic late_reset;

assign BVALID_M0 = 1'b0;
assign BRESP_M0 = 2'b0;
assign BID_M0 = `AXI_ID_BITS'b0;

// always_ff @( posedge ACLK or negedge ARESETn ) begin        //fulfill vip
//     if(~ARESETn)
//         late_reset <= ARESETn;
//     else 
//         late_reset <= ARESETn;
// end

CPU cpu(
.clk(ACLK),
// .rst(late_reset),
.rst(ARESETn),

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
.IM_read(read),
//stall
.IM_stall(w_im_stall),
.DM_stall(w_dm_stall),
.DMA_interrupt(DMA_interrupt),
.WDT_timeout(WDT_timeout)
);

// assign w_write = (w_write_type == 4'hf) ? 1'b0 : 1'b1;

Master M0(                          //IM
    .clk(ACLK)                   ,
    .reset(ARESETn)                 ,

    //from cpu
    .READ(read)                 ,
    .WRITE(1'b0)                ,
    .WRITE_TYPE(4'hf)           ,
    .ADDR_IN(w_im_addr)         ,
    .DATA_IN(32'b0)             ,

    //to cpu
    .DATA_OUT(w_im_data_out)    ,
    .STALL(w_im_stall)          ,
    
    // Read address
    .ARID(M0_AR.ARID)              ,
    .ARADDR(M0_AR.ARADDR)          ,
    .ARLEN(M0_AR.ARLEN)            ,
    .ARSIZE(M0_AR.ARSIZE)          ,
    .ARBURST(M0_AR.ARBURST)        ,
    .ARVALID(M0_AR.ARVALID)        ,
    .ARREADY(M0_AR.ARREADY)        ,

    // Read data
    .RID(M0_R.RID)                ,
    .RDATA(M0_R.RDATA)            ,
    .RRESP(M0_R.RRESP)            ,
    .RLAST(M0_R.RLAST)            ,
    .RVALID(M0_R.RVALID)          ,
    .RREADY(M0_R.RREADY)          ,

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
    .ARID(M1_AR.ARID)              ,
    .ARADDR(M1_AR.ARADDR)          ,
    .ARLEN(M1_AR.ARLEN)            ,
    .ARSIZE(M1_AR.ARSIZE)          ,
    .ARBURST(M1_AR.ARBURST)        ,
    .ARVALID(M1_AR.ARVALID)        ,
    .ARREADY(M1_AR.ARREADY)        ,

    // Read data
    .RID(M1_R.RID)                ,
    .RDATA(M1_R.RDATA)            ,
    .RRESP(M1_R.RRESP)            ,
    .RLAST(M1_R.RLAST)            ,
    .RVALID(M1_R.RVALID)          ,
    .RREADY(M1_R.RREADY)          ,

    //Write address
    .AWID(M1_AW.AWID)              ,
    .AWADDR(M1_AW.AWADDR)          ,
    .AWLEN(M1_AW.AWLEN)            ,
    .AWSIZE(M1_AW.AWSIZE)          ,
    .AWBURST(M1_AW.AWBURST)        ,
    .AWVALID(M1_AW.AWVALID)        ,
    .AWREADY(M1_AW.AWREADY)        ,

    // Write data
    .WDATA(M1_W.WDATA)            ,
    .WSTRB(M1_W.WSTRB)            ,
    .WLAST(M1_W.WLAST)            ,
    .WVALID(M1_W.WVALID)          ,
    .WREADY(M1_W.WREADY)          ,

    // Write Response
    .BID(M1_B.BID)                ,
    .BRESP(M1_B.BRESP)            ,
    .BVALID(M1_B.BVALID)          ,
    .BREADY(M1_B.BREADY)       
);


endmodule