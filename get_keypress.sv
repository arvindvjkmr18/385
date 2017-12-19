module get_keypress(

		input logic	CLOCK_50,
		input logic [7:0] KEYCODE,
		input logic GET_INPUT,

		output logic [2:0] USER_INPUT,
		//for debug:
		output logic [6:0]	HEX0, HEX1
);

	logic[7:0] keycode, keycode_capture;
	
	always_ff @ (posedge CLOCK_50)
	begin
	
		keycode <= keycode_capture;
	
	end
	
	always_comb
	begin
	
		keycode_capture = keycode;		// hold last keycode
	
		if(~GET_INPUT)
		begin
			
			keycode_capture = KEYCODE;	// from PS2
			
		end
	
	end

	always_comb
	begin
			USER_INPUT = 3'b000;
			
			//up
			if(keycode == 8'h1D)
			begin
				USER_INPUT = 3'b001;
			end
			
			//left
			else if(keycode == 8'h1C)
			begin
				USER_INPUT = 3'b010;
			end
			
			//down
			else if(keycode == 8'h1B)
			begin
				USER_INPUT = 3'b100;
			end
			
			//right
			else if(keycode == 8'h23)
			begin
				USER_INPUT = 3'b101;
			end
			
			//default
			else
			begin
				USER_INPUT = 3'b000;
			end
				
	end
	
	HexDriver hex_inst_0( USER_INPUT, HEX0 );
	
endmodule