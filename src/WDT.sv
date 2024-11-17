//--------------------------- Info ---------------------------//
    //Module Name :　WDT
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
  parameter [1:0] INITIAL = 2'b00,
                  2'b01,
                  2'b10,
                  2'b11;


  logic     [31:0]  WDT_CNT;

//---------------------- Main code -------------------------//
//------------------------- FSM -------------------------//
  
  always_ff @( clock ) begin
    if () S_cur <=  INITIAL;
    else  S_cur <=  S_nxt;
  end

  always_comb begin
    case ()
      : 
      default: 
    endcase
  end

//-------------------Count Down module---------------------//
  //------------------------- CNT -------------------------//
    always_ff @(posedege clk2) begin
      if (rst2 || WDLIVE)
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
      else if (WDT_CNT == 32'd0)
        WTO   <=  1'b1;
      else
        WTO   <=  1'b0;
    end
  
  endmodule