`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2024 01:41:42 PM
// Design Name: 
// Module Name: VGA
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


module VGA(
    input clk,
    input reset,
    input video_on,
    input [9:0] x, y,
    output reg [11:0] rgb,
    input wire [7:0] din,
    input wire [7:0] din2,
    output reg we,
    input wire we2,
    output reg oe,
    output reg [7:0] num2,
    input targetClk
    );
    
    reg [7:0] addr;
    reg [7:0] dout;
    reg [7:0] mem [255:0];
    reg p_we;
    
    initial begin
        dout = 0;
        addr = 0;
    end
        
    always @(posedge targetClk) begin
        if (we != p_we) begin
            mem[addr] = din;
            addr = addr + 1;
            p_we = we;
        end
        if (we2) begin
            mem[addr] = din;
            addr = addr + 1;
        end
        if (reset || (oe && addr == 0)) begin
            dout = 0;
            addr = 0;
            if (oe == 1) oe = 0;
        end
        if (oe) begin
            if (addr > 0) begin
                addr = addr - 1;
                dout = mem[addr];
                mem[addr] = 0;
            end
            oe = 0;
        end
        num2 = addr + 48;
    end
    
    wire [2:0] rom_x;
    wire [3:0] rom_y;
    reg [14:0] rom_address;
    wire ascii_bit;
    reg ascii_bit_on;
    
    assign rom_x = x[2:0];
    assign rom_y = y[3:0];
    
    ASCIIRom rom(clk, rom_address, ascii_bit);
    
//    assign ascii_bit_on = ((128 <= x && x < 136 + 8 * (addr - ((addr >> 3) << 3)) && 128 <= y && y < 144 + 16 * (addr >> 3)) ? ascii_bit : 1'b0);
    
    always @* begin
        if (~video_on) rgb = 12'h000;
        else begin
            if (ascii_bit_on) rgb = 12'hAAA;
            else rgb = 12'h005;
        end
        if (128 <= y && y < 144 + 16 * (addr >> 3) && 128 <= x && x < 136 + 8 * (((y - 128) >> 4) < (addr >> 3) ? 7 : addr - ((addr >> 3) << 3))) begin
            rom_address = (mem[((x - 128) >> 3) + (((y - 128) >> 4) << 3)] << 7) + rom_x + (rom_y << 3);
            ascii_bit_on = ascii_bit;
        end
        else ascii_bit_on = 1'b0;
    end
endmodule
