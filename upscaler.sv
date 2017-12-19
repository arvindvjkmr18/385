// *** Operation verified 11/20/17 2:43 pm ***
module upscaler(

	// Input Coordinates (640 x 480 space)
	input logic [9:0] X_IN,
	input logic [9:0] Y_IN,
	
	// Output Coordinates (320 x 240 space)
	output logic [8:0] X_OUT,
	output logic [8:0] Y_OUT
	
);

	// Internal wires:
	logic [9:0] x_input, y_input, x_output, y_output;
	
	assign x_input = X_IN;
	assign y_input = Y_IN;
	
	// Upscale by factor of 2:
	always_comb
	begin
	
		x_output = x_input / 2;
		y_output = y_input / 2;
	
	end
	
	// Truncate top bit (2^9 spans 320 x 240 pixel coords)
	assign X_OUT = x_output[8:0];
	assign Y_OUT = y_output[8:0];

endmodule