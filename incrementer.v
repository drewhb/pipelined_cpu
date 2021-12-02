module incrementer(out, in);

   output [31:0] out;
   input [31:0]  in;
   reg [31:0]    out;
   
   always @(in)
     out = in + 1;
   
endmodule
