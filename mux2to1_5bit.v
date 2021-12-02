module mux2to1_5bit(out, in0, in1, sel);

   output [4:0] out;
   reg [4:0]    out;
   input [4:0]  in0, in1;
   input        sel;
   
   always @(in0, in1, sel)
     out = sel ? in1: in0;
endmodule
