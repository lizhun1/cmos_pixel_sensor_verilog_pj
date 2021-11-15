`define width 64
`define length 64
`define datasize 18

interface dut_io(input bit SCLK,input bit clk1,input bit clk2,input bit clk3);
logic 	[`width*`length-1:0] 	hit;
logic							mem_full;
logic							mem_empty;
logic	[23:0]					LVDS;
logic							SS;
logic	[7:0]					MOSI;
logic	[7:0]					MISO;
logic							sys_reset;

clocking	cb_cmd @(posedge SCLK);//指令同步信号
	input MISO;
	output MOSI;
endclocking
clocking  	cb1 @(posedge clk3);//数据输出同步
	input LVDS;
endclocking
//testbench连接端口
modport TB(output sys_reset,output SS,output hit,input mem_empty,input mem_full,clocking cb_cmd,clocking cb1);

endinterface:dut_io


