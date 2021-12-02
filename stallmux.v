module stallmux(wb, m, ex, MemToReg, RegWrite,
                MemRead, MemWrite,
                RegDst, AluOp, AluSrc, AluMux, HiLoEnable,
                HazardMuxSelect);
   
   output [1:0] wb;
   output [1:0] m;
   output [6:0] ex;
   reg [1:0]    wb;
   reg [1:0]    m;
   reg [13:0]   ex;
   
   input        MemToReg, RegWrite, MemRead, MemWrite, RegDst, AluSrc, HazardMuxSelect;
   input [1:0]  AluMux;
   input        HiLoEnable;
   input [8:0]  AluOp;
   
   always @(MemToReg or RegWrite or MemRead or MemWrite or RegDst or AluOp or AluSrc or HazardMuxSelect
            or AluMux or HiLoEnable)
     begin
        if(~HazardMuxSelect)
          begin
             wb = {MemToReg, RegWrite};
             m  = {MemRead, MemWrite};
             ex =    {RegDst, AluOp, AluSrc, AluMux, HiLoEnable};
          end
        else
          begin
             wb = 0;
             m  = 0;
             ex = 0;
          end
     end
   
endmodule
