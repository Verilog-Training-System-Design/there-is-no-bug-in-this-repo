//--------------------------- Info ---------------------------//
    //Module Name :　 DMA
    //INFO        :   slave FSM
    //                master FSM
//----------------------- Environment -----------------------//
    `include "DMA_Master.sv"
    `include "DMA_Slave.sv"    
//------------------------- Module -------------------------//
  module DMA (
      input clk, rst,
    //from (CPU) DMA slave
      input         DMAEN,
      input  [31:0] DMASRC,
      input  [31:0] DMADST,
      input  [31:0] DMALEN,
      output logic  DMA_interrupt
  );

//---------------------- Parameter -------------------------//
    logic     [:0]  S_S_cur, S_S_nxt;
    parameter       S_IDLE    = 3'd0,
                    ;

    logic     [:0]  M_S_cur, M_S_nxt;
    parameter       M_IDLE    = 3'd0,
                    M_CHECK;

    logic           remaind_data = ;

//---------------------- Main code -------------------------//
  //--------------- CPU control signal reg -----------------//
    reg_dma_en

  //-------------------Slave FSM -------------------------//
    always_ff @(posedege clk) begin
      if (rst)  S_S_cur <=  IDLE;
      else      S_S_cur <=  S_S_nxt;
    end

    always_comb begin
      
    end





  //-------------------Master FSM -------------------------//
    always_ff @(posedege clk) begin
      if (rst)  M_S_cur <=  IDLE;
      else      M_S_cur <=  M_S_nxt;
    end

    always_comb begin
      case (M_S_cur)
        M_IDLE: M_S_nxt = (reg_dma_en) ? : M_IDLE;

        default: 
      endcase
    end


  endmodule
