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
    input reset,
    input uart_txd_in,
    output uart_rxd_out
    );
    //outputs
    reg [7:0] outb = 0;
    reg valid = 0;
    
    //vars
    reg [25:0] accum = 0;
    wire pps = (accum == 0);
    reg [9:0] dat = 0;
    reg start_bit = 0;
    wire end_bit = dat[9];
    wire last_dat_bit = dat[1];
    assign uart_rxd_out = !uart_txd_in;
    
    
    always @(negedge uart_txd_in) begin
        start_bit <= 1;
    end
    
    always @(posedge clk100mhz) begin
        //TODO set proper baud
        accum <= (pps ? 50_000_000 : accum) - 1;
        if (pps) begin
            if (start_bit) begin
                dat <= (dat << 1) | uart_txd_in;
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