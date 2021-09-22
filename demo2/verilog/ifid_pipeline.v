module ifid_pipeline(
		//Inputs:
		//Input from Fetch stage:
		PCInc_Out_ToD,
		Instr_Out_ToD,
		//Pipelining input:
		IFWrite,
		IFFlush,
		clk,
		rst,
		
		//Outputs:
		Instr_In_FromF, 
		PCInc_In_FromF
		);


//Inputs:
input [15:0] PCInc_Out_ToD, Instr_Out_ToD;
input IFWrite, IFFlush, clk, rst;
wire [15:0] InstrOutTmp;
//Output:
output [15:0] PCInc_In_FromF, Instr_In_FromF;

//RegInputs
wire [15:0] PCIncRegIn, InstrRegIn;

assign PCIncRegIn = (IFWrite) ? PCInc_Out_ToD : PCInc_In_FromF;

assign InstrRegIn = (IFWrite & ~IFFlush & ~rst) ? Instr_Out_ToD :
					(IFWrite &  IFFlush & ~rst) ? (16'b0001_1000_0000_0000) :
					 rst ? 16'b0001_1000_0000_0000 : Instr_In_FromF; //If flusing, bubble a nop through the pipeline
					 


dff PCIncPipeReg[15:0] (.d(PCIncRegIn), .q(PCInc_In_FromF), .clk(clk), .rst(rst));
dff InstrPipeReg[15:0] (.d(InstrRegIn), .q(InstrOutTmp), .clk(clk), .rst(1'b0)); //Tie rst to 0, so the instruction wont become a halt


assign Instr_In_FromF = (rst) ? 16'b0001_1000_0000_0000 : InstrOutTmp;
endmodule