
interface RA;
    logic [`AXI_ID_BITS-1:0] ARID;
    logic [`AXI_IDS_BITS-1:0] ARID_S;
	logic [`AXI_ADDR_BITS-1:0] ARADDR;
	logic [`AXI_LEN_BITS-1:0] ARLEN;
	logic [`AXI_SIZE_BITS-1:0] ARSIZE;
	logic [1:0] ARBURST;
	logic ARVALID;
	logic ARREADY;

    modport  Master(
        input ARID, input ARADDR, input ARLEN, input ARSIZE, input ARBURST, input ARVALID,
        output ARREADY
    );

    // modport M1(
    //     input ARID, input ARADDR, input ARLEN, input ARSIZE, input ARBURST, input ARVALID,
    //     output ARREADY
    // );

    // modport M2(
    //     input ARID, input ARADDR, input ARLEN, input ARSIZE, input ARBURST, input ARVALID,
    //     output ARREADY
    // );

    modport Slave(
        input ARREADY,
        output ARID_S, output ARADDR, output ARLEN, output ARSIZE, output ARBURST, output ARVALID
    );

    // modport ROM(
    //     input ARREADY,
    //     output ARID_S, output ARADDR, output ARLEN, output ARSIZE, output ARBURST, output ARVALID
    // );

    // modport IM(
    //     input ARREADY,
    //     output ARID_S, output ARADDR, output ARLEN, output ARSIZE, output ARBURST, output ARVALID
    // );

    // modport DM(
    //     input ARREADY,
    //     output ARID_S, output ARADDR, output ARLEN, output ARSIZE, output ARBURST, output ARVALID
    // );    

    // modport DMA(
    //     input ARREADY,
    //     output ARID_S, output ARADDR, output ARLEN, output ARSIZE, output ARBURST, output ARVALID
    // );

    // modport WDT(
    //     input ARREADY,
    //     output ARID_S, output ARADDR, output ARLEN, output ARSIZE, output ARBURST, output ARVALID
    // );

    // modport DRAM(
    //     input ARREADY,
    //     output ARID_S, output ARADDR, output ARLEN, output ARSIZE, output ARBURST, output ARVALID
    // );
endinterface //read_address

interface R;
    logic [`AXI_ID_BITS-1:0] RID;
    logic [`AXI_IDS_BITS-1:0] RID_S;
	logic [`AXI_DATA_BITS-1:0] RDATA;
	logic [1:0] RRESP;
	logic RLAST;
	logic RVALID;
	logic RREADY;

    modport Master (
        input RREADY,
        output RID,output RDATA,output RRESP,output RLAST,output RVALID
    );

    // modport M1 (
    //     input RREADY,
    //     output RID,output RDATA,output RRESP,output RLAST,output RVALID
    // );

    // modport M2 (
    //     input RREADY,
    //     output RID,output RDATA,output RRESP,output RLAST,output RVALID
    // );

    modport Slave (
        input RID_S, input RDATA, input RRESP, input RLAST, input RVALID,
        output RREADY
    );

    // modport ROM (
    //     input RID_S, input RDATA, input RRESP, input RLAST, input RVALID,
    //     output RREADY
    // );

    // modport IM (
    //     input RID_S, input RDATA, input RRESP, input RLAST, input RVALID,
    //     output RREADY
    // );

    // modport DM (
    //     input RID_S, input RDATA, input RRESP, input RLAST, input RVALID,
    //     output RREADY
    // );

    // modport DMA (
    //     input RID_S, input RDATA, input RRESP, input RLAST, input RVALID,
    //     output RREADY
    // );

    // modport WDT (
    //     input RID_S, input RDATA, input RRESP, input RLAST, input RVALID,
    //     output RREADY
    // );

    // modport DRAM (
    //     input RID_S, input RDATA, input RRESP, input RLAST, input RVALID,
    //     output RREADY
    // );
endinterface //read_data

interface WA;
    logic [`AXI_ID_BITS-1:0] AWID;
    logic [`AXI_IDS_BITS-1:0] AWID_S;
	logic [`AXI_ADDR_BITS-1:0] AWADDR;
	logic [`AXI_LEN_BITS-1:0] AWLEN;
	logic [`AXI_SIZE_BITS-1:0] AWSIZE;
	logic [1:0] AWBURST;
	logic AWVALID;
    logic AWREADY;

    // modport M0 (
    //     input AWID, input AWADDR, input AWLEN, input AWSIZE, input AWBURST, input AWVALID,
    //     output AWREADY
    // );

    modport Master (
        input AWID, input AWADDR, input AWLEN, input AWSIZE, input AWBURST, input AWVALID,
        output AWREADY
    );

    // modport M2 (
    //     input AWID, input AWADDR, input AWLEN, input AWSIZE, input AWBURST, input AWVALID,
    //     output AWREADY
    // );

    modport Slave (
        input AWREADY,
        output AWID_S, output AWADDR, output AWLEN, output AWSIZE, output AWBURST, output AWVALID
    );

    // modport ROM (
    //     input AWREADY,
    //     output AWID_S, output AWADDR, output AWLEN, output AWSIZE, output AWBURST, output AWVALID
    // );

    // modport IM (
    //     input AWREADY,
    //     output AWID_S, output AWADDR, output AWLEN, output AWSIZE, output AWBURST, output AWVALID
    // );

    // modport DM (
    //     input AWREADY,
    //     output AWID_S, output AWADDR, output AWLEN, output AWSIZE, output AWBURST, output AWVALID
    // );

    // modport DMA (
    //     input AWREADY,
    //     output AWID_S, output AWADDR, output AWLEN, output AWSIZE, output AWBURST, output AWVALID
    // );

    // modport WDT (
    //     input AWREADY,
    //     output AWID_S, output AWADDR, output AWLEN, output AWSIZE, output AWBURST, output AWVALID
    // );

    // modport DRAM (
    //     input AWREADY,
    //     output AWID_S, output AWADDR, output AWLEN, output AWSIZE, output AWBURST, output AWVALID
    // );
endinterface //write_address

interface W;
    logic [`AXI_DATA_BITS-1:0] WDATA;
	logic [`AXI_STRB_BITS-1:0] WSTRB;
	logic WLAST;
	logic WVALID;
	logic WREADY;

    // modport M0 (
    //     input WDATA, input WSTRB, input WLAST, input WVALID,
	//     output WREADY
    // );

    modport Master (
        input WDATA, input WSTRB, input WLAST, input WVALID,
	    output WREADY
    );

    // modport M2 (
    //     input WDATA, input WSTRB, input WLAST, input WVALID,
	//     output WREADY
    // );

    modport Slave (
        input WREADY,
        output WDATA, output WSTRB, output WLAST, output WVALID
    );

    // modport ROM (
    //     input WREADY,
    //     output WDATA, output WSTRB, output WLAST, output WVALID
    // );

    // modport IM (
    //     input WREADY,
    //     output WDATA, output WSTRB, output WLAST, output WVALID
    // );

    // modport DM (
    //     input WREADY,
    //     output WDATA, output WSTRB, output WLAST, output WVALID
    // );

    // modport DMA (
    //     input WREADY,
    //     output WDATA, output WSTRB, output WLAST, output WVALID
    // );

    // modport WDT (
    //     input WREADY,
    //     output WDATA, output WSTRB, output WLAST, output WVALID
    // );

    // modport DRAM (
    //     input WREADY,
    //     output WDATA, output WSTRB, output WLAST, output WVALID
    // );
endinterface //write data

interface B;
    logic [`AXI_ID_BITS-1:0] BID;
    logic [`AXI_IDS_BITS-1:0] BID_S;
	logic [1:0] BRESP;
	logic BVALID;
	logic BREADY;

    // modport M0 (
    //     input BREADY,
    //     output BID, output BRESP, output BVALID, output BREADY
    // );

    modport Master (
        input BREADY,
        output BID, output BRESP, output BVALID
    );

    // modport M2 (
    //     input BREADY,
    //     output BID, output BRESP, output BVALID
    // );

    modport Slave (
        input BID_S, input BRESP, input BVALID,
        output BREADY
    );

    // modport ROM (
    //     input BID_S, input BRESP, input BVALID,
    //     output BREADY
    // );

    // modport IM (
    //     input BID_S, input BRESP, input BVALID,
    //     output BREADY
    // );

    // modport DM (
    //     input BID_S, input BRESP, input BVALID,
    //     output BREADY
    // );

    // modport DMA (
    //     input BID_S, input BRESP, input BVALID,
    //     output BREADY
    // );

    // modport WDT (
    //     input BID_S, input BRESP, input BVALID,
    //     output BREADY
    // );

    // modport DRAM (
    //     input BID_S, input BRESP, input BVALID,
    //     output BREADY
    // );
endinterface //response

// interface fifo;
    
// endinterface //fifo