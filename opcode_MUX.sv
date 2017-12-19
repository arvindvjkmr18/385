module opcode_MUX(

	// Control Signals:
	input logic	SEL,				// Input select
	
	// Input data:
	input logic [1:0]		ADDR_A,
	input logic [1:0] 	ID_CODE_A,
	input logic [8:0] 	X_A,
	input logic [8:0] 	Y_A,
	
	input logic [1:0]		ADDR_B,
	input logic [1:0] 	ID_CODE_B,
	input logic [8:0]		X_B,
	input logic [8:0]		Y_B,
	
	// Output data:
	output logic [1:0]	ADDR_OUT,
	output logic [1:0]	ID_CODE_OUT,
	output logic [8:0]	X_OUT,
	output logic [8:0]	Y_OUT

);

	always_comb
	begin
	
		if(SEL)
		begin
			ADDR_OUT = ADDR_B;
			ID_CODE_OUT = ID_CODE_B;
			X_OUT = X_B;
			Y_OUT = Y_B;
		end
		else
		begin
			ADDR_OUT = ADDR_A;
			ID_CODE_OUT = ID_CODE_A;
			X_OUT = X_A;
			Y_OUT = Y_A;
		end
	
	end

endmodule