`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2024 03:41:52 PM
// Design Name: 
// Module Name: baudrate_generator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module baudrate_generator(
    output reg baud,
    input clk
    );
    
    // Clock = 10ns
    // ClockFreq = 1/10ns = 100 MHz
    // Baudrate = 9600
    // sampling every 16 ticks
    // counter = ClockFreq/Baudrate/16/2 = 100000000/9600/16/2 = 325.521
    
    integer counter;
    always @(posedge clk) begin
        counter = counter + 1;
        if (counter == 325) begin
            counter = 0;
            baud = ~baud;
        end
    end
endmodule
