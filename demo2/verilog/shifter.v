module shifter (In, Cnt, Op, Out); //16-bit barrerl shifter
   
   input [15:0] In;
   input [3:0]  Cnt;
   input [1:0]  Op;
   output[15:0] Out;

   /*
   Your code goes here
   */
    
   wire [15:0] muxL1_Out, muxL2_Out, muxL3_Out;
   reg [15:0] muxL1_In, muxL2_In, muxL3_In, muxL4_In;
   
   mux2_1 muxL1[15:0] (.InA(In), .InB(muxL1_In), .S(Cnt[0]), .Out(muxL1_Out));
   mux2_1 muxL2[15:0] (.InA(muxL1_Out), .InB(muxL2_In), .S(Cnt[1]), .Out(muxL2_Out));
   mux2_1 muxL3[15:0] (.InA(muxL2_Out), .InB(muxL3_In), .S(Cnt[2]), .Out(muxL3_Out));
   mux2_1 muxL4[15:0] (.InA(muxL3_Out), .InB(muxL4_In), .S(Cnt[3]), .Out(Out));
   always @(*) begin
	case(Op)
		2'b00: begin //rotate left
			//#2;
			muxL1_In = {In[14:0],In[15]};
			//#2;
		    muxL2_In = {muxL1_Out[13:0],muxL1_Out[15:14]}; 
			//#2;
			muxL3_In = {muxL2_Out[11:0],muxL2_Out[15:12]};
			//#2;
			muxL4_In = {muxL3_Out[7:0], muxL3_Out[15:8]};
			//#2;

		end
		2'b01: begin //shift left
			//#2;	
			muxL1_In = {In[14:0], 1'b0};
			//#2;
		    muxL2_In = {muxL1_Out[13:0], 2'b00}; 
			//#2;
			muxL3_In = {muxL2_Out[11:0], 4'b0000};
			//#2;
			muxL4_In = {muxL3_Out[7:0], 8'b0000_0000};
			//#2;
			
		end
		2'b10: begin //rotate right
			//$display("SRA: Cnt: %d, Op=%d, A=$x",Cnt, Op, In);
			//#2;
			muxL1_In = {In[0], In[15:1]};
			//#2;
		    muxL2_In = {muxL1_Out[1:0],muxL1_Out[15:2]}; 
			//#2;
			muxL3_In = {muxL2_Out[3:0],muxL2_Out[15:4]};
			//#2;
			muxL4_In = {muxL3_Out[7:0], muxL3_Out[15:8]};
			//#2;
			
		end
		
		default: begin //shift right logic
			//$display("SRL: Cnt: %d, Op=%d, A=$x",Cnt, Op, In);
			//#2;
			muxL1_In = {1'b0, In[15:1]};
			//#2;
		    muxL2_In = {{2{1'b0}},muxL1_Out[15:2]}; 
			//#2;
			muxL3_In = {{4{1'b0}},muxL2_Out[15:4]};
			//#2;
			muxL4_In = {{8{1'b0}}, muxL3_Out[15:8]};
			//#2;
		end
   
	endcase
   end
   
endmodule

