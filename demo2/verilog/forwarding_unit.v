module forwarding_unit(
		//Inputs
		Instr,
		XMWriteToReg,
		XMRd,
		MWWriteToReg,
		MWRd,
		
		//Outputs
		selForwardA,
		selForwardB
		);

//Inputs
input [15:0] Instr;
input [2:0] XMRd, MWRd;
input XMWriteToReg, MWWriteToReg;

//Outputs
output [1:0] selForwardA, selForwardB;

wire [2:0] DXRs, DXRt;

assign DXRs = Instr[10:8];
assign DXRt = Instr[7:5];

assign selForwardA = (XMWriteToReg & (XMRd == DXRs)) ? 2'b10 :
					 (MWWriteToReg & (MWRd == DXRs)) ? 2'b01 : 2'b00;
			  

assign selForwardB = (XMWriteToReg  &(XMRd == DXRt)) ? 2'b10 :
					 (MWWriteToReg  & (MWRd == DXRt)) ? 2'b01 : 2'b00;

endmodule