module decode_stage(Instr_In_FromF, 
					PCInc_In_FromF, 
					WR_In_FromW, 
					WD_In_FromW,
					WriteToReg_FromW,
					XForwardA,
					MForwardA,
					DXRd,
					DXMemRead,
					
				    DForwardA,
					XMWriteToReg,
					XMRd,
					MWWriteToReg,
					MWRd,
					DXWriteToReg,
					
					
					clk, 
					rst,
					
					RegWriteDataSel, 
					ALUOp,
					MemReadEn, 
					MemWriteEn, 
					RegDst, 
					ALUSelB,
					SelFlag,
					JSe, 
					ISe, 
					I2Se,
					RD1, 
					RD2, 
					Instr_Out_ToX, 
					PCInc_Out_ToX, 
					PCSel, 
					BJAddr_Out_ToF, 
					Halt, 
					Cin, 
					invA,
					WriteToReg,
					selCond,
					selPCInc,
					err,
					IFWrite, 
					IFFlush,
					PCWrite
				);
					
//Inputs
input [15:0] Instr_In_FromF, PCInc_In_FromF,WD_In_FromW, XForwardA, MForwardA, DForwardA;
input  clk, rst, WriteToReg_FromW, DXMemRead, XMWriteToReg, MWWriteToReg, DXWriteToReg;
input [2:0] WR_In_FromW, DXRd, XMRd, MWRd;
//Outputs
output MemReadEn, MemWriteEn,PCSel, Halt, Cin, invA,err, IFWrite, IFFlush, WriteToReg, PCWrite, selCond, RegWriteDataSel,selPCInc;
output [1:0]  RegDst, ALUSelB;
output [2:0] SelFlag;
output [3:0] ALUOp;
output [15:0] Instr_Out_ToX, PCInc_Out_ToX, BJAddr_Out_ToF, RD1, RD2, JSe, I2Se, ISe;

//Connect outputs and inputs across stages
assign Instr_Out_ToX = Instr_In_FromF;
assign PCInc_Out_ToX = PCInc_In_FromF;

wire ZeroExt;
wire err_control, err_rf;
wire [15:0] PCImm, PCAdd;

wire Condition, EnableNop, WriteToReg_Temp, MemWriteEn_Temp,MemReadEn_Temp; 

//Control Unit
control cu(.Instr(Instr_In_FromF), .Halt(Halt), .SelFlag(SelFlag), .RegWriteDataSel(RegWriteDataSel), .ALUOp(ALUOp), .Cin(Cin), .invA(invA), .MemReadEn(MemReadEn_Temp),
		   .MemWriteEn(MemWriteEn_Temp), .RegDst(RegDst), .Branch(Branch), .Jump(Jump), .ZeroExt(ZeroExt), .WriteToReg(WriteToReg_Temp), .ALUSelB(ALUSelB), .PCImmSel(PCImmSel),
		   .PCAddSel(PCAddSel),.selCond(selCond), .selPCInc(selPCInc), .err(err_control));
		   
//TODO: Write Hazard detection logic
hazard_detection hd(
			//INputs
			.DXRd(DXRd),
			.Instr(Instr_In_FromF),
			.DXMemRead(DXMemRead),
			
			//Outputs
			.IFWrite(IFWrite),
			.PCWrite(PCWrite),
			.EnableNop(EnableNop)
);	

assign MemWriteEn = EnableNop ? 1'b0 : MemWriteEn_Temp;
assign WriteToReg = EnableNop ? 1'b0 : WriteToReg_Temp;
assign MemReadEn = EnableNop ? 1'b0 : MemReadEn_Temp;

//Sign extend immediate values

assign JSe = { {5{Instr_In_FromF[10]}}, Instr_In_FromF[10:0] };

assign I2Se = (ZeroExt == 1'b1) ? {{8{1'b0}}, Instr_In_FromF[7:0]} : {{8{Instr_In_FromF[7]}}, Instr_In_FromF[7:0]};

assign ISe = (ZeroExt == 1'b1) ? {{12{1'b0}}, Instr_In_FromF[4:0]} : {{12{Instr_In_FromF[4]}}, Instr_In_FromF[4:0]};

//Register File
rf_bypass registerFile(.read1data(RD1), .read2data(RD2), .err(err_rf), .clk(clk), .rst(rst), 
					  .read1regsel(Instr_In_FromF[10:8]), .read2regsel(Instr_In_FromF[7:5]), .writeregsel(WR_In_FromW), .writedata(WD_In_FromW), .write(WriteToReg_FromW));
			
			

//Forwarding logic:	
wire [15:0] BranchSrc;
wire [1:0] selForwardA;
wire [2:0] FDRs;

assign FDRs = Instr_In_FromF[10:8];

assign selForwardA =  (DXWriteToReg & (DXRd == FDRs)) ? 2'b11:
					  (XMWriteToReg & (XMRd == FDRs)) ? 2'b10:
					  (MWWriteToReg & (MWRd == FDRs)) ? 2'b01: 2'b00;
					

assign PCImm = PCImmSel ? I2Se : JSe;
assign PCAdd = PCAddSel ? BranchSrc : PCInc_In_FromF; 

fulladder16 pcAddr(.A(PCImm), .B(PCAdd), .SUM(BJAddr_Out_ToF));

//Comparator logic


assign BranchSrc = (selForwardA == 2'b00) ? RD1:
				   (selForwardA == 2'b01) ? MForwardA :
				   (selForwardA == 2'b10) ? XForwardA : DForwardA; 

assign Condition = (SelFlag == 3'b000) ? (BranchSrc == 0)   :   //Rs == 0; BEQZ
				   (SelFlag == 3'b001) ? (BranchSrc[15] != 0)  : //Rs < 0; BLTZ
				   (SelFlag == 3'b011) ? (BranchSrc != 0)  : //Rs != 0; BNEZ
				   (SelFlag == 3'b100) ? ((BranchSrc == 0) | (BranchSrc[15] == 0) ) : 1'b0;   //Rs >= 0; BGEZ

assign PCSel = (Branch & Condition) | Jump;	

//assign IFFlush
assign IFFlush = PCSel ? 1'b1 : 1'b0; //If taking a branch flush the IFID register




assign err = err_control | err_rf ;
endmodule