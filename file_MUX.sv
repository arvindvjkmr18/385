// Control access to entity file's addressing and write-enable ports,
// to coordinate between sprite and position subsystems
module file_MUX(

	// Input control
	input logic INPUT_SEL,				// Control signal from system FSM
	
	// Input data
	input logic [1:0] SPR_ADDR,		// Address input from sprite subsystem
	
	input logic [1:0] POS_ADDR,		// Address input from position subsystem
	input logic POS_WE,					// Write enable input from position subsystem

	// Output data
	output logic [1:0] MUX_ADDR,		// Mux output to entity file
	output logic MUX_WE
	
);

	// Other assignments:
	
	
	// Route access to entity file:
	always_comb
	begin
	
		// INPUT_SEL:
		//	0: Sprite Subsystem
		// 1: Position Subsystem
		if(INPUT_SEL)
		begin
		
			MUX_ADDR = POS_ADDR;
			MUX_WE = POS_WE;
		
		end
		else
		begin
		
			MUX_ADDR = SPR_ADDR;
			MUX_WE = 1'b0;
		
		end
	
	end
	
endmodule