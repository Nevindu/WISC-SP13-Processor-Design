module decode_stage(Instr_In_FromF, PCInc_In_FromF, WR_In_FromX, WD_In_FromX, PCsel_In_FromX, BJAddr_In_FromX, clk, rst,
					RegWriteDataSel, ALUOp, MemReadEn, MemWriteEn, RegDst,Branch, Jump, ALUSelB, PCImmSel, PCAddSel, SelFlag,
					JSe, ISe, I2Se, RD1, RD2, Instr_Out, PCInc_Out, PCsel_Out_ToF, BJAddr_Out_ToF, Halt, Cin, invA, err);
					
//Inputs
input [15:0] Instr_In_FromF, PCInc_In_FromF, BJAddr_In_FromX, WD_In_FromX;
input  PCsel_In_FromX, clk, rst;
input [2:0] WR_In_FromX;
//Outputs
output MemReadEn, MemWriteEn,Branch,Jump, PCAddSel, PCImmSel, PCsel_Out_ToF, Halt, Cin, invA,err;
output [1:0] RegWriteDataSel, RegDst, ALUSelB;
output [2:0] SelFlag;
output [3:0] ALUOp;
output [15:0] Instr_Out, PCInc_Out, BJAddr_Out_ToF, RD1, RD2, JSe, I2Se, ISe;

//Connect outputs and inputs across stages
assign Instr_Out = Instr_In_FromF;
assign PCInc_Out = PCInc_In_FromF;
assign BJAddr_Out_ToF = BJAddr_In_FromX;
assign PCsel_Out_ToF = PCsel_In_FromX;

wire  WriteToReg, ZeroExt;
wire err_control, err_rf;

//Control Unit
control cu(.Instr(Instr_In_FromF), .Halt(Halt), .SelFlag(SelFlag), .RegWriteDataSel(RegWriteDataSel), .ALUOp(ALUOp), .Cin(Cin), .invA(invA), .MemReadEn(MemReadEn),
		   .MemWriteEn(MemWriteEn), .RegDst(RegDst), .Branch(Branch), .Jump(Jump), .ZeroExt(ZeroExt), .WriteToReg(WriteToReg), .ALUSelB(ALUSelB), .PCImmSel(PCImmSel),
		   .PCAddSel(PCAddSel), .err(err_control));
		   


//Sign extend immediate values

assign JSe = { {5{Instr_In_FromF[10]}}, Instr_In_FromF[10:0] };

assign I2Se = (ZeroExt == 1'b1) ? {{8{1'b0}}, Instr_In_FromF[7:0]} : {{8{Instr_In_FromF[7]}}, Instr_In_FromF[7:0]};

assign ISe = (ZeroExt == 1'b1) ? {{12{1'b0}}, Instr_In_FromF[4:0]} : {{12{Instr_In_FromF[4]}}, Instr_In_FromF[4:0]};

//Register File
rf registerFile(.read1data(RD1), .read2data(RD2), .err(err_rf), .clk(clk), .rst(rst), 
					  .read1regsel(Instr_In_FromF[10:8]), .read2regsel(Instr_In_FromF[7:5]), .writeregsel(WR_In_FromX), .writedata(WD_In_FromX), .write(WriteToReg));

assign err = err_control | err_rf;
endmodule