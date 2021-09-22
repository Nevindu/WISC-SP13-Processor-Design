module control(
		Instr,
		
		Halt,
		SelFlag,
		RegWriteDataSel,
		ALUOp,
		Cin,
		invA,
		MemReadEn,
		MemWriteEn,
		RegDst,
		Branch,
		Jump,
		ZeroExt,
		WriteToReg,
		ALUSelB,
		PCImmSel,
		PCAddSel,
		err);

input [15:0] Instr;

output reg Halt,MemReadEn,MemWriteEn,Branch,Jump,ZeroExt,WriteToReg,PCImmSel,PCAddSel,Cin,invA,err;
output reg [1:0] RegWriteDataSel,RegDst,ALUSelB;
output reg [2:0] SelFlag;
output reg [3:0] ALUOp;


wire [4:0] Opcode;
wire [1:0] OpcodeExt;

assign Opcode = Instr[15:11];
assign OpcodeExt = Instr[1:0];

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
   */

always @(*) begin
	{Halt,MemReadEn, MemWriteEn, Branch, Jump, ZeroExt, WriteToReg, PCImmSel, PCAddSel,Cin, invA,err} = 16'b0000_0000_0000_0000;
	RegWriteDataSel = 2'b00;
	RegDst = 2'b00;
	ALUSelB = 2'b00;
	SelFlag = 3'b000;
	ALUOp = 4'b0000;
	
	case(Opcode)
		5'b01000: begin //ADDI
			RegWriteDataSel = 2'b11;
			ALUOp = 4'b0100;
			ALUSelB = 2'b11;
			WriteToReg = 1'b1;
		end
		
		5'b01001: begin //SUBI
			RegWriteDataSel = 2'b11;
			ALUOp = 4'b0100;
			ALUSelB = 2'b11;
			WriteToReg = 1'b1;
			invA = 1'b1;
			Cin = 1'b1;
		end
		
		5'b01010: begin //XORI
			RegWriteDataSel = 2'b11;
			ALUOp = 4'b0110;
			ALUSelB = 2'b11;
			WriteToReg = 1'b1;
			ZeroExt = 1'b1;
		end
		
		5'b01011: begin //ANDNI
			RegWriteDataSel = 2'b11;
			ALUOp = 4'b0111;
			ALUSelB = 2'b11;
			WriteToReg = 1'b1;
			ZeroExt = 1'b1;
		end
		
		5'b10100: begin //ROLLI
			RegWriteDataSel = 2'b11;
			ALUOp = 4'b0000;
			ALUSelB = 2'b11;
			WriteToReg = 1'b1;
		end
		
		5'b10101: begin //SLII
			RegWriteDataSel = 2'b11;
			ALUOp = 4'b0001;
			ALUSelB = 2'b11;
			WriteToReg = 1'b1;
		end
		
		5'b10110: begin //RORI
			RegWriteDataSel = 2'b11;
			ALUOp = 4'b0010;
			ALUSelB = 2'b11;
			WriteToReg = 1'b1;
		end
		
		5'b10111: begin //SRLI
			RegWriteDataSel = 2'b11;
			ALUOp = 4'b0011;
			ALUSelB = 2'b11;
			WriteToReg = 1'b1;
		end
		
		5'b10000: begin //ST
			MemWriteEn = 1'b1;
			ALUOp = 4'b0100; //ADD
			ALUSelB = 2'b11;
		end
	
		5'b10001: begin //LD
			RegWriteDataSel = 2'b10;
			MemReadEn = 1'b1;
			ALUOp = 4'b0100; //ADD
			ALUSelB = 2'b11;
			WriteToReg = 1'b1;
		end
		
		5'b10011: begin //STU
			RegWriteDataSel = 2'b11;
			MemWriteEn = 1'b1;
			RegDst = 2'b01;
			ALUOp = 4'b0100; //ADD
			ALUSelB = 2'b11;
			WriteToReg = 1'b1;
		end
		
		5'b11001: begin //ADD,SUB,XOR,ANDN
			RegWriteDataSel = 2'b11;
			RegDst = 2'b10;
			ALUSelB = 2'b01;
			WriteToReg = 1'b1;
			ALUOp = 4'b1000;
			
		end
		
		5'b11011: begin //ADD,SUB,XOR,ANDN
			RegWriteDataSel = 2'b11;
			RegDst = 2'b10;
			ALUSelB = 2'b01;
			WriteToReg = 1'b1;
			ALUOp = (OpcodeExt == 2'b00) ? 4'b0100 :
					(OpcodeExt == 2'b01) ? 4'b0100 :
					(OpcodeExt == 2'b10) ? 4'b0110 : 4'b0111; 
			
			Cin = (OpcodeExt == 2'b01) ? 1'b1 : 1'b0;
			invA = (OpcodeExt == 2'b01) ? 1'b1 : 1'b0;
			
		end
		
		5'b11010: begin //ROL,SLL,ROR,SRL
			RegWriteDataSel = 2'b11;
			RegDst = 2'b10;
			ALUSelB = 2'b01;
			WriteToReg = 1'b1;
			ALUOp = (OpcodeExt == 2'b00) ? 4'b0000 :
					(OpcodeExt == 2'b01) ? 4'b0001 :
					(OpcodeExt == 2'b10) ? 4'b0010 : 4'b0011;
		end
		
		5'b11100: begin //SEQ
			RegWriteDataSel = 2'b01;
			RegDst = 2'b10;
			ALUSelB = 2'b01;
			WriteToReg = 1'b1;
			ALUOp = 4'b0100; //SUB (ADD)
			invA = 1'b1;
			Cin = 1'b1;
			SelFlag = 3'b000;
		end
		
		5'b11101: begin //SLT
			RegWriteDataSel = 2'b01;
			RegDst = 2'b10;
			ALUSelB = 2'b01;
			WriteToReg = 1'b1;
			ALUOp = 4'b0100; //SUB (ADD)
			invA = 1'b1;
			Cin = 1'b1;
			SelFlag = 3'b001;
		end
		
		5'b11110: begin //SLE
			RegWriteDataSel = 2'b01;
			RegDst = 2'b10;
			ALUSelB = 2'b01;
			WriteToReg = 1'b1;
			ALUOp = 4'b0100; //SUB (ADD)
			invA = 1'b1;
			Cin = 1'b1;
			SelFlag = 3'b010;
		end
		
		5'b11111 : begin //SCO
			RegWriteDataSel = 2'b01;
			RegDst = 2'b10;
			ALUSelB = 2'b01;
			WriteToReg = 1'b1;
			ALUOp = 4'b0100; //ADD
			SelFlag = 3'b101;
		end
		
		5'b01100 : begin //BEQZ
			ALUSelB = 2'b10;
			ALUOp = 4'b0100; //ADD
			SelFlag = 3'b000;
			Branch = 1'b1;
			PCImmSel = 1'b1;
		end
		
		5'b01101 : begin //BNEZ
			ALUSelB = 2'b10;
			ALUOp = 4'b0100; //ADD
			SelFlag = 3'b011;
			Branch = 1'b1;
			PCImmSel = 1'b1;
		end
		
		5'b01110 : begin //BLTZ
			ALUSelB = 2'b10;
			ALUOp = 4'b0100; //SUB
			SelFlag = 3'b001;
			Branch = 1'b1;
			PCImmSel = 1'b1;
			invA = 1'b1;
			Cin = 1'b1;
		end
		
		5'b01111 : begin //BGEZ
			ALUSelB = 2'b10;
			ALUOp = 4'b0100; //SUB
			SelFlag = 3'b100;
			Branch = 1'b1;
			PCImmSel = 1'b1;
			invA = 1'b1;
			Cin = 1'b1;
		end
		
		5'b11000 : begin //LBI
			RegWriteDataSel = 2'b11;
			RegDst = 2'b01;
			ALUSelB = 2'b00;
			ALUOp = 4'b1011; //ADD
			WriteToReg = 1'b1;
		end
		
		5'b10010 : begin //SLBI
			RegWriteDataSel = 2'b11;
			RegDst = 2'b01;
			ALUSelB = 2'b00;
			ZeroExt = 1'b1;
			ALUOp = 4'b1001; //SLBI
			WriteToReg = 1'b1;
		end
		
		5'b00100 : begin //J
			Jump = 1'b1;
		end
		
		5'b00110 : begin //JAL
			Jump = 1'b1;
			WriteToReg = 1'b1;
			RegDst = 2'b11;
			RegWriteDataSel = 2'b00;
		end
		
		5'b00101 : begin //JR
			Jump = 1'b1;
			PCImmSel = 1'b1;
			PCAddSel = 1'b1;
		end
		
		5'b00111 : begin //JALR
			RegWriteDataSel = 2'b00;
			RegDst = 2'b11;
			WriteToReg = 1'b1;
			Jump = 1'b1;
			PCImmSel = 1'b1;
			PCAddSel = 1'b1;
		end
		
		5'b00000 : begin //HALT
			Halt = 1'b1;
		end
		
		5'b00001 : begin //NOP
			//Do Nothing?
		end
		
		5'b00010 : begin //SIIC
			//TODO
		end
		
		default : begin //Undefined state. Throw error
			err = 1'b1;
		end
	endcase

end


endmodule