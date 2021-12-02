module RegFile(clk, reset, WriteData, WriteRegister, RegWrite, ReadReg1, ReadReg2, 
               ReadData1, ReadData2);
   
   output [31:0] ReadData1, ReadData2;
   reg [31:0]    ReadData1, ReadData2;
   input         reset;
   input [31:0]  WriteData;
   input [4:0]   WriteRegister, ReadReg1, ReadReg2;
   input         RegWrite, clk;
   
   integer       i;
   reg [31:0]    Reg_File[31:0]; //32bit x32 word memory declaration
   
   always @(ReadReg1 or ReadReg2 or WriteRegister or WriteData)
     begin
        ReadData1 = Reg_File[ReadReg1];
        ReadData2 = Reg_File[ReadReg2];
        //Register File Write Through
        if (ReadReg1 == WriteRegister && (ReadReg1 != 0) )
          ReadData1 = WriteData;
        if (ReadReg2 == WriteRegister && (ReadReg2 != 0) )
          ReadData2 = WriteData;
     end
   
   always @(posedge clk)
     begin
        if (reset) 
          begin
             for (i=0; i<32; i=i+1)
               Reg_File[i] <= 0;
          end
        else if (RegWrite)
          begin
             if (WriteRegister != 32'd0)
               Reg_File[WriteRegister] <= WriteData;
          end
     end

endmodule
