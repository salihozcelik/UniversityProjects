`timescale 1 ns/1 ns

module testbench();		
  wire alarm;
  reg [4:0]in;
  my_comp comptotest(alarm,in);

  initial begin
	
    $dumpfile("test.vcd");
    $dumpvars(0,in,alarm);
			
	in = 0;
	# 10;
    repeat(31) begin
		in = in + 1 ;
		#10;
	end
	
  end
	
endmodule