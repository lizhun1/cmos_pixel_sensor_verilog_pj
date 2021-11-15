`ifndef INC_SCOREBOARD_SV
`define INC_SCOREBOARD_SV
class Scoreboard;
	string   name;		// unique identifier
	// flag to indicate goal reached
	int packets_num;
	Packet   pkt2send[];		// Packet object from Drivers
	Packet   pkt2cmp[];		// Packet object from Receivers
	pkt_mbox  driver_mbox;		// mailbox for Packet objects from Drivers
	pkt_mbox  receiver_mbox;	// mailbox for Packet objects from Receivers
	covport 	cov;//覆盖率
  extern function new(string name = "Scoreboard", pkt_mbox driver_mbox = null, receiver_mbox = null,int packets_num_n);
  extern virtual task start();
  extern virtual task check();
endclass: Scoreboard

function Scoreboard::new(string name= "Scoreboard", pkt_mbox driver_mbox= null, receiver_mbox= null,int packets_num_n);
  this.name = name;
  this.packets_num=packets_num_n;
  pkt2cmp=new[packets_num];
  pkt2send=new[packets_num];
  if (driver_mbox == null) driver_mbox = new();
  this.driver_mbox = driver_mbox;
  if (receiver_mbox == null) receiver_mbox = new();
  this.receiver_mbox = receiver_mbox;
  $display("build scoreboard successful:%s",this.name);
endfunction: new

task Scoreboard::start();
	int i;
	for(i=0;i<packets_num;i=i+1)
	begin
			fork
			this.driver_mbox.get(this.pkt2send[i]);
			this.receiver_mbox.get(this.pkt2cmp[i]);	
			join	
			$display("scoreboard packet get successful");
			this.pkt2send[i].compare(this.pkt2cmp[i]);
	end
endtask: start

task Scoreboard::check();
	//this.pkt2send.compare(this.pkt2cmp);
endtask: check
`endif
