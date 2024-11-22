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
      //
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
    
  //----------------------- Parameter -----------------------//   

    //DMA Signal
      logic         DMAEN;
      logic [31:0]  DMASRC;  
      logic [31:0]  DMADST;  
      logic [31:0]  DMALEN;      

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

    );

    DMA_Master DMA_Master_inst(
      
    );

    DMA DMA_inst(

    );


endmodule