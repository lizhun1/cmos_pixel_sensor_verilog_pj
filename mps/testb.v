`timescale 1ns/1ps
module tb_top;
reg clk;
reg clkout;
reg [127:0] state;
reg read;
reg en;
reg readout;

wire [127:0] reset;
reg reset_pe;
wire full;
wire empty;
wire [7:0]addr;
 pixel_encoder128 pro128(	state,
							read,
							addr,
							reset,
							reset_pe,
							en,
							clk,
							readout,
							clkout,
							full,
							empty);
initial
	begin
		state<=127'b1111111111111111111111111111111;
		clk=0;
		clkout=0;
		read=1'b0;
		readout=1'b1;
		en=1'b1;
		reset_pe=1'b1;
		#200 reset_pe=1'b0;
		#1000 reset_pe=1'b1;
		#1000 reset_pe=1'b0;
		read=1'b1;
		#4000 readout<=1'b0;
		#4000 readout<=1'b1;
		
		#160000 $stop;
	end
always #100 clk=~clk;
always #200 clkout=~clkout;
endmodule
