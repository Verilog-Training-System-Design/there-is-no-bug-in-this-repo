module Regfile_f (
    input clk,
    input reset,
    input [4:0] frd_reg1_addr,
    input [4:0] frd_reg2_addr,
    input [4:0] w_freg_addr,
    input [31:0] w_f_data,
    input RegWrite_f,

    output [31:0] frd_reg1_data,
    output [31:0] frd_reg2_data
);

logic [31:0] float_register [31:0];
integer i;

always_ff @(posedge clk or negedge reset) begin
    if(~reset)begin
        for(i=0 ; i<32 ; i=i+1)
            float_register[i] <= 32'h0;
    end 
    else if(RegWrite_f) begin
        float_register[w_freg_addr] <= w_f_data;
    end
end

assign frd_reg1_data = float_register[frd_reg1_addr];
assign frd_reg2_data = float_register[frd_reg2_addr];

endmodule