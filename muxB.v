`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2021 06:55:11 PM
// Design Name: 
// Module Name: muxB
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


module muxB(
outputB,
AluIB,
WriteBackData,
MemAluOut,
forwardB

    );
    input [31:0] AluIB, WriteBackData, MemAluOut;
    input [1:0] forwardB;
    output reg [31:0] outputB;
    reg flag = 1'b0;
    
    always @(*) begin
    if (forwardB == 2'b00) begin
        outputB <= AluIB;
    end else if( forwardB == 2'b01) begin
        outputB <= WriteBackData;
        flag <= 1'b1;
    end else if (forwardB == 2'b10) begin
        outputB <= MemAluOut;
    end
end

endmodule
