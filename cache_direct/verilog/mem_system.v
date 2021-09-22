/* $Author: karu $ */
/* $LastChangedDate: 2009-04-24 09:28:13 -0500 (Fri, 24 Apr 2009) $ */
/* $Rev: 77 $ */

module mem_system(/*AUTOARG*/
   // Outputs
   DataOut, Done, Stall, CacheHit, err,
   // Inputs
   Addr, DataIn, Rd, Wr, createdump, clk, rst
   );
   
   input [15:0] Addr;
   input [15:0] DataIn;
   input        Rd;
   input        Wr;
   input        createdump;
   input        clk;
   input        rst;
   
   output [15:0] DataOut;
   output reg Done;
   output reg Stall;
   output reg CacheHit;
   output err;

	   //cache inputs and outputs
   wire hit, dirty, valid, cache_err;
   reg enable, comp, write;
   reg [2:0] offset;
   wire [4:0] tag_in, tag_out;
   wire [7:0] index;
   wire [15:0] c_data_out;
   reg [15:0] c_data_in;
   
   //mem inputs and outputs
   wire  mem_err, stall;
   wire [3:0] busy;
   wire [15:0]  mem_bank_data_out;
   wire [15:0] mem_data_in;
   wire [15:0] mem_bank_addr;
   reg wr, rd;
   
   wire [4:0] state;
   reg [4:0] next_state;
   
   dff stateReg[4:0](.d(next_state), .q(state), .clk(clk), .rst(rst));
   
   
   ///

   localparam IDLE        = 5'b00000;
   localparam READ_CACHE   = 5'b00001;
   
   localparam READ_MEM_B0    = 5'b00010;
   localparam HOLD0  = 5'b00011;
   localparam WRITE_CAHE_W0 = 5'b00100;
   
   localparam READ_MEM_B1    = 5'b00101;
   localparam HOLD1  = 5'b00110;
   localparam WRITE_CAHE_W1 = 5'b00111;
   
   localparam READ_MEM_B2    = 5'b01000;
   localparam HOLD2  = 5'b01001;
   localparam WRITE_CAHE_W2 = 5'b01010;
   
   localparam READ_MEM_B3    = 5'b01011;
   localparam HOLD3  = 5'b01100;
   localparam WRITE_CAHE_W3 = 5'b01101; 
   
   localparam CACHE_WRITE_DONE   = 5'b01110;
   
   localparam WRITE_CACHE   = 5'b01111;
   localparam WRITE_MEM_B0  = 5'b10000;
   localparam WRITE_MEM_B1  = 5'b10001;
   localparam WRITE_MEM_B2  = 5'b10010;
   localparam WRITE_MEM_B3  = 5'b10011;
   localparam WRITE_MISS    = 5'b10100;
  

   localparam DONE        = 5'b10101;
   localparam UNKNOWN     = 5'b10110;
  
  
	 // your code here
 
   reg [4:0] tag_select;
   reg [2:0] bank_idx;
  
   assign mem_bank_addr = {tag_select, Addr[10:3], bank_idx};
   assign tag_in = Addr[15:11];
   assign index = Addr[10:3];
   assign DataOut = c_data_out;
   assign mem_data_in = c_data_out;


   /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
   parameter memtype = 0;
   cache #(0 + memtype) c0(// Outputs
                          .tag_out              (tag_out),
                          .data_out             (c_data_out),
                          .hit                  (hit),
                          .dirty                (dirty),
                          .valid                (valid),
                          .err                  (cache_err),
                          // Inputs
                          .enable               (enable),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (tag_in),
                          .index                (index),
                          .offset               (offset),
                          .data_in              (c_data_in),
                          .comp                 (comp),
                          .write                (write),
                          .valid_in             (1'b1));

   four_bank_mem mem(// Outputs
                     .data_out          (mem_bank_data_out),
                     .stall             (stall),
                     .busy              (busy),
                     .err               (mem_err),
                     // Inputs
                     .clk               (clk),
                     .rst               (rst),
                     .createdump        (createdump),
                     .addr              (mem_bank_addr),
                     .data_in           (mem_data_in),
                     .wr                (wr),
                     .rd                (rd));

   
  

  always@(*)begin 
  
   Done = 1'b0;
   Stall = 1'b1;
   comp = 1'b0;
   enable = 1'b0;
   CacheHit = 1'b0;
   write = 1'b0;
   wr = 1'b0;
   rd = 1'b0;
 
   bank_idx = 3'b000;
   offset = Addr[2:0];
   tag_select = Addr[15:11];
   c_data_in = DataIn;


    case(state)

      IDLE: begin
        enable = 1'b1;
        Stall = 1'b0;
        next_state =  (Rd & Wr) ? UNKNOWN :
					  Rd ? READ_CACHE : 
					  Wr ? WRITE_CACHE : IDLE;
      end

      READ_CACHE: begin
		  enable = 1'b1;
		  comp = 1'b1;
		  next_state = (hit & valid) ? DONE : 
					   (~dirty & (~hit | ~valid)) ? READ_MEM_B0 : 
					   dirty ? WRITE_MEM_B0 : UNKNOWN;
      end
	  
	  READ_MEM_B0: begin
		  rd = 1'b1; 
		  next_state = (stall) ? READ_MEM_B0: HOLD0;
      end

      HOLD0: begin
		next_state = WRITE_CAHE_W0;
      end
	  
	  WRITE_CAHE_W0: begin
		  enable = 1'b1;
		  write = 1'b1;
		  offset = 3'b000;
		  c_data_in = mem_bank_data_out;
		  next_state = READ_MEM_B1;
      end

      READ_MEM_B1: begin
		  rd = 1'b1;
		  bank_idx = 3'b010;
		  next_state = stall ? READ_MEM_B1: HOLD1;
      end

      HOLD1: begin
		next_state = WRITE_CAHE_W1;
      end

	 
      WRITE_CAHE_W1: begin
		  enable = 1'b1;
		  write = 1'b1;
		  bank_idx = 3'b010;
		  offset = 3'b010;
		  c_data_in = mem_bank_data_out;
		  next_state = READ_MEM_B2;
      end

      READ_MEM_B2: begin
		  rd = 1'b1;
		  bank_idx = 3'b100;
		  next_state = stall ? READ_MEM_B2: HOLD2;
      end

      HOLD2: begin
		  next_state = WRITE_CAHE_W2;
      end
	  
	  
      WRITE_CAHE_W2: begin
		  enable = 1'b1;
		  write = 1'b1;
		  bank_idx = 3'b100;
		  offset = 3'b100;
		  c_data_in = mem_bank_data_out;
		  next_state = READ_MEM_B3; 
      end

      READ_MEM_B3: begin
		  rd = 1'b1;
		  bank_idx = 3'b110;
		  next_state = stall ? READ_MEM_B3: HOLD3;
      end

      HOLD3: begin
		 next_state = WRITE_CAHE_W3;
      end

      WRITE_CAHE_W3: begin
		  enable = 1'b1;
		  write = 1'b1;
		  bank_idx = 3'b110;
		  offset = 3'b110;
		  c_data_in = mem_bank_data_out;
		  next_state =  Wr ? WRITE_MISS : CACHE_WRITE_DONE;
      end

      WRITE_MISS: begin
			enable = 1'b1;
			comp = 1'b1;
			write = 1'b1;
			next_state = CACHE_WRITE_DONE;
      end

      CACHE_WRITE_DONE: begin
			enable = 1'b1;
			Done = 1'b1;
			next_state =  IDLE;
      end

      WRITE_CACHE: begin
		  enable = 1'b1;
		  comp = 1'b1;
		  write = 1'b1;
		  next_state = (hit & valid) ? DONE : 
					   (~dirty & (~hit | ~valid)) ? READ_MEM_B0 : 
					   (dirty & Wr) ? WRITE_MEM_B0 : UNKNOWN;
      end

      WRITE_MEM_B0: begin
		  enable = 1'b1;
		  comp = 1'b0;
		  wr = 1'b1; 
		  offset = 3'b000;
		  tag_select = tag_out;
		  next_state = stall ? WRITE_MEM_B0 : WRITE_MEM_B1;
      end

      WRITE_MEM_B1: begin
		  enable = 1'b1;
		  wr = 1'b1;
		  bank_idx = 3'b010;
		  tag_select = tag_out;
		  offset = 3'b010;
		  next_state = stall ? WRITE_MEM_B1: WRITE_MEM_B2;
      end

      WRITE_MEM_B2: begin
		  enable = 1'b1;
		  wr = 1'b1;
		  bank_idx = 3'b100;
		  tag_select = tag_out;
		  offset = 3'b100;
		  next_state = stall ? WRITE_MEM_B2: WRITE_MEM_B3;
      end


      WRITE_MEM_B3: begin
		  enable = 1'b1;
		  wr = 1'b1; 
		  bank_idx = 3'b110;
		  tag_select = tag_out;
		  offset = 3'b110;
		  next_state = stall ? WRITE_MEM_B3: READ_MEM_B0;

      end

      UNKNOWN: begin
			next_state =  IDLE;
      end

      DONE: begin
			enable = 1'b1;
			Done = 1'b1;
			CacheHit = 1'b1;
			next_state =  IDLE;
      end

      default: begin
      end
    endcase
   end
			
			
	assign err = mem_err | cache_err;
	
endmodule // mem_system

// DUMMY LINE FOR REV CONTROL :9:
