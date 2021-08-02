`timescale 1 ns/1 ns

module comp(xe,se,ne,ye,clk,rst);		

	input wire xe;
  input wire clk,rst;
  output reg [3:0] se;
  output reg [3:0] ne;
  output reg [2:0] ye;
	
  always @(se,xe) begin	
		case (se)     
			4'b0000:
			begin
              ye <= 3'b000;
              if ( xe == 0)
                ne <= 4'b0000;
              
              else if ( xe == 1 )
                
                ne <= 4'b0001;
              
			end
          
         	4'b0001:
			begin
			ye <= 3'b000;
              if ( xe == 0)
                ne <= 4'b0010;
              else if(xe == 1)
                ne <= 4'b0001;
			end
          	4'b0010:
			begin
              ye <= 3'b000;
              if ( xe == 0)
                ne <= 4'b0100;
              else if(xe == 1)
                ne <= 4'b0011;				
			end          
         	4'b0011:
			begin
              ye <= 3'b001;
              if ( xe == 0)
                ne <= 4'b0000;
              else if(xe == 1)
                ne <= 4'b0001;
				
			end
			4'b0100:
			begin
              ye <= 3'b000;
              if ( xe == 0)
                ne <= 4'b0110;
              else if(xe == 1)
                ne <= 4'b0101;
				
			end
          
        	4'b0101:
			begin
              ye <= 3'b010;
              if ( xe == 0)
                ne <= 4'b0000;
              else if(xe == 1)
                ne <= 4'b0001;				
			end
          4'b0110:
			begin
              ye <= 3'b000;
              if ( xe == 0)
                ne <= 4'b1000;
              else if(xe == 1)
                ne <= 4'b0111;
				
			end
          
         4'b0111:
			begin
              ye = 3'b011;
              if ( xe == 0)
                ne = 4'b0000;
              else if(xe == 1)
                ne = 4'b0001;
				
			end
          4'b1000:
			begin
              ye <= 3'b000;
              if ( xe == 0)
                ne <= 4'b1000;
              else if(xe == 1)
                ne <= 4'b1001;
				
			end
          
         4'b1001:
			begin
              ye <= 3'b111;
              if ( xe == 0)
                ne <= 4'b0000;
              else if(xe == 1)
                ne <= 4'b0001;
				
			end
                              
          
		endcase


	end
	
 always @(posedge clk) begin
   if (rst)begin
 se <= 4'b0000;
 ne<= 4'b0000;
   end
 else
 se <= ne;
end 

endmodule

