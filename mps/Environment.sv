
class Environment;
	string name;
	event done;
	virtual dut_io.TB dut_io;
	int run_packets=1;
	int den;
	int readbmp=0;

  Driver     drvr;	// driver objects
  Receiver   rcvr;	// receiver objects
  Generator  gen;		// generator object
  Scoreboard sb;		// scoreboard object

  extern function new(string name = "Env", virtual dut_io.TB dut_io);
  extern virtual task run();
  extern virtual function void configure();
  extern virtual function void build();
  extern virtual task start();
  extern virtual task wait_for_end();
  extern virtual task reset();

endclass: Environment

function Environment::new(string name = "Env", virtual dut_io.TB dut_io);
  this.name = name;
  this.dut_io = dut_io;
endfunction: new

task Environment::run();

		  this.build();
		  this.reset();
		  this.start();
		 
		->done;
endtask: run

function void Environment::configure();
	int fp;
	int p;
	fp=$fopen("envconfig.txt","rb");
	$fseek(fp,8,0);
	readbmp=$fgetc(fp)-8'b00110000;
	$fseek(fp,20,0);
	run_packets=($fgetc(fp)-8'b00110000)*10+($fgetc(fp)-8'b00110000);
	$fseek(fp,29,0);
	den=($fgetc(fp)-8'b00110000)*100+($fgetc(fp)-8'b00110000)*10+($fgetc(fp)-8'b00110000);
	$display("%d",den);
	$fclose(fp);
endfunction: configure
	
function void Environment::build();
	$display("env build");
    this.gen = new(,readbmp,run_packets,den);
	this.sb = new( , , ,run_packets);
    this.drvr = new(, this.gen.out_box, this.sb.driver_mbox, this.dut_io,run_packets);
    this.rcvr = new(, this.sb.receiver_mbox, this.dut_io,run_packets);
	
	$display("build env successful");
endfunction: build

task Environment::reset();
	this.dut_io.sys_reset<=1'b1;
	@this.dut_io.cb_cmd  this.dut_io.sys_reset<=1'b0;
	$display("topsys reset successful");
endtask: reset

task Environment::start();
$display("env start");
    this.gen.start();
    fork
		this.drvr.start();
		this.rcvr.start();
	join
	this.sb.start();
endtask: start

task Environment::wait_for_end();
   wait(this.done.triggered);
endtask: wait_for_end
