module memwb_pipeline(
		
		//Inputs: (From Stage M)
		RegWriteDataSel_Out_ToW, 
		//PCInc_Out_ToW, 
		ReadData_ToW, 
		ALUResult_Out_ToW,
		WR_Out_ToW, 
		
		WriteToReg_ToW,
		//Halt_ToW,
		clk,
		rst,
		
		//Outputs: (To Stage W)
		RegWriteDataSel_In_FromM, 
		//PCInc_In_FromM, 
		ReadData_FromM, 
		ALUResult_In_FromM,
		WR_In_FromM, 
		
		WriteToReg_FromM,
		//Halt_FromM
		
		);
		
//Inputs:
input WriteToReg_ToW, clk, rst; //Halt_ToW,
input  RegWriteDataSel_Out_ToW;
input [2:0] WR_Out_ToW;
input [15:0]  ALUResult_Out_ToW,ReadData_ToW;  //PCInc_Out_ToW,

//outputs
output  WriteToReg_FromM;//Halt_FromM;
output RegWriteDataSel_In_FromM;
output [2:0] WR_In_FromM;
output [15:0]  ALUResult_In_FromM,ReadData_FromM; //PCInc_In_FromM,

//registers

dff wreg(.d(WriteToReg_ToW), .clk(clk), .rst(rst), .q(WriteToReg_FromM));
//dff halt(.d(Halt_ToW), .clk(clk), .rst(rst), .q(Halt_FromM));


dff regWrite(.d(RegWriteDataSel_Out_ToW), .clk(clk), .rst(rst), .q(RegWriteDataSel_In_FromM));

dff wr[2:0](.d(WR_Out_ToW), .clk(clk), .rst(rst), .q(WR_In_FromM));

//dff pcInc[15:0](.d(PCInc_Out_ToW), .clk(clk), .rst(rst), .q(PCInc_In_FromM));
dff aluRes[15:0](.d(ALUResult_Out_ToW), .clk(clk), .rst(rst), .q(ALUResult_In_FromM));
dff rd[15:0](.d(ReadData_ToW), .clk(clk), .rst(rst), .q(ReadData_FromM));


endmodule