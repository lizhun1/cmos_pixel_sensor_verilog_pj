`ifndef INC_GENERATOR_SV
`define INC_GENERATOR_SV
class Generator;
  string  name;		// unique identifier
  int i;
  int den;
  int packets;
  string str;
  Packet  pkt2send[];	// stimulus Packet object
  pkt_mbox out_box;	// mailbox to Drivers
  
  extern function new(string name = "Generator",int readbmp,int packets_n,int den_n);
  extern virtual task gen();
  extern virtual task start();
endclass

function Generator::new(string name = "Generator",int readbmp,int packets_n,int den_n);
	int fp;
	int p;
	int seed;
	$system("del seed.txt");
	$system("echo %time% >>seed.txt");
	fp=$fopen("seed.txt","rb");
	seed=($fgetc(fp)-8'b00110000)*10000000+($fgetc(fp)-8'b00110000)*1000000;
	$fgetc(fp);
	seed=seed+($fgetc(fp)-8'b00110000)*100000+($fgetc(fp)-8'b00110000)*10000;
	$fgetc(fp);
	seed=seed+($fgetc(fp)-8'b00110000)*1000+($fgetc(fp)-8'b00110000)*100;
	$fgetc(fp);
	seed=seed+($fgetc(fp)-8'b00110000)*10+($fgetc(fp)-8'b00110000)*1;
	$fclose(fp);
	$display("seed is %d",seed);
  this.packets=packets_n;
  this.name = name;
  this.den=den_n;
  $display("build generator successful:%s",this.name);
  this.pkt2send=new[this.packets];
  for(i=0;i<this.packets;i=i+1)
	begin
		str.itoa(i);
		this.pkt2send[i] = new({"pkt",this.str},seed-i,this.den);
		
	end
	
  if(readbmp==1&&this.packets==1) 
	begin
		this.pkt2send[0].readbmp();
		$display("build bmp image successful,image is:");
	end
  else 
	begin
		$display("build random images successful,images are:");
	end
	
for(i=0;i<this.packets;i=i+1)
	begin
		$display("random images %s:",this.pkt2send[i].name);
		this.pkt2send[i].display();
		if(this.pkt2send[i].randomize());
		$display("build random cmd successful:%b",this.pkt2send[i].cmd);
	end
  this.out_box=new();
  $display("build mailbox successful");
endfunction

task Generator::gen();
endtask

task Generator::start();
for(i=0;i<packets;i=i+1)
	begin
		Packet pkt=new pkt2send[i];
		this.out_box.put(pkt);
	end
	$display("generator packets send successful");	
endtask
`endif
