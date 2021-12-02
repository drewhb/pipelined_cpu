// 32-bit sign extend
module signextend(extendout, in);

   input [15:0] in;
   output [31:0] extendout;
   reg [31:0]    extendout;
   
   always @(in)
     if (in[15] == 1)
       extendout = {16'hffff,in};
     else
       extendout = {16'h0000,in};

endmodule
