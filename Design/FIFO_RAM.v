module DUAL_RAM #(parameter DATA_WIDTH =8,parameter ADDR_WIDTH= 4 ,parameter MEM_SIZE = 32)(
    //Write Part
    input wire w_clk,w_rst,
    input wire wclken,
    input wire [DATA_WIDTH-1:0] wrdata,
    input wire [ADDR_WIDTH-1:0] waddr, 
    //Read Part
    output wire [DATA_WIDTH-1:0] rdata,
    input wire  [ADDR_WIDTH-1:0] raddr
);

// RAM Structure
    reg [DATA_WIDTH-1:0] MEM [MEM_SIZE-1:0];
    integer i;

//Write Memory Logic
    always @(posedge w_clk or negedge w_rst) begin
        if (!w_rst) begin
            for (i=0; i<= MEM_SIZE-1; i=i+1) begin
                MEM[i] <= 'b0;
            end
        end else begin
            //Write Part logic 
            if (wclken) begin
                MEM[waddr] <= wrdata;
            end  
        end
    end    
//Read Part Logic 
assign rdata = MEM[raddr];

endmodule