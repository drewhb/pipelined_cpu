`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2021 05:13:42 PM
// Design Name: 
// Module Name: muxA
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


module muxA(
outputA,
IDEX_A,
WriteBackData,
MemAluOut,
forwardA
    );
    
    input [31:0] IDEX_A, WriteBackData, MemAluOut;
    input [1:0] forwardA;
    output reg [31:0] outputA;
    reg flag = 1'b0;
    
    always @(*) begin
    if (forwardA == 2'b00) begin
        outputA <= IDEX_A;
    end else if( forwardA == 2'b01) begin
        outputA <= WriteBackData;
        flag = 1'b1;
    end else if (forwardA == 2'b10) begin
        outputA <= MemAluOut;
    end
end


endmodule
