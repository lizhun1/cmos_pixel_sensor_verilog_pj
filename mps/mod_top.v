module mod_top(	hit,
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
input 	[64*64-1:0] 	hit;
input             		clk1;
input             		clk2;
input             		clk3;
input 					sys_reset;
output	 				mem_full;
output 					mem_empty;
//spi
input 					SS;
input 					SCLK;
output	[7:0]          	MISO;
input 	[7:0]  			MOSI;
//
output [23:0] 			LVDS;

//顶层信号
wire 	[4095:0] 		hit;
wire 					clk1;
wire 					clk2;
wire 					clk3;
wire 					sys_reset;
wire					SS;
wire					SCLK;
wire					mem_full;
wire					mem_empty;
reg		[7:0]			MISO;
wire	[7:0]			MOSI;
wire 	[23:0] 			LVDS;
//内部寄存器
reg 	[3:0]			sys_state;
reg  	[7:0] 			cmd_reg;
reg		[3:0]			ram 		[3:0];


//像素信号  
wire [4095:0] pix_reset ;
wire [4095:0] pix_state ;

//编码器信号
wire [127:0] pro_state [31:0];
reg  [31:0]  pro_read;
wire [7:0]   pro_addr  [31:0];
wire [127:0] pro_reset [31:0];
wire [31:0]  pro_reset_pe;
reg  [31:0]  pro_en;
wire [31:0]  pro_clk;
wire [31:0]  pro_readout;
wire [31:0]  pro_clkout;
wire [31:0]  pro_full;
wire [31:0]  pro_empty;


//reader信号
wire [31:0] dcol_full;
wire [31:0] dcol_empty;
wire [14:0] dcol_addin   [31:0];
wire [31:0] dcol_clk;
wire [31:0] dcol_readin;
wire [18:0] dcol_addrout [31:0];
reg  [31:0] dcol_reset;
wire [31:0] dcol_resetpe;
wire [31:0] dcol_write_q;
wire [31:0] dcol_sel;

//fifo信号
wire [31:0] fifo_write_q;
reg        	fifo_read_q;
wire        fifo_clk_in;
wire        fifo_clk_out;
wor  [18:0] fifo_addr_in;
wire [23:0] fifo_addr_out;
wire        fifo_full;
wire        fifo_empty;
reg        	fifo_reset;
wire [31:0] fifo_sel;
//timemod信号
wire 		ti_full;
reg 		ti_reset;
wire [6:0]  timeout;



parameter IDLE=4'b0000;
parameter GTCD=4'b0001;
parameter DCOD=4'b0010;
parameter EXEU=4'b0011;


genvar i;
generate
	for(i=0;i<64*64;i=i+1)
		begin:shifter0
			pixelcell pixel(hit[i],
							pix_reset[i],
							pix_state[i]);
		end
endgenerate

genvar j;
generate
	for(j=0;j<32;j=j+1)
		begin:shifter1
			pixel_encoder128 pe(	pro_state[j],
									pro_read[j],
									pro_addr[j],
									pro_reset[j],
									pro_reset_pe[j],
									pro_en[j],
									pro_clk[j],
									pro_readout[j],
									pro_clkout[j],
									pro_full[j],
									pro_empty[j]);
		end
endgenerate
genvar k;
generate
	for(k=0;k<32;k=k+1)
		begin:shifter2
			dcol_reader reader(	dcol_full[k],
								dcol_empty[k],
								dcol_addin[k],
								dcol_clk[k],
								dcol_readin[k],
								dcol_addrout[k],
								dcol_reset[k],
								dcol_resetpe[k],
								dcol_write_q[k],
								dcol_sel[k]);
		end
		
endgenerate
FIFO fi(fifo_write_q,
		fifo_read_q,
		fifo_clk_in,
		fifo_clk_out,
		fifo_addr_in,
		fifo_addr_out,
		fifo_full,
		fifo_empty,
		fifo_reset,
		fifo_sel);
time_mod ti(	ti_full,
				timeout,
				ti_reset);
				
				
				
//信号连接	
assign 	LVDS=fifo_addr_out;
assign 	mem_full=fifo_full;
assign	mem_empty=fifo_empty;	
assign 	ti_full=pro_full[0];

genvar h;
generate
	for(h=0;h<32;h=h+1)
		begin: link1
			assign fifo_addr_in=dcol_addrout[h];
		end
endgenerate
assign 	fifo_clk_out=clk3;
assign 	fifo_clk_in=clk2;
assign  fifo_write_q=dcol_write_q;

assign	dcol_sel=fifo_sel;
assign 	dcol_full=pro_full;
assign 	dcol_empty=pro_empty;


genvar g;
generate
	for(g=0;g<32;g=g+1)
		begin:link2
			assign dcol_addin[g][7:0]=pro_addr[g];
			assign dcol_addin[g][14:8]=timeout;
			assign pro_reset_pe[g]=dcol_resetpe[g];
			assign dcol_clk[g]=clk2;
			assign pro_clk[g]=clk1;
			assign pro_clkout[g]=clk2;
			assign pro_readout[g]=dcol_readin[g];
		end
endgenerate

genvar p;
generate
	for(p=0;p<32;p=p+1)
		begin:link3
			assign pro_state[p]=pix_state[p*128+127:p*128];
			assign pix_reset[p*128+127:p*128]=pro_reset[p];
		end
endgenerate 





//逻辑部分
always@(*)
	begin
		fifo_read_q<=ram[0][0];
		fifo_reset<=ram[0][1];
		ti_reset<=ram[0][2];
		
		dcol_reset<={ram[1][0],ram[1][0],ram[1][0],ram[1][0],ram[1][0],ram[1][0],ram[1][0],ram[1][0],ram[1][1],ram[1][1],ram[1][1],ram[1][1],ram[1][1],ram[1][1],ram[1][1],ram[1][1],ram[1][2],ram[1][2],ram[1][2],ram[1][2],ram[1][2],ram[1][2],ram[1][2],ram[1][2],ram[1][3],ram[1][3],ram[1][3],ram[1][3],ram[1][3],ram[1][3],ram[1][3],ram[1][3]};
		pro_read<={ram[2][0],ram[2][0],ram[2][0],ram[2][0],ram[2][0],ram[2][0],ram[2][0],ram[2][0],ram[2][1],ram[2][1],ram[2][1],ram[2][1],ram[2][1],ram[2][1],ram[2][1],ram[2][1],ram[2][2],ram[2][2],ram[2][2],ram[2][2],ram[2][2],ram[2][2],ram[2][2],ram[2][2],ram[2][3],ram[2][3],ram[2][3],ram[2][3],ram[2][3],ram[2][3],ram[2][3],ram[2][3]};
		pro_en<={ram[3][0],ram[3][0],ram[3][0],ram[3][0],ram[3][0],ram[3][0],ram[3][0],ram[3][0],ram[3][1],ram[3][1],ram[3][1],ram[3][1],ram[3][1],ram[3][1],ram[3][1],ram[3][1],ram[3][2],ram[3][2],ram[3][2],ram[3][2],ram[3][2],ram[3][2],ram[3][2],ram[3][2],ram[3][3],ram[3][3],ram[3][3],ram[3][3],ram[3][3],ram[3][3],ram[3][3],ram[3][3]};
		
	end
always@(posedge SCLK or sys_reset)
	begin
		if(sys_reset) 
			begin
				sys_state<=4'b0000;
				cmd_reg<=8'b0;
				ram[0]<=4'b0000;
				ram[1]<=4'b0000;
				ram[2]<=4'b0000;
				ram[3]<=4'b0000;
				
			end
		else
			begin
			if(SS)
				begin
					case(sys_state)
						IDLE: 	begin
									if(MOSI==8'b0)  sys_state<=GTCD;
								end
						GTCD:  	begin
									cmd_reg<=MOSI;
									sys_state<=DCOD;
								end
						DCOD:  	begin
									case(cmd_reg[7:6])
										2'b00:	ram[cmd_reg[5:4]]<=cmd_reg[3:0];
										2'b01:	begin
													MISO[3:0]<=ram[cmd_reg[5:4]];
													MISO[7:4]<=4'b0000;	
												end
										2'b10:	begin
													ram[0][2:1]<=2'b11;
													ram[1]<=4'b1111;
													ram[0][3]<=1'b1;
												end
										
										2'b11:	begin
													ram[0][0]<=1'b1;
													ram[2]<=4'b1111;
													ram[3]<=4'b1111;
												end
									endcase
									sys_state<=EXEU;
								end
						EXEU:	begin
									sys_state<=IDLE;
									if(ram[0][3]==1'b1) 
										begin
											ram[0][2:1]<=2'b00;
											ram[1]<=4'b0000;
											ram[0][3]<=1'b0;
										end
								end
					endcase
				end
			end
	end

endmodule
