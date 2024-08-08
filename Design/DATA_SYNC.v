module DATA_SYNC #(parameter NUM_STAGES = 2 ,parameter BUS_WIDTH = 8)(
    input wire CLK,RST,
    input wire [BUS_WIDTH-1:0] Unsync_bus,
    output wire [BUS_WIDTH-1:0] sync_bus,
);
  
endmodule