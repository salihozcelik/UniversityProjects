`timescale 1 ns/1 ns

module Testbench();

wire [3:0]s;
wire [3:0]n;
wire [2:0]y;
reg x;

integer i;

reg [31:0]number;

reg Clk_s;
initial Clk_s = 1;
always #10 Clk_s = ~Clk_s ;

reg Rst_s;
initial Rst_s = 1 ;

  comp ctt(x,s,n,y,Clk_s, Rst_s);

initial begin
    $dumpfile("test.vcd");
	$dumpvars(0, Clk_s, Rst_s, s, n, y, x);
	
  	
	#20;
	number = 32'b00001011001011111000010001010101 ;
	for(i = 31; i >= 0 ; i = i-1)begin
	Rst_s = 0;
	x = number[i];	
	#20;
	end
	#20;

	number = 32'b00001011001011111000010001010101 ;
	Rst_s <= 1;
  
	for(i = 31; i >= 0 ; i = i-1)begin
	Rst_s = 0;
	x = number[i];	
	#20;
	end	
	#20;

	number = 32'b00001011001011111000010001010101 ;
	Rst_s <= 1;
	for(i = 31; i >= 0 ; i = i-1)begin
	Rst_s = 0;
	x = number[i];	
	#20;
	end	
	#20;

	number = 32'b00001011001011111000010001010101 ;
	Rst_s <= 1;
	for(i = 31; i >= 0 ; i = i-1)begin
	Rst_s = 0;
	x = number[i];	
	#20;
	end	
	#20;

	number = 32'b00001011001011111000010001010101 ;
	Rst_s <= 1;
	for(i = 31; i >= 0 ; i = i-1)begin
	Rst_s = 0;
	x = number[i];	
	#20;
	end	
	#20;

    $finish;
end

endmodule
