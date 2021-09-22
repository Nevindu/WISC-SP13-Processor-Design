/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module proc (/*AUTOARG*/
   // Outputs
   err, 
   // Inputs
   clk, rst
   );

   input clk;
   input rst;

   output err;

   // None of the above lines can be modified

   // OR all the err ouputs for every sub-module and assign it as this
   // err output
   
   // As desribed in the homeworks, use the err signal to trap corner
   // cases that you think are illegal in your statemachines
   
   
   /* your code here */
   
   wire fetch_err, decode_err, execute_err, memory_err, write_err;
   
   wire PCSel_DtToF;
   wire IFWrite, IFFlush, PCWrite;
   wire  Halt_DtoXRegIn, Halt_DtoXRegOut, Halt_XtoMRegIn,Halt_XtoMRegOut, Halt; //, Halt_MtoWRegIn,Halt_MtoWRegOut,
   wire [15:0] BJAddr_DtoF;
   wire [15:0] PCInc_FtoDRegIn, PCInc_FtoDRegOut, PCInc_DtoXRegIn, PCInc_DtoXRegOut;// PCInc_XtoMRegIn, PCInc_XtoMRegOut, PCInc_MtoWRegIn,PCInc_MtoWRegOut;
   wire [15:0] Instr_FtoDRegIn, Instr_FtoDRegOut, Instr_DtoXRegIn, Instr_DtoXRegOut;
   
   wire [2:0] WR_XtoMRegIn,WR_XtoMRegOut, WR_MtoWRegIn,WR_MtoWRegOut,WR_WtoD;
   wire [15:0] WD_WtoD;
   
   wire  RegWriteDataSel_DXRegIn,RegWriteDataSel_DXRegOut, RegWriteDataSel_XMRegIn, RegWriteDataSel_XMRegOut, RegWriteDataSel_MWRegIn,RegWriteDataSel_MWRegOut;
   wire MemReadEn_DXRegIn,MemReadEn_DXRegOut, MemReadEn_XMRegIn, MemReadEn_XMRegOut;
   wire MemWriteEn_DXRegIn,MemWriteEn_DXRegOut, MemWriteEn_XMRegIn, MemWriteEn_XMRegOut;
   
   wire [3:0] ALUOp_DXRegIn, ALUOp_DXRegOut;
   wire [1:0] RegDst_DXRegIn,RegDst_DXRegOut, ALUSelB_DXRegIn,ALUSelB_DXRegOut;
   //wire ZRegIn,ZRegOut, OflRegIn, OflRegOut, NRegIn, NRegOut, CoutRegIn, CoutRegOut, 
   wire CinRegIn, CinRegOut, invARegIn, invARegOut;
   wire [15:0] JSe_DXRegIn, JSe_DXRegOut, I2Se_DXRegIn, I2Se_DXRegOut, ISe_DXRegIn,ISe_DXRegOut, RD1_DXRegIn,RD1_DXRegOut, RD2_DXRegIn, RD2_DXRegOut;
   wire [15:0] RD2_XMRegIn,RD2_XMRegOut,  ALUResult_XMRegIn,ALUResult_XMRegOut, ALUResult_MWRegIn, ALUResult_MWRegOut;
   
   
   wire [2:0] SelFlag_DXRegIn, SelFlag_DXRegOut; //SelFlag_XMRegIn,SelFlag_XMRegOut;
   
   wire [15:0] ReadDataRegIn, ReadDataRegOut;
   //wire ConditionRegIn, ConditionRegOut;
   wire WriteToReg_DXRegIn,WriteToReg_DXRegOut, WriteToReg_XMRegIn, WriteToReg_XMRegOut, WriteToReg_MWRegIn,WriteToReg_MWRegOut, WriteToReg_WD;
   wire [1:0] selForwardA;
   wire selCond_DXRegIn, selCond_DXRegOut, selPCInc_DXRegIn, selPCInc_DXRegOut;
   
   fetch_stage fetch(.PCsel_In_FromD(PCSel_DtToF), 
					.BJAddr_In_FromD(BJAddr_DtoF), 
					.Halt_In_FromD(Halt), 
					.PCWrite(PCWrite),
					.clk(clk), 
					.rst(rst), 
					
					.PCInc_Out_ToD(PCInc_FtoDRegIn), 
					.Instr_Out_ToD(Instr_FtoDRegIn), 
					.err(fetch_err)
					);
					
   ifid_pipeline IFID(
				.PCInc_Out_ToD(PCInc_FtoDRegIn),
				.Instr_Out_ToD(Instr_FtoDRegIn),
				.IFWrite(IFWrite),
				.IFFlush(IFFlush),
				.clk(clk),
				.rst(rst),
				
				.Instr_In_FromF(Instr_FtoDRegOut), 
				.PCInc_In_FromF(PCInc_FtoDRegOut)
				);
   
   decode_stage decode(.Instr_In_FromF(Instr_FtoDRegOut), 
					  .PCInc_In_FromF(PCInc_FtoDRegOut), 
					  .WR_In_FromW(WR_WtoD),
					  .WD_In_FromW(WD_WtoD),  
					  .WriteToReg_FromW(WriteToReg_WD), 
					  
					  .XForwardA(ALUResult_XMRegOut),
					  .MForwardA(WD_WtoD),
					  .DXRd(WR_XtoMRegIn),
					  .DXMemRead(MemReadEn_DXRegOut),
					   
					
					  .DForwardA(ALUResult_XMRegIn),
					  .XMWriteToReg(WriteToReg_XMRegOut),
					  .XMRd(WR_XtoMRegOut),
					  .MWWriteToReg(WriteToReg_MWRegOut),
					  .MWRd(WR_MtoWRegOut),
					  .DXWriteToReg(WriteToReg_DXRegOut),
					
					   
					  .clk(clk), 
					  .rst(rst), 
					  
					  .RegWriteDataSel(RegWriteDataSel_DXRegIn), 
					  .ALUOp(ALUOp_DXRegIn), 
					  .MemReadEn(MemReadEn_DXRegIn), 
					  .MemWriteEn(MemWriteEn_DXRegIn),
					  .RegDst(RegDst_DXRegIn),
					  .ALUSelB(ALUSelB_DXRegIn), 
					  .SelFlag(SelFlag_DXRegIn),
					  .JSe(JSe_DXRegIn), 
					  .ISe(ISe_DXRegIn), 
					  .I2Se(I2Se_DXRegIn), 
					  .RD1(RD1_DXRegIn), 
					  .RD2(RD2_DXRegIn), 
					  .Instr_Out_ToX(Instr_DtoXRegIn), 
					  .PCInc_Out_ToX(PCInc_DtoXRegIn), 
					  .PCSel(PCSel_DtToF),
					  .BJAddr_Out_ToF(BJAddr_DtoF), 
					  .Halt(Halt_DtoXRegIn), 
					  .Cin(CinRegIn), 
					  .invA(invARegIn), 
					  .WriteToReg(WriteToReg_DXRegIn),
					  .err(decode_err),
					  .IFWrite(IFWrite),
					  .IFFlush(IFFlush),
					  .PCWrite(PCWrite),
					  .selCond(selCond_DXRegIn),
					  .selPCInc(selPCInc_DXRegIn)
					  );
					  
	
    idex_pipeline IDEX(
					//Inputs: (From stage D)
					.Instr_Out_ToX(Instr_DtoXRegIn), 
					.PCInc_Out_ToX(PCInc_DtoXRegIn), 
					.RegWriteDataSel_ToX(RegWriteDataSel_DXRegIn), 
					.JSe_ToX(JSe_DXRegIn),
					.I2Se_ToX(I2Se_DXRegIn),
					.ISe_ToX(ISe_DXRegIn),
					.RD1_ToX(RD1_DXRegIn), 
					.RD2_ToX(RD2_DXRegIn), 
					//Control signal inputs:
					.ALUOp_ToX(ALUOp_DXRegIn),
					.MemReadEn_ToX(MemReadEn_DXRegIn), 
					.MemWriteEn_ToX(MemWriteEn_DXRegIn), 
					.RegDst_ToX(RegDst_DXRegIn), 
					.ALUSelB_ToX(ALUSelB_DXRegIn),
					.SelFlag_ToX(SelFlag_DXRegIn),
					.Halt_ToX(Halt_DtoXRegIn), 
					.Cin_ToX(CinRegIn), 
					.invA_ToX(invARegIn),
					.WriteToReg_ToX(WriteToReg_DXRegIn),
					.selCond_ToX(selCond_DXRegIn),
					.selPCInc_ToX(selPCInc_DXRegIn),
					
					.clk(clk),
					.rst(rst),
					
					//Outputs: (To stage X)
					.Instr_In_FromD(Instr_DtoXRegOut), 
					.PCInc_In_FromD(PCInc_DtoXRegOut), 
					.RegWriteDataSel_In_FromD(RegWriteDataSel_DXRegOut),
					.ALUOp_FromD(ALUOp_DXRegOut), 
					.MemReadEn_In_FromD(MemReadEn_DXRegOut), 
					.MemWriteEn_In_FromD(MemWriteEn_DXRegOut), 
					.RegDst_FromD(RegDst_DXRegOut),
					.ALUSelB_FromD(ALUSelB_DXRegOut),
					.SelFlag_In_FromD(SelFlag_DXRegOut),
					.JSe_FromD(JSe_DXRegOut), 
					.ISe_FromD(ISe_DXRegOut), 
					.I2Se_FromD(I2Se_DXRegOut),
					.RD1_FromD(RD1_DXRegOut),
					.RD2_In_FromD(RD2_DXRegOut), 
					.invA_FromD(invARegOut),
					.Cin_FromD(CinRegOut), 
					.Halt_In_FromD(Halt_DtoXRegOut),
					.WriteToReg_FromD(WriteToReg_DXRegOut),
					.selCond_FromD(selCond_DXRegOut),
					.selPCInc_FromD(selPCInc_DXRegOut)
					
				);
					 
    execute_stage execute(
					.Instr_In_FromD(Instr_DtoXRegOut),
					.PCInc_In_FromD(PCInc_DtoXRegOut), 
					.RegWriteDataSel_In_FromD(RegWriteDataSel_DXRegOut), 
					.ALUOp(ALUOp_DXRegOut), 
					.MemReadEn_In_FromD(MemReadEn_DXRegOut), 
					.MemWriteEn_In_FromD(MemWriteEn_DXRegOut), 
					.RegDst(RegDst_DXRegOut) , 
					.ALUSelB(ALUSelB_DXRegOut),
					.SelFlag_In_FromD(SelFlag_DXRegOut),
					.JSe(JSe_DXRegOut),
					.ISe(ISe_DXRegOut), 
					.I2Se(I2Se_DXRegOut), 
					.RD1(RD1_DXRegOut),
					.RD2_In_FromD(RD2_DXRegOut), 
					.invA(invARegOut), 
					.Cin(CinRegOut), 
					.Halt_In_FromD(Halt_DtoXRegOut),
					.WriteToReg_FromD(WriteToReg_DXRegOut),
					//Forwarding unit input
					.XForwardA(ALUResult_XMRegOut), //ExMem ALU result output
					.XForwardB(ALUResult_XMRegOut),
					.MForwardA(WD_WtoD),
					.MForwardB(WD_WtoD),
					.XMWriteToReg(WriteToReg_XMRegOut),
					.XMRd(WR_XtoMRegOut),
					.MWWriteToReg(WriteToReg_MWRegOut),
					.MWRd(WR_MtoWRegOut),
					.selCond(selCond_DXRegOut),
					.selPCInc(selPCInc_DXRegOut),
					
					//Outputs
					.RegWriteDataSel_Out_ToMem(RegWriteDataSel_XMRegIn),
					.MemReadEn_Out_ToMem(MemReadEn_XMRegIn),
					.MemWriteEn_Out_ToMem(MemWriteEn_XMRegIn), 
					//.PCInc_Out_ToMem(PCInc_XtoMRegIn),
					.Z(ZRegIn),
					.Ofl(OflRegIn), 
					.N(NRegIn) , 
					.Cout(CoutRegIn),
					.ALUResult(ALUResult_XMRegIn), 
					.WR_Out_ToMem(WR_XtoMRegIn), 
					.RD2_Out_ToMem(RD2_XMRegIn),
					//.SelFlag_Out_ToMem(SelFlag_XMRegIn), 
					.Halt_Out_ToMem(Halt_XtoMRegIn),
					.WriteToReg_ToMem(WriteToReg_XMRegIn),
					.selForwardA(selForwardA),
					.err(execute_err)
					);
					
					

	exmem_pipeline EXMEM(
					
					//Inputs: (From Stage X)
					.RegWriteDataSel_Out_ToMem(RegWriteDataSel_XMRegIn),
					.MemReadEn_Out_ToMem(MemReadEn_XMRegIn), 
					.MemWriteEn_Out_ToMem(MemWriteEn_XMRegIn), 
					//.PCInc_Out_ToMem(PCInc_XtoMRegIn),
					.Z_ToMem(ZRegIn), 
					.Ofl_ToMem(OflRegIn),
					.N_ToMem(NRegIn),
					.Cout_ToMem(CoutRegIn),
					.ALUResult_ToMem(ALUResult_XMRegIn),
					.WR_Out_ToMem(WR_XtoMRegIn),
					.RD2_Out_ToMem(RD2_XMRegIn), 
					//.SelFlag_Out_ToMem(SelFlag_XMRegIn),
					.Halt_Out_ToMem(Halt_XtoMRegIn), 
					.WriteToReg_ToMem(WriteToReg_XMRegIn),
					
					.clk(clk),
					.rst(rst),
					
					//Outputs: (To Stage M)
					.RegWriteDataSel_In_FromX(RegWriteDataSel_XMRegOut),
					.MemReadEn_In_FromX(MemReadEn_XMRegOut), 
					.MemWriteEn_In_FromX(MemWriteEn_XMRegOut), 
					//.PCInc_In_FromX(PCInc_XtoMRegOut),
					.Z_FromX(ZRegOut), 
					.Ofl_FromX(OflRegOut),
					.N_FromX(NRegOut),
					.Cout_FromX(CoutRegOut),
					.ALUResult_FromX(ALUResult_XMRegOut),
					.WR_In_FromX(WR_XtoMRegOut),
					.RD2_In_FromX(RD2_XMRegOut), 
					//.SelFlag_In_FromX(SelFlag_XMRegOut),
					.Halt_In_FromX(Halt_XtoMRegOut),
					.WriteToReg_FromX(WriteToReg_XMRegOut)
					);
					
	memory_stage memory(
					.RegWriteDataSel_In_FromX(RegWriteDataSel_XMRegOut), 
					.MemReadEn_In_FromX(MemReadEn_XMRegOut),
					.MemWriteEn_In_FromX(MemWriteEn_XMRegOut),
					//.PCInc_In_FromX(PCInc_XtoMRegOut),
					//.Ofl(OflRegOut),
					//.Z(ZRegOut),
					//.N(NRegOut), 
					//.Cout(CoutRegOut), 
					.ALUResult_In_FromX(ALUResult_XMRegOut), 
					.WR_In_FromX(WR_XtoMRegOut), 
					.RD2_In_FromX(RD2_XMRegOut), 
					//.SelFlag_In_FromX(SelFlag_XMRegOut), 
					.Halt_In_FromX(Halt_XtoMRegOut),
					.WriteToReg_FromX(WriteToReg_XMRegOut),
					//.Halt_Signal(Halt),
					.clk(clk), 
					.rst(rst),
					
					.RegWriteDataSel_Out_ToW(RegWriteDataSel_MWRegIn),
					//.PCInc_Out_ToW(PCInc_MtoWRegIn), 
					.ReadData(ReadDataRegIn), 
					.ALUResult_Out_ToW(ALUResult_MWRegIn), 
					.WR_Out_ToW(WR_MtoWRegIn),
					//.Condition(ConditionRegIn), 
					.WriteToReg_ToW(WriteToReg_MWRegIn),
					.Halt_Signal(Halt),
					.err(memory_err)
					);
		
	
	memwb_pipeline MEMWB(
					//Inputs: (From Stage M)
					.RegWriteDataSel_Out_ToW(RegWriteDataSel_MWRegIn), 
					//.PCInc_Out_ToW(PCInc_MtoWRegIn), 
					.ReadData_ToW(ReadDataRegIn), 
					.ALUResult_Out_ToW(ALUResult_MWRegIn),
					.WR_Out_ToW(WR_MtoWRegIn), 
					//.Condition_ToW(ConditionRegIn),
					.WriteToReg_ToW(WriteToReg_MWRegIn),
					//.Halt_ToW(Halt_MtoWRegIn),
					.clk(clk),
					.rst(rst),
					
					//Outputs: (To Stage W)
					.RegWriteDataSel_In_FromM(RegWriteDataSel_MWRegOut), 
					//.PCInc_In_FromM(PCInc_MtoWRegOut), 
					.ReadData_FromM(ReadDataRegOut), 
					.ALUResult_In_FromM(ALUResult_MWRegOut),
					.WR_In_FromM(WR_MtoWRegOut), 
					//.Condition_FromM(ConditionRegOut),
					.WriteToReg_FromM(WriteToReg_MWRegOut)
					//.Halt_FromM(Halt_MtoWRegOut)
					);
	
	write_stage write(
					.RegWriteDataSel_In_FromMem(RegWriteDataSel_MWRegOut), 
					//.PCInc_In_FromMem(PCInc_MtoWRegOut), 
					//.Condition_In_FromMem(ConditionRegOut), 
					.ReadData_In_FromMem(ReadDataRegOut), 
					.ALUResult_In_FromMem(ALUResult_MWRegOut), 
					.WR_In_FromMem(WR_MtoWRegOut),
					.WriteToReg_FromMem(WriteToReg_MWRegOut),
					//.Halt_FromMem(Halt_MtoWRegOut),
	
					//Outputs
					.WR_Out_ToD(WR_WtoD), 
					.WD_Out_ToD(WD_WtoD), 
					.WriteToReg_ToD(WriteToReg_WD),
					//.Halt_Signal(Halt),
					.err(write_err)
					);
					   
					   
					   
   assign err = fetch_err | decode_err | execute_err | memory_err | write_err;
endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
