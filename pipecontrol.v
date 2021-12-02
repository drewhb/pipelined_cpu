module pipecontrol(opcode, equal, RegDst, AluOp, AluSrc, BranchMux, MemRead, MemWrite, ZeroMux, RegWrite, MemToReg, IfFlush);
   input     [5:0] opcode;
   input           equal;
   output [1:0]    AluOp, BranchMux;
   output          RegDst, AluSrc, MemRead, MemWrite, ZeroMux, RegWrite, MemToReg, IfFlush;
   reg [1:0]       AluOp;
   reg             RegDst, AluSrc, MemRead, MemWrite, ZeroMux, RegWrite, MemToReg, IfFlush;
   reg [2:0]       caseoperation, BranchMux;
   
   parameter rformat = 0;
   parameter    iformat = 1;
   parameter lw    = 2;
   parameter    sw = 3;
   parameter    beq = 4;
   parameter    bne = 5;
   parameter     j = 6;
   
   always @ (opcode)
     begin
        caseoperation = 0;
        if (opcode == 0)
          caseoperation = rformat;
        if (opcode == 6'd8 || opcode == 6'd10 || opcode == 6'd12 || opcode == 6'd13 || opcode == 6'd15)
          caseoperation = iformat;
        if (opcode == 6'd35)
          caseoperation = lw;
        if (opcode == 6'd43)
          caseoperation = sw;
        if (opcode == 6'd4)
          caseoperation = beq;
        if (opcode == 6'd5)
          caseoperation = bne;
        if (opcode == 6'd2)
          caseoperation = j;
        
     end 
   always @ (caseoperation or equal)
     begin
        case (caseoperation)
          rformat: begin
             RegDst = 1;
             AluOp = 2'b10;
             AluSrc = 0;
             BranchMux = 0;
             MemRead = 0;
             MemWrite = 0;
             ZeroMux = 1;        //don't care - for branches only
             RegWrite = 1;
             MemToReg = 0;
             IfFlush = 0;
          end
          
          iformat: begin
             RegDst = 0;         //changed from a one
             AluOp = 2'b11;
             AluSrc = 1;
             BranchMux = 0;
             MemRead = 0;
             MemWrite = 0;
             ZeroMux = 1;        // don't care - for branches only
             RegWrite = 1;
             MemToReg = 0;
             IfFlush = 0;
          end
          
          lw: begin
             RegDst = 0;
             AluOp = 2'b00;
             AluSrc = 1;
             BranchMux = 0;
             MemRead = 1;
             MemWrite = 0;
             ZeroMux = 1;        // don't care - for branches only
             RegWrite = 1;
             MemToReg = 1;
             IfFlush = 0;
          end
          
          sw: begin
             RegDst = 0;            //don't care
             AluOp = 2'b00;
             AluSrc = 1;
             BranchMux = 0;
             MemRead = 0;
             MemWrite = 1;
             ZeroMux = 1;        // don't care - for branches only
             RegWrite = 0;
             MemToReg = 0;        //don't care
             IfFlush = 0;
          end
          
          beq: begin
             RegDst = 0;            // don't care
             AluOp = 2'b01;
             AluSrc = 0;
             MemRead = 0;
             MemWrite = 0;
             ZeroMux = 0;        // for branches only
             RegWrite = 0;
             MemToReg = 0;        // don't care
             if (equal == 1)
               begin IfFlush = 1; BranchMux = 1; end
             else begin IfFlush = 0; BranchMux = 0; end
          end
          
          bne: begin
             RegDst = 0;            // don't care
             AluOp = 2'b01;
             AluSrc = 0;
             MemRead = 0;
             MemWrite = 0;
             ZeroMux = 1;        // for branches only
             RegWrite = 0;
             MemToReg = 0;        // don't care
             if (equal == 0)
               begin IfFlush = 1; BranchMux = 1; end
             else begin IfFlush = 0; BranchMux = 0; end
          end
          
          j: begin
             RegDst = 0;            // don't care
             AluOp = 2'b00;        // don't care
             AluSrc = 0;            // don't care
             BranchMux = 2;            
             MemRead = 0;
             MemWrite = 0;        
             ZeroMux = 0;        // for branches only
             RegWrite = 0;
             MemToReg = 0;        // don't care
             IfFlush = 1;
          end
        endcase
     end
endmodule
