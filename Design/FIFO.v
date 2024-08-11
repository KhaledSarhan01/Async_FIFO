module FIFO #(parameter DATA_WIDTH = 8 ,parameter ADDR_WIDTH = 3,parameter MEM_SIZE = 8)(
    //Write Part
    input wire W_CLK,W_RST,
    input wire W_INC,
    input wire [DATA_WIDTH-1:0] WR_DATA,
    output wire FULL,
    //Read Part
    input wire R_CLK,R_RST,
    input wire R_INC,
    output wire [DATA_WIDTH-1:0] RD_DATA,
    output wire EMPTY
);
//Wires
    //Address
        wire [ADDR_WIDTH-1:0] Wr_ADDR;
        wire [ADDR_WIDTH-1:0] Rd_ADDR;
    //Read Pointers
        wire [ADDR_WIDTH:0] unsync_rd_ptr;
        wire [ADDR_WIDTH:0] sync_rd_ptr;
    //Write Pointers
        wire [ADDR_WIDTH:0] unsync_wr_ptr;
        wire [ADDR_WIDTH:0] sync_wr_ptr;
    //Write Clock Enable
        wire Wr_CLK_En;
        assign Wr_CLK_En = ~(FULL) & W_INC;

//FIFO MEMORY
DUAL_RAM #(.DATA_WIDTH(DATA_WIDTH),.ADDR_WIDTH(ADDR_WIDTH),.MEM_SIZE(MEM_SIZE)) FIFO_MEMORY(
    //Write Part
    .w_clk(W_CLK),.w_rst(W_RST),
    .wrdata(WR_DATA),
    .waddr(Wr_ADDR),
    .wclken(Wr_CLK_En),
    //Read Part
    .rdata(RD_DATA),
    .raddr(Rd_ADDR)
);

//SYNCING READ TO WRITE 
DATA_SYNC #(.BUS_WIDTH(ADDR_WIDTH+1)) SYNC_R2W(
    .CLK(W_CLK),.RST(W_RST),
    .Unsync_bus(unsync_rd_ptr),
    .sync_bus(sync_rd_ptr)
);

//SYNCING WRITE TO READ
DATA_SYNC #(.BUS_WIDTH(ADDR_WIDTH+1)) SYNC_W2R(
    .CLK(R_CLK),.RST(R_RST),
    .Unsync_bus(unsync_wr_ptr),
    .sync_bus(sync_wr_ptr)
);

//READ CONTROL LOGIC
RD_CONTRL #(.ADDR_WIDTH(ADDR_WIDTH)) rptr_empty(
    .r_clk(R_CLK),.r_rst(R_RST),
    //interface
    .rinc(R_INC),
    .rempty(EMPTY),
    //pointers 
    .w_ptr(sync_wr_ptr),    // Here we input Write pointer from W2R SYNC
    .r_ptr(unsync_rd_ptr),  // Here we output Read pointer into R2W SYNC
    //memory
    .raddr(Rd_ADDR)
);

//WRITE CONTROL LOGIC
WR_CONTRL #(.ADDR_WIDTH(ADDR_WIDTH)) wptr_full(
    .w_clk(W_CLK),.w_rst(W_RST),
    //interface
    .winc(W_INC),
    .wfull(FULL),
    //pointers 
    .w_ptr(unsync_wr_ptr),  // Here we output Write pointer into W2R SYNC
    .r_ptr(sync_rd_ptr),    // Here we input Read pointer from R2W SYNC
    //memory
    .waddr(Wr_ADDR)
);

endmodule