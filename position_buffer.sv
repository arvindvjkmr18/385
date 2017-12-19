module position_buffer(

	input logic				CLOCK_50,
	
	input logic				BUFFER_LOAD,
	
	input logic [1:0]		ADDR_IN,
	input logic [1:0]		ID_CODE_IN,
	input logic [8:0]		X_IN,
	input logic	[8:0]		Y_IN,
	
	output logic [1:0]	ADDR_OUT,
	output logic [1:0]	ID_CODE_OUT,
	output logic [8:0]	X_OUT,
	output logic [8:0]	Y_OUT

);

	logic [1:0] addr, new_addr, id_code, new_id_code;
	logic [8:0] x, y, new_x, new_y;

	assign ADDR_OUT = addr;
	assign ID_CODE_OUT = id_code;
	assign X_OUT = x;
	assign Y_OUT = y;
	
	always_ff @ (posedge CLOCK_50)
	begin
	
		addr <= new_addr;
		id_code <= new_id_code;
		x <= new_x;
		y <= new_y;
	
	end
	
	always_comb
	begin
	
		new_addr = addr;
		new_id_code = id_code;
		new_x = x;
		new_y = y;
		
		if(BUFFER_LOAD)
		begin
		
			new_addr = ADDR_IN;
			new_id_code = ID_CODE_IN;
			new_x = X_IN;
			new_y = Y_IN;
		
		end
	
	end


endmodule