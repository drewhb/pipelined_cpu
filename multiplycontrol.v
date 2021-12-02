module multiplycontrol(Opcode,Funct,AluMux,HiLoEnable);
   input  [5:0] Funct, Opcode;
   output [1:0] AluMux;
   output       HiLoEnable;
   reg [1:0]    AluMux;
   reg          HiLoEnable;
   
   always @ (Funct or Opcode)
     begin
        AluMux = 0;
        HiLoEnable = 0;
        if (Opcode == 0)
          begin
             if (Funct == 24)
               begin
                  HiLoEnable = 1;
                  AluMux = 0;
               end
             if (Funct == 16)
               begin
                  HiLoEnable = 0;
                  AluMux = 2'b01;
               end
             if (Funct == 18)
               begin
                  HiLoEnable = 0;
                  AluMux = 2'b10;
               end
          end
     end
   
endmodule
