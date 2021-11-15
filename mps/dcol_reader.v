module dcol_reader(	full,
					empty,
					addrin,
					clk,
					readin,
					addrout,
					reset,
					resetpe,
					write_q,
					sel);
					
					
					
input 			full;
input			empty;
input 	[14:0]	addrin;
input			clk;
input 			reset;
input 			sel;


output 			readin;
output 	[18:0]	addrout;
output 			resetpe;
output 			write_q;

wire 			sel;
wire 			full;
wire 			empty;
wire 	[14:0] 	addrin;
wire 			reset;
reg 			write_q;
reg 			resetpe;

reg 			readin;
reg 	[18:0]	addrout;
reg 	[14:0] 	mem[7:0];
reg 	[2:0]	pointer;
reg 	[1:0] 	state_dcol;
reg    	[1:0]		wait_two_clk;

parameter IDLE=2'b00;
parameter READ=2'b01;
parameter WAIT=2'b11;
parameter DATA=2'b10;




always@(posedge clk)
	begin
		if(reset==1'b1) 
			begin
				state_dcol<=IDLE;
				resetpe<=1'b1;
				readin<=1'b0;
				wait_two_clk=2'b00;
			end
		else
			begin
				resetpe<=1'b0;
				case(state_dcol)
					IDLE : 	begin
								addrout<=19'bzzzzzzzzzzzzzzzzzzz;
								pointer<=3'b111;
								write_q<=1'b0;
								readin<=1'b0;
								if(empty) 
									begin
										resetpe<=1'b1;
									end	
								if(full) 
									begin
										state_dcol<=READ;
										readin<=1'b1;
									end

							end
					READ :	begin
								if(readin)
									begin
										pointer<=pointer+3'b001;
										mem[pointer]=addrin;
									end
								if(pointer==3'b111) 
									begin
										if(mem[0][0]|mem[1][0]|mem[2][0]|mem[3][0]|mem[4][0]|mem[5][0]|mem[6][0]|mem[7][0]) 
											begin
												write_q<=1'b1;
												state_dcol<=WAIT;
												addrout<=19'bzzzzzzzzzzzzzzzzzzz;
												readin<=1'b0;
												pointer<=3'b000;
											end
									end	
								if(empty) 
									begin
										resetpe<=1'b1;
										state_dcol<=IDLE;
									end	
							end
					
					WAIT :	begin
								if(sel) 
									begin
										state_dcol<=DATA;
										addrout[18:8]<=mem[0][14:4];
										addrout[0]<=mem[0][0];
										addrout[1]<=mem[1][0];
										addrout[2]<=mem[2][0];
										addrout[3]<=mem[3][0];
										addrout[4]<=mem[4][0];
										addrout[5]<=mem[5][0];
										addrout[6]<=mem[6][0];
										addrout[7]<=mem[7][0];
									end
							end				
					DATA :	begin
								state_dcol<=READ;
								write_q<=1'b0;
								readin<=1'b1;
								mem[0]<=15'b0;
								mem[1]<=15'b0;
								mem[2]<=15'b0;
								mem[3]<=15'b0;
								mem[4]<=15'b0;
								mem[5]<=15'b0;
								mem[6]<=15'b0;
								mem[7]<=15'b0;
								addrout<=19'bzzzzzzzzzzzzzzzzzzz;
								if(empty) 
									begin
										resetpe<=1'b1;
										state_dcol<=IDLE;
									end
							end
					
				endcase
			end
	end
endmodule
