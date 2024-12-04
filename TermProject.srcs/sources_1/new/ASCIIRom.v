`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2024 01:52:44 PM
// Design Name: 
// Module Name: ASCIIRom
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

module ASCIIRom(
	input wire clk,
    input [14:0] addr,
    output reg [0:0] data
	);

	reg [0:0] rom[32767:0];

    initial begin
        $readmemh("glyph_thai.mem", rom);
    end
    
    always @(posedge clk) begin
        data <= rom[addr];
    end
endmodule
