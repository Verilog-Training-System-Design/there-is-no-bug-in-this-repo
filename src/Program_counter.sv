module Program_counter (
    input clk,
    input reset,
    input Write_en,
    input [31:0] pc_in,
    input im_stall,
    input dm_stall,
    input [31:0] CSR_ISR_pc,
    input CSR_reset,
    input [31:0] CSR_retpc,
    input CSR_ret,

    output logic [31:0] pc_out 
);

always_ff @(posedge clk or negedge reset) begin
    if(~reset)
        pc_out <= 32'h0;
    else begin
        if(CSR_reset)
            pc_out <= CSR_retpc;
        else if(CSR_ret)
            pc_out <= CSR_ISR_pc;
        else if(Write_en & !im_stall & !dm_stall)
            pc_out <= pc_in;
    end
end

endmodule