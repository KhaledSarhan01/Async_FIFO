module RD_CONTRL #(parameter ADDR_WIDTH = 4)(
    input wire r_clk,r_rst,
    //interface
    input wire rinc,
    output wire rempty,
    //pointers 
    input wire  [ADDR_WIDTH:0] w_ptr,
    input wire w_ptr_en,
    output wire [ADDR_WIDTH:0] r_ptr,
    output wire r_ptr_en,
    //memory
    output wire [ADDR_WIDTH-1:0] raddr
);

endmodule