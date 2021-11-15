program automatic sam();


event e1,e2;
initial begin
    $display("@%0d:1:before trigger",$time);
    -> e1;
    @e2;
    $display("@%0d:1:after trigger",$time);
end

initial begin
    $display("@%0d:2:before trigger",$time);
    -> e2;
    @e1;
    $display("@%0d:2:after trigger",$time);
end


endprogram
