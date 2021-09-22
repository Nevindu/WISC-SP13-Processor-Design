module exmem_pipeline(
	
	//Inputs: (From Stage X)
		RegWriteDataSel_Out_ToMem,
		MemReadEn_Out_ToMem, 
		MemWriteEn_Out_ToMem, 
		//PCInc_Out_ToMem,
		Z_ToMem, 
		Ofl_ToMem,
		N_ToMem,
		Cout_ToMem,
		ALUResult_ToMem,
		WR_Out_ToMem,
		RD2_Out_ToMem, 
		//SelFlag_Out_ToMem,
		Halt_Out_ToMem, 
		WriteToReg_ToMem,
		
		clk,
		rst,
		
		//Outputs: (To Stage M)
		RegWriteDataSel_In_FromX,
		MemReadEn_In_FromX, 
		MemWriteEn_In_FromX, 
		//PCInc_In_FromX,
		Z_FromX, 
		Ofl_FromX,
		N_FromX,
		Cout_FromX,
		ALUResult_FromX,
		WR_In_FromX,
		RD2_In_FromX, 
		//SelFlag_In_FromX,
		Halt_In_FromX,
		WriteToReg_FromX
	);
	
//inputs
input MemReadEn_Out_ToMem, MemWriteEn_Out_ToMem, Z_ToMem, Ofl_ToMem, N_ToMem,Cout_ToMem, Halt_Out_ToMem,WriteToReg_ToMem,clk, rst;
input [15:0] RD2_Out_ToMem, ALUResult_ToMem; //PCInc_Out_ToMem,
input RegWriteDataSel_Out_ToMem;
input [2:0]  WR_Out_ToMem; //SelFlag_Out_ToMem,

//output
output MemReadEn_In_FromX, MemWriteEn_In_FromX, Z_FromX, Ofl_FromX, N_FromX,Cout_FromX, Halt_In_FromX,WriteToReg_FromX;
output [15:0]  RD2_In_FromX, ALUResult_FromX; //PCInc_In_FromX,
output  RegWriteDataSel_In_FromX;
output [2:0]  WR_In_FromX;//SelFlag_In_FromX,

//registers
dff memReadEn(.d(MemReadEn_Out_ToMem), .clk(clk), .rst(rst), .q(MemReadEn_In_FromX));
dff memWriteEn(.d(MemWriteEn_Out_ToMem), .clk(clk), .rst(rst), .q(MemWriteEn_In_FromX));
dff z(.d(Z_ToMem), .clk(clk), .rst(rst), .q(Z_FromX));
dff ofl(.d(Ofl_ToMem), .clk(clk), .rst(rst), .q(Ofl_FromX));
dff n(.d(N_ToMem), .clk(clk), .rst(rst), .q(N_FromX));
dff cout(.d(Cout_ToMem), .clk(clk), .rst(rst), .q(Cout_FromX));
dff halt(.d(Halt_Out_ToMem), .clk(clk), .rst(rst), .q(Halt_In_FromX));
dff wreg(.d(WriteToReg_ToMem), .clk(clk), .rst(rst), .q(WriteToReg_FromX));

//dff pcInc[15:0](.d(PCInc_Out_ToMem), .clk(clk), .rst(rst), .q(PCInc_In_FromX));
dff rd2[15:0](.d(RD2_Out_ToMem), .clk(clk), .rst(rst), .q(RD2_In_FromX));
dff aluRes[15:0](.d(ALUResult_ToMem), .clk(clk), .rst(rst), .q(ALUResult_FromX));

dff regWrite(.d(RegWriteDataSel_Out_ToMem), .clk(clk), .rst(rst), .q(RegWriteDataSel_In_FromX));

//dff selFlag[2:0](.d(SelFlag_Out_ToMem), .clk(clk), .rst(rst), .q(SelFlag_In_FromX));
dff wr[2:0](.d(WR_Out_ToMem), .clk(clk), .rst(rst), .q(WR_In_FromX));


endmodule