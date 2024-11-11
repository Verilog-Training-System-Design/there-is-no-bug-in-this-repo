`include "../include/AXI_define.svh"

//decode address to which slave (read address and write address)

module Decoder(
    input [`AXI_ADDR_BITS-1:0] 			ADDR,
    input                               VALID,              //the address correctness
    output logic                        READY,              //slave take the address
    input                               READY_S0,           
    input                               READY_S1,
    input                               READY_S2,
    output logic                        VALID_S0,           //axi ready to transfer address to slave
    output logic                        VALID_S1,
    output logic                        VALID_S2
);

always_comb begin
    case (ADDR[(`AXI_ADDR_BITS-1):(`AXI_ADDR_BITS/2)])      //[31:16]
        16'h0 : begin
            VALID_S0 = VALID;
            VALID_S1 = 1'b0;
            VALID_S2 = 1'b0;
            if(VALID)
                READY = READY_S0;
            else 
                READY = 1'b0;
        end
        16'h1 : begin
            VALID_S0 = 1'b0;
            VALID_S1 = VALID;
            VALID_S2 = 1'b0;
            if(VALID)
                READY = READY_S1;
            else 
                READY = 1'b0;
        end
        default : begin
            VALID_S0 = 1'b0;
            VALID_S1 = 1'b0;
            VALID_S2 = VALID;
            if(VALID)
                READY = READY_S2;
            else 
                READY = 1'b0;
        end
    endcase
end

endmodule





