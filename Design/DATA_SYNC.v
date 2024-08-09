module DATA_SYNC #(parameter BUS_WIDTH = 8)(
    input wire CLK,RST,
    input wire [BUS_WIDTH-1:0] Unsync_bus,
    output wire [BUS_WIDTH-1:0] sync_bus
);

// Using Flip Flop synchronizer with Gray encoding input/output 
    reg [BUS_WIDTH-1:0] synchronizer;
    integer i;

    always @(posedge CLK or negedge RST ) begin
        if (!RST) begin
            {sync_bus,synchronizer} <= 'b0;            
        end else begin
            {sync_bus,synchronizer} <= {synchronizer,Unsync_bus};
        end
    end

endmodule