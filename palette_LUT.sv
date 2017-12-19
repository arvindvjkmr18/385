// *** Operation verified 11/20/17 12:55 pm ***
module palette_LUT(

	// Input signals
	input logic [7:0]		PIXEL_IN,
	
	// Output signals
	output logic [7:0]	VGA_R,
	output logic [7:0]	VGA_G,
	output logic [7:0]	VGA_B
	
);

	// Internal wires:
	logic [2:0] RED, GREEN;
	logic [1:0] BLUE;
	
	// Parse out embedded colors from 8' PIXEL_IN (RRRGGGBB encoding)
	assign RED = PIXEL_IN[7:5];
	assign GREEN = PIXEL_IN[4:2];
	assign BLUE = PIXEL_IN[1:0];
	
	// Red Channel LUT:
	// (2^3 -> 2^8 color space requires quantization interval of 32)
	always_comb
	begin
	
		case(RED)
		
			3'b000:	VGA_R = 8'h10;	// R Ch = 16;
			3'b001:	VGA_R = 8'h20;	// R Ch = 48;
			3'b010:	VGA_R = 8'h50; // R Ch = 80;
			3'b011:	VGA_R = 8'h70;	// R Ch = 112;
			3'b100:	VGA_R = 8'h90;	// R Ch = 144;
			3'b101:	VGA_R = 8'hB0;	//	R Ch = 176;
			3'b110:	VGA_R = 8'hD0; // R Ch = 208;
			3'b111:	VGA_R = 8'hF0;	// R Ch = 240;
			
			default VGA_R = 8'hFF;
		
		endcase
	
	end
	
	// Green Channel LUT:
	// (2^3 -> 2^8 color space requires quantization interval of 32)
	always_comb
	begin
	
		case(GREEN)
		
			3'b000:	VGA_G = 8'h10;	// G Ch = 16;
			3'b001:	VGA_G = 8'h20;	// G Ch = 48;
			3'b010:	VGA_G = 8'h50; // G Ch = 80;
			3'b011:	VGA_G = 8'h70;	// G Ch = 112;
			3'b100:	VGA_G = 8'h90;	// G Ch = 144;
			3'b101:	VGA_G = 8'hB0;	//	G Ch = 176;
			3'b110:	VGA_G = 8'hD0; // G Ch = 208;
			3'b111:	VGA_G = 8'hF0;	// G Ch = 240;
			
			default VGA_G = 8'hFF;
		
		endcase
	
	end
	
	// Blue Channel LUT:
	// (2^2 -> 2^8 color space requires quantization interval of 64)
	always_comb
	begin
	
		case(BLUE)
		
			2'b00:	VGA_B = 8'h20;	// G Ch = 32;
			2'b01:	VGA_B = 8'h60;	// G Ch = 96;
			2'b10:	VGA_B = 8'hA0; // G Ch = 160;
			2'b11:	VGA_B = 8'hE0;	// G Ch = 224;
			
			
			default VGA_B = 8'hFF;
		
		endcase
	
	end
	
	
endmodule