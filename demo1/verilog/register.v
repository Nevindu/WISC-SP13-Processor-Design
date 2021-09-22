module register(IN, clk, rst, OUT);

input [15:0] IN;
input clk, rst;

output [15:0] OUT;

//wire [15:0] D_IN;

//assign D_IN = write == 1'b1 ? IN : OUT;

dff reg0[15:0] (.q(OUT), .d(IN), .clk(clk), .rst(rst));


endmodule