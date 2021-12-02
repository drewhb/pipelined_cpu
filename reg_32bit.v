// Register, 32 bits (with an enable input)
module reg_32bit(out, in, enable, reset, clk);

   output [31:0] out;
   reg [31:0]    out;
   input [31:0]  in;
   input         enable, clk, reset;
   
   always @(posedge clk)
     begin
        if(reset)
          out <= 0;
        else
          if(enable)
            out <= in;
     end

endmodule
