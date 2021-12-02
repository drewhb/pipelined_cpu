`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2021 04:42:12 PM
// Design Name: 
// Module Name: ForwardingUnit
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


module ForwardingUnit(
forwardA,
forwardB,
IDEX_Rs,
IDEX_Rt,
MemDest,        //Ex/MemMemRegisterRD
WriteBackDest,  //MEM/WB.Register RD
WBMemOut,       //MEM/WB.RegWrite
MEM_Data        //Ex/MEM.RegWrite
);
    
    
    input [4:0] MemDest, WriteBackDest, IDEX_Rs, IDEX_Rt;
    input  MEM_Data, WBMemOut;
    output reg [1:0] forwardA;
    output reg [1:0] forwardB;
   
   
always @(*)
begin
  forwardA = 2'b00;
  forwardB = 2'b00;
  if (MEM_Data && MemDest != 0 && MemDest == IDEX_Rs) begin
    forwardA = 2'b10;
  end if (MEM_Data && MemDest != 0 && MemDest == IDEX_Rt) begin
    forwardB = 2'b10;
  end if( WBMemOut && WriteBackDest != 0 && MemDest != IDEX_Rs && WriteBackDest == IDEX_Rs) begin
    forwardA = 2'b01;
  end if( WBMemOut && WriteBackDest != 0 && MemDest != IDEX_Rt && WriteBackDest == IDEX_Rt) begin
    forwardB = 2'b01;
  end
end



    
    
endmodule
