module dut_top(hitin,reset,read,valid,addr,clk);
input [127:0] hitin;
input read;
input reset;
input clk;
output valid;
output [6:0] addr;

wire [127:0] hitin;
wire reset;
wire read;
wire clk;
wire valid;
wire [6:0] addr;

wire [127:0] state;
wire [127:0] reset_p;

genvar a;
generate 
	for(a=0;a<128;a=a+1)
		begin:shifter2
			pixelcell pixel_ins(hitin[a],
								reset_p[a],
								state[a]);
		end
endgenerate
pixel_encoder128 pixel_encoder128_h(state,
									read,
									addr,
									valid,
									reset_p,
									reset,
									clk);

endmodule
