module pfa(A,B,Cin,S,G,P); //Partial full adder

input A,B,Cin;
output S,G,P;

assign S = (A ^ B) ^ Cin;

assign P = A ^ B;

assign G =  A & B;


endmodule 