// Register, 32 bits, no enable input
module reg_32bitne(out, in, reset, clk);

   output [31:0] out;
   reg [31:0]    out;
   input [31:0]  in;
   input         clk, reset;
   
   always @(posedge clk)
     begin
        if(reset == 1'b1)
          out <= 0;
        else
          out <= in;
     end
   
endmodule
