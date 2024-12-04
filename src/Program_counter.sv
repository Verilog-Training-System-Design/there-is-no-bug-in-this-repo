module Program_counter (
    input clk,
    input reset,
    input Write_en,
    input [31:0] pc_in,
    input im_stall,
    input dm_stall,
    input CSR_interrupt,
    input [31:0] CSR_ISR_pc,
    input CSR_reset,
    input [31:0] CSR_retpc,
    input CSR_ret,
    input CSR_stall,

    output logic [31:0] pc_out 
);

logic ISR_reg, ISR_reg2;
logic ISR_reg_result;
assign ISR_reg_result = ISR_reg ^ CSR_interrupt;

always_ff @( posedge clk or negedge reset ) begin 
    if(~reset) begin
        ISR_reg <= 1'b0;
        ISR_reg2 <= 1'b0;
    end
    else if(CSR_interrupt)  begin
        ISR_reg <= CSR_interrupt; 
        ISR_reg2 <= ISR_reg;        
    end
    else begin
        ISR_reg  <= 1'b0;
        ISR_reg2 <= 1'b0;     
    end
end

always_ff @(posedge clk or negedge reset) begin
    if(~reset)
        pc_out <= 32'h0;
    else if(CSR_reset)
        pc_out <= 32'h0;
    else begin
        if(CSR_ret)
            pc_out <= CSR_retpc;
        else if(ISR_reg_result)
            pc_out <= CSR_ISR_pc;
        else if(Write_en & ~im_stall & ~dm_stall & ~CSR_stall)
            pc_out <= pc_in;
    end
end

endmodule
