module addr_MUX(

	// Control signals:
	input logic [1:0]	SEL,
	
	// Input data:
	input logic	[1:0]	ADDR_A,
	input logic	[1:0]	ADDR_B,
	input logic [1:0] ADDR_C,
	
	// Output data:
	output logic [1:0] ADDR_OUT

);

	always_comb
	begin

		if(SEL == 2'b01)
			ADDR_OUT = ADDR_B;
		else if (SEL == 2'b10)
			ADDR_OUT = ADDR_C;
		else
		   ADDR_OUT = ADDR_A;
	end

endmodule