`include "../include/AXI_define.svh"

//decode address to which slave (read address and write address)

module Decoder(
    input [`AXI_ADDR_BITS-1:0] 			ADDR,
    input                               VALID,              //the address correctness
    output logic                        READY,              //slave take the address
    input                               READY_S0,           
    input                               READY_S1,
    input                               READY_S2,
    input                               READY_S3,
    input                               READY_S4,
    input                               READY_S5,
    output logic                        VALID_S0,           //axi ready to transfer address to slave
    output logic                        VALID_S1,
    output logic                        VALID_S2,
    output logic                        VALID_S3,
    output logic                        VALID_S4,
    output logic                        VALID_S5
);

always_comb begin
    case (ADDR[(`AXI_ADDR_BITS-1):(`AXI_ADDR_BITS/2)])      //[31:16]
        16'h0 : begin                       //ROM
            VALID_S0 = VALID;
            VALID_S1 = 1'b0;
            VALID_S2 = 1'b0;
            VALID_S3 = 1'b0;
            VALID_S4 = 1'b0;
            VALID_S5 = 1'b0;
            if(VALID)
                READY = READY_S0;
            else 
                READY = 1'b0;
        end
        16'h1 : begin                       //IM
            VALID_S0 = 1'b0;
            VALID_S1 = VALID;
            VALID_S2 = 1'b0;
            VALID_S3 = 1'b0;
            VALID_S4 = 1'b0;
            VALID_S5 = 1'b0;
            if(VALID)
                READY = READY_S1;
            else 
                READY = 1'b0;
        end
        16'h2 : begin                       //DM
            VALID_S0 = 1'b0;
            VALID_S1 = 1'b0;
            VALID_S2 = VALID;
            VALID_S3 = 1'b0;
            VALID_S4 = 1'b0;
            VALID_S5 = 1'b0;
            if(VALID)
                READY = READY_S2;
            else 
                READY = 1'b0;
        end
        16'h1002 : begin                    //DMA
            VALID_S0 = 1'b0;
            VALID_S1 = 1'b0;
            VALID_S2 = 1'b0;
            VALID_S3 = VALID;
            VALID_S4 = 1'b0;
            VALID_S5 = 1'b0;
            if(VALID)
                READY = READY_S3;
            else 
                READY = 1'b0;
        end
        16'h1001 : begin                    //WDT
            VALID_S0 = 1'b0;
            VALID_S1 = 1'b0;
            VALID_S2 = 1'b0;
            VALID_S3 = 1'b0;
            VALID_S4 = VALID;
            VALID_S5 = 1'b0;
            if(VALID)
                READY = READY_S4;
            else 
                READY = 1'b0;
        end
        default : begin                     //DRAM
            VALID_S0 = 1'b0;
            VALID_S1 = 1'b0;
            VALID_S2 = 1'b0;
            VALID_S3 = 1'b0;
            VALID_S4 = 1'b0;
            VALID_S5 = VALID;
            if(VALID)
                READY = READY_S5;
            else 
                READY = 1'b0;
        end
    endcase
end

endmodule





