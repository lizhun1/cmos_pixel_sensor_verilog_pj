`include "Packet.sv"


program automatic debug();
initial
	begin
		Packet p_h;
		p_h=new(,2,10);
		p_h.display();
		p_h.makebmp();
		$display("%d",$time);
	end
endprogram
