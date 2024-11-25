//--------------------------- Info ---------------------------//
    //Module Name :　Watch Dog Timer
    //INFO        :   clk (system clock)
    //                clk2(WDT clock) 
//----------------------- Environment -----------------------//

//------------------------- Module -------------------------//
  module WDT (
    input     clk,  rst,
    input     clk2, rst2,
    input     WDEN,
    input     WDLIVE,
    input     [31:0]  WTOCNT,
    output    logic   WTO
  );
  
//---------------------- parameter -------------------------//
  logic     [1:0] S_cur, S_nxt;
  parameter [1:0] INITIAL     = 2'b00,
                  CNTDOWN     = 2'b01,
                  RSTCNT      = 2'b10,
                  TIMEOUT     = 2'b11;
  logic             CNT_EXCEED;
  logic     [31:0]  WDT_CNT;
  //CDC_single bit
  logic     reg_clk1_WDEN, reg_clk1_WDLIVE;   
  logic     reg_clk2_WDLIVE_1, reg_clk2_WDLIVE_2;        
  logic     reg_clk2_WDEN_1, reg_clk2_WDEN_2; 
  //CDC_multi bit
  logic     [31:0]  reg_clk1_WTOCNT;
  logic     [31:0]  reg_clk2_WTOCNT_1;
  logic     [31:0]  reg_clk2_WTOCNT_2;

//---------------------- Main code -------------------------//
//----------- CDC Problem for clk1 input signal ------------//
  //WDLIVE/Enable- clock1 flop
    always_ff @(posedge clk) begin
      if(rst)
        reg_clk1_WDLIVE <=  1'b0;
        reg_clk1_WDEN   <=  1'b0;
      else
        reg_clk1_WDLIVE <=  WDLIVE;
        reg_clk1_WDEN   <=  WDEN;        
    end
  //WDLIVE/Enable- clock2 flop (WDLIVE 是否需要每次都變化都同步)
    always_ff @(posedge clk2) begin
      if(rst2) begin
        reg_clk2_WDLIVE_1 <=  1'b0;  
        reg_clk2_WDLIVE_2 <=  1'b0;
        reg_clk2_WDEN_1   <=  1'b0;  
        reg_clk2_WDEN_2   <=  1'b0;
      end
      else begin
        reg_clk2_WDLIVE_1 <=  reg_clk1_WDLIVE;  
        reg_clk2_WDLIVE_2 <=  reg_clk2_WDLIVE_1; 
        reg_clk2_WDEN_1   <=  reg_clk1_WDEN;  
        reg_clk2_WDEN_2   <=  reg_clk2_WDEN_1;       
      end
    end
  //WTOCNT(mult bit syn problem, method 2, no load signal & feedback)
    always_ff @(posedge clk) begin
      if(rst)
        reg_clk1_WTOCNT <=  32'd0;
      else
        reg_clk1_WTOCNT <=  WTOCNT;
    end

    always_ff @(posedge clk2) begin
      if(rst2) begin
        reg_clk2_WTOCNT_1 <=  32'd0;  
        reg_clk2_WTOCNT_2 <=  32'd0;
      end
      else begin
        reg_clk2_WTOCNT_1 <=  reg_clk1_WTOCNT;  
        reg_clk2_WTOCNT_2 <=  reg_clk2_WDLIVE_1;        
      end
    end
//------------------------- FSM -------------------------//
  always_ff @(posedge clk2) begin
    if (rst2)   S_cur <=  INITIAL;
    else        S_cur <=  S_nxt;
  end

  always_comb begin
    case (S_cur)
      INITIAL: begin 
        if(reg_clk2_WDEN_2)         S_nxt = CNTDOWN;//Wait for enable
        else if (reg_clk2_WDLIVE_2) S_nxt = RSTCNT;
        else                        S_nxt = INITIAL;
      end
      CNTDOWN: begin
        if(CNT_EXCEED)       S_nxt = TIMEOUT;
        else                 S_nxt = CNTDOWN;        
      end
      RSTCNT: begin
        S_nxt = INITIAL;        
      end
      TIMEOUT:  begin
        S_nxt = INITIAL;          
      end
      default:    S_nxt = INITIAL; //WDT_CNT
    endcase
  end

//-------------------Count Down module---------------------//
    assign  CNT_EXCEED  = ((S_cur == CNTDOWN) && (WDT_CNT == 0)) ? 1'b1 : 1'b0;
  //------------------------- CNT -------------------------//
    always_ff @(posedge clk2) begin
      if (rst2)
        WDT_CNT <=  32'd0;
      else begin
        case (s_cur)
          INITIAL: WDT_CNT <=  reg_clk2_WTOCNT_2;
          CNTDOWN: WDT_CNT <=  WTOCNT - 32'd1;
          RSTCNT:  WDT_CNT <=  32'd0;
          default: WDT_CNT <=  WDT_CNT;
        endcase
      end 
    end

  //------------------------- WTO -------------------------//
    always_ff @(posedge clk2) begin
      if (rst2) begin
        WTO   <=  1'b0;  
      end 
      else if (S_cur == WDT_OUT)
        WTO   <=  1'b1;
      else
        WTO   <=  1'b0;
    end
  
  endmodule