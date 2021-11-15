`ifndef INC_DRIVER_SV
`define INC_DRIVER_SV
class Driver;
	virtual dut_io.TB dut_io;	// interface signal
	string    name;		// unique identifier
	int packets_num;
	int i;
	Packet    pkt2send;		// stimulus Packet object
	pkt_mbox in_box;	// Generator mailbox
	pkt_mbox out_box;	// Scoreboard mailbox

	extern virtual task send_img();
	extern virtual task send_cmd();
	extern virtual task send_sysreset();
	extern virtual task send_sysstart();
  extern function new(string name = "Driver", pkt_mbox in_box, out_box, virtual dut_io.TB dut_io,int packets_num_n);
  extern virtual task start();
endclass

task Driver::send_img(); 
	this.dut_io.SS<=1'b1;
	foreach(pkt2send.image_h.img[i,j])
			dut_io.hit[i*64+j]=pkt2send.image_h.img[i][j];
	repeat(100) @this.dut_io.cb_cmd ;
	dut_io.hit<=4096'b0;
	$display("image to interface successful");
endtask

task Driver::send_cmd(); 
	this.dut_io.SS<=1'b1;
	@this.dut_io.cb_cmd 	dut_io.cb_cmd.MOSI<=8'b00000000;
	@this.dut_io.cb_cmd 	dut_io.cb_cmd.MOSI<=pkt2send.cmd;
	$display("random cmd to interface successful");
endtask

task Driver::send_sysreset(); 
	@this.dut_io.cb_cmd 	dut_io.cb_cmd.MOSI<=8'b00000000;
	@this.dut_io.cb_cmd 	dut_io.cb_cmd.MOSI<=8'b10000000;
	$display("reset cmd to interface successful");
endtask

task Driver::send_sysstart(); 
	@this.dut_io.cb_cmd 	dut_io.cb_cmd.MOSI<=8'b00000000;
	@this.dut_io.cb_cmd 	dut_io.cb_cmd.MOSI<=8'b11000000;
	$display("start cmd to interface successful");
endtask


function Driver::new(string name = "Driver", pkt_mbox in_box, out_box, virtual dut_io.TB dut_io,int packets_num_n);
  this.name   = name;
  this.packets_num=packets_num_n;
  this.dut_io = dut_io;
  this.in_box = in_box;
  this.out_box = out_box;
  $display("build driver successful:%s",this.name);
endfunction

task Driver::start();
	fork
		begin
			for(i=0;i<packets_num;i=i+1)
			begin
				this.in_box.get(pkt2send);
				$display("driver get packet successful");
				this.out_box.put(pkt2send);
				$display("driver send packet successful");
				send_img();
				repeat(900) @dut_io.cb1;
			end
		end
		begin
			send_sysstart();
			@this.dut_io.cb_cmd ;
			@this.dut_io.cb_cmd ;
			send_sysreset();
		end
	join
	//send_cmd();
endtask
`endif


