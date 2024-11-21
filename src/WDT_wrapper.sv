//--------------------------- Info ---------------------------//
    //Module Name :　Watch Dog Timer Wrapper
    //INFO        :   clk (system clock)
    //                clk2(WDT clock) 
//----------------------- Environment -----------------------//

//------------------------- Module -------------------------//
  module WDT_wrapper (
    //WDT Module
    input     clk,  rst,
    input     clk2, rst2,
    output    logic   WTO,
    //need to revise to interface
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
    //FSM
      logic     [1:0] S_nxt;
      parameter [1:0]   SADDR     = 2'd0,
                        RDATA     = 2'd1,
                        WDATA     = 2'd2,
                        WRESP     = 2'd3;
    //CNT
      logic   [`AXI_LEN_BITS -1:0]  cnt;
    //Data register
      logic   [`AXI_IDS_BITS -1:0]  reg_ARID , reg_AWID;
      logic   [`MEM_ADDR_LEN -1:0]  reg_ARAddr, reg_AWAddr; 
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
      always_ff @(posedge ACLK ) begin
          if(!ARESETn)   S_cur <=  SADDR;
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
          default:  S_nxt  = SADDR;
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
        always_ff @(posedge ACLK) begin
          if (!ARESETn) begin
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
        always_ff @(posedge ACLK) begin
          if(!ARESETn)   reg_AWID     <=  `MEM_ADDR_LEN'd0;
          else           reg_AWID     <=  (Waddr_done)  ? S_AWID : reg_AWID;
        end   

        always_ff @(posedge ACLK) begin
          if(!ARESETn)   reg_AWAddr   <=  `MEM_ADDR_LEN'd0;
          else           reg_AWAddr   <=  (Waddr_done)  ? S_AWAddr[15:2] : reg_AWAddr;
        end   
        
        always_ff @(posedge ACLK ) begin
          if(!ARESETn)   reg_AWLen   <=  `AXI_LEN_BITS'd0;
          else           reg_AWLen   <=  (Waddr_done)  ? S_AWLen : reg_AWLen;
        end
        //awsize
        //awburst
        always_ff @(posedge ACLK) begin
          if(!ARESETn) begin
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
        //Wdata(WDT)
        //Wstrb(MEM)
        //WLast(Last Signal)
        assign  S_WReady  = (S_cur == WDATA)  ? 1'b1  : 1'b0;       
      //Resp
        assign  S_BID     = reg_AWID; 
        assign  S_BResp   = `AXI_RESP_OKAY;
        assign  S_BValid  = (S_cur == WRESP)  ? 1'b1  : 1'b0;  
    //---------------------- R-channel ----------------------// 
      //Addr
        always_ff @(posedge ACLK) begin
          if(!ARESETn) begin
            reg_ARID      <=  `AXI_IDS_BITS'd0;
            reg_ARAddr    <=  `MEM_ADDR_LEN'd0;
            reg_ARLen     <=  `AXI_LEN_BITS'd0;
          end          
          else  begin
            reg_ARID     <=  (Raddr_done)  ? S_ARID : reg_ARID;
            reg_ARAddr   <=  (Raddr_done)  ? S_ARAddr[15:2] : reg_ARAddr;
            reg_ARLen    <=  (Raddr_done)  ? S_ARLen : reg_ARLen;
          end      
        end
        //Rsize
        //Rburst
        always_ff @(posedge ACLK) begin
          if(!ARESETn) begin
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
        assign  S_RData   = DO;

        assign  S_RResp   = `AXI_RESP_OKAY;
        assign  S_RLast   = (cnt == reg_ARLen)  ? 1'b1  : 1'b0;    
        assign  S_RValid  = (S_cur == RDATA)    ? 1'b1  : 1'b0;   
    //------------------------- WDT -------------------------//   
        always_ff @(posedge clk) begin
            if (rst) begin
                WDEN    <=  1'b0;
                WDLIVE  <=  1'b0;
                WTOCNT  <=  32'd0;
            end 
            else if (WVALID_S) begin
                case (reg_AWAddr[15:0])
                16'h0100:   WDEN    <=  WDATA_S[0];
                16'h0200:   WDLIVE  <=  WDATA_S[0];
                16'h0300:   WTOCNT  <=  WDATA_S;
                endcase           
            end
        end

        WDT WDT_inst(
            .clk(clk),      .rst(rst),
            .clk2(clk2),    .rst2(rst2),
            .WDEN   (WDEN),
            .WDLIVE (WDLIVE),
            .WTOCNT (WTOCNT),
            .WTO    (WTO)
        );
    endmodule
