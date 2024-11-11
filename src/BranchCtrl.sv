module BranchCtrl (
    input [1:0] branch,
    input zero,

    output logic [1:0] bCtrl
);

always_comb begin
    case(branch)
        2'd0 : bCtrl = 2'd0;
        2'd1 : bCtrl = 2'd2;
        2'd2 : begin
            if(zero)
                bCtrl = 2'd1;
            else 
                bCtrl = 2'd0;
        end
        2'd3 : bCtrl = 2'd1;
    endcase
end

endmodule

//0 pc+4
//1 JALR
//2 B-type
//3 JAL