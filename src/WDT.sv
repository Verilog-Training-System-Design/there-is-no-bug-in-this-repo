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
                  ENABLE      = 2'b01,
                  START_CNT_D = 2'b10,
                  WDT_OUT     = 2'b11;
  //CDC
  logic    reg_clk1_WDLIVE;   
  logic    reg_clk2_WDLIVE_1, reg_clk2_WDLIVE_2;        

  logic     [31:0]  WDT_CNT;

//---------------------- Main code -------------------------//
//----------- CDC Problem for clk1 input signal ------------//
  //WDLIVE- clock1 flop
    always_ff @(posedege clk) begin
      if(rst)
        reg_clk1_WDLIVE <=  1'b0;
      else
        reg_clk1_WDLIVE <=  WDLIVE;
    end
  //WDLIVE- clock2 flop (WDLIVE 是否需要每次都變化都同步)
    always_ff @(posedege clk2) begin
      if(rst2) begin
        reg_clk2_WDLIVE_1 <=  1'b0;  
        reg_clk2_WDLIVE_2 <=  1'b0;
      end
      else begin
        reg_clk2_WDLIVE_1 <=  reg_clk1_WDLIVE;  
        reg_clk2_WDLIVE_2 <=  reg_clk2_WDLIVE_1;        
      end
    end
  //WTOCNT

//------------------------- FSM -------------------------//
  always_ff @(posedege clk2) begin
    if (rst2)   S_cur <=  INITIAL;
    else        S_cur <=  S_nxt;
  end

  always_comb begin
    case (S_cur)
      INITIAL: begin
        if(WDEN)  S_nxt = ENABLE;
        else      S_nxt = INITIAL;
      end
      ENABLE: begin
        
      end
      START_CNT_D: begin
        
      end
      default:    S_nxt = INITIAL; //WDT_CNT
    endcase
  end

//-------------------Count Down module---------------------//
  //------------------------- CNT -------------------------//
    always_ff @(posedege clk2) begin
      if (rst2 || reg_clk2_WDLIVE_2)
        WDT_CNT <=  32'd0;  
      else if (WDEN)
        WDT_CNT <=  WTOCNT;
      else
        WDT_CNT <=  WDT_CNT - 32'd1;    
    end

  //------------------------- WTO -------------------------//
    always_ff @(posedege clk2) begin
      if (rst2) begin
        WTO   <=  1'b0;  
      end 
      else if (S_cur == WDT_OUT)
        WTO   <=  1'b1;
      else
        WTO   <=  1'b0;
    end
  
  endmodule