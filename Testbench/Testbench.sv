/*
    First the FIFO Problem:
        Reading Frequency = 40 MHz  "Reading Period = 25ns"
        Writing Frequency = 100 MHz "Writing Period = 10ns"
        Writing Data Packet size = 10 Byte
    Solution:     
        Time needed to write One Byte = 10ns
        Time needed to write the Packet = 100 ns
        number of packets to be read = 100/25 = 4 byte 
        then min FIFO Depth = 10 - 4 = 6 byte 
*/
`timescale 1ns/1ps

module tb_FIFO;
//////////////////////////////
////////// Signals //////////
////////////////////////////
//Parameters
    parameter DATA_WIDTH = 8 ;
    parameter ADDR_WIDTH = 4;
    parameter MEM_SIZE = 32;
    localparam PKT_SIZE = 10;

//Write Part
    reg tb_W_CLK,tb_W_RST;
    reg tb_W_INC;
    reg [DATA_WIDTH-1:0] tb_WR_DATA;
    wire tb_FULL;

//Read Part
    reg tb_R_CLK,tb_R_RST;
    reg tb_R_INC;
    wire [DATA_WIDTH-1:0] tb_RD_DATA;
    wire tb_EMPTY;

//Interanl Signals
    wire [DATA_WIDTH-1:0] RAM_MEMORY [MEM_SIZE-1:0];
    assign RAM_MEMORY = DUT.FIFO_MEMORY.MEM;
    wire [ADDR_WIDTH-1:0] Wr_address;
    assign Wr_address = DUT.Wr_ADDR;

//Test Data
    reg [DATA_WIDTH-1:0] Test_Data [PKT_SIZE-1:0];
    integer i;
    initial begin
        for ( i=0 ; i<= PKT_SIZE-1 ; i=i+1 ) begin
           Test_Data[i]= $random; 
        end
    end
//////////////////////////////
/////// Instatiation ////////
////////////////////////////

FIFO #(.DATA_WIDTH(DATA_WIDTH),.ADDR_WIDTH(ADDR_WIDTH),.MEM_SIZE(MEM_SIZE)) DUT(
    //Write Part
    .W_CLK(tb_W_CLK),
    .W_RST(tb_W_RST),
    .W_INC(tb_W_INC),
    .WR_DATA(tb_WR_DATA),
    .FULL(tb_FULL),
    //Read Part
    .R_CLK(tb_R_CLK),
    .R_RST(tb_R_RST),
    .R_INC(tb_R_INC),
    .RD_DATA(tb_RD_DATA),
    .EMPTY(tb_EMPTY)
);

//////////////////////////////
///// Clock Generation //////
////////////////////////////
    localparam RD_Clock_Period = 25;
    always #(RD_Clock_Period/2) tb_R_CLK=~tb_R_CLK;
    initial tb_R_CLK = 1'b1;

    localparam WR_Clock_Period = 10;
    always #(WR_Clock_Period/2) tb_W_CLK=~tb_W_CLK;
    initial tb_W_CLK = 1'b1;
    
//////////////////////////////
//// Write Initial Block ////
////////////////////////////
    initial begin
        //Start the Testbench
        $display("======= Testbench Starts =======");
        //$dumpfile("tb_results.vcd");
        //$dumpvars;

        // Write Initialization
            Write_Initialization();
        // Reset 
            Write_Reset();
        // Write a Packet
            Packet_Write(Test_Data);

    end

//////////////////////////////
///// Read Initial Block ////
////////////////////////////
    initial begin
        //Read Initialization
            Read_Initialization();
        // Reset 
            Read_Reset();
        //Read a Packet
            Packet_Read(Test_Data);
        //stop the Testbench
        $display("======= Testbench End =======");
        #100; $stop;   
    end

//////////////////////////////
////////// Tasks ////////////
////////////////////////////

// Write Tasks 
task Write_Initialization;
    begin
        tb_W_RST = 1'b1;
        tb_W_INC = 1'b0;
        tb_WR_DATA = 8'b0;
    end
    endtask

task  Write_Reset;
    begin
        #(5); //set time
        $display("---->Reset the Write Part");
        tb_W_RST = 1'b0;
        #(10); //release time
        tb_W_RST = 1'b1;  
    end
    endtask

task Packet_Write;
    input [DATA_WIDTH-1:0] INPUT_Data [PKT_SIZE-1:0];
    integer i;
    begin
    $display("Writing Data into FIFO has started at time=%0t",$time);
    
    //Adding Data 
    for ( i = 0; i <= PKT_SIZE-1 ; ) begin
        if (!tb_FULL) begin
            //Setting Time
            tb_W_INC = 1'b1;
            tb_WR_DATA = INPUT_Data[i];
            $display("++++ Entering Data =%8b at time=%0t",INPUT_Data[i],$time);
            @(posedge tb_W_CLK);
            check_write_data(INPUT_Data[i]);
            i=i+1; 
        end else begin
            $display("====> FIFO is FULL at time=%0t",$time);
            tb_W_INC = 1'b1;
            @(posedge tb_W_CLK);
        end
        
    end
    
    //Release Time
     #(WR_Clock_Period);
     tb_W_INC = 1'b0;
     $display("Writing Data into FIFO has finished at time=%0t",$time);
    end
endtask    
    
task check_write_data;
    input [DATA_WIDTH-1:0] reference_Data;
    begin
        #(WR_Clock_Period*0.25);
        if (reference_Data == RAM_MEMORY[Wr_address]) begin
            $display("Entering Data Success at time=%0t and Data = %8b",$time,RAM_MEMORY[Wr_address]);
        end else begin
            $display("Entering Data Fails at time=%0t and Data = %8b",$time,RAM_MEMORY[Wr_address]);
        end
    end
endtask    
//Read Tasks 
task Read_Initialization;
    begin
        tb_R_RST = 1'b1 ;
        tb_R_INC = 1'b0 ;  
    end
    endtask    

task Read_Reset;
    begin
          #(5); //set time
          $display("---->Reset the Read Part");
          tb_R_RST = 1'b0;
          #(10); //release time
          tb_R_RST = 1'b1;
    end
    endtask 
    
task Packet_Read;
    input [DATA_WIDTH-1:0] INPUT_Data [PKT_SIZE-1:0];
    integer i;
    begin
    $display("Reading Data into FIFO has started at time=%0t",$time);
    
    //Adding Data 
    for ( i = 0; i <= PKT_SIZE-1 ;) begin
        if (!tb_EMPTY) begin
        //Setting Time
            $display(" ---- Outputing Data =%8b at time=%0t",INPUT_Data[i],$time);
            tb_R_INC = 1'b1;
            check_read_data(INPUT_Data[i]);
            @(posedge tb_R_CLK);
            i=i+1;
        end else begin
        //Setting Time
            $display("====> FIFO is Empty at time=%0t",$time);
            tb_R_INC = 1'b0;
            @(posedge tb_R_CLK);
        end
    end
    
    //Release Time
     #(RD_Clock_Period);
     tb_R_INC = 1'b0;
     $display("Reading Data into FIFO has finished at time=%0t",$time);
    end
endtask     

task check_read_data;
    input [DATA_WIDTH-1:0] reference_Data;
    begin
        #(RD_Clock_Period*0.25);
        if (reference_Data == tb_RD_DATA) begin
            $display("Exiting Data Success at time=%0t and Data = %8b",$time,tb_RD_DATA);
        end else begin
            $display("Exiting Data Fails at time=%0t and Data = %8b",$time,tb_RD_DATA);
        end
    end
endtask 
endmodule

/*
    Write Variables
        tb_W_INC = 1'b0;
        tb_WR_DATA = 8'b0;
        
        tb_FULL = 1'b0;

    Read Variables
        tb_R_RST = 1'b1 ;
        tb_R_INC = 1'b0 ;

        tb_RD_DATA = 8'b0;
        tb_EMPTY = 1'b0;
*/