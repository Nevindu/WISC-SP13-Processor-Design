module execute_stage(Instr_In_FromD, 
					PCInc_In_FromD, 
					RegWriteDataSel_In_FromD,
					ALUOp, 
					MemReadEn_In_FromD, 
					MemWriteEn_In_FromD, 
					RegDst,
					ALUSelB,
					SelFlag_In_FromD,
					JSe, 
					ISe, 
					I2Se,
					RD1,
					RD2_In_FromD, 
					invA,
					Cin, 
					Halt_In_FromD,
					WriteToReg_FromD,
					////Forward unit input
					XForwardA,
					XForwardB,
					MForwardA,
					MForwardB,
					XMWriteToReg,
					XMRd,
					MWWriteToReg,
					MWRd,
					selCond,
					selPCInc,
					
					
					//Outputs
					RegWriteDataSel_Out_ToMem,
					MemReadEn_Out_ToMem, 
					MemWriteEn_Out_ToMem, 
					//PCInc_Out_ToMem,
					Z, 
					Ofl,
					N,
					Cout,
					ALUResult,
					WR_Out_ToMem,
					RD2_Out_ToMem, 
					//SelFlag_Out_ToMem,
					Halt_Out_ToMem, 
					WriteToReg_ToMem,
					selForwardA,
					err
			);

//inputs
input  MemReadEn_In_FromD, MemWriteEn_In_FromD,invA, Cin, Halt_In_FromD, WriteToReg_FromD, XMWriteToReg, MWWriteToReg, selCond, selPCInc,RegWriteDataSel_In_FromD;
input [15:0] Instr_In_FromD, PCInc_In_FromD,JSe, ISe, I2Se, RD1, RD2_In_FromD, XForwardA, XForwardB, MForwardA, MForwardB;
input [1:0]  RegDst, ALUSelB;
input [2:0] SelFlag_In_FromD, XMRd, MWRd;
input [3:0] ALUOp;

//outputs
output MemReadEn_Out_ToMem, MemWriteEn_Out_ToMem, Z, Ofl, N,Cout, Halt_Out_ToMem,WriteToReg_ToMem, RegWriteDataSel_Out_ToMem, err;
output [15:0] RD2_Out_ToMem, ALUResult; //PCInc_Out_ToMem,
output [1:0] selForwardA;
output [2:0]  WR_Out_ToMem; //SelFlag_Out_ToMem,

//Tie outputs and inputs
assign RegWriteDataSel_Out_ToMem = RegWriteDataSel_In_FromD;
assign MemReadEn_Out_ToMem = MemReadEn_In_FromD;
assign MemWriteEn_Out_ToMem = MemWriteEn_In_FromD;
//assign PCInc_Out_ToMem = PCInc_In_FromD;
assign WriteToReg_ToMem = WriteToReg_FromD;




//assign SelFlag_Out_ToMem = SelFlag_In_FromD;
assign Halt_Out_ToMem = Halt_In_FromD;

wire [15:0] ALUB, ALURegB, ALURegA, ALUOut;
wire ALUerr;

wire [1:0] selForwardB;

//forwarding unit
forwarding_unit fwu(
				.Instr(Instr_In_FromD),
				.XMWriteToReg(XMWriteToReg),
				.XMRd(XMRd),
				.MWWriteToReg(MWWriteToReg),
				.MWRd(MWRd),
				
				//Outputs
				.selForwardA(selForwardA),
				.selForwardB(selForwardB)
					
				);
	

//ALU
assign ALURegB = (selForwardB == 2'b00) ? RD2_In_FromD :
				 (selForwardB == 2'b01) ? MForwardB :
				 (selForwardB == 2'b10) ? XForwardB :RD2_In_FromD;
				 
assign RD2_Out_ToMem = ALURegB; //accounting for forwarding

assign ALUB = (ALUSelB == 2'b00) ? I2Se :
		      (ALUSelB == 2'b01) ? ALURegB :
			  (ALUSelB == 2'b10) ? 16'h0000 : ISe;
			   
assign ALURegA = (selForwardA == 2'b00) ? RD1:
				 (selForwardA == 2'b01) ? MForwardA :
				 (selForwardA == 2'b10) ? XForwardA :RD1;
			   
alu ALU(.A(ALURegA), .B(ALUB), .Cin(Cin), .Op(ALUOp), .invA(invA),.Out(ALUOut), .Ofl(Ofl), .Z(Z), .N(N), .Cout(Cout), .err(ALUerr));

//Generate condition
wire lt, lte, geq;

assign lt = (~Z & ~N) ^ Ofl;
assign lte = lt | Z;
assign geq = N | Z;

assign Condition = (SelFlag_In_FromD == 3'b000) ? Z   :
				   (SelFlag_In_FromD == 3'b001) ? lt  :
				   (SelFlag_In_FromD == 3'b010) ? lte :
				   (SelFlag_In_FromD == 3'b011) ? ~Z  :
				   (SelFlag_In_FromD == 3'b100) ? geq : Cout;
				   
//Select ALU result
assign ALUResult = selCond  ? Condition : 
				   selPCInc ? PCInc_In_FromD: ALUOut;


//RegDst select
assign WR_Out_ToMem = (RegDst == 2'b00) ? Instr_In_FromD[7:5] :
					  (RegDst == 2'b01) ? Instr_In_FromD[10:8]:
					  (RegDst == 2'b10) ? Instr_In_FromD[4:2] : 3'b111;
					  
					  
				  

assign err = ALUerr | (selForwardB == 2'b11) | (selForwardA == 2'b11);

endmodule