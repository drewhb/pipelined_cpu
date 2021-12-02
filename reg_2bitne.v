// Register, 2 bits, no enable input
module reg_2bitne(out, in, reset, clk);

   output  [1:0]  out;
   reg [1:0]      out;
   input [1:0]    in;
   input          clk, reset;
   
   always @(posedge clk)
     
     begin
        if(reset == 1'b1)
          out <= 0;
        else
          out <= in;
     end
   
endmodule
