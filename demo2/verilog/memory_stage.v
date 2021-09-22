module memory_stage(
		//Inputs
		RegWriteDataSel_In_FromX, 
		MemReadEn_In_FromX, 
		MemWriteEn_In_FromX, 
		//PCInc_In_FromX,
	 
		
		ALUResult_In_FromX, 
		WR_In_FromX,
		
		RD2_In_FromX,
		//SelFlag_In_FromX, 
		Halt_In_FromX,
		WriteToReg_FromX,
		//Halt_Signal,
		clk,
		rst,
		
		//Outputs
		RegWriteDataSel_Out_ToW, 
		//PCInc_Out_ToW, 
		ReadData, 
		ALUResult_Out_ToW,
		WR_Out_ToW, 
	
		WriteToReg_ToW,
		Halt_Signal,
		err
		
		);
		
//Inputs
input MemReadEn_In_FromX, MemWriteEn_In_FromX, Halt_In_FromX, WriteToReg_FromX,clk,rst; //Halt_Signal,
input RegWriteDataSel_In_FromX;
input [2:0] WR_In_FromX; //SelFlag_In_FromX,
input [15:0] ALUResult_In_FromX,RD2_In_FromX;//PCInc_In_FromX;

//Outputs
output  WriteToReg_ToW, Halt_Signal, err;
output RegWriteDataSel_Out_ToW;
output [2:0] WR_Out_ToW;
output [15:0] ALUResult_Out_ToW,ReadData; //PCInc_Out_ToW,

//Tie Outputs
assign RegWriteDataSel_Out_ToW = RegWriteDataSel_In_FromX;
//assign PCInc_Out_ToW = PCInc_In_FromX;
assign ALUResult_Out_ToW = ALUResult_In_FromX;
assign WR_Out_ToW = WR_In_FromX;
assign WriteToReg_ToW = WriteToReg_FromX;
assign Halt_Signal = Halt_In_FromX;


				   
wire enable;
	

//Data memory

assign enable = (MemReadEn_In_FromX | MemWriteEn_In_FromX) & ~Halt_Signal;

memory2c data_memory(.data_out(ReadData), .data_in(RD2_In_FromX), .addr(ALUResult_In_FromX), .enable(enable), 
					.wr(MemWriteEn_In_FromX), .createdump(Halt_Signal), .clk(clk), .rst(rst));

assign err = 1'b0;


endmodule