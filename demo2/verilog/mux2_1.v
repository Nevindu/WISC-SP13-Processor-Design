module mux2_1 (InA, InB, S, Out);

input InA, InB, S;
output Out;

assign Out = S ? InB : InA;

endmodule