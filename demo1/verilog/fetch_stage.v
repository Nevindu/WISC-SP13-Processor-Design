module fetch_stage(PCsel_In_FromD, BJAddr_In_FromD, PCInc_Out_ToD, Instr_Out_ToD, clk, rst, Halt_In_FromD, err);

input [15:0] BJAddr_In_FromD;
input PCsel_In_FromD;
input clk;
input rst;
input Halt_In_FromD;

output  [15:0] PCInc_Out_ToD, Instr_Out_ToD;
output err;

wire [15:0] PCIn , PCOut;

assign PCIn = (PCsel_In_FromD == 1'b1) ? BJAddr_In_FromD : PCInc_Out_ToD;

//register PC(.IN(PCIn), .clk(clk), .rst(rst), .OUT(PCOut));

dff PC[15:0](.q(PCOut), .d(PCIn), .clk(clk), .rst(rst));

fulladder16 pcAdder(.A(16'h0002), .B(PCOut), .SUM(PCInc_Out_ToD));

memory2c data_memory(.data_out(Instr_Out_ToD), .data_in({16{1'b0}}), .addr(PCOut), .enable(~Halt_In_FromD), .wr(1'b0), .createdump(1'b0), .clk(clk), .rst(rst));


assign err = 1'b0;
endmodule