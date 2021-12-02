// Register, 5 bits, no enable input
module reg_5bitne(out, in, reset, clk);

   output  [4:0] out;
   reg [4:0]     out;
   input [4:0]   in;
   input         clk, reset;
   
   always @(posedge clk)
     
     begin
        if(reset == 1'b1)
          out <= 0;
        else
          out <= in;
     end

endmodule
