//--------------------------- Info ---------------------------//
    //Module Name :　 DMA
    //INFO        :   
    //                
//----------------------- Environment -----------------------//
    `include "DMA_Master.sv"
    `include "DMA_Slave.sv"    
//------------------------- Module -------------------------//
  module DMA (
    input clk, rst,
    input         DMAEN,
    input         DMASRC,
    input         DMADST,
    input         DMALEN,
    output logic  DMA_interrupt
  );
    
//---------------------- Main code -------------------------//
//-------------------- Slave (CPU2DMA) ---------------------//
    DMA_Slave DMA_Slave_inst(

    );

//-------------------- Master (CPU2S) ----------------------//
  //--------------------- Arbiter -------------------------//
    DMA_Master DMA_Master_inst(
      
    );



  endmodule
