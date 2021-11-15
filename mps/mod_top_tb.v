`timescale 1ns/1ps
module tb_top_mod;
reg 	[4095:0] 		hit;
reg						clk1;
reg 					clk2;
reg 					clk3;
reg					sys_reset;
reg					SS;
reg					SCLK;
wire					mem_full;
wire					mem_empty;
wire		[7:0]			MISO;
reg	[7:0]			MOSI;
wire 	[23:0] 			LVDS;


mod_top mod_top_h(	hit,
				mem_full,
				mem_empty,
				clk1,
				clk2,
				clk3,
				LVDS,
				SCLK,
				MOSI,
				MISO,
				SS,
				sys_reset);
initial
	begin
		clk1=0;
		clk2=0;
		clk3=0;
		SCLK=0;
		SS=1'b1;
		sys_reset=1'b1;
		hit=4096'hffffffffffffffffffffffffffffffffffffffff;
		#320 sys_reset=1'b0;
		#320 MOSI=8'b0;
		#320 MOSI=8'b11000000;
		#320
		#320	
		#320 MOSI=8'b0;
		#320 MOSI=8'b10000000;
		#2000 hit=4096'h0;
		#300000 $stop;
	end
always #25 clk1=~clk1;
always #200 clk2=~clk2;
always #200 clk3=~clk3;
always #160 SCLK=~SCLK;

endmodule


