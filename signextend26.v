// 26-to-32-bit sign extend
module signextend26(extendout, in);
   
   input [25:0] in;
   output [31:0] extendout;
   reg [31:0]    extendout;
   
   always @(in)
     if (in[25] == 1)
       extendout = {6'b111111,in};
     else
       extendout = {6'b000000,in};
   
endmodule
