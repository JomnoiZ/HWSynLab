`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2024 01:41:42 PM
// Design Name: 
// Module Name: system
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


module system(
    input clk,
    input btnC,
    input btnD,
    input btnU,
    input [15:0] sw,
    input wire RsRx,
    output wire RsTx,
    input wire Rx,
    output wire Tx,
    output wire Hsync,
    output wire Vsync,
    output wire [3:0] vgaRed,
    output wire [3:0] vgaGreen,
    output wire [3:0] vgaBlue,
    output wire [6:0] seg,
    output wire dp,
    output wire [3:0] an
    );
    
    wire [7:0] num0;
    wire [7:0] num1;
    wire [7:0] num2;
    reg [7:0] num3;
    
    wire video_on, p_tick;
    wire [9:0] x, y;
    wire [11:0] rgb;
    wire [7:0] data_received;
    
    wire targetClk;
    wire [18:0] tclk;
    assign tclk[0] = clk;
    assign an = {an3, an2, an1, an0};
    assign dp = 1;
    
    genvar c;
    generate for(c = 0; c < 18; c = c + 1)
    begin
        clockDiv fdiv(tclk[c + 1], tclk[c]);
    end
    endgenerate
    
    clockDiv fdivTarget(targetClk, tclk[18]);
    
    quadSevenSeg q7Seg(seg, dp, an0, an1, an2, an3, num0, num1, num2, num3, targetClk);
    
    wire reset, send, to_push, to_pop;
    wire send_sw;
    
    singlePulser spReset(reset, btnD, targetClk);
    singlePulser spPush(send, btnC, targetClk);
    singlePulser spPushSW(send_sw, btnU, targetClk);
    
    wire isThai;
    wire [7:0] to_send_alp;
    reg [7:0] alp;
    
    assign to_send_alp = alp;
    
    UART uart(data_received, sw[7:0], num0, num1, to_push, to_pop, RsTx, RsRx, Tx, Rx, send, isThai, clk);
    
    VGASync sync(clk, reset, Hsync, Vsync, video_on, p_tick, x, y);

    VGA vga(clk, reset, video_on, x, y, rgb, alp, sw, to_push, send_sw, to_pop, num2, targetClk);
    
    assign {vgaRed, vgaGreen, vgaBlue} = rgb;
    
    always @(posedge targetClk) begin
        if (isThai) begin
            case (data_received)
                "d": alp = 8'd128; // ? (Ko Kai)
                "-": alp = 8'd129; // ? (Kho Khai)
                "\\": alp = 8'd130; // ? (Kho Khon)
                "8": alp = 8'd131; // ? (Kho Khwai)
                "|": alp = 8'd132; // ? (Kho Khon)
                "S": alp = 8'd133; // ? (Kho Rakhang)
                "'": alp = 8'd134; // ? (Ngo Ngu)
                "0": alp = 8'd135; // ? (Cho Chan)
                "C": alp = 8'd136; // ? (Cho Ching)
                "=": alp = 8'd137; // ? (Cho Chang)
                ":": alp = 8'd138; // ? (So So)
                "G": alp = 8'd139; // ? (Cho Cho)
                "P": alp = 8'd140; // ? (Yo Ying)
                "E": alp = 8'd141; // ? (Do Cha Da)
                "D": alp = 8'd142; // ? (To Patak)
                "{": alp = 8'd143; // ? (Tho Thung)
                "R": alp = 8'd144; // ? (Tho Thahan)
                "<": alp = 8'd145; // ? (Tho Thong)
                "I": alp = 8'd146; // ? (No Nen)
                "f": alp = 8'd147; // ? (Do Dek)
                "9": alp = 8'd148; // ? (To Tao)
                "5": alp = 8'd149; // ? (Tho Thung)
                "m": alp = 8'd150; // ? (Tho Thahan)
                "T": alp = 8'd151; // ? (Tho Thong)
                "o": alp = 8'd152; // ? (No Nen)
                "[": alp = 8'd153; // ? (Bo Baimai)
                "x": alp = 8'd154; // ? (Po Pla)
                "z": alp = 8'd155; // ? (Pho Phung)
                "/": alp = 8'd156; // ? (Fo Fa)
                "r": alp = 8'd157; // ? (Pho Phan)
                "a": alp = 8'd158; // ? (Fo Fan)
                "4": alp = 8'd159; // ? (Pho Sam-phao)
                ",": alp = 8'd160; // ? (Mo Ma)
                "p": alp = 8'd161; // ? (Yo Yak)
                "i": alp = 8'd162; // ? (Ro Ruea)
                "-": alp = 8'd163; // ? (Ruea)
                "]": alp = 8'd164; // ? (Lo Ling)
                "?": alp = 8'd165; // ? (Lu)
                ";": alp = 8'd166; // ? (Wo Waen)
                "L": alp = 8'd167; // ? (So Sala)
                "K": alp = 8'd168; // ? (So Rua)
                "l": alp = 8'd169; // ? (So Sik)
                "s": alp = 8'd170; // ? (Ho Nokhuk)
                ">": alp = 8'd171; // ? (Lo Chula)
                "v": alp = 8'd172; // ? (O Ang)
                "V": alp = 8'd173; // ? (Ho Hip)
                "O": alp = 8'd174; // ? (Pai Yan Noi)
                "t": alp = 8'd175; // ? (Sara A)
                "y": alp = 8'd176; // ? (Mai Hun A Kat)
                "u": alp = 8'd177; // ? (Sara Aa)
                "e": alp = 8'd178; // ? (Sara Am)
                "b": alp = 8'd179; // ? (Sara I)
                "u": alp = 8'd180; // ? (Sara Ii)
                "7": alp = 8'd181; // ? (Sara Ue)
                "n": alp = 8'd182; // ? (Sara Uee)
                "6": alp = 8'd183; // ? (Sara U)
                "^": alp = 8'd184; // ? (Sara Uu)
                "B": alp = 8'd185; // ? (Phinthu)
                "1": alp = 8'd186; // ? (Baht)
                "g": alp = 8'd187; // ? (Sara E)
                "c": alp = 8'd188; // ? (Sara Ae)
                "F": alp = 8'd189; // ? (Sara O)
                ".": alp = 8'd190; // ? (Sara Ai Maimuan)
                "w": alp = 8'd191; // ? (Sara Ai Maimalai)
                "q": alp = 8'd192; // ? (Mai Ya Mok)
                "H": alp = 8'd193; // ? (Sara Tai Ku)
                "j": alp = 8'd194; // ? (Mai Ek)
                "h": alp = 8'd195; // ? (Mai Tho)
                "U": alp = 8'd196; // ? (Mai Tri)
                "J": alp = 8'd197; // ? (Mai Chattawa)
                "N": alp = 8'd198; // ? (THANTHAKHAT)
                default: alp = 8'd0; // Default for unmapped characters
            endcase
        end   
        else alp = data_received;
    
        num3 <= alp;
    end
endmodule
