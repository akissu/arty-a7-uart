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
    input clk,
    input reset,
    input rxd,
    output reg [7:0] outb,
    output reg valid = 0
    );
    reg [25:0] accum = 0;
    wire pps = (accum == 0);
    reg [9:0] dat = 0;
    reg start_bit = 0;
    wire end_bit = dat[9];
    
    always @(negedge rxd) begin
        start_bit <= 1;
    end
    
    always @(posedge clk) begin
        //TODO set proper baud
        accum <= (pps ? 50_000_000 : accum) - 1;
        if (pps) begin
            if (start_bit) begin
                dat <= (dat << 1) | rxd;
            end
        end
    end
    
    always @(end_bit) begin
        valid <= dat[0];
        outb <= dat[8:1];
        dat <= 0;
        start_bit <= 0;
    end
endmodule