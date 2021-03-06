module gameoverROM(

	// Timing signals:
	input logic CLOCK_50,
	
	// Input control signals:
	input logic RESET,
	input logic R_G_O,	//read enable signal
	
	// Input data signals:
	input logic	[2:0]  SPRITE_ID,
	input logic [4:0] SPRITE_X,
	input logic [4:0] SPRITE_Y,
	
	// Output data signals:
	output logic [7:0] SPRITE_PIXEL

);

	// SPRITE ROM:
	// 32 bytes (pixels) in 512 entries
	// (32 horizontal pixel by 32 rows, 16 sprites)
	//bit [31:0][7:0]mem[32]; // one sprite test only (512 for 16 sprites)
	logic [255:0]mem[256];
	
	// Internal wires & registers
	int x, y, x_update, y_update, x_offset, y_offset;	// counters

	logic [7:0] pout;	// Output pixel data
	
	// Load sprite data to memory
	initial
	begin
	
		$readmemh("C:/Users/arvin/Documents/ECE385/Final Project/final_proj_v3/gameover.txt", mem);
	
	end

	always_ff @ (posedge CLOCK_50)
	begin
			
		// Output pixel data from memory:
		if(R_G_O)
		begin
		
			pout[0] <= mem[y_offset][x_offset];
			pout[1] <= mem[y_offset][x_offset + 1];
			pout[2] <= mem[y_offset][x_offset + 2];
			pout[3] <= mem[y_offset][x_offset + 3];
			pout[4] <= mem[y_offset][x_offset + 4];
			pout[5] <= mem[y_offset][x_offset + 5];
			pout[6] <= mem[y_offset][x_offset + 6];
			pout[7] <= mem[y_offset][x_offset + 7];
	
		end
		
		else
		begin
			pout <= 8'b00000000;
		end
	
	end
	
	// Calculation of the next x and y value:
	always_comb
	begin
	

		y_offset = y + SPRITE_ID * 32;
		x_offset = 8 * x;
	
	end

	assign SPRITE_PIXEL = pout;
		
	assign x = SPRITE_X;
	assign y = SPRITE_Y;

endmodule