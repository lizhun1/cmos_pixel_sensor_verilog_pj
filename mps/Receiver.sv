`ifndef INC_RECEIVER_SV
`define INC_RECEIVER_SV
`define zipbit 8
class Receiver;
	virtual dut_io.TB dut_io;	// interface signals
	pkt_mbox out_box;	// Scoreboard mailbox
	string   name;		// unique identifier
	Packet   pkt2cmp[];		// actual Packet object
	int packets_num;
	extern function new(string name = "Receiver", pkt_mbox out_box, virtual dut_io.TB dut_io,int packets_num_n);
	extern virtual task start();
	extern virtual task recv(int j);
	extern virtual task decode(int cou);
endclass

task Receiver::recv(int j);
	int count=0;
	pkt2cmp[j].image_h.clear();
	pkt2cmp[j].image_h.frame=this.dut_io.cb1.LVDS[23:17];
	while(1)
		begin
			@(dut_io.cb1) 
			begin
				decode(j);
				count=count+1;
			end
			if(count==1000) break;	
		end
	$display("Receiver decode successful");
	$display("received image is:");
	pkt2cmp[j].display();
		
endtask

task Receiver::decode(int cou);//对输出地址进行解码
	int x=0;
	int y=0;
	int i;
	x=2*(this.dut_io.cb1.LVDS[16:12])+(this.dut_io.cb1.LVDS[11]?1:0);
	y=8*this.dut_io.cb1.LVDS[10:8];
	for(i=0;i<`zipbit;i=i+1)
		begin
		pkt2cmp[cou].image_h.img[x][y+i]=this.dut_io.cb1.LVDS[i];
		end
	//$display("codeis%b",this.dut_io.cb1.LVDS);
endtask

function Receiver::new(string name="Receiver", pkt_mbox out_box, virtual dut_io.TB dut_io,int packets_num_n);
	int j;
  this.name = name;
  this.packets_num=packets_num_n;
  pkt2cmp=new[packets_num];
  for(j=0;j<packets_num;j=j+1)  
  begin
  pkt2cmp[j] = new(,1,1);
  pkt2cmp[j].image_h.clear();
  end
  this.dut_io = dut_io;
  this.out_box = out_box;
  $display("build Receiver successful:%s",this.name);
endfunction

task Receiver::start();
	int j;
	for(j=0;j<packets_num;j=j+1)
	begin
		recv(j);
		this.pkt2cmp[j].makebmp();
		$display(" Receiver img2bmp successful");
		out_box.put(this.pkt2cmp[j]);
		$display("Receiver packet send successful");
	end
endtask
`endif
