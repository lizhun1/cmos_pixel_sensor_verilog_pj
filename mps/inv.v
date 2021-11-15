module main(clk,in,out);
input clk;
input in;
output out;
wire clk;
wire in;
reg out;
always@(posedge clk)
	begin
		out<=~in;
	end
endmodule