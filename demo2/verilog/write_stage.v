module write_stage(
	//inputs
	RegWriteDataSel_In_FromMem,
	//PCInc_In_FromMem, 
	//Condition_In_FromMem, 
	ReadData_In_FromMem, 
	ALUResult_In_FromMem,
	WR_In_FromMem,
	WriteToReg_FromMem,
	//Halt_FromMem,
	
	//Outputs
	WR_Out_ToD, 
	WD_Out_ToD, 
	WriteToReg_ToD,
	//Halt_Signal,
	err
);

//inputs
input  WriteToReg_FromMem; //Halt_FromMem; //Condition_In_FromMem,
input RegWriteDataSel_In_FromMem;
input [2:0] WR_In_FromMem;
input [15:0]  ReadData_In_FromMem, ALUResult_In_FromMem; //PCInc_In_FromMem,

//outputs
output WriteToReg_ToD,  err;//Halt_Signal,
output [2:0] WR_Out_ToD;
output [15:0] WD_Out_ToD;

//Tie Outputs
assign WR_Out_ToD = WR_In_FromMem;
assign WriteToReg_ToD = WriteToReg_FromMem;
//assign Halt_Signal = Halt_FromMem;


//Select Writeback data
assign WD_Out_ToD = (RegWriteDataSel_In_FromMem == 1'b0) ? ReadData_In_FromMem : ALUResult_In_FromMem;
					
	
assign err = 1'b0;
	
endmodule
					  
					  
	