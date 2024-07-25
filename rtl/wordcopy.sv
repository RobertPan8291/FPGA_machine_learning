module wordcopy(input logic clk, input logic rst_n,
                // slave (CPU-facing)
                output logic slave_waitrequest,
                input logic [3:0] slave_address,
                input logic slave_read, output logic [31:0] slave_readdata,
                input logic slave_write, input logic [31:0] slave_writedata,
                // master (SDRAM-facing)
                input logic master_waitrequest,
                output logic [31:0] master_address,
                output logic master_read, input logic [31:0] master_readdata, input logic master_readdatavalid,
                output logic master_write, output logic [31:0] master_writedata);
	 
	
	
	parameter [4:0] INIT = 5'b00000,
						 RECORD_DST = 5'b00001,
						 HOLD_DST = 5'b00010,
						 RECORD_SRC = 5'b00011,
						 HOLD_SRC = 5'b00100,
						 RECORD_N = 5'b00101,
						 HOLD_N = 5'b00110,
						 START_READ = 5'b00111,
						 WAIT_READ = 5'b01000,
						 COLLECT = 5'b01001,
						 SEND_DATA = 5'b01010,
						 INCREMENT = 5'b01011;				 
	
	logic [4:0] state = INIT; 
	
	logic [31:0] n_word_counter;
	
	logic [31:0] n_word;
	logic [31:0] dst_addr_reg;
	logic [31:0] src_addr_reg;
	
	
	
	logic [31:0] data_to_copy;
	
	
	always_ff @(posedge clk or posedge rst_n) begin
		if(rst_n) begin
			state <= INIT; 
		end else begin
			case(state) 
				INIT: begin
							if(slave_write && (slave_address == 4'd1))
								state <= RECORD_DST;
							else
								state <= INIT;
						end
				RECORD_DST: state <= HOLD_DST;
				HOLD_DST: begin
							if(slave_write &&  (slave_address == 4'd2))
								state <= RECORD_SRC;
							else
								state <= HOLD_DST;							
						end
				RECORD_SRC: state <= HOLD_SRC;
				HOLD_SRC: begin
							if(slave_write &&  (slave_address == 4'd3))
								state <= RECORD_N;
							else
								state <= HOLD_SRC;							
						end		
				RECORD_N: state <= HOLD_N; 
				HOLD_N: begin
							if(slave_write &&  (slave_address == 4'd0))
								state <= START_READ;
							else
								state <= HOLD_N;							
						end	
			   START_READ: state <= WAIT_READ;
				WAIT_READ: begin
								if(master_readdatavalid && ~master_waitrequest) 
									state <= COLLECT;
								else 
									state <= WAIT_READ;
							  end
				COLLECT: state <= SEND_DATA; 
				SEND_DATA: begin
								 if(~master_waitrequest) 
									state <= INCREMENT;
								 else
									state <= SEND_DATA;
							  end
				INCREMENT: begin
								 if(n_word_counter == n_word - 1'b1)
									state <= INIT; 
								 else 
									state <= START_READ;
							  end
		   endcase   
		end
	end
	
	
	always_ff @(posedge clk or posedge rst_n) begin
		if(rst_n) begin 
			slave_waitrequest <= 1'b1;
			master_address <= 32'd0;
			master_read <= 1'b0;
			master_write <= 1'b0;
			master_writedata <= 32'd0;
			n_word_counter <= 32'd0;
		end else begin
			case (state) 
				INIT: begin 
							slave_waitrequest <= 1'b1;
							master_address <= 32'd0;
							master_read <= 1'b0;
							master_write <= 1'b0;
							master_writedata <= 32'd0;
							n_word_counter <= 32'd0;
							if(state == RECORD_DST)
								dst_addr_reg <= slave_writedata;

						end
				RECORD_DST: begin 
									dst_addr_reg <= slave_writedata;
									slave_waitrequest <= 1'b0;
								end
				HOLD_DST: slave_waitrequest <= 1'b1;
				RECORD_SRC: begin
									src_addr_reg <= slave_writedata; 
									slave_waitrequest <= 1'b0;
								end
				HOLD_SRC: slave_waitrequest <= 1'b1;
				RECORD_N: begin
									n_word <= slave_writedata;
									slave_waitrequest <= 1'b0;
							 end
				HOLD_N: slave_waitrequest <= 1'b1;	
				START_READ: begin
									master_read <= 1'b1;
									master_address <= src_addr_reg;
									slave_waitrequest <= 1'b0;
								end
				COLLECT: begin
									data_to_copy <= master_readdata;
									master_read <= 1'b0;
									master_address <= 32'd0;
							end
				SEND_DATA: begin
									master_write <= 1'b1;
									master_address <= dst_addr_reg;
									master_writedata <= data_to_copy;
							  end			
				INCREMENT: 	begin 
									master_write <= 1'b0; 
									n_word_counter <= n_word_counter + 1'b1;
									src_addr_reg <= src_addr_reg + 1'b1;
									dst_addr_reg <= dst_addr_reg + 1'b1;
								end
			endcase
		end
	end
	 
	 
endmodule: wordcopy
