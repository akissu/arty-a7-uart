`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/15/2020 04:12:47 PM
// Design Name: 
// Module Name: uart
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


module uart(
    input clk100mhz,
    input ck_rst,
    input uart_txd_in,
    output uart_rxd_out,
    output valid,
    output a1,
    output led0_g,
    output led1_g,
    output led2_g,
    output led3_g
    );
    reg [25:0] accum = 0;
    reg [7:0] i = 0;
    reg [7:0] outb = 0;
    reg [7:0] dat = 0;
    reg validb = 0;
    wire pps = (accum == 0);
    assign valid = validb;
    assign led0_g = outb[0];
    assign led1_g = outb[1];
    assign led2_g = outb[2];
    assign led3_g = outb[3];
    assign uart_rxd_out = uart_txd_in;
    assign a1 = uart_txd_in;
    
    always @(posedge clk100mhz) begin
        //100mhz/(baud 115200 * 10-bit) = 868.05
        accum <= (pps ? 868 : accum) - 1;
        if (ck_rst == 0) begin
            accum <= 0;
            outb <= 0;
            i <= 0;
        end
        else if (pps) begin
            validb <= 1;
            if (i == 0) begin
                if (uart_txd_in == 0) begin
                    i <= 1;
                end
            end
            else if (i < 9) begin
                dat[i - 1] = uart_txd_in;
                i <= (i + 1);
            end
            else begin
                outb <= dat;
                i <= 0;
                if (uart_txd_in == 1) begin
                    validb <= 0;
                end
            end
        end
    end
endmodule
