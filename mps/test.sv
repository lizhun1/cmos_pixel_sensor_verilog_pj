program automatic test(dut_io.TB dut_io);
import dut_test_pkg::*;
  Environment env;
  initial begin
	env = new("env",dut_io);
	env.configure();
	env.run();	
  end
endprogram: test

