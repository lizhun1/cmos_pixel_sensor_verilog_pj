`timescale 1ns/1ps
module tb_top_dcol;
reg clk;
reg full;
reg empty;
reg [14:0] addrin;
reg reset;
reg sel;
wire [18:0]addrout;
wire readin;
wire resetpe;
wire write_q;


 dcol_reader	dc(	full,
					empty,
					addrin,
					clk,
					readin,
					addrout,
					reset,
					resetpe,
					write_q,
					sel);
initial
	begin
		sel=1'b1;
		full=1'b1;
		addrin[14:8]=7'b0000000;
		clk=0;
		#200
		reset=1'b1;
		#200 addrin[7:0]=8'b10100001;
		#100 reset=1'b0;
		#200 addrin[7:0]=8'b10100011;
		#200 addrin[7:0]=8'b10100101;
		#200 addrin[7:0]=8'b10100111;
		#200 addrin[7:0]=8'b10101001;
		#200 addrin[7:0]=8'b10101011;
		#200 addrin[7:0]=8'b10101101;
		#200 addrin[7:0]=8'b10101111;
		
		#4000 $stop;
	end
always #100 clk=~clk;
endmodule


