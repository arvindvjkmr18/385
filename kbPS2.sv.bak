module kbPS2(

	input logic				CLOCK_50,
	input logic				PS2_CLK,
	input logic				PS2_DAT,
	input logic				RESET_H,
	
	output logic [7:0]   KEYCODE,
	output logic [6:0]	HEX0, HEX1

);

	logic [7:0] kc, kbout1, kbout2;
	//logic reset_h;
	
	//assign reset_h = ~RESET;
	assign KEYCODE = kc;

	keyboard kb_device(

			.Clk(CLOCK_50),
			.psClk(PS2_CLK),
			.psData(PS2_DAT),
			.reset(RESET_H),
			.keyCode(kc),
			.press(),
			.kbBYTE1(kbout1),
			.kbBYTE2(kbout2)
	);
	
	HexDriver hex_inst_0( kc[3:0], HEX0 );
	HexDriver hex_inst_1( kc[7:4], HEX1 );

endmodule