module cla_4(A,B, Cin, S, G, P); //4bit Carry-Lookahead adder

input [3:0] A,B;
input Cin;

output [3:0] S;
output G, P;

wire p0,g0,p1,g1,p2,g2;

wire c1,c2,c3;

pfa pfa1 (.A(A[0]), .B(B[0]), .Cin(Cin), .S(S[0]), .G(g0), .P(p0));

assign c1 = g0 | (p0 & Cin);

pfa pfa2 (.A(A[1]), .B(B[1]), .Cin(c1), .S(S[1]), .G(g1), .P(p1));

assign c2 = g1 | (p1 & g0) | (p1 & p0 & Cin);

pfa pfa3 (.A(A[2]), .B(B[2]), .Cin(c2), .S(S[2]), .G(g2), .P(p2));

assign c3 = g2 | (p2 & g1) | (p2 & p1 & g0) | (p2 & p1 & p0 & Cin);

pfa pfa4 (.A(A[3]), .B(B[3]), .Cin(c3), .S(S[3]), .G(g3), .P(p3));


assign G = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0);
assign P = (p3 & p2 & p1 & p0);

endmodule