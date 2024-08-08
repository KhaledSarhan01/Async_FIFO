module WR_CONTRL #(parameter ADDR_WIDTH = 4)(
    input wire w_clk,w_rst,
    //interface
    input wire winc,
    output wire wfull,
    //pointers 
    output wire  [ADDR_WIDTH:0] w_ptr,
    output wire w_ptr_en,
    input wire [ADDR_WIDTH:0] r_ptr,
    input wire r_ptr_en,
    //memory
    output wire [ADDR_WIDTH-1:0] waddr
);

endmodule