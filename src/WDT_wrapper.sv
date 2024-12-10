//--------------------------- Info ---------------------------//
    //Module Name :　Watch Dog Timer Wrapper
    //INFO        :   clk (system clock)
    //                clk2(WDT clock) 
//----------------------- Environment -----------------------//
    `include "../include/CPU_define.svh"
    `include "WDT.sv"
//------------------------- Module -------------------------//
  module WDT_wrapper (
    //WDT Module
    input     clk,  rst,
    input     clk2, rst2,
    output    logic   WTO,
    //need to revise to interface
    //READ ADDRESS1
    // input [`AXI_IDS_BITS-1:0] 			  S_ARID,   
    // input [`AXI_ADDR_BITS-1:0] 			  S_ARAddr, 
    // input [`AXI_LEN_BITS-1:0] 			  S_ARLen,  
    // input [`AXI_SIZE_BITS-1:0] 			  S_ARSize, 
    // input [1:0] 						          S_ARBurst,
    // input 								            S_ARValid,
    // output logic 						          S_ARReady,

    // //READ DATA1  
    // output logic [`AXI_IDS_BITS-1:0]  S_RID,    
    // output logic [`AXI_DATA_BITS-1:0] S_RData,  
    // output logic [1:0] 					      S_RResp,  
    // output logic 						          S_RLast,  
    // output logic 						          S_RValid, 
    // input 								            S_RReady,

    // //WRITE ADDRESS
    // input [`AXI_IDS_BITS-1:0] 			  S_AWID,   
    // input [`AXI_ADDR_BITS-1:0] 			  S_AWAddr, 
    // input [`AXI_LEN_BITS-1:0] 			  S_AWLen,  
    // input [`AXI_SIZE_BITS-1:0] 			  S_AWSize, 
    // input [1:0] 						          S_AWBurst,
    // input 								            S_AWValid,
    // output logic 						          S_AWReady,
    
    // //WRITE DATA
    // input [`AXI_DATA_BITS-1:0] 			  S_WData,  
    // input [`AXI_STRB_BITS-1:0] 			  S_WStrb,  
    // input 								            S_WLast,  
    // input 								            S_WValid, 
    // output logic 						          S_WReady,
    
    // //WRITE RESPONSE
    // output logic [`AXI_IDS_BITS-1:0]  S_BID,
    // output logic [1:0] 					      S_BResp,
    // output logic 						          S_BValid,
    // input 								            S_BReady

    RA.Slave S_AR,
    R.Slave S_R, 
    WA.Slave S_AW,
    W.Slave S_W,
    B.Slave S_B
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
      logic   [`AXI_ADDR_BITS -1:0]  reg_ARAddr, reg_AWAddr; 
      logic   [`AXI_LEN_BITS -1:0]  reg_ARLen, reg_AWLen;
    //Last Signal
      logic   W_last, R_last;
    //Done Signal 
      logic   Raddr_done, Rdata_done, Waddr_done, Wdata_done, Wresp_done;
    //WDT Signal
      logic                WDEN;
      logic                WDLIVE;
      logic     [31:0]     WTOCNT;

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
      assign  W_last  = S_W.WLAST & Wdata_done;
      assign  R_last  = S_R.RLAST & Rdata_done;  
    //--------------------- Done Signal ---------------------//
      assign  Raddr_done  = S_AR.ARVALID & S_AR.ARREADY; 
      assign  Rdata_done  = S_R.RVALID  & S_R.RREADY;
      assign  Waddr_done  = S_AW.AWVALID & S_AW.AWREADY;
      assign  Wdata_done  = S_W.WVALID  & S_W.WREADY;
      assign  Wresp_done  = S_B.BVALID  & S_B.BREADY;
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
          else           reg_AWID     <=  (Waddr_done)  ? S_AW.AWID_S : reg_AWID;
        end   

        always_ff @(posedge clk or negedge rst) begin
          if(!rst)   reg_AWAddr   <=  `AXI_ADDR_BITS'd0;
          else           reg_AWAddr   <=  (Waddr_done)  ? S_AW.AWADDR : reg_AWAddr;
        end   
        
        always_ff @(posedge clk or negedge rst ) begin
          if(!rst)   reg_AWLen   <=  `AXI_LEN_BITS'd0;
          else           reg_AWLen   <=  (Waddr_done)  ? S_AW.AWLEN : reg_AWLen;
        end
        //awsize
        //awburst
        always_ff @(posedge clk or negedge rst) begin
          if(!rst) begin
            S_AW.AWREADY    <=   1'b0;
          end          
          else  begin
            case (S_cur)
              SADDR:      S_AW.AWREADY   <= (Waddr_done) ? 1'b0 : 1'b1;
              WRESP:      S_AW.AWREADY   <=   1'b0;  
              default:    S_AW.AWREADY   <=   1'b0;
            endcase
          end      
        end    
      //Data
        //Wdata(WDT)
        //Wstrb(MEM)
        //WLast(Last Signal)
        assign  S_W.WREADY  = (S_cur == WDATA)  ? 1'b1  : 1'b0;       
      //Resp
        assign  S_B.BID_S     = reg_AWID; 
        assign  S_BResp   = `AXI_RESP_OKAY;
        assign  S_B.BVALID  = (S_cur == WRESP)  ? 1'b1  : 1'b0;  
    //---------------------- R-channel ----------------------// 
      //Addr
        always_ff @(posedge clk or negedge rst) begin
          if(!rst) begin
            reg_ARID      <=  `AXI_IDS_BITS'd0;
            reg_ARAddr    <=  `AXI_ADDR_BITS'd0;
            reg_ARLen     <=  `AXI_LEN_BITS'd0;
          end          
          else  begin
            reg_ARID     <=  (Raddr_done)  ? S_AR.ARID_S : reg_ARID;
            reg_ARAddr   <=  (Raddr_done)  ? S_AR.ARADDR : reg_ARAddr;
            reg_ARLen    <=  (Raddr_done)  ? S_AR.ARLEN : reg_ARLen;
          end      
        end
        //Rsize
        //Rburst
        always_ff @(posedge clk or negedge rst) begin
          if(!rst) begin
            S_AR.ARREADY    <=   1'b0;
          end          
          else  begin
            case (S_cur)
              SADDR:      S_AR.ARREADY   <= (Raddr_done) ? 1'b0 : 1'b1;
              WRESP:      S_AR.ARREADY   <=   1'b0;  
              default:    S_AR.ARREADY   <=   1'b0;
            endcase
          end      
        end        
      //data
        assign  S_R.RID_S     = reg_ARID;
        //Data problem (need to solve)
        assign  S_R.RDATA   = 32'd0;

        assign  S_R.RRESP   = `AXI_RESP_OKAY;
        assign  S_R.RLAST   = ((cnt == reg_ARLen) && (S_cur == RDATA))  ? 1'b1  : 1'b0;    
        assign  S_R.RVALID  = (S_cur == RDATA)    ? 1'b1  : 1'b0;   
    //------------------------- WDT -------------------------//   
        always_ff @(posedge clk or negedge rst) begin
            if (!rst) begin
                WDEN    <=  1'b0;
                WDLIVE  <=  1'b0;
                WTOCNT  <=  32'd0;
            end 
            else if (Wdata_done) begin
                case (reg_AWAddr[15:0])
                16'h0100:   WDEN    <=  S_W.WDATA[0];
                16'h0200:   WDLIVE  <=  S_W.WDATA[0];
                16'h0300:   WTOCNT  <=  S_W.WDATA;
                endcase           
            end
        end

       logic WTO_clk2_result;
       logic WTO_clk1_result1, WTO_clk1_result2;
       logic WTOCNT_load;

        always_ff @(posedge clk or negedge rst) begin
            if(!rst)
              WTOCNT_load <=  1'b0;
            else begin
              if (Wdata_done && (reg_AWAddr[15:0] ==16'h0300)) begin
                WTOCNT_load <=  1'b1;               
              end 
              else begin
                WTOCNT_load <=  WTOCNT_load;                    
              end
            end
        end
        always_ff @(posedge clk or negedge rst) begin
            if (!rst) begin
                WTO_clk1_result1    <=  1'b0;
                WTO_clk1_result2    <=  1'b0;
            end 
            else begin
                WTO_clk1_result1    <=  WTO_clk2_result;
                WTO_clk1_result2    <=  WTO_clk1_result1;     
            end
        end
        
        assign WTO  =  WTO_clk1_result2;
        
        WDT WDT_inst(
            .clk(clk),      .rst(rst),
            .clk2(clk2),    .rst2(rst2),
            .WDEN   (WDEN),
            .WDLIVE (WDLIVE),
            .WTOCNT (WTOCNT),
            .WTO    (WTO_clk2_result),
            .WTOCNT_load (WTOCNT_load)
        );
    endmodule
