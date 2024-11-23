//--------------------------- Info ---------------------------//
    //Module Name :　DMA Wrapper
    //INFO        :  
//----------------------- Environment -----------------------//
    `include "DMA_slave.sv"
    `include "DMA_master.sv"
    `include "DMA.sv"
//------------------------- Module -------------------------//
    module DMA_wrapper (
        input   clk, rst,
      //Slave port
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
        input 								BREADY_S,
      //Master port    
      //WRITE ADDRESS
        output logic [`AXI_ID_BITS-1:0]         AWID_M2        ,
        output logic [`AXI_ADDR_BITS-1:0]       AWADDR_M2      ,
        output logic [`AXI_LEN_BITS-1:0]        AWLEN_M2       ,
        output logic [`AXI_SIZE_BITS-1:0]       AWSIZE_M2      ,
        output logic [1:0]                      AWBURST_M2     ,
        output logic                            AWVALID_M2     ,
        input                                   AWREADY_M2     ,  
      //WRITE DATA
        output logic [`AXI_DATA_BITS-1:0]       WDATA_M2       ,
        output logic [`AXI_STRB_BITS-1:0]       WSTRB_M2       ,
        output logic                            WLAST_M2       ,
        output logic                            WVALID_M2      ,
        input                                   WREADY_M2      ,  
      //WRITE RESPONSE
        input [`AXI_ID_BITS-1:0]                BID_M2         ,
        input [1:0]                             BRESP_M2       ,
        input                                   BVALID_M2      ,
        output logic                            BREADY_M2      ,  
      //READ ADDRESS1
        output logic [`AXI_ID_BITS-1:0]         ARID_M2        ,
        output logic [`AXI_ADDR_BITS-1:0]       ARADDR_M2      ,
        output logic [`AXI_LEN_BITS-1:0]        ARLEN_M2       ,
        output logic [`AXI_SIZE_BITS-1:0]       ARSIZE_M2      ,
        output logic [1:0]                      ARBURST_M2     ,
        output logic                            ARVALID_M2     ,
        input                                   ARREADY_M2     ,  
      //READ DATA1
        input [`AXI_ID_BITS-1:0]                RID_M2         ,
        input [`AXI_DATA_BITS-1:0]              RDATA_M2       ,
        input [1:0]                             RRESP_M2       ,
        input                                   RLAST_M2       ,
        input                                   RVALID_M2      ,
        output logic                            RREADY_M2      ,
      //DMA Interrupt
        output logic                            DMA_interrupt        
    );
    
  //----------------------- Parameter -----------------------//   
    //DMA slave -> DMA
      logic         w_DMAEN;
      logic [31:0]  w_DMASRC;  
      logic [31:0]  w_DMADST;  
      logic [31:0]  w_DMALEN;      

  //----------------------- DMA -------------------------//
    //Signal Decoding
    always_ff @(posedge clk) begin
        if (rst) begin
            DMAEN   <=  1'b0;
            DMASRC  <=  32'd0;
            DMADST  <=  32'd0;
            DMALEN  <=  32'd0;
        end 
        else if (WVALID_S) begin
            case (reg_AWAddr[15:0])
            16'h0100:   DMAEN   <=  WDATA_S[0];
            16'h0200:   DMASRC  <=  WDATA_S;
            16'h0300:   DMADST  <=  WDATA_S; 
            16'h0400:   DMALEN  <=  WDATA_S;
            endcase           
        end
    end

    DMA_Slave DMA_Slave_inst(
        .clk(), .rst(),
      //
        .S_AWID     (),  
        .S_AWAddr   (),
        .S_AWLen    (), 
        .S_AWSize   (),
        .S_AWBurst  (),
        .S_AWValid  (),
        .S_AWReady  (),
      //
        .S_WData    (), 
        .S_WStrb    (), 
        .S_WLast    (), 
        .S_WValid   (),
        .S_WReady   (),
      //
        .S_BID      (),
        .S_BResp    (),
        .S_BValid   (),
        .S_BReady   (),
      //
        .S_ARID     (),  
        .S_ARAddr   (),
        .S_ARLen    (), 
        .S_ARSize   (),
        .S_ARBurst  (),
        .S_ARValid  (),
        .S_ARReady  (),
      //AXI Rdata          
        .S_RID      (),   
        .S_RData    (), 
        .S_RResp    (), 
        .S_RLast    (), 
        .S_RValid   (),
        .S_RReady   (),
      //to DMA
        .DMAEN      (w_DMAEN ),
        .DMASRC     (w_DMASRC),
        .DMADST     (w_DMADST),
        .DMALEN     (w_DMALEN)
    );


    //use Master.sv
    DMA_Master DMA_Master_inst(
        .clk(), .rst(),
      //  
        .M_AWID     (AWID_M2   ),  
        .M_AWAddr   (AWADDR_M2 ),
        .M_AWLen    (AWLEN_M2  ), 
        .M_AWSize   (AWSIZE_M2 ),
        .M_AWBurst  (AWBURST_M2),
        .M_AWValid  (AWVALID_M2),
        .M_AWReady  (AWREADY_M2),
      //
        .M_WData    (WDATA_M2  ), 
        .M_WStrb    (WSTRB_M2  ), 
        .M_WLast    (WLAST_M2  ), 
        .M_WValid   (WVALID_M2 ),
        .M_WReady   (WREADY_M2 ),
      //
        .M_BID      (BID_M2    ),
        .M_BResp    (BRESP_M2  ),
        .M_BValid   (BVALID_M2 ),
        .M_BReady   (BREADY_M2 ),
      //
        .M_ARID     (ARID_M2   ),  
        .M_ARAddr   (ARADDR_M2 ),
        .M_ARLen    (ARLEN_M2  ), 
        .M_ARSize   (ARSIZE_M2 ),
        .M_ARBurst  (ARBURST_M2),
        .M_ARValid  (ARVALID_M2),
        .M_ARReady  (ARREADY_M2),
      //
        .M_RID      (RID_M2    ),   
        .M_RData    (RDATA_M2  ), 
        .M_RResp    (RRESP_M2  ), 
        .M_RLast    (RLAST_M2  ), 
        .M_RValid   (RVALID_M2 ),
        .M_RReady   (RREADY_M2 ),

        .Data_in    (),
        .Data_out   ()
    );

    DMA DMA_inst(
        .clk(), .rst(),        
        .DMAEN      (w_DMAEN ),
        .DMASRC     (w_DMASRC),
        .DMADST     (w_DMADST),
        .DMALEN     (w_DMALEN)
    );


endmodule