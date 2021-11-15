module pixelcell(	hit,
					reset,
					state);
 input 	hit;
 input 	reset;
 output state;
 wire 	hit;
 wire 	reset;
 reg 	state;
 always@(hit or reset)
	begin
		if(reset) state<=1'b0;
		else state<=hit;
	end
 endmodule