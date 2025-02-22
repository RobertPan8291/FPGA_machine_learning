module dot(input logic clk, input logic rst_n,
           // slave (CPU-facing)
           output logic slave_waitrequest, 
           input logic [3:0] slave_address,
           input logic slave_read, output logic [31:0] slave_readdata,
           input logic slave_write, input logic [31:0] slave_writedata,
           // master (memory-facing)
           input logic master_waitrequest,
           output logic [31:0] master_address,
           output logic master_read, input logic [31:0] master_readdata, input logic master_readdatavalid,
           output logic master_write, output logic [31:0] master_writedata);


			  parameter [4:0] INIT = 5'd0,
									RECORD_W = 5'd1,
									HOLD_W= 5'd2,
									RECORD_IF = 5'd3,
									HOLD_IF = 5'd4,
									RECORD_N = 5'd5,
									HOLD_N = 5'd6,
									HOLD = 5'd7,
									START_READ_W = 5'd8,
									WAIT_FOR_STABLE_W = 5'd19,
									WAIT_READ_W = 5'd9,
									COLLECT_W = 5'd10,
									START_READ_IF = 5'd11,
									WAIT_FOR_STABLE_IF = 5'd20,
									WAIT_READ_IF = 5'd12,
									COLLECT_IF = 5'd13,
									MULTIPLY = 5'd14,
									SHIFT = 5'd15,
									INCREMENT = 5'd16,
									WAIT_TO_SEND = 5'd17,
									SEND_DATA = 5'd18;
									
				logic [4:0] state = INIT; 
				
				logic [31:0] n_word_counter;
	
				logic [31:0] n_word;
				
				logic [31:0] w_addr_reg; 
				logic [31:0] if_addr_reg; 
				
				logic [31:0] temp_w; 
				logic [31:0] temp_if;
				
				logic [31:0] temp_result;
				
				logic [31:0] sum; 
				
				logic [4:0] stable_counter; 
				
				logic [31:0] rounded_result;
				
			  always_ff @(posedge clk or negedge rst_n) begin
					if(~rst_n) begin
						state <= INIT; 
					end else begin		
						case(state)
							INIT: begin
										/*if(slave_write && (slave_address == 4'd2))
											state <= RECORD_W;
										else if(slave_write && (slave_address == 4'd3))
											state <= RECORD_IF;
										else if(slave_write && (slave_address == 4'd5))
											state <= RECORD_N;*/
										if(slave_write && (slave_address == 4'd0))
											state <= HOLD;
										else 
											state <= INIT;
									end
							 RECORD_W: state <= HOLD_W;
							 HOLD_W: state <= INIT;
							 RECORD_IF: state <= HOLD_IF;
							 HOLD_IF: state <= INIT;
							 RECORD_N: state <= HOLD_N;
							 HOLD_N: state <= INIT; 
							 HOLD: state <= START_READ_W; 
							 START_READ_W: state <= WAIT_FOR_STABLE_W;
							 WAIT_FOR_STABLE_W: begin 
															if(stable_counter >= 5'd30)
																state <= WAIT_READ_W;
															else 
																state <= WAIT_FOR_STABLE_W;
													
													  end
							 WAIT_READ_W: begin
										if(master_readdatavalid /*&& ~master_waitrequest*/) 
											state <= COLLECT_W;
										else 
											state <= WAIT_READ_W;
							  end
							 COLLECT_W: state <= START_READ_IF; 
							 START_READ_IF: state <= WAIT_FOR_STABLE_IF;
							 WAIT_FOR_STABLE_IF: begin 
															if(stable_counter >= 5'd30)
																state <= WAIT_READ_IF;
															else 
																state <= WAIT_FOR_STABLE_IF;
													
													  end
							 WAIT_READ_IF: begin
										if(master_readdatavalid /*&& ~master_waitrequest*/) 
											state <= COLLECT_IF;
										else 
											state <= WAIT_READ_IF;
							  end
							 COLLECT_IF: state <= MULTIPLY; 
							 MULTIPLY: state <= SHIFT;
							 SHIFT: state <= INCREMENT; 
							 INCREMENT: begin
												if(n_word_counter == n_word - 1'b1)
													state <= WAIT_TO_SEND; 
												else 
													state <= START_READ_W;			
											end
							 WAIT_TO_SEND: begin
												  if(slave_read) 
														state <= SEND_DATA;
													else 
														state <= WAIT_TO_SEND;
												end
							 SEND_DATA: state <= INIT;
						endcase
					end
				end
				
				
				always_ff @(posedge clk or negedge rst_n) begin
					if(~rst_n) begin 
						slave_waitrequest <= 1'b1;
						master_address <= 32'd0;
						master_read <= 1'b0;
						master_write <= 1'b0;
						master_writedata <= 32'd0;
						n_word_counter <= 32'd0;
						sum <= 32'd0;
					end else begin
						case (state) 
							INIT: begin
										slave_waitrequest <= 1'b0;
										master_address <= 32'd0;
										master_read <= 1'b0;
										master_write <= 1'b0;
										master_writedata <= 32'd0;
										n_word_counter <= 32'd0;
										sum <= 32'd0;	
										stable_counter <= 5'd0;	
									end
							/*RECORD_W: begin
											w_addr_reg <= slave_writedata;
											slave_waitrequest <= 1'b0;
										 end
							RECORD_IF: begin
											if_addr_reg <= slave_writedata; 
											slave_waitrequest <= 1'b0;
										  end
							RECORD_N: begin
											n_word <= slave_writedata;
											slave_waitrequest <= 1'b0; 
										 end*/
							HOLD: slave_waitrequest <= 1'b0; 
							START_READ_W: begin 
													master_read <= 1'b1;
													master_address <= w_addr_reg;
													slave_waitrequest <= 1'b1;
											  end
							WAIT_FOR_STABLE_W: begin
														stable_counter <= stable_counter + 1'b1;
													 end
							WAIT_READ_W: stable_counter <= 5'd0;
							COLLECT_W: begin
													//temp_w <= master_readdata;
													master_read <= master_read;
													//master_address <= 32'd0;
										  end
							START_READ_IF: begin
													master_read <= 1'b1;
													master_address <= if_addr_reg;										
												end
							WAIT_FOR_STABLE_IF: begin
														stable_counter <= stable_counter + 1'b1;
													 end
							WAIT_READ_IF: stable_counter <= 5'd0;
							COLLECT_IF: begin
													//temp_if <= master_readdata;
													master_read <= master_read;
													//master_address <= 32'd0;
											end
							/*MULTIPLY: begin 
													temp_result <= (temp_w * temp_if);
										 end
							SHIFT: begin 
											temp_result <= temp_result >> 16;
									 end*/
							INCREMENT: begin
												//w_addr_reg <= w_addr_reg + 1'b1;
												//if_addr_reg <= if_addr_reg + 1'b1;
												n_word_counter <= n_word_counter + 1'b1;
												sum <= sum + temp_result; 
										  end
							WAIT_TO_SEND: begin
												slave_readdata <= sum;
											  end
							//SEND_DATA: begin
												//slave_waitrequest <= 1'b0;
										  //end
							
					
						endcase
					end	
				end
			  
			  
			  always_ff @(posedge clk) begin
					if((state == WAIT_READ_W) && (master_readdatavalid /*&& ~master_waitrequest*/))
						temp_w <= master_readdata;
			  end
			  
			  always_ff @(posedge clk) begin
					if((state == WAIT_READ_IF) && (master_readdatavalid /*&& ~master_waitrequest*/))
						temp_if <= master_readdata;
			  end
			  
			  always_ff @(posedge clk) begin
					if((state == INIT) && (slave_write && (slave_address == 4'd2)))
						w_addr_reg <= slave_writedata;
					else if(state == INCREMENT) 
						w_addr_reg <= w_addr_reg + 1'b1;
			  end
			  
			  always_ff @(posedge clk) begin
					if((state == INIT) && (slave_write && (slave_address == 4'd3)))
						if_addr_reg <= slave_writedata;
					else if(state == INCREMENT) 
						if_addr_reg <= if_addr_reg + 1'b1;
			  end		
			  
			  always_ff @(posedge clk) begin
					if((state == INIT) && (slave_write && (slave_address == 4'd5)))
						n_word <= slave_writedata;
			  end	
			  
			  
			  multiplier multiplier_inst(
					.a(temp_w),
					.b(temp_if),
					.result(temp_result)
				);
			 
			 rounder rounder_inst(
					.in(sum),
					.round_32_bit(rounded_result)
			);
			  
endmodule: dot