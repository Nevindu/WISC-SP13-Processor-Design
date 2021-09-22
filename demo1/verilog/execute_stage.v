module execute_stage(Instr, PCInc_In_FromD, WR_In_FromMem, WD_In_FromMem, PCsel_In_FromMem, BJAddr_In_FromMem,
					RegWriteDataSel_In_FromD, ALUOp, MemReadEn_In_FromD, MemWriteEn_In_FromD, RegDst,Branch_In_FromD, Jump_In_FromD, 
					ALUSelB, PCImmSel, PCAddSel, SelFlag_In_FromD,
					JSe, ISe, I2Se, RD1, RD2_In_FromD, invA, Cin, Halt_In_FromD,
					//Outputs
					RegWriteDataSel_Out_ToMem, Branch_Out_ToMem, Jump_Out_ToMem, MemReadEn_Out_ToMem, MemWriteEn_Out_ToMem, PCInc_Out_ToMem, BJAddr_Out_ToMem, 
					Z, Ofl, N,Cout, ALUResult,
					WD_Out_ToD, WR_Out_ToMem, WR_Out_ToD, BJAddr_Out_ToD,PCsel_Out_ToD, RD2_Out_ToMem, SelFlag_Out_ToMem, Halt_Out_ToMem, err
			);

//inputs
input PCsel_In_FromMem, MemReadEn_In_FromD, MemWriteEn_In_FromD, Branch_In_FromD, Jump_In_FromD, PCImmSel, PCAddSel, invA, Cin, Halt_In_FromD;
input [15:0] Instr, PCInc_In_FromD, WD_In_FromMem, BJAddr_In_FromMem, JSe, ISe, I2Se, RD1, RD2_In_FromD;
input [1:0] RegWriteDataSel_In_FromD, RegDst, ALUSelB;
input [2:0] SelFlag_In_FromD, WR_In_FromMem;
input [3:0] ALUOp;

//outputs
output Branch_Out_ToMem, Jump_Out_ToMem, MemReadEn_Out_ToMem, MemWriteEn_Out_ToMem, Z, Ofl, N,Cout, Halt_Out_ToMem, PCsel_Out_ToD,err;
output [15:0] PCInc_Out_ToMem, WD_Out_ToD, BJAddr_Out_ToMem, BJAddr_Out_ToD, RD2_Out_ToMem, ALUResult;
output [1:0] RegWriteDataSel_Out_ToMem;
output [2:0] SelFlag_Out_ToMem, WR_Out_ToMem, WR_Out_ToD;

//Tie outputs and inputs
assign RegWriteDataSel_Out_ToMem = RegWriteDataSel_In_FromD;
assign Branch_Out_ToMem = Branch_In_FromD;
assign Jump_Out_ToMem = Jump_In_FromD;
assign MemReadEn_Out_ToMem = MemReadEn_In_FromD;
assign MemWriteEn_Out_ToMem = MemWriteEn_In_FromD;
assign PCInc_Out_ToMem = PCInc_In_FromD;
assign BJAddr_Out_ToD = BJAddr_In_FromMem;
assign WD_Out_ToD = WD_In_FromMem;
assign WR_Out_ToD = WR_In_FromMem;
assign PCsel_Out_ToD = PCsel_In_FromMem;
assign RD2_Out_ToMem = RD2_In_FromD;
assign SelFlag_Out_ToMem = SelFlag_In_FromD;
assign Halt_Out_ToMem = Halt_In_FromD;

wire [15:0] PCImm, PCAdd, ALUB;
wire ALUerr;

assign PCImm = PCImmSel ? I2Se : JSe;
assign PCAdd = PCAddSel ? RD1 : PCInc_In_FromD; 

fulladder16 pcAddr(.A(PCImm), .B(PCAdd), .SUM(BJAddr_Out_ToMem));

//ALU
assign ALUB = (ALUSelB == 2'b00) ? I2Se :
		       (ALUSelB == 2'b01) ? RD2_In_FromD :
			   (ALUSelB == 2'b10) ? 16'h0000 : ISe;
			   
alu ALU(.A(RD1), .B(ALUB), .Cin(Cin), .Op(ALUOp), .invA(invA),.Out(ALUResult), .Ofl(Ofl), .Z(Z), .N(N), .Cout(Cout), .err(ALUerr));

//RegDst selecr
assign WR_Out_ToMem = (RegDst == 2'b00) ? Instr[7:5] :
					  (RegDst == 2'b01) ? Instr[10:8]:
					  (RegDst == 2'b10) ? Instr[4:2] : 3'b111;

assign err = ALUerr;

endmodule