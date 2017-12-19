module testbench();

timeunit 10ns;

timeprecision 1ns;

// Signals:

	
	// Input timing signals
	logic				CLOCK_50;		// 50 MHz Master (Data) Clock	
	
	logic				PS2_CLK;
	logic				PS2_DAT;
	
	// Input control signals
	logic				RESET;			// System reset
	
	// Output (to DAC via Pin-Planner)
	logic				VGA_CLK;			// 25 MHz VGA (Video) Clock
	logic				VGA_SYNC_N;
	logic				VGA_BLANK_N;
	logic 			VGA_HS;
	logic				VGA_VS;
	logic [7:0]		VGA_R;
	logic [7:0]		VGA_G;
	logic [7:0]		VGA_B;
	logic [6:0]		HEX0;
	logic [6:0]		HEX1;
	logic 			LEDR0;
	logic				LEDR1;
	
always begin : CLOCK_GEN
#1 CLOCK_50 = ~CLOCK_50;
end

initial begin: INITIALIZATION

	CLOCK_50 = 1'b0;
	RESET = 1'b1;
	
end

system_toplevel dut(.*);

	logic [2:0] State, eng_sel;
	logic run_game_over, g_o_done;
	logic g_o_we;
	
	assign State = dut.FSM.State;
	assign run_game_over = dut.run_game_over;
	assign g_o_done = dut.g_o_done;
	assign eng_sel = dut.eng_sel;
	assign g_o_we = dut.g_o_we;
	
initial begin

	force dut.pos_sub_sys.player.keycode = 8'h23;
	
	#20000 release dut.pos_sub_sys.player.keycode;

end


initial begin : TEST_VECTORS
	
	#1 RESET = 1'b0;

	#1 RESET = 1'b1;
	
end

endmodule
