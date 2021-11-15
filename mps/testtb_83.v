`timescale 1ns/1ps
module tb_top83;
reg clk;
reg [7:0] state;
reg read;
reg reset_encoder;

wire valid;
wire [3:0]addr;
wire [7:0] reset;

 pro_encoder83 pro83(state,read,reset,addr,clk,reset_encoder);
initial
	begin
		state<=8'b11111111;
		clk=0;
		read=1'b0;
		#200
		
		reset_encoder=1'b1;
		#200 reset_encoder=1'b0;
		#1000 reset_encoder=1'b1;
		#1000 reset_encoder=1'b0;
		#200 read=1'b1;
		#4000 $stop;
	end
always #100 clk=~clk;
endmodule

