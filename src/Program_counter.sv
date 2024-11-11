module Program_counter (
    input clk,
    input reset,
    input Write_en,
    input [31:0] pc_in,
    input im_stall,
    input dm_stall, 

    output logic [31:0] pc_out 
);

always_ff @(posedge clk or negedge reset) begin
    if(~reset)
        pc_out <= 32'h0;
    else begin
        if(Write_en & !im_stall & !dm_stall)
            pc_out <= pc_in;
    end
end

endmodule