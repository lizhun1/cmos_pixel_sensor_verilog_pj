module pro_encoder42(state,read,reset,addr,valid,clk,reset_encoder);

input [3:0] state;
input read;
input clk;
input reset_encoder;
output [1:0]addr;
output [3:0]reset;
output valid;

wire [3:0] state;
wire clk;
wire read;
wire reset_encoder;
reg [1:0] addr;
reg [3:0] reset;
wire valid;

assign valid=state[3]|state[2]|state[1]|state[0];

always@(state or reset_encoder)
	begin
		if(reset_encoder==1'b1)	
			begin
				reset<=4'b0000;
				addr<=2'b11;
			end
		else
			begin
				if(state[7]==1'b1) 
			end
	end
endmodule