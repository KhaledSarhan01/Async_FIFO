module WR_CONTRL #(parameter ADDR_WIDTH = 4)(
    input wire w_clk,w_rst,
    //interface
    input wire winc,
    output wire wfull,
    //pointers 
    output wire  [ADDR_WIDTH:0] w_ptr,
    input wire [ADDR_WIDTH:0] r_ptr,
    //memory
    output wire [ADDR_WIDTH-1:0] waddr
);
    //Registers
    wire [ADDR_WIDTH:0] gray_ptr;
    reg [ADDR_WIDTH:0] bn_ptr;
    reg full_flag;

    // Binary Encoded Pointer Logic
    always @(posedge w_clk or negedge w_rst) begin
        if (!w_rst) begin
            bn_ptr <= 'b0;
        end else begin
                bn_ptr <= bn_ptr + winc & ~(full_flag);
        end
    end
    
    // Gray Encoded Pointer Logic
    assign gray_ptr = (bn_ptr >>1) ^ bn_ptr;
    
    // Full Flag Logic
    always @(posedge w_clk or negedge w_rst) begin
        if (!w_rst) begin
            full_flag <= 1'b0;
        end else begin
            if ((gray_ptr[ADDR_WIDTH:ADDR_WIDTH-1] != r_ptr[ADDR_WIDTH:ADDR_WIDTH-1])&& (gray_ptr[ADDR_WIDTH-2:0] == r_ptr[ADDR_WIDTH-2:0])) begin
                full_flag <= 1'b1;
            end else begin
                full_flag <= 1'b0;
            end
        end
    end
    //Outputs
    assign waddr = bn_ptr[ADDR_WIDTH-1:0];
    assign w_ptr = gray_ptr;
    assign wfull = full_flag;

endmodule