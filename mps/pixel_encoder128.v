module pixel_encoder128(	state,
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
//输入信号
input 	[127:0] state;
input 			clk;
input 			clkout;
input 			readout;
input 			read;
input 			reset_pe;
input 			en;
//输出信号
output 	[7:0] 	addr;
output 	[127:0] reset;
output 			full;
output 			empty;

wire 	[127:0] state;
wire 			clk;
wire 			read;
wire 			reset_pe;
wire 			en;
reg 	[7:0] 	addr;
reg 			full;
wire 	[127:0] reset;
wire 			empty;

reg 	[15:0] 	read_p;
wire 	[3:0] 	addr_p	[15:0];
wire 	[15:0] 	clk_p;
reg 	[15:0] 	reset_p;

reg 	[3:0]	mem		[127:0];
reg 	[2:0] 	pointer;
reg 	[6:0] 	readpointer;
reg 			key;




genvar h;
generate
	for(h=0;h<16;h=h+1)
		begin: shifter3
			assign clk_p[h]=clk;
		end
endgenerate

 genvar i;
 generate
	for(i=0;i<16;i=i+1)
		begin:shifter
			pro_encoder83 pro(	state[7+i*8:0+i*8],
								read_p[i],
								reset[7+i*8:i*8],
								addr_p[i],
								clk_p[i],
								reset_p[i] );
		end
endgenerate

always@(posedge clk)
	begin
		if(en==1'b1)
			begin
				if(reset_pe==1'b1)
					begin
						pointer<=3'b000;
						reset_p<=16'b1111111111111111;
						read_p<=16'b0;
						full<=1'b0;
						key<=1'b0;
					end
				else
					begin
						reset_p<=16'b0000000000000000;
						if(read==1'b1)
							begin
								if(full==1'b0)
									begin
										read_p<=16'b1111111111111111;
										key<=1'b0;
										if(read_p==16'b1111111111111111)
											begin
												key<=1'b1;
												if(key)
												begin
													pointer<=pointer+3'b001;
													mem[pointer]<=addr_p[0];
													mem[pointer+8]<=addr_p[1];
													mem[pointer+2*8]<=addr_p[2];
													mem[pointer+3*8]<=addr_p[3];
													mem[pointer+4*8]<=addr_p[4];
													mem[pointer+5*8]<=addr_p[5];
													mem[pointer+6*8]<=addr_p[6];
													mem[pointer+7*8]<=addr_p[7];
													mem[pointer+8*8]<=addr_p[8];
													mem[pointer+9*8]<=addr_p[9];
													mem[pointer+10*8]<=addr_p[10];
													mem[pointer+11*8]<=addr_p[11];
													mem[pointer+12*8]<=addr_p[12];
													mem[pointer+13*8]<=addr_p[13];
													mem[pointer+14*8]<=addr_p[14];
													mem[pointer+15*8]<=addr_p[15];
												end
											end
									end
								else read_p<=16'b0000000000000000;	
							end
						
					end
					if(pointer==3'b111) 
						begin
							full<=1'b1;
							pointer<=3'b000;
							read_p<=16'b0000000000000000;
						end
					if(readpointer==7'b1111111) full<=1'b0;
			end
	end

always@(posedge clkout)
	begin
		if(reset_pe==1'b1) 
			begin
				readpointer<=7'b0000000;
				addr<=8'bzzzzzzzz;
			end
		else
			begin
				if(full==1'b1)
					begin
					if(readout==1'b1)
						begin
						readpointer<=readpointer+7'b0000001;
						addr[3:0]<=mem[readpointer];
						addr[7:4]<=readpointer[6:3];
						end
					end
			end
	end
assign empty=((readpointer==7'b1111111)?1:0);
endmodule