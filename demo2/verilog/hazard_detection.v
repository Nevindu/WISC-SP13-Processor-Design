module hazard_detection(
			//INputs
			DXRd,
			Instr,
			DXMemRead,
			
			//Outputs
			IFWrite,
			PCWrite,
			EnableNop
		);
		
//Inputs
input [15:0] Instr;
input [2:0] DXRd;
input DXMemRead;

//Outputs
output IFWrite, PCWrite, EnableNop;

wire [2:0] FDRs, FDRt;

assign FDRs = Instr[10:8];
assign FDRt = Instr[7:5];

assign IFWrite = (DXMemRead & ((DXRd == FDRs) | (DXRd == FDRt))) ? 1'b0 : 1'b1;

assign PCWrite = (DXMemRead & ((DXRd == FDRs) |  (DXRd == FDRt))) ? 1'b0 : 1'b1;

assign EnableNop = (DXMemRead & ((DXRd == FDRs) | (DXRd == FDRt))) ? 1'b1 : 1'b0;
		
endmodule