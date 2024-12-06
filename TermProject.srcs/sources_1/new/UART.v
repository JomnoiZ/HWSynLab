`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2024 03:39:22 PM
// Design Name: 
// Module Name: UART
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


module UART(
    output reg [7:0] data_receive,
    input wire [7:0] data_transmit,
    output reg [7:0] num0,
    output reg [7:0] num1,
    output reg we,
    output reg oe,
    output RsTx,
    input RsRx,
    output Tx,
    input Rx,
    input wire enable,
    output reg isThai,
    input clk
    );
    
    reg en, last_received, last_received2;
    reg [7:0] data_in;
    wire [7:0] data_out, data_out2;
    wire sent, received, received2, baud;
    
    baudrate_generator baudrate_gen(baud, clk);
    uart_rx receiver_keyboard(received2, data_out2, RsRx, baud);
    uart_rx receiver(received, data_out, Rx, baud);
    uart_tx transmitter(sent, data_in, Tx, en, baud);
    
    always @(posedge baud) begin
        if (en) en = 0;
    
        if (enable) begin 
            data_in = data_transmit;
            num0 = data_transmit;
            en = 1;
        end
        
        if (~last_received & received) begin
            if (data_out == 96) begin
                isThai = ~isThai;
            end
            else if (data_out == 127) begin
                oe = ~oe;
            end
            else begin
                data_receive = data_out;
                we = ~we;
            end
        end
        last_received = received;
        
        if (~last_received2 & received2) begin
            data_in = data_out2;
            num0 = data_out2;
            en = 1;
        end
        last_received2 = received2;
    end
endmodule