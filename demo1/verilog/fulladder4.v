module fulladder4(A, B, CI, SUM, CO);

input [3:0] A,B;
input CI;

output [3:0] SUM;
output CO;

wire co0, co1, co2;

fulladder f0 (.A(A[0]), .B(B[0]), .Cin(CI), .S(SUM[0]), .Cout(co0));
fulladder f1 (.A(A[1]), .B(B[1]), .Cin(co0), .S(SUM[1]), .Cout(co1));
fulladder f2 (.A(A[2]), .B(B[2]), .Cin(co1), .S(SUM[2]), .Cout(co2));
fulladder f3 (.A(A[3]), .B(B[3]), .Cin(co2), .S(SUM[3]), .Cout(CO));


endmodule
