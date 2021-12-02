module mux2to1_1bit(out, in0, in1, sel);

   output  out;
   reg     out;
   input   in0, in1;
   input   sel;
   
   always @(in0, in1, sel)
     out = sel ? in1: in0;
endmodule
