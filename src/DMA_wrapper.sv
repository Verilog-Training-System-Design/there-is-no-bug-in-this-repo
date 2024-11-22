//--------------------------- Info ---------------------------//
    //Module Name :　DMA Wrapper
    //INFO        :  
//----------------------- Environment -----------------------//
    `include "DMA_slave.sv"
    `include "DMA_master.sv"
    `include "DMA.sv"
//------------------------- Module -------------------------//
    module DMA_wrapper (
        ports
    );
    
  //----------------------- DMA -------------------------//



   DMA DMA_inst(

    );


endmodule