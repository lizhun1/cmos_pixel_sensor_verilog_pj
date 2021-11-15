module time_mod(pro_full,timeout,reset);
input pro_full;
input reset;
output [6:0]timeout;

wire pro_full;
wire reset;
reg [6:0]timeout;

always@(posedge pro_full or posedge reset)
	begin
		if(reset)
			timeout<=7'b0;
		else
			timeout<=timeout+7'b0000001;
	end
endmodule
