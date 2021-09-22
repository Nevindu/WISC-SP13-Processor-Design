module memory_stage(
		//Inputs
		RegWriteDataSel_In_FromX, Branch_In_FromX, Jump_In_FromX, MemReadEn_In_FromX, MemWriteEn_In_FromX, PCInc_In_FromX,
		BJAddr_In_FromX, Ofl, Z, N, Cout, ALUResult_In_FromX, WR_In_FromX, WR_In_FromW, WD_In_FromW, RD2_In_FromX, SelFlag_In_FromX, Halt_In_FromX,clk,rst,
		
		//Outputs
		RegWriteDataSel_Out_ToW, PCInc_Out_ToW, ReadData, ALUResult_Out_ToW, WR_Out_ToW, Condition, BJAddr_Out_ToX, PCSel, WR_Out_ToX,
		WD_Out_ToX, err
		
		);
		
//Inputs
input Branch_In_FromX, Jump_In_FromX, MemReadEn_In_FromX, MemWriteEn_In_FromX, Ofl, Z, N, Cout, Halt_In_FromX, clk,rst;
input [1:0] RegWriteDataSel_In_FromX;
input [2:0] SelFlag_In_FromX, WR_In_FromW, WR_In_FromX;
input [15:0] BJAddr_In_FromX, ALUResult_In_FromX, WD_In_FromW,RD2_In_FromX, PCInc_In_FromX;

//Outputs
output PCSel, Condition, err;
output [1:0] RegWriteDataSel_Out_ToW;
output [2:0] WR_Out_ToW, WR_Out_ToX;
output [15:0] PCInc_Out_ToW, ALUResult_Out_ToW, WD_Out_ToX, BJAddr_Out_ToX, ReadData; 

//Tie Outputs
assign RegWriteDataSel_Out_ToW = RegWriteDataSel_In_FromX;
assign PCInc_Out_ToW = PCInc_In_FromX;
assign ALUResult_Out_ToW = ALUResult_In_FromX;
assign WR_Out_ToW = WR_In_FromX;
assign WR_Out_ToX = WR_In_FromW;
assign BJAddr_Out_ToX = BJAddr_In_FromX;
assign WD_Out_ToX = WD_In_FromW;

//Generate condition and PCSel
wire lt, lte, geq, enable;

assign lt = (~Z & ~N) ^ Ofl;
assign lte = lt | Z;
assign geq = N | Z;

assign Condition = (SelFlag_In_FromX == 3'b000) ? Z   :
				   (SelFlag_In_FromX == 3'b001) ? lt  :
				   (SelFlag_In_FromX == 3'b010) ? lte :
				   (SelFlag_In_FromX == 3'b011) ? ~Z  :
				   (SelFlag_In_FromX == 3'b100) ? geq : Cout;
				   
assign PCSel = (Branch_In_FromX & Condition) | Jump_In_FromX;	
	

//Data memory

assign enable = (MemReadEn_In_FromX | MemWriteEn_In_FromX) & ~Halt_In_FromX;

memory2c data_memory(.data_out(ReadData), .data_in(RD2_In_FromX), .addr(ALUResult_In_FromX), .enable(enable), 
					.wr(MemWriteEn_In_FromX), .createdump(Halt_In_FromX), .clk(clk), .rst(rst));

assign err = 1'b0;


endmodule