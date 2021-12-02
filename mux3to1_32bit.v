module mux3to1_32bit(out, in0,in1,in2,select);
   output [31:0] out;
   reg [31:0]    out;
   input [31:0]  in0, in1, in2;
   input [1:0]   select;
   
   always @(select or in0 or in2 or in1)
     begin
        case(select)
          
          0:    out = in0;
          1:    out = in1;
          2:    out = in2;
          default: out = in0;
        endcase
     end
   
endmodule
