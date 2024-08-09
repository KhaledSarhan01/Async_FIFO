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
        $dumpfile("tb_results.vcd");
        $dumpvars;

        // Write Initialization
            Write_Initialization();
        // Reset 
            Write_Reset();
        // Write a Packet
        //    Packet_Write();

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
        //    Packet_Read();
        //stop the Testbench
        $display("======= Testbench End =======");
        #1000; $stop;   
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
        #(WR_Clock_Period); //set time
        $display("---->Reset the Write Part");
        tb_W_RST = 1'b0;
        #(WR_Clock_Period); //release time
        tb_W_RST = 1'b1;  
    end
    endtask

  /*  task Packet_Write;
        begin
            
        end
    endtask    
    */
//Read Tasks 
    task Read_Initialization;
    begin
        tb_R_RST = 1'b1 ;
        tb_R_INC = 1'b0 ;  
    end
    endtask    

    task Read_Reset;
    begin
          #(RD_Clock_Period); //set time
          $display("---->Reset the Read Part");
          tb_R_RST = 1'b0;
          #(RD_Clock_Period); //release time
          tb_R_RST = 1'b1;
    end
    endtask 
    
 /*   task Packet_Read;
    begin
            
    end
    endtask     
    */
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