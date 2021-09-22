module alu (A, B, Cin, Op, invA,Out, Ofl, Z, N, Cout, err);
   
        input [15:0] A;
        input [15:0] B;
        input Cin;
        input [3:0] Op;
        input invA;
        output [15:0] Out;
        output Ofl;
        output Z;
		output N;
		output Cout;
		output err;

   /*
	Your code goes here
   */
   
    /*
	OPCode    Function
	0000	rll		rotate left
	0001	sll		shift left
	0010	rrl 	rotate right
	0011	srl		shift right logical
	0100	ADD		A+B & B-A
	0101	OR		A OR B
	0110	XOR		A XOR B
	0111	ANDNI	A AND NOT(B)
	1000	BTR		Bit reverse
	1001	SLBI 	Rs <- (Rs << 8) | I(zero ext.)
	1011	LBI 	Rs <-  I(Sign ext.)
   */
	 wire[15:0] InA, B, AorB, AxorB, AandB, shifterOut, Sum, Areverse, SLBI, LBI;
	 
	 wire G0,P0, G1,P1, G2,P2,G3,P3;
	 wire C4, C8, C12, C15;
	 wire signedOf;
	 
	 //reg[15:0] muxOut;
	 
     assign InA = invA ? ~A : A;
	 
	 
	 
	 assign AorB = InA | B;
	 assign AxorB = InA ^ B;
	 assign AandB = InA & (~B);
	 
	 assign Areverse = {InA[0], InA[1], InA[2], InA[3], InA[4], InA[5], InA[6], InA[7], InA[8], InA[9], InA[10], InA[11], InA[12], InA[13], InA[14], InA[15]};
	 
	 assign SLBI = (InA << 8) | B;
	 
	 assign LBI = B;
	 
	 //adder
	 cla_4 c0(.A(InA[3:0]), .B(B[3:0]), .Cin(Cin), .S(Sum[3:0]), .G(G0), .P(P0));
	 assign C4 = G0 | (P0 & Cin);
	 
	 cla_4 c1(.A(InA[7:4]), .B(B[7:4]), .Cin(C4), .S(Sum[7:4]), .G(G1), .P(P1));
	 assign C8 = G1 | (P1 & G0) | (P1 & P0 & Cin);

	 cla_4 c2(.A(InA[11:8]), .B(B[11:8]), .Cin(C8), .S(Sum[11:8]), .G(G2), .P(P2));
	 assign C12 = G2 | (P2 & G1) | (P2 & P1 & G0) | (P2 & P1 & P0 & Cin);
	 
	 cla_4 c3(.A(InA[15:12]), .B(B[15:12]), .Cin(C12), .S(Sum[15:12]), .G(G3), .P(P3));
	 assign C15 = G3 | (P3&G2) | (P3 &P2 & G1) | (P3& P2 & P1 & G0) | (P3 & P2 & P1 & P0 & Cin);


	//shifter
	 shifter s0(.In(InA), .Cnt(B[3:0]), .Op(Op[1:0]), .Out(shifterOut));
	 
	 assign Out = Op ==  4'b0101 ? AorB  : 
				  Op ==  4'b0110 ? AxorB : 
				  Op ==  4'b0111 ? AandB :
				  Op ==  4'b0000 ? shifterOut :
				  Op ==  4'b0001 ? shifterOut :
				  Op ==  4'b0010 ? shifterOut :
				  Op ==  4'b0011 ? shifterOut :
				  Op ==  4'b0100 ? Sum : 
				  Op ==  4'b1000 ? Areverse :
				  Op ==  4'b1001 ? SLBI : LBI;

	assign Z = (Out == 0);
	
	assign signedOf = (InA[15] == B[15]) & (Sum[15] != InA[15]);
	
	assign Ofl =  (Op == 3'b100) & signedOf;

	assign N = Out[15];
	
	assign err = 1'b0;
	
	assign Cout = C15;
	
	
endmodule
