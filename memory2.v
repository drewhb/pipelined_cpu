module memory2(clk, mem_read, mem_write, address, data_in, data_out);
   input  clk, mem_read, mem_write;
   input [31:0] address, data_in;
   output [31:0] data_out;
   integer       i;
   
   reg [31:0]    mem_array [0:127];
   
   initial begin
      // Fill the first 128 memory cells, each with its own address
      for (i=0; i<128; i=i+1)
        mem_array[i] <= i;
      
   end
   
   always @(posedge clk)
     begin
        if(mem_write)
          mem_array[address] <= data_in;
     end
   
   assign data_out = mem_array[address];
endmodule
