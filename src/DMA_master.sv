//--------------------------- Info ---------------------------//
    //Module Name :   DMA_master
    //INFO        :   

//----------------------- Environment -----------------------//

//------------------------- Module -------------------------//
  module DMA_master (
      input         clk, rst,
    //DMA port 


    //AXI Waddr
      output  logic   [`AXI_ID_BITS -1:0]     M_AWID,    
      output  logic   [`AXI_ADDR_BITS -1:0]   M_AWAddr,  
      output  logic   [`AXI_LEN_BITS -1:0]    M_AWLen,   
      output  logic   [`AXI_SIZE_BITS -1:0]   M_AWSize,  
      output  logic   [1:0]                   M_AWBurst, 
      output  logic                           M_AWValid, 
      input                                   M_AWReady,
    //AXI Wdata     
      output  logic   [`AXI_DATA_BITS -1:0]   M_WData,   
      output  logic   [`AXI_STRB_BITS -1:0]   M_WStrb,   
      output  logic                           M_WLast,   
      output  logic                           M_WValid,  
      input                                   M_WReady,
    //AXI Wresp
      input         [`AXI_ID_BITS -1:0]       M_BID,
      input         [1:0]                     M_BResp,
      input                                   M_BValid,
      output  logic                           M_BReady,                   
    //AXI Raddr
      output  logic   [`AXI_ID_BITS -1:0]     M_ARID,    
      output  logic   [`AXI_ADDR_BITS -1:0]   M_ARAddr,  
      output  logic   [`AXI_LEN_BITS -1:0]    M_ARLen,   
      output  logic   [`AXI_SIZE_BITS -1:0]   M_ARSize,  
      output  logic   [1:0]                   M_ARBurst, 
      output  logic                           M_ARValid, 
      input                                   M_ARReady,
    //AXI Rdata   
      input           [`AXI_ID_BITS   -1:0]   M_RID,         
      input           [`AXI_DATA_BITS -1:0]   M_RData,   
      input           [1:0]                   M_RResp,   
      input                                   M_RLast,   
      input                                   M_RValid,  
      output  logic                           M_RReady
  );
    
  endmodule

