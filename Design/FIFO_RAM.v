module DUAL_RAM #(parameter DATA_WIDTH =8,parameter ADDR_WIDTH= 4 ,parameter MEM_SIZE = 32)(
    //Write Part
    input wire w_clk,w_rst,
    input wire wclken,
    input wire [DATA_WIDTH-1:0] wrdata,
    input wire [ADDR_WIDTH-1:0] waddr, 
    //Read Part
    output reg [DATA_WIDTH-1:0] rdata,
    input wire  [ADDR_WIDTH-1:0] raddr
);

// RAM Structure
    reg [ADDR_WIDTH-1:0] MEM [MEM_SIZE-1:0];
    integer i;

// Clock gating
    wire g_clk;
    reg g_clk_latch;
    always @(w_clk or wclken) begin
        if(!w_clk)begin
            g_clk_latch <= wclken;
        end
    end
    assign g_clk = w_clk & g_clk_latch;

// Memory Logic
    always @(posedge g_clk or negedge w_rst) begin
        if (!w_rst) begin
            for (i=0; i<= MEM_SIZE-1; i=i+1) begin
                MEM[i] <= 'b0;
            end
            rdata <= 'b0;
        end else begin
            //Read Part logic
                rdata <= MEM[raddr];
            //Write Part logic   
                MEM[waddr] <= wrdata;
        end
    end    

endmodule