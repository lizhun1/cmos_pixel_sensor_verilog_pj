`timescale 1ns/100ps
module dut_test_top;
parameter 	sclk_cycle=500;
parameter 	clk1_cycle=25;
parameter	clk2_cycle=160;
parameter	clk3_cycle=400;
bit systemclk;
bit clk1;
bit clk2;
bit clk3;
dut_io top_io(systemclk,clk1,clk2,clk3);
test t(top_io);
mod_top mps(	top_io.hit,
				top_io.mem_full,
				top_io.mem_empty,
				top_io.clk1,
				top_io.clk2,
				top_io.clk3,
				top_io.LVDS,
				top_io.SCLK,
				top_io.MOSI,
				top_io.MISO,
				top_io.SS,
				top_io.sys_reset
				);
initial
	begin
		systemclk=0;
		clk1=0;
		clk2=0;
		clk3=0;
	end
always 			#(sclk_cycle/2) systemclk=~systemclk;
always 			#(clk1_cycle/2) clk1=~clk1;
always 			#(clk2_cycle/2) clk2=~clk2;
always 			#(clk3_cycle/2) clk3=~clk3;
endmodule
