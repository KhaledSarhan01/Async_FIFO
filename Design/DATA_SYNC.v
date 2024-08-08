module DATA_SYNC #(parameter NUM_STAGES = 2 ,parameter BUS_WIDTH = 8)(
    input wire CLK,RST,
    input wire [BUS_WIDTH-1:0] Unsync_bus,
    output wire [BUS_WIDTH-1:0] sync_bus
);

// Using Flip Flop synchronizer with Gray encoding input/output 
    reg [BUS_WIDTH-1:0] synchronizer [NUM_STAGES-1:0] ;
    integer i;

    always @(posedge CLK or negedge RST ) begin
        if (!RST) begin
            for (i = 0; i <= NUM_STAGES-1; i=i+1 ) begin
               synchronizer[i] <= 'b0; 
            end 
        end else begin
            synchronizer[0] <= Unsync_bus;
            for (i = 1; i<= NUM_STAGES-1; i=i+1) begin
                synchronizer[i] <= synchronizer[i-1];
           end
        end
    end

    assign sync_bus = synchronizer[NUM_STAGES-1];
endmodule