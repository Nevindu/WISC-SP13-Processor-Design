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
   
   wire PCSel_DtToF, PCSel_XtoD, PCSel_MtoX;
   wire  Halt_DtoF, Halt_XtoM;
   wire [15:0] BJAddr_DtoF, BJAddr_XtoD, BJAddr_MtoX, BJAddr_XtoM;
   wire [15:0] PCInc_FtoD, PCInc_DtoX, PCInc_XtoM, PCInc_MtoW;
   wire [15:0] Instr_FtoD, Instr_DtoX;
   
   wire [2:0] WR_XtoM, WR_MtoW, WR_WtoM, WR_MtoX, WR_XtoD;
   wire [15:0] WD_WtoM, WD_MtoX, WD_XtoD;
   
   wire [1:0] RegWriteDataSel_DX, RegWriteDataSel_XM, RegWriteDataSel_MW;
   wire MemReadEn_DX, MemReadEn_XM;
   wire MemWriteEn_DX, MemWriteEn_XM;
   
   wire [3:0] ALUOp_DX;
   wire [1:0] RegDst_DX, ALUSelB_DX;
   wire PCImmSel_DX, PCAddSel_DX, Z, Ofl, N, Cout, Cin, invA;
   wire [15:0] JSe_DX, I2Se_DX, ISe_DX, RD1_DX, RD2_DX, RD2_XM,  ALUResult_XM, ALUResult_MW;
   
   wire Branch_DX, Branch_XM, Jump_DX, Jump_XM;
   wire [2:0] SelFlag_DX, SelFlag_XM;
   
   wire [15:0] ReadData;
   wire Condition;
   
   fetch_stage fetch(.PCsel_In_FromD(PCSel_DtToF), 
					.BJAddr_In_FromD(BJAddr_DtoF), 
					
					.PCInc_Out_ToD(PCInc_FtoD), 
					.Instr_Out_ToD(Instr_FtoD), 
					.clk(clk), .rst(rst), 
					.Halt_In_FromD(Halt_DtoF), 
					.err(fetch_err)
					);
   
   decode_stage decode(.Instr_In_FromF(Instr_FtoD), 
					  .PCInc_In_FromF(PCInc_FtoD), 
					  .WR_In_FromX(WR_XtoD),
					  .WD_In_FromX(WD_XtoD), 
					  .PCsel_In_FromX(PCSel_XtoD), 
					  .BJAddr_In_FromX(BJAddr_XtoD), 
					  .clk(clk), 
					  .rst(rst), 
					   
					  .RegWriteDataSel(RegWriteDataSel_DX), 
					  .ALUOp(ALUOp_DX), 
					  .MemReadEn(MemReadEn_DX), 
					  .MemWriteEn(MemWriteEn_DX),
					  .RegDst(RegDst_DX),
					  .Branch(Branch_DX), 
					  .Jump(Jump_DX), 
					  .ALUSelB(ALUSelB_DX), 
					  .PCImmSel(PCImmSel_DX),
					  .PCAddSel(PCAddSel_DX), 
					  .SelFlag(SelFlag_DX),
					  .JSe(JSe_DX), 
					  .ISe(ISe_DX), 
					  .I2Se(I2Se_DX), 
					  .RD1(RD1_DX), 
					  .RD2(RD2_DX), 
					  .Instr_Out(Instr_DtoX), 
					  .PCInc_Out(PCInc_DtoX), 
					  .PCsel_Out_ToF(PCSel_DtToF),
					  .BJAddr_Out_ToF(BJAddr_DtoF), 
					  .Halt(Halt_DtoF), 
					  .Cin(Cin), 
					  .invA(invA), 
					  .err(decode_err)
					  );
					 
    execute_stage execute(
					.Instr(Instr_DtoX),
					.PCInc_In_FromD(PCInc_DtoX), 
					.WR_In_FromMem(WR_MtoX), 
					.WD_In_FromMem(WD_MtoX), 
					.PCsel_In_FromMem(PCSel_MtoX),
					.BJAddr_In_FromMem(BJAddr_MtoX),
					.RegWriteDataSel_In_FromD(RegWriteDataSel_DX), 
					.ALUOp(ALUOp_DX), 
					.MemReadEn_In_FromD(MemReadEn_DX), 
					.MemWriteEn_In_FromD(MemWriteEn_DX), 
					.RegDst(RegDst_DX) , 
					.Branch_In_FromD(Branch_DX), 
					.Jump_In_FromD(Jump_DX), 
					.ALUSelB(ALUSelB_DX),
					.PCImmSel(PCImmSel_DX),
					.PCAddSel(PCAddSel_DX),
					.SelFlag_In_FromD(SelFlag_DX),
					.JSe(JSe_DX),
					.ISe(ISe_DX), 
					.I2Se(I2Se_DX), 
					.RD1(RD1_DX),
					.RD2_In_FromD(RD2_DX), 
					.invA(invA), 
					.Cin(Cin), 
					.Halt_In_FromD(Halt_DtoF),
					
					//Outputs
					.RegWriteDataSel_Out_ToMem(RegWriteDataSel_XM),
					.Branch_Out_ToMem(Branch_XM), 
					.Jump_Out_ToMem(Jump_XM), 
					.MemReadEn_Out_ToMem(MemReadEn_XM),
					.MemWriteEn_Out_ToMem(MemWriteEn_XM), 
					.PCInc_Out_ToMem(PCInc_XtoM),
					.BJAddr_Out_ToMem(BJAddr_XtoM), 
					.Z(Z),
					.Ofl(Ofl), 
					.N(N) , 
					.Cout(Cout),
					.ALUResult(ALUResult_XM), 
					.WD_Out_ToD(WD_XtoD),
					.WR_Out_ToMem(WR_XtoM), 
					.WR_Out_ToD(WR_XtoD), 
					.BJAddr_Out_ToD(BJAddr_XtoD), 
					.PCsel_Out_ToD(PCSel_XtoD),
					.RD2_Out_ToMem(RD2_XM),
					.SelFlag_Out_ToMem(SelFlag_XM), 
					.Halt_Out_ToMem(Halt_XtoM),
					.err(execute_err)
					);
					
	memory_stage memory(
					.RegWriteDataSel_In_FromX(RegWriteDataSel_XM), 
					.Branch_In_FromX(Branch_XM),
					.Jump_In_FromX(Jump_XM), 
					.MemReadEn_In_FromX(MemReadEn_XM),
					.MemWriteEn_In_FromX(MemWriteEn_XM),
					.PCInc_In_FromX(PCInc_XtoM),
					.BJAddr_In_FromX(BJAddr_XtoM), 
					.Ofl(Ofl),
					.Z(Z),
					.N(N), 
					.Cout(Cout), 
					.ALUResult_In_FromX(ALUResult_XM), 
					.WR_In_FromX(WR_XtoM), 
					.WR_In_FromW(WR_WtoM), 
					.WD_In_FromW(WD_WtoM), 
					.RD2_In_FromX(RD2_XM), 
					.SelFlag_In_FromX(SelFlag_XM), 
					.Halt_In_FromX(Halt_XtoM),
					.clk(clk), 
					.rst(rst),
		
					.RegWriteDataSel_Out_ToW(RegWriteDataSel_MW),
					.PCInc_Out_ToW(PCInc_MtoW), .ReadData(ReadData), 
					.ALUResult_Out_ToW(ALUResult_MW), 
					.WR_Out_ToW(WR_MtoW),
					.Condition(Condition), 
					.BJAddr_Out_ToX(BJAddr_MtoX), 
					.PCSel(PCSel_MtoX),
					.WR_Out_ToX(WR_MtoX),
					.WD_Out_ToX(WD_MtoX), 
					.err(memory_err)
					);
		
	
	write_stage write(
					.RegWriteDataSel_In_FromMem(RegWriteDataSel_MW), 
					.PCInc_In_FromMem(PCInc_MtoW), 
					.Condition_In_FromMem(Condition), 
					.ReadData_In_FromMem(ReadData), 
					.ALUResult_In_FromMem(ALUResult_MW), 
					.WR_In_FromMem(WR_MtoW),
	
					//Outputs
					.WR_Out_ToMem(WR_WtoM), 
					.WD_Out_ToMem(WD_WtoM), 
					.err(write_err)
					);
					   
					   
					   
   assign err = fetch_err | decode_err | execute_err | memory_err | write_err;
endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
