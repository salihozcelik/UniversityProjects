`timescale 1 ns/1 ns

module my_comp(F,inputs);		
  input [4:0]inputs;
  output wire F;
  wire nd,not_nde,not_de;
  wire [1:0]decoder_in;
  wire [3:0]decoder_out;
  wire [7:0]mux_inputs;
  wire [2:0]mux_selects;
  
  assign decoder_in[1] = inputs[1];
  assign decoder_in[0] = inputs[0];

  not n1(nd,inputs[1]);
  not n2(not_nde,decoder_out[1]);
  not n3(not_dne,decoder_out[2]);
  
  deco decoder(decoder_out[3:0],decoder_in[1:0]);
  
  assign mux_inputs[0] = inputs[1];
  assign mux_inputs[1] = decoder_out[2];
  assign mux_inputs[2] = decoder_out[1];
  assign mux_inputs[3] = decoder_out[1];
  assign mux_inputs[4] = not_nde;
  assign mux_inputs[5] = decoder_out[1];
  assign mux_inputs[6] = nd;
  assign mux_inputs[7] = not_dne;
  
  
  assign mux_selects[2] = inputs[4];
  assign mux_selects[1] = inputs[3];
  assign mux_selects[0] = inputs[2];
  
  
  mux multiplexer(F,mux_inputs[7:0],mux_selects[2:0]);
	
endmodule

`timescale 1 ns/1 ns

module deco(
	output reg [3:0] Y,
	input [1:0] X
);

  always @(*) begin
		case(X)
			2'b00: Y <= 4'b0001;
			2'b01: Y <= 4'b0010;
			2'b10: Y <= 4'b0100;
			default: Y <= 4'b1000;
		endcase
	end

endmodule

`timescale 1ns / 1ns

module mux(
	output reg Y,
	input [7:0] X,
	input [2:0] S
);

	always @(*) begin
		case(S)
			3'b000: Y <= X[0];
			3'b001: Y <= X[1];
			3'b010: Y <= X[2];
			3'b011: Y <= X[3];
			3'b100: Y <= X[4];
			3'b101: Y <= X[5];
			3'b110: Y <= X[6];
			default: Y <= X[7];
		endcase
	end

endmodule
