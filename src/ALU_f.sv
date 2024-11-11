module ALU_f (                      //There will be (positive + negative)
    input [31:0] float1,
    input [31:0] float2,
    input [1:0] operand,

    output logic [31:0] float_ans
);

reg [31:0] f1_swap, f2_swap, x, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10;
reg [23:0] f1_m, f2_m;
reg [7:0] f1_exp, f2_exp, x11;
reg f1_sign, f2_sign;

reg [7:0] exp_diff;

reg [23:0] f2_temp_m, temp_m;
reg carry, G_bit, R_bit, S_bit, swap_flag;

reg sign;
reg [22:0] man;
reg [7:0] exp;

integer i;

always_comb begin                           //make f1_swap >= f2_swap 
    if(float1[30:23] > float2[30:23])begin
        f1_swap = float1;
        f2_swap = float2;
        swap_flag = 1'b0;
    end
    else if(float1[30:23] < float2[30:23])begin
        f1_swap = float2;
        f2_swap = float1;
        swap_flag = 1'b1;
    end
    else begin
        if(float1[22:0] > float2[22:0])begin
            f1_swap = float1;
            f2_swap = float2;
            swap_flag = 1'b0;
        end
        else 
            {f1_swap, f2_swap, swap_flag} = (float1[22:0] < float2[22:0]) ? {float2, float1, 1'b1}: {float1, float2, 1'b0};
    end
end

always_comb begin
    temp_m = 24'd0;
    x = 32'd0;
    x1 = 32'd0;
    x2 = 32'd0;
    x3 = 32'd0;
    x4 = 32'd0;
    x5 = 32'd0;
    x6 = 32'd0;
    x7 = 32'd0;
    x8 = 32'd0;
    x9 = 32'd0;
    x10 = 32'd0;
    x11 = 8'd0;
    carry = 1'b0;
    G_bit = 1'b0;
    R_bit = 1'b0;
    S_bit = 1'b0;
    sign = 1'b0;
    man = 23'b0;
    f1_m = {1'b1, f1_swap[22:0]};
    f2_m = {1'b1, f2_swap[22:0]};
    f1_exp = f1_swap[30:23];
    f2_exp = f2_swap[30:23];
    f1_sign = f1_swap[31];
    f2_sign = f2_swap[31];
    exp_diff = f1_exp - f2_exp;
    
    if(exp_diff >= 8'd3)
        {G_bit, R_bit, S_bit} = f2_m[(exp_diff - 8'd1)-: 3 ];
    else if(exp_diff == 8'd2) begin
        G_bit = f2_m[1];
        R_bit = f2_m[0];
        S_bit = 1'b0;
    end
    else if(exp_diff == 8'd1)begin
        G_bit = f2_m[0];
        R_bit = 1'b0;
        S_bit = 1'b0;
    end else begin
        G_bit = 1'b0;
        R_bit = 1'b0;
        S_bit = 1'b0;
    end

    f2_temp_m = f2_m >> exp_diff;
    f2_temp_m = (G_bit & (R_bit | S_bit | f2_temp_m[0])) ? f2_temp_m + 24'd1 : f2_temp_m;

    exp = f1_exp;
    case (operand)
        2'd0 : begin        //add
            if(f1_sign ^ f2_sign)begin                          //different sign
                {carry, temp_m} = {1'b0, f1_m} - {1'b0, f2_temp_m};                             //unequal length
            end 
            else begin                                          //f1, f2 have the same sign
                {carry, temp_m} = f1_m + f2_temp_m;
            end

            if(carry)begin
                temp_m  = temp_m >> 1;
                exp = exp + 8'd1;
                sign = f1_sign;
                man = temp_m[22:0];
                float_ans = {sign, exp, man};
            end
            else begin
                x = {8'b0, temp_m};
                x1 = x | (x >> 1);
                x2 = x1 | (x1 >> 2);
                x3 = x2 | (x2 >> 4);
                x4 = x3 | (x3 >> 8);
                x5 = x4 | (x4 >> 16);
                x6 = x5 - ((x5 >> 1) & 32'h55555555);
                x7 = ((x6 >> 2) & 32'h33333333) + (x6 & 32'h33333333);
                x8 = ((x7 >> 4) + x7) & 32'h0f0f0f0f;
                x9 = x8 + (x8 >> 8);
                x10 = x9 + (x9 >> 16);
                x11 = (8'd24 - (x10[7:0] & 8'h7f));
                sign = f1_sign;
                man = temp_m[22:0] << x11; 
                float_ans = {sign, exp-x11, man};
            end

        end
        2'd1 : begin        //sub
            if(f1_sign ^ f2_sign)begin
                {carry, temp_m} = f1_m + f2_temp_m;
            end
            else begin
                {carry, temp_m} = {1'b0, f1_m} - {1'b0, f2_temp_m};                             //unequal length
            end

            if(carry)begin
                temp_m  = temp_m >> 1;
                exp = exp + 8'd1;
                sign = swap_flag ? ~f1_sign : f1_sign;
                man = temp_m[22:0]; 
                float_ans = {sign, exp, man};
            end
            else begin
                x = {8'b0, temp_m};
                x1 = x | (x >> 1);
                x2 = x1 | (x1 >> 2);
                x3 = x2 | (x2 >> 4);
                x4 = x3 | (x3 >> 8);
                x5 = x4 | (x4 >> 16);
                x6 = x5 - ((x5 >> 1) & 32'h55555555);
                x7 = ((x6 >> 2) & 32'h33333333) + (x6 & 32'h33333333);
                x8 = ((x7 >> 4) + x7) & 32'h0f0f0f0f;
                x9 = x8 + (x8 >> 8);
                x10 = x9 + (x9 >> 16);
                x11 = (8'd24 - (x10[7:0] & 8'h7f));
                sign = swap_flag ? ~f1_sign : f1_sign;
                man = temp_m[22:0] << x11; 
                float_ans = {sign, exp-x11, man};
            end
        end  
        default : float_ans = 32'd0;        //do nothing
    endcase
    // case (operand)
    //     2'd0 : begin        //add
    //         if(f1_sign ^ f2_sign)begin                          //different sign
    //             {carry, temp_m} = f1_m - f2_temp_m;                             //unequal length
    //             if(carry)begin
    //                 temp_m  = temp_m >> 1;
    //                 exp = exp + 8'd1;
    //             end
    //             else begin
    //                 for(i=0 ; temp_m[23] != 1'b1 && i<24 ; i=i+1)begin          //only can have i<24, need to fixed 
    //                     temp_m = temp_m << 1;                                   //sign bit will be lost
    //                     exp = exp - 8'd1;
    //                 end
    //             end
    //             sign = f1_sign;
    //             man = temp_m[22:0];
    //             float_ans = {sign, exp, man};
    //         end 
    //         else begin                                          //f1, f2 have the same sign
    //             {carry, temp_m} = f1_m + f2_temp_m;
    //             if(carry)begin
    //                 temp_m  = temp_m >> 1;
    //                 exp = exp + 8'd1;
    //             end
    //             else begin
    //                 for(i=0 ; temp_m[23] != 1'b1 && i<24 ; i=i+1)begin
    //                     temp_m = temp_m << 1;
    //                     exp = exp - 8'd1;
    //                 end
    //             end
    //             sign = f1_sign;
    //             man = temp_m[22:0];
    //             float_ans = {sign, exp, man};
    //         end
    //     end
    //     2'd1 : begin        //sub
    //         if(f1_sign ^ f2_sign)begin
    //             {carry, temp_m} = f1_m + f2_temp_m;
    //             if(carry)begin
    //                 temp_m  = temp_m >> 1;
    //                 exp = exp + 8'd1;
    //             end
    //             else begin
    //                 for(i=0 ; temp_m[23] != 1'b1 && i<24 ; i=i+1)begin
    //                     temp_m = temp_m << 1;
    //                     exp = exp - 8'd1;
    //                 end
    //             end
    //             sign = swap_flag ? ~f1_sign : f1_sign;
    //             man = temp_m[22:0];
    //             float_ans = {sign, exp, man};
    //         end
    //         else begin
    //             {carry, temp_m} = f1_m - f2_temp_m;                             //unequal length
    //             if(carry)begin
    //                 temp_m  = temp_m >> 1;
    //                 exp = exp + 8'd1;
    //             end
    //             else begin
    //                 for(i=0 ; temp_m[23] != 1'b1 && i<24 ; i=i+1)begin
    //                     temp_m = temp_m << 1;
    //                     exp = exp - 8'd1;
    //                 end
    //             end
    //             sign = swap_flag ? ~f1_sign : f1_sign;
    //             man = temp_m[22:0];
    //             float_ans = {sign, exp, man};
    //         end
    //     end  
    //     default : float_ans = 32'd0;        //do nothing
    // endcase
end

endmodule