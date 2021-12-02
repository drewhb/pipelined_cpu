module alu(a, b, aluop, shamt,  result, hi, lo);
   input signed    [31:0]    a, b;
   input [3:0]               aluop;
   input [4:0]               shamt;
   
   output signed [31:0]      result, hi, lo;
   reg [31:0]                result, hi, lo;
   
   
   always @(a or b or aluop or shamt)
     begin
        lo = 0;
        hi = 0;
        result = 0;
        case (aluop)
          4'b0000:    result = a & b;          // and
          4'b0001:    result = a | b;          // or
          4'b0010:    result = a+b;            // add
          4'b0011:    result = b << shamt;     // shift left
          4'b0100:    result = b >> shamt;     // shift right
          4'b0101:    result = b << 16;        // load upper immidate
          4'b0110:    result = a-b;            // subtract    
          4'b0111:            // set if less than
            if (a < b)
              result = 1;
            else
              result = 0;
          4'b1000:    begin                // multiply
             {hi,lo} = a*b;
          end
          default:     result = 0;
        endcase
     end
endmodule
