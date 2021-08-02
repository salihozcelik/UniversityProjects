`timescale 1 ns/1 ns

module comp(xe,cur,next,ye,clk,rst);		

	input wire xe;
  input wire clk,rst;
  output reg [1:0] cur;
  output reg [1:0] next;
  output reg [1:0] ye;
	
  always @(cur,xe) begin	
		case (cur)     
			2'b00:
			begin
        if ( xe == 0)begin
           ye <= 2'b10;
           next <= 2'b10;
         end             
         else if ( xe == 1 )begin
           ye <= 2'b11;
           next <= 2'b00;
         end              
			end
      2'b01:
      begin
        if ( xe == 0)begin
           ye <= 2'b10;
           next <= 2'b10;
         end             
         else if ( xe == 1 )begin
           ye <= 2'b11;
           next <= 2'b00;
         end              
      end
      2'b10:
      begin
        if ( xe == 0)begin
           ye <= 2'b10;
           next <= 2'b10;
         end             
         else if ( xe == 1 )begin
           ye <= 2'b10;
           next <= 2'b11;
         end              
      end
      2'b11:
      begin
        if ( xe == 0)begin
           ye <= 2'b11;
           next <= 2'b10;
         end             
         else if ( xe == 1 )begin
           ye <= 2'b01;
           next <= 2'b11;
         end              
      end
		endcase
	end
	
always @(posedge clk) begin
  if (rst)begin
    cur <= 4'b0000;
    next<= 4'b0000;
  end
  else
    cur <= next;
end 

endmodule

