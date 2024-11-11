module Regfile (
    input clk,
    input reset,
    input [4:0] rd_reg1_addr,
    input [4:0] rd_reg2_addr,
    input [4:0] w_reg_addr,
    input [31:0] w_data,
    input RegWrite,

    output [31:0] rd_reg1_data,
    output [31:0] rd_reg2_data
);

logic [31:0] register [31:0];
integer i;

always_ff @(posedge clk or negedge reset) begin
    if(~reset)begin
        for(i=0 ; i<32 ; i=i+1)
            register[i] <= 32'h0;
    end 
    else if(RegWrite && (w_reg_addr != 5'd0)) begin
        register[w_reg_addr] <= w_data;
    end
end

assign rd_reg1_data = register[rd_reg1_addr];
assign rd_reg2_data = register[rd_reg2_addr];

endmodule