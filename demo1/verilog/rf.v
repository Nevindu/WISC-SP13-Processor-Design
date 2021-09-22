/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module rf (
           // Outputs
           read1data, read2data, err,
           // Inputs
           clk, rst, read1regsel, read2regsel, writeregsel, writedata, write
           );
   input clk, rst;
   input [2:0] read1regsel;
   input [2:0] read2regsel;
   input [2:0] writeregsel;
   input [15:0] writedata;
   input        write;

   output  [15:0] read1data;
   output  [15:0] read2data;
   output        err;

   // your code
   
   wire [15:0] r0In, r1In, r2In, r3In, r4In, r5In, r6In, r7In, read1, read2;
   wire [15:0] r0Out, r1Out, r2Out, r3Out, r4Out, r5Out, r6Out, r7Out;

   register r0(.IN(r0In), .clk(clk), .rst(rst), .OUT(r0Out));
   register r1(.IN(r1In), .clk(clk), .rst(rst), .OUT(r1Out));
   register r2(.IN(r2In), .clk(clk), .rst(rst), .OUT(r2Out));
   register r3(.IN(r3In), .clk(clk), .rst(rst), .OUT(r3Out));
   register r4(.IN(r4In), .clk(clk), .rst(rst), .OUT(r4Out));
   register r5(.IN(r5In), .clk(clk), .rst(rst), .OUT(r5Out));
   register r6(.IN(r6In), .clk(clk), .rst(rst), .OUT(r6Out));
   register r7(.IN(r7In), .clk(clk), .rst(rst), .OUT(r7Out));
   

	assign r0In = (writeregsel == 3'b000 & write) ? writedata : r0Out;
	assign r1In = (writeregsel == 3'b001 & write) ? writedata : r1Out;
	assign r2In = (writeregsel == 3'b010 & write) ? writedata : r2Out;
	assign r3In = (writeregsel == 3'b011 & write) ? writedata : r3Out;
	assign r4In = (writeregsel == 3'b100 & write) ? writedata : r4Out;
	assign r5In = (writeregsel == 3'b101 & write) ? writedata : r5Out;
	assign r6In = (writeregsel == 3'b110 & write) ? writedata : r6Out;
	assign r7In = (writeregsel == 3'b111 & write) ? writedata : r7Out;
	
	/*always @* begin
		 $display("WR: %h, WD: %h, RR1: %h, RR2: %h, WEN: %h, R7IN: %h, R7Out: %h",writeregsel, writedata, read1regsel, read2regsel, write, r7In, r7Out);
	end*/
   
   /*
   always @(*) begin
		case(write) 
			
			1'b1: begin
				r0In = writeregsel == 3'b000 ? writedata : r0Out;
				r1In = writeregsel == 3'b001 ? writedata : r1Out;
				r2In = writeregsel == 3'b010 ? writedata : r2Out;
				r3In = writeregsel == 3'b011 ? writedata : r3Out;
				r4In = writeregsel == 3'b100 ? writedata : r4Out;
				r5In = writeregsel == 3'b101 ? writedata : r5Out;
				r6In = writeregsel == 3'b110 ? writedata : r6Out;
				r7In = writeregsel == 3'b111 ? writedata : r7Out;
				
				$display("WRITING %h to REG:%h, WR: %h, ReadR1: %h, ReadR2: %h",writedata, writeregsel, write, read1regsel, read2regsel);
			end
		endcase

   end
   */
	
	assign read1data =  read1regsel == 3'b000 ? r0Out : 
						read1regsel == 3'b001 ? r1Out :
						read1regsel == 3'b010 ? r2Out :
						read1regsel == 3'b011 ? r3Out :
						read1regsel == 3'b100 ? r4Out :
						read1regsel == 3'b101 ? r5Out :
						read1regsel == 3'b110 ? r6Out : r7Out;

	assign read2data =  read2regsel == 3'b000 ? r0Out : 
						read2regsel == 3'b001 ? r1Out :
						read2regsel == 3'b010 ? r2Out :
						read2regsel == 3'b011 ? r3Out :
						read2regsel == 3'b100 ? r4Out :
						read2regsel == 3'b101 ? r5Out :
						read2regsel == 3'b110 ? r6Out : r7Out;
	
	assign err = 1'b0;
endmodule
// DUMMY LINE FOR REV CONTROL :1:
