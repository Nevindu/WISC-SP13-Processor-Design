module write_stage(
	//inputs
	RegWriteDataSel_In_FromMem, PCInc_In_FromMem, Condition_In_FromMem, ReadData_In_FromMem, ALUResult_In_FromMem,
	WR_In_FromMem,
	
	//Outputs
	WR_Out_ToMem, WD_Out_ToMem, err
);

//inputs
input Condition_In_FromMem;
input [1:0] RegWriteDataSel_In_FromMem;
input [2:0] WR_In_FromMem;
input [15:0] PCInc_In_FromMem, ReadData_In_FromMem, ALUResult_In_FromMem;

//outputs
output err;
output [2:0] WR_Out_ToMem;
output [15:0] WD_Out_ToMem;

//Tie Outputs
assign WR_Out_ToMem = WR_In_FromMem;


//Select Writeback data
assign WD_Out_ToMem = (RegWriteDataSel_In_FromMem == 2'b00) ? PCInc_In_FromMem :
					  (RegWriteDataSel_In_FromMem == 2'b01) ? Condition_In_FromMem :
					  (RegWriteDataSel_In_FromMem == 2'b10) ? ReadData_In_FromMem : ALUResult_In_FromMem;
					  
	
assign err = 1'b0;
	
endmodule
					  
					  
	