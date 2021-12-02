module alucontrol(funct,opcode,aluop, shamt, aluout);
   input [5:0]    funct,opcode;
   input [1:0]    aluop;
   output [8:0]   aluout;
   reg [3:0]      alu;
   input [4:0]    shamt;    
   
   assign  aluout = {shamt, alu};
   
   always @(funct or aluop or opcode)
     begin
        case (aluop)
          2'b00:    alu = 4'b0010;        // lw / sw - add
          2'b01:    alu = 4'b0110;        // beq / bne - subtract
          2'b10: begin
             case (funct)
               0:    alu = 4'b0011;       // shift left
               2:    alu = 4'b0100;       // shift right
               32:   alu = 4'b0010;       // add 
               34:   alu = 4'b0110;       // sub
               33:   alu = 4'b0010;       // addu
               35:   alu = 4'b0110;       // subu
               24:   alu = 4'b1000;       // mult
               26:   alu = 4'b1001;       // div
               16:   alu = 4'b0010;       // mfhi - add 
               18:   alu = 4'b0010;       // mflo - add
               36:   alu = 4'b0000;       // and    
               37:   alu = 4'b0001;       // or
               42:   alu = 4'b0111;       // slt
               default: alu = 4'b1111; 
             endcase
          end
          2'b11: begin                // accept I-type
             case (opcode)
               8:    alu = 4'b0010;       // addi
               12:   alu = 4'b0000;       // andi
               13:   alu = 4'b0001;       // ori
               10:   alu = 4'b0111;       // slti
               15:   alu = 4'b0101;       // lui
               default: alu = 4'b1111;
             endcase
          end
        endcase
     end
endmodule

