module load_in_counter(countout,clk,reset);
   output [31:0] countout;
   input         clk,reset;
   reg [31:0]    countout;
   
   always @ (posedge clk)
     if (reset)
       countout <= 0;
     else
       countout <= countout + 1;
endmodule
