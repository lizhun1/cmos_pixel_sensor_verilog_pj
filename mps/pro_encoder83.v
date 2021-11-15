module pro_encoder83(	state,
						read,
						reset,
						addr,
						clk,
						reset_encoder);

input 	[7:0] 	state;
input 			read;
input 			clk;
input 			reset_encoder;
output 	[3:0]	addr;
output 	[7:0]	reset;


wire 	[7:0] 	state;
wire 			clk;
wire 			read;
wire 			reset_encoder;
reg 	[2:0] 	state_read=3'b000;
reg 	[3:0] 	addr=4'b0000;
reg 	[7:0] 	reset=8'b00000000;


always@(posedge clk)
	begin
		if(reset_encoder) state_read<=3'b111;			
		else 
			begin
				if(read) state_read<=state_read+1;
				else state_read<=3'b111;
			end
	end
always@(negedge clk)
	begin
		
		if(reset_encoder) reset<=8'b00000000;
		if(state_read==3'b000) reset<=8'b00000000;
		if(read) reset[state_read]<=1'b1;
		
	end
always@(state_read)
	begin
		if(read)
			begin
				case(state_read)
					3'b000: begin
								if(state[0]==1) addr<=4'b0001;
								else addr<=4'b0000;
							end
					3'b001: begin
								if(state[1]==1) addr<=4'b0011;
								else addr<=4'b0000;
							end
					3'b010: begin
								if(state[2]==1) addr<=4'b0101;
								else addr<=4'b0000;
							end
					3'b011: begin
								if(state[3]==1) addr<=4'b0111;
								else addr<=4'b0000;
							end
					3'b100: begin
								if(state[4]==1) addr<=4'b1001;
								else addr<=4'b0000;
							end
					3'b101: begin
								if(state[5]==1) addr<=4'b1011;
								else addr<=4'b0000;
							end
					3'b110: begin
								if(state[6]==1) addr<=4'b1101;
								else addr<=4'b0000;
							end
					3'b111: begin
								if(state[7]==1) addr<=4'b1111;
								else addr<=4'b0000;
							end
				endcase
			end
		else 
			begin
				addr<=4'b0000;
			end
	end
endmodule