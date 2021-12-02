module jumpadd(BranchAddress, JOffset, BOffset, OpCode, IDEX_PC);

   output  [31:0] BranchAddress;
   reg [31:0]     BranchAddress;
   input [25:0]   JOffset;
   input [31:0]   IDEX_PC;
   input [15:0]   BOffset;
   input [5:0]    OpCode;
   
   
   always @ (JOffset or BOffset or IDEX_PC or OpCode)
     if(OpCode == 2)
       if(JOffset[25] == 1)
         BranchAddress = {6'b111111,JOffset} + IDEX_PC;
       else
         BranchAddress = {6'b0000,JOffset} + IDEX_PC;
     else
       if(BOffset[15] == 1)
         BranchAddress = {16'hffff,BOffset} + IDEX_PC;
       else
         BranchAddress = {16'h0000,BOffset} + IDEX_PC;
endmodule
