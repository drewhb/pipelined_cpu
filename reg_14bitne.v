// Register, 14 bits, no enable input
module reg_14bitne(out, in, reset, clk);

   output [13:0]  out;
   reg [13:0]     out;
   input [13:0]   in;
   input          clk, reset;
   
   always @(posedge clk)
     
     begin
        if(reset == 1'b1)
          out <= 0;
        else
          out <= in;
     end
   
endmodule
