//--------------------------- Info ---------------------------//
    //Module Name :　WDT
    //Type        :   
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

//---------------------- Main code -------------------------//
//------------------------- FSM -------------------------//
  
  always_ff @( clock ) begin
    if () S_cur <=  INITIAL;
    else  S_cur <=  S_nxt;
  end

  always_comb begin
    case (param)
      : 
      default: 
    endcase
  end
//WTO
  always_ff @(posedege clk2) begin
    if (conditions) begin
      WTO   <=  1'b0;  
    end 
    else begin
      
    end
  end
  
  endmodule