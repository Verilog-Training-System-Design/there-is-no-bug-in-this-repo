//--------------------------- Info ---------------------------//
    //Module Name :   DMA_slave
    //INFO        :   

//----------------------- Environment -----------------------//

//------------------------- Module -------------------------//
  module DMA_slave (
      input              clk  ,rst,
    //AXI Waddr
      input  [`AXI_IDS_BITS -1:0]         S_AWID,    
      input  [`AXI_ADDR_BITS -1:0]        S_AWAddr,  
      input  [`AXI_LEN_BITS -1:0]         S_AWLen,   
      input  [`AXI_SIZE_BITS -1:0]        S_AWSize,  
      input  [1:0]                        S_AWBurst, 
      input                               S_AWValid, 
      output  logic                       S_AWReady,
    //AXI Wdata     
      input  [`AXI_DATA_BITS -1:0]        S_WData,   
      input  [`AXI_STRB_BITS -1:0]        S_WStrb,   
      input                               S_WLast,   
      input                               S_WValid,  
      output  logic                       S_WReady,
    //AXI Wresp
      output  logic [`AXI_IDS_BITS -1:0]  S_BID,
      output  logic [1:0]                 S_BResp,
      output  logic                       S_BValid,
      input                               S_BReady,           
    //AXI Raddr
      input  [`AXI_IDS_BITS -1:0]         S_ARID,    
      input  [`AXI_ADDR_BITS -1:0]        S_ARAddr,  
      input  [`AXI_LEN_BITS -1:0]         S_ARLen,   
      input  [`AXI_SIZE_BITS -1:0]        S_ARSize,  
      input  [1:0]                        S_ARBurst, 
      input                               S_ARValid, 
      output  logic                       S_ARReady,
    //AXI Rdata   
      output  logic [`AXI_IDS_BITS  -1:0] S_RID,         
      output  logic [`AXI_DATA_BITS -1:0] S_RData,   
      output  logic [1:0]                 S_RResp,   
      output  logic                       S_RLast,   
      output  logic                       S_RValid,  
      input                               S_RReady,
    //to DMA
      output  logic                       DMAEN,
      output  logic [`AXI_DATA_BITS -1:0] DMASRC,
      output  logic [`AXI_DATA_BITS -1:0] DMADST,
      output  logic [`AXI_DATA_BITS -1:0] DMALEN
  );

  //----------------------- Parameter -----------------------//
    //FSM
      logic     [1:0] S_cur, S_nxt;
      parameter [1:0]   SADDR     = 2'd0,
                        RDATA     = 2'd1,
                        WDATA     = 2'd2,
                        WRESP     = 2'd3;
    //CNT
      logic   [`AXI_LEN_BITS -1:0]  cnt;
    //Data register
      logic   [`AXI_IDS_BITS -1:0]  reg_ARID , reg_AWID;
      //logic   [`MEM_ADDR_LEN -1:0]  reg_ARAddr, reg_AWAddr; 
      logic   [31:0]  reg_ARAddr, reg_AWAddr; 
      logic   [`AXI_LEN_BITS -1:0]  reg_ARLen, reg_AWLen;
    //Last Signal
      logic   W_last, R_last;
    //Done Signal 
      logic   Raddr_done, Rdata_done, Waddr_done, Wdata_done, Wresp_done;

  //----------------------- Main Code -----------------------//
    //------------------------- FSM -------------------------//
      always_ff @(posedge clk or negedge rst ) begin
          if(!rst)   S_cur <=  SADDR;
          else          S_cur <=  S_nxt;
      end

      always_comb begin
        case (S_cur)
          SADDR:  begin
            if (Waddr_done) begin
              S_nxt = WDATA;
            end
            else if (Raddr_done) begin
              S_nxt = RDATA; 
            end
            else begin
              S_nxt = SADDR;            
            end
          end          
          //S_nxt  = (Raddr_done) ? RDATA   : RADDR; 
          RDATA:  S_nxt  = (R_last)     ? SADDR   : RDATA; 
          WDATA:  S_nxt  = (W_last)     ? WRESP   : WDATA; 
          WRESP:  S_nxt  = (Wresp_done) ? SADDR   : WRESP; 
          // default:  S_nxt  = SADDR;
        endcase
      end 
    //--------------------- Last Signal ---------------------//  
      assign  W_last  = S_WLast & Wdata_done;
      assign  R_last  = S_RLast & Rdata_done;  
    //--------------------- Done Signal ---------------------//
      assign  Raddr_done  = S_ARValid & S_ARReady; 
      assign  Rdata_done  = S_RValid  & S_RReady;
      assign  Waddr_done  = S_AWValid & S_AWReady;
      assign  Wdata_done  = S_WValid  & S_WReady;
      assign  Wresp_done  = S_BValid  & S_BReady;
    //------------------------- CNT -------------------------//
        always_ff @(posedge clk or negedge rst) begin
          if (!rst) begin
            cnt   <=  `AXI_LEN_BITS'd0;
          end 
          else begin
            if(R_last || W_last)  begin
              cnt   <=  `AXI_LEN_BITS'd0;            
            end
            else if (Rdata_done || Wdata_done) begin
              cnt   <=  cnt + `AXI_LEN_BITS'd1;            
            end
            else  begin
              cnt   <=  cnt;
            end
          end
        end
    //----------------- W-channel (priority) -----------------//
      //Addr
        always_ff @(posedge clk or negedge rst) begin
          if(!rst)   reg_AWID     <=  `AXI_IDS_BITS'd0;
          else      reg_AWID     <=  (Waddr_done)  ? S_AWID : reg_AWID;
        end   

        always_ff @(posedge clk or negedge rst) begin
          if(!rst)   reg_AWAddr   <=  `AXI_ADDR_BITS'd0;
          else      reg_AWAddr   <=  (Waddr_done)  ? S_AWAddr : reg_AWAddr;
        end   
        
        always_ff @(posedge clk or negedge rst ) begin
          if(!rst)   reg_AWLen   <=  `AXI_LEN_BITS'd0;
          else      reg_AWLen   <=  (Waddr_done)  ? S_AWLen : reg_AWLen;
        end
        //awsize
        //awburst
        always_ff @(posedge clk or negedge rst) begin
          if(!rst) begin
            S_AWReady    <=   1'b0;
          end          
          else  begin
            case (S_cur)
              SADDR:      S_AWReady   <= (Waddr_done) ? 1'b0 : 1'b1;
              WRESP:      S_AWReady   <=   1'b0;  
              default:    S_AWReady   <=   1'b0;
            endcase
          end      
        end    
      //Data
        //Wdata(MEM)
        //Wstrb(MEM)
        //WLast(Last Signal)
        assign  S_WReady  = (S_cur == WDATA)  ? 1'b1  : 1'b0;       
      //Resp
        assign  S_BID     = reg_AWID; 
        assign  S_BResp   = `AXI_RESP_OKAY;
        assign  S_BValid  = (S_cur == WRESP)  ? 1'b1  : 1'b0;  
    //---------------------- R-channel ----------------------// 
      //Addr
        always_ff @(posedge clk or negedge rst) begin
          if(!rst) begin
            reg_ARID      <=  `AXI_IDS_BITS'd0;
            reg_ARAddr    <=  `AXI_ADDR_BITS'd0;
            reg_ARLen     <=  `AXI_LEN_BITS'd0;
          end          
          else  begin
            reg_ARID     <=  (Raddr_done)  ? S_ARID : reg_ARID;
            reg_ARAddr   <=  (Raddr_done)  ? S_ARAddr : reg_ARAddr;
            reg_ARLen    <=  (Raddr_done)  ? S_ARLen : reg_ARLen;
          end      
        end
        //Rsize
        //Rburst
        always_ff @(posedge clk or negedge rst) begin
          if(!rst) begin
            S_ARReady    <=   1'b0;
          end          
          else  begin
            case (S_cur)
              SADDR:      S_ARReady   <= (Raddr_done) ? 1'b0 : 1'b1;
              WRESP:      S_ARReady   <=   1'b0;  
              default:    S_ARReady   <=   1'b0;
            endcase
          end      
        end        
      //data
        assign  S_RID     = reg_ARID;
        //Data problem (need to solve)
        assign  S_RData   = 32'd0;

        assign  S_RResp   = `AXI_RESP_OKAY;
        assign  S_RLast   = ((cnt == reg_ARLen) & (S_cur == RDATA))  ? 1'b1  : 1'b0;    
        assign  S_RValid  = (S_cur == RDATA)    ? 1'b1  : 1'b0; 

    //------------------------ DMA --------------------------//
    //Signal Decoding
        always_ff @(posedge clk or negedge rst) begin
            if (!rst) begin
                DMAEN   <=  1'b0;
                DMASRC  <=  32'd0;
                DMADST  <=  32'd0;
                DMALEN  <=  32'd0;
            end 
            else if (Wdata_done) begin
                case (reg_AWAddr[15:0])
                16'h0100:   DMAEN   <=  S_WData[0];
                16'h0200:   DMASRC  <=  S_WData;
                16'h0300:   DMADST  <=  S_WData; 
                16'h0400:   DMALEN  <=  S_WData;
                endcase           
            end
        end
  endmodule