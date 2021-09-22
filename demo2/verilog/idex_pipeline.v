module idex_pipeline(
	
		//Inputs: (From stage D)
		Instr_Out_ToX, 
		PCInc_Out_ToX, 
		RegWriteDataSel_ToX, 
		JSe_ToX,
		I2Se_ToX,
		ISe_ToX,
		RD1_ToX, 
		RD2_ToX, 
		//Control signal inputs:
		ALUOp_ToX,
		MemReadEn_ToX, 
		MemWriteEn_ToX, 
		RegDst_ToX, 
		ALUSelB_ToX,
		SelFlag_ToX,
		Halt_ToX, 
		Cin_ToX, 
		invA_ToX,
		WriteToReg_ToX,
		selCond_ToX,
		selPCInc_ToX,
		
		clk,
		rst,
		
		//Outputs: (To stage X)
		Instr_In_FromD, 
		PCInc_In_FromD, 
		RegWriteDataSel_In_FromD,
		ALUOp_FromD, 
		MemReadEn_In_FromD, 
		MemWriteEn_In_FromD, 
		RegDst_FromD,
		ALUSelB_FromD,
		SelFlag_In_FromD,
		JSe_FromD, 
		ISe_FromD, 
		I2Se_FromD,
		RD1_FromD,
		RD2_In_FromD, 
		invA_FromD,
		Cin_FromD, 
		Halt_In_FromD,
		WriteToReg_FromD,
		selCond_FromD,
		selPCInc_FromD
		);
		
//inputs
input MemReadEn_ToX, MemWriteEn_ToX, Halt_ToX, Cin_ToX, invA_ToX, WriteToReg_ToX, selCond_ToX, selPCInc_ToX, clk, RegWriteDataSel_ToX,rst;
input [1:0]  RegDst_ToX, ALUSelB_ToX;
input [2:0] SelFlag_ToX;
input [3:0] ALUOp_ToX;
input [15:0] Instr_Out_ToX, PCInc_Out_ToX, RD1_ToX, RD2_ToX, JSe_ToX, I2Se_ToX, ISe_ToX; 

//outputs
output MemReadEn_In_FromD, MemWriteEn_In_FromD, Halt_In_FromD, Cin_FromD,invA_FromD, WriteToReg_FromD, selCond_FromD, RegWriteDataSel_In_FromD,selPCInc_FromD;
output [1:0]  RegDst_FromD, ALUSelB_FromD;
output [2:0] SelFlag_In_FromD;
output [3:0] ALUOp_FromD;
output [15:0] Instr_In_FromD, PCInc_In_FromD, RD1_FromD, RD2_In_FromD, JSe_FromD, I2Se_FromD, ISe_FromD; 


//registers

dff memRead(.d(MemReadEn_ToX), .clk(clk), .rst(rst), .q(MemReadEn_In_FromD));
dff memWrite(.d(MemWriteEn_ToX), .clk(clk), .rst(rst), .q(MemWriteEn_In_FromD));
dff halt(.d(Halt_ToX), .clk(clk), .rst(rst), .q(Halt_In_FromD));
dff cin(.d(Cin_ToX), .clk(clk), .rst(rst), .q(Cin_FromD));
dff inva(.d(invA_ToX), .clk(clk), .rst(rst), .q(invA_FromD));
dff wreg(.d(WriteToReg_ToX), .clk(clk), .rst(rst), .q(WriteToReg_FromD));
dff selC(.d(selCond_ToX), .clk(clk), .rst(rst), .q(selCond_FromD));
dff selPC(.d(selPCInc_ToX), .clk(clk), .rst(rst), .q(selPCInc_FromD));

dff regWrite(.d(RegWriteDataSel_ToX), .clk(clk), .rst(rst), .q(RegWriteDataSel_In_FromD));
dff regDst[1:0](.d(RegDst_ToX), .clk(clk), .rst(rst), .q(RegDst_FromD));
dff aluSelB[1:0](.d(ALUSelB_ToX), .clk(clk), .rst(rst), .q(ALUSelB_FromD));

dff selFlag[2:0](.d(SelFlag_ToX), .clk(clk), .rst(rst), .q(SelFlag_In_FromD));

dff alu[3:0](.d(ALUOp_ToX), .clk(clk), .rst(rst), .q(ALUOp_FromD));

dff instr[15:0](.d(Instr_Out_ToX), .clk(clk), .rst(rst), .q(Instr_In_FromD));
dff pcInc[15:0](.d(PCInc_Out_ToX), .clk(clk), .rst(rst), .q(PCInc_In_FromD));
dff rd1[15:0](.d(RD1_ToX), .clk(clk), .rst(rst), .q(RD1_FromD));
dff rs2[15:0](.d(RD2_ToX), .clk(clk), .rst(rst), .q(RD2_In_FromD));
dff jse[15:0](.d(JSe_ToX), .clk(clk), .rst(rst), .q(JSe_FromD));
dff i2se[15:0](.d(I2Se_ToX), .clk(clk), .rst(rst), .q(I2Se_FromD));
dff ise[15:0](.d(ISe_ToX), .clk(clk), .rst(rst), .q(ISe_FromD));

endmodule