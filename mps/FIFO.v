module FIFO(write_q,
			read_q,
			clk,
			clkout,
			addrin,
			addrout,
			full,
			empty,
			reset,
			sel);

input 	[31:0]	write_q;
input 			clk;
input 			clkout;
input 	[18:0]	addrin;
input 			reset;
input 			read_q;
output 	[23:0]	addrout;
output 			full;
output 			empty;
output 	[31:0] 	sel;


wire 	[18:0] 	addrin;
wire 	[31:0] 	write_q;
wire 			clk;
wire 			clkout;
wire 			reset;
wire 			read_q;
reg 	[31:0] 	sel;
wire 			full;
wire 			empty;
reg 	[23:0] 	addrout;

reg 	[23:0] 	mem			[255:0];
reg 	[8:0] 	write_pointer;
reg 	[8:0] 	read_pointer;
reg 	[4:0] 	counter;
reg 	[1:0] 	state_f;





always@(posedge clk)
	begin
		if(reset) 
			begin
				write_pointer<=9'b000000000;
				counter<=5'b0;
				sel<=32'b0;
				state_f<=2'b00;
				addrout<=24'bzzzzzzzzzzzzzzzzzzzzzzzz;
			end
		else
			begin
				case(state_f)
					2'b00:	begin
								counter<=counter+5'b00001;
								if(write_q[counter])
									begin
										sel[counter]<=1'b1;
										state_f<=2'b01;
									end
							end
							
					2'b01: 	begin
								state_f<=2'b10;
							end
							
					2'b10: 	begin
								mem[write_pointer[7:0]]<={addrin[18:12],counter-5'b00001,addrin[11:0]};
								write_pointer<=write_pointer+9'b00000001;
								state_f<=2'b00;
								sel[counter-5'b00001]<=1'b0;
							end
				endcase			
			end
	end
	
always@(posedge clkout)
	begin
		if(reset) 
			begin
				read_pointer<=9'b000000000;
			end
		else 
			begin
				if(read_q&&~empty)
					begin
						read_pointer<=read_pointer+9'b000000001;
						addrout<=mem[read_pointer[7:0]];
					end
				else addrout<=24'bzzzzzzzzzzzzzzzzzzzzzzzz;
			end
	end

assign empty=(read_pointer==write_pointer);
assign full=(read_pointer=={~write_pointer[8],write_pointer[7:0]});

endmodule
