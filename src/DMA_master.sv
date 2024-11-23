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

  //----------------------- Parameter -----------------------//
    //FSM
    logic   [2:0] S_cur, S_nxt;
    parameter   INITIAL   = 3'd0,
                RADDR     = 3'd1,
                RDATA     = 3'd2,
                WADDR     = 3'd3,
                WDATA     = 3'd4,
                WRESP     = 3'd5;

  //----------------------- Main Code -----------------------//
    //------------------------- FSM -------------------------//
      always_ff @(posedge ACLK) begin
          if(!ARESETn)
              S_cur   = INITIAL;
          else
              S_cur   = S_nxt;
      end

      always_comb begin
        case (S_cur)
          INITIAL:  begin
            if(Start_burst_read) begin
              S_nxt   = RADDR;
            end
            else if  (Start_burst_write) begin
              S_nxt   = WADDR;           
            end
            else begin
              S_nxt   = INITIAL;
            end
          end
          RADDR:  S_nxt  = (Raddr_done) ? RDATA   : RADDR; 
          RDATA:  begin
            if(reg_Rvalid_both)  
              S_nxt  = (M_RLast_h1) ? INITIAL : RDATA; 
            else
              S_nxt  = (R_last) ? INITIAL : RDATA;
          end
          WADDR:  S_nxt  = (Waddr_done) ? WDATA   : WADDR; 
          WDATA: 
              S_nxt  = (W_last)     ? WRESP   : WDATA;                

          WRESP:  begin
            if(reg_R_W_both)  
              S_nxt  = (M_RLast_h1) ? INITIAL : WRESP; 
            else 
              S_nxt  = (Wresp_done) ? INITIAL : WRESP;
          end 
          default:  S_nxt  = INITIAL;
        endcase
      end



  endmodule

