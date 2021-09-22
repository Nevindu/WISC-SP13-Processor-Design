/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module rf_bypass (
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

   output [15:0] read1data;
   output [15:0] read2data;
   output        err;

   // your code
   
   wire [15:0] read1data_temp, read2data_temp;
   
   
   rf regf(.read1data(read1data_temp), .read2data(read2data_temp), .err(err), .clk(clk), .rst(rst), .read1regsel(read1regsel), .read2regsel(read2regsel),
		  .writeregsel(writeregsel) , .writedata(writedata), .write(write));
		  
	assign read1data = write == 1'b1 ? (writeregsel == read1regsel ? writedata : read1data_temp) : read1data_temp;
	assign read2data = write == 1'b1 ? (writeregsel == read2regsel ? writedata : read2data_temp) : read2data_temp;

endmodule
// DUMMY LINE FOR REV CONTROL :1:
