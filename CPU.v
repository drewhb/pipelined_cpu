module CPU(out, clk, Reset, LoadInstructions, Instruction);
   
   output [31:0] out;
   input         Reset, LoadInstructions, clk;
   input [31:0]  Instruction;
   
   // IF Wires
   wire [31:0]   PCIn, PCOut, IncrementedAddress, BranchAddress, InstructionOut;
   wire [31:0]   LoadAddress, InstructionAddress, JumpAddress;
   wire          PCWrite, IF_Flush, IF_FlushorReset, IFID_Enable;
   wire [1:0]    PCSelect;
   
   // IF/ID Wires
   wire [31:0]   IDEX_Instruction, IDEX_PC;
   
   // ID Wires
   wire          HazardMuxSelect;
   
   wire [5:0]    OpCode;
   assign OpCode = IDEX_Instruction[31:26];
   wire          RegDst, Equal, AluSrc, MemRead, MemWrite;
   wire          ZeroMuxSelect, RegWrite, MemToReg;
   wire [1:0]    AluOp;
   
   wire [5:0]    Funct;
   assign Funct = IDEX_Instruction[5:0];
   wire [1:0]    AluMux;
   wire          HiLoEnable;
   
   wire [1:0]    WBControl, MEMControl;
   wire [13:0]   EXControl;
   
   
   wire [15:0]   BOffset;
   assign BOffset = IDEX_Instruction[15:0];
   wire [25:0]   JOffset;
   assign JOffset     = IDEX_Instruction[25:0];
   
   wire          CompareOut;
   wire [4:0]    ReadReg1, ReadReg2;
   assign ReadReg1 = IDEX_Instruction[25:21];
   assign ReadReg2 = IDEX_Instruction[20:16];
   wire [31:0]   RegSrcA, RegSrcB;
   wire [31:0]   Immediate;
   wire [8:0]    AluCntrlOut;
   wire [4:0]    Shamt;
   assign Shamt = IDEX_Instruction[10:6];
   
   
   //ID/EX Wires
   
   wire [1:0]    IDEX_WBControl, IDEX_MEMControl;
   wire [13:0]   IDEX_EXControl;
   wire [31:0]   IDEX_A, IDEX_B;
   wire [31:0]   IDEX_Immediate;
   wire [4:0]    IDEX_Rs, IDEX_Rt, IDEX_Rd;
   
   // EX Wires
   wire          MemReadEx;
   assign MemReadEx = IDEX_MEMControl[1];
   wire [1:0]    MuxASelect;
   wire [1:0]    MuxBSelect;
   wire [31:0]   AluA, AluB, AluIB;
   
   wire          EX_AluSrc,  EX_HiLoEnable, EX_RegDst;
   //wire [1:0] EX_AluMux;
   wire [8:0]    EX_AluCntrlOut;
   wire [1:0]    EX_AluMuxSelect;
   assign EX_HiLoEnable = IDEX_EXControl[0];
   assign EX_AluMuxSelect = IDEX_EXControl[2:1];
   assign EX_AluSrc = IDEX_EXControl[3];
   assign EX_AluCntrlOut = IDEX_EXControl[12:4];
   assign EX_RegDst =     IDEX_EXControl[13];
   
   wire [31:0]   AluResult, Hi, Lo, AluMuxResult;
   wire [31:0]   HiRegOut, LoRegOut;
   
   wire [4:0]    RegDestMuxOut;
   
   ///  Ex/Mem Wires
   
   wire [1:0]    EXMEM_WBControl;
   
   wire [1:0]    EXMEM_MEMControl;
   wire [31:0]   MEM_Data;
   
   
   // Mem Wires
   wire [31:0]   MemAluOut;
   wire [4:0]    MemDest;
   
   wire          MEM_RegWrite;
   assign MEM_RegWrite = EXMEM_WBControl[0];  //WB TAP FOR FORWARD
   
   wire          MEM_MemRead;
   wire          MEM_MemWrite;
   assign MEM_MemRead = EXMEM_MEMControl[1];
   assign MEM_MemWrite = EXMEM_MEMControl[0];
   
   wire [31:0]   MemOut;
   
   // Mem/WB
   wire [1:0]    WB_WBControl;
   wire [31:0]   WBMemOut, WBAluOut;
   
   //WB Wires
   wire          RegWriteWB;
   assign RegWriteWB =  WB_WBControl[0];
   wire          MemToRegSelect;
   assign MemToRegSelect = WB_WBControl[1];
   wire [31:0]   WriteBackData;
   assign out = WriteBackData;
   wire [4:0]    WriteBackDest;
   
   
   
   //1 and 2 ahead //FORWARDING UNIT
   wire ex_mem_rd, mem_wb_rd, id_ex_rt, id_ex_rs;
   wire [2:0] forwardA, forwardB;
   wire [31:0] outputA, outputB;
   
   

   ////////////////// IF Stage    ////////////////////////////
   
   reg_32bit             PC(PCOut, PCIn, PCWrite, Reset, clk);
   memory2               InstructionMem(clk, 1'b1, LoadInstructions, InstructionAddress,
                                        Instruction, InstructionOut);
   //memory            InstructionMem(clk, InstructionAddress[4:0], Instruction, LoadInstructions, InstructionOut);
   
   mux2to1                AddressMux(InstructionAddress, PCOut, LoadAddress, LoadInstructions);
   load_in_counter    AddressCounter(LoadAddress,clk,Reset);
   
   incrementer            Increment(IncrementedAddress, PCOut);
   mux3to1_32bit                BranchMux(PCIn, IncrementedAddress, BranchAddress, JumpAddress, PCSelect);
   
   //////////////////// IF / ID ////////////////////////////
   reg_32bit            IFID_PCReg(IDEX_PC, IncrementedAddress, IFID_Enable, IF_FlushorReset, clk);
   or                     FlushOr(IF_FlushorReset, IF_Flush, Reset);
   reg_32bit            IFID_InstructionReg(IDEX_Instruction, InstructionOut, IFID_Enable, IF_FlushorReset, clk);
   
   //////////////////  ID Stage    ///////////////////////////
   
   hazardunit       HazardDetectionUnit(IFID_Enable,PCWrite,HazardMuxSelect);
   
   pipecontrol       Control(OpCode, Equal, RegDst, AluOp, AluSrc, PCSelect, MemRead, MemWrite,
                             ZeroMuxSelect, RegWrite, MemToReg, IF_Flush);
   
   multiplycontrol  MultControl(OpCode,Funct,AluMux,HiLoEnable);
   
   stallmux StalMux(WBControl, MEMControl, EXControl, MemToReg, RegWrite,
                    MemRead, MemWrite,
                    RegDst, AluCntrlOut, AluSrc, AluMux, HiLoEnable,
                    HazardMuxSelect);
   
   jumpadd  SmartAddressAdder(BranchAddress, JOffset, BOffset, OpCode, IDEX_PC);
   
   mux2to1_1bit ZeroMux(Equal, CompareOut, ~CompareOut, ZeroMuxSelect);
   
   RegFile RegisterFile(clk, Reset, WriteBackData, WriteBackDest, RegWriteWB, ReadReg1, ReadReg2, 
                        RegSrcA, RegSrcB);
   
   signextend SignExtender(Immediate, BOffset);
   signextend26 SignExtender26(JumpAddress, IDEX_Instruction[25:0]);
   
   alucontrol AluCntrl(Funct, OpCode, AluOp , Shamt, AluCntrlOut);
   
   
   //////////////////  ID/ EX   /////////////////////////////////////
   
   reg_2bitne  IDEX_WBReg(IDEX_WBControl, WBControl, Reset, clk);
   reg_2bitne  IDEX_MEMReg(IDEX_MEMControl, MEMControl, Reset, clk);
   reg_14bitne IDEX_EXReg(IDEX_EXControl, EXControl, Reset, clk);
   
   reg_32bitne IDEX_RegSrcA(IDEX_A, RegSrcA, Reset, clk);
   reg_32bitne IDEX_RegSrcB(IDEX_B, RegSrcB, Reset, clk);
   
   reg_32bitne IDEX_ImmediateReg(IDEX_Immediate,
                                 HazardMuxSelect?0:Immediate,
                                 Reset, clk);
   
   reg_5bitne  IDEX_RsReg(IDEX_Rs,
                          HazardMuxSelect?0:IDEX_Instruction[25:21],
                          Reset, clk);
   reg_5bitne  IDEX_RtReg(IDEX_Rt,
                          HazardMuxSelect?0:IDEX_Instruction[20:16],
                          Reset, clk);
   reg_5bitne  IDEX_RdReg(IDEX_Rd,
                          HazardMuxSelect?0:IDEX_Instruction[15:11],
                          Reset, clk);


   /////////////////   EX Stage ///////////////////////////////////////
   
   mux2to1 ImmAluBMux(AluIB, IDEX_B, IDEX_Immediate, EX_AluSrc);
   
   alu MarkAlu(outputA,
               outputB,
               EX_AluCntrlOut[3:0],
               EX_AluCntrlOut[8:4],
               AluResult,
               Hi,
               Lo);

   reg_32bit HiReg(HiRegOut, Hi, EX_HiLoEnable, Reset, clk);
   reg_32bit LoReg(LoRegOut, Lo, EX_HiLoEnable, Reset, clk);

   mux3to1_32bit AluResultMux(AluMuxResult,
                              AluResult,
                              HiRegOut,
                              LoRegOut,
                              EX_AluMuxSelect);
   
   mux2to1_5bit RegDstMux(RegDestMuxOut, IDEX_Rt, IDEX_Rd, EX_RegDst);
   
   ///////////////// Forwarding Unit //////////////////////////////////
   
     ForwardingUnit forward(forwardA,forwardB, IDEX_Rs, IDEX_Rt, MemDest, WriteBackDest, RegWriteWB, MEM_RegWrite);
     muxA muxa(outputA, IDEX_A, WriteBackData, MemAluOut, forwardA);
     muxB muxb(outputB, AluIB, WriteBackData, MemAluOut, forwardB);
     
     
   ////////////////   EX/MEM  /////////////////////////////////////////
   
   reg_2bitne  EXMEM_WBReg(EXMEM_WBControl, IDEX_WBControl, Reset, clk);
   reg_2bitne  EXMEM_MEMReg(EXMEM_MEMControl, IDEX_MEMControl, Reset, clk);
   
   reg_32bitne EXMEM_ALUReg(MemAluOut, AluMuxResult, Reset, clk);
   
   reg_5bitne  EXMEM_RegDest(MemDest, RegDestMuxOut, Reset, clk);
   
   reg_32bitne EXMEM_MemData(MEM_Data, IDEX_B, Reset, clk);
   
   
   
   ///////////// MEM   /////////////////////////////////////////////////
   
   memory2 DataMem(clk, MEM_MemRead, MEM_MemWrite, MemAluOut, MEM_Data, MemOut);
   //memory DataMem(clk, MemAluOut[4:0], MEM_Data, MEM_MemWrite, MemOut);
   
   
   /////////////  MEM/WB //////////////////////////////////////////////
   
   reg_2bitne  MEMWB_WBControl(WB_WBControl, EXMEM_WBControl, Reset, clk);
   
   reg_32bitne MEMWB_MemDataReg(WBMemOut, MemOut, Reset, clk);
   
   reg_32bitne MEMWB_ALUReg(WBAluOut, MemAluOut, Reset, clk);
   
   reg_5bitne MEMWB_DataMem(WriteBackDest, MemDest, Reset, clk);
   
   
   ////////////   WB    ////////////////////////////////////////////////
   
   mux2to1 MemToRegMux(WriteBackData, WBAluOut, WBMemOut, MemToRegSelect);
   
endmodule
