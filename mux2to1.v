module mux2to1(out, in0, in1, sel);

   output [31:0] out;
   reg [31:0]    out;
   input [31:0]  in0, in1;
   input         sel;
   
   always @(in0, in1, sel)
     out = sel ? in1: in0;
endmodule
