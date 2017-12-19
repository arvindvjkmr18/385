module detectPageFlip(
	
	input logic CLOCK_50,
	input logic PAGE_SEL,
	output logic PAGE_FLIP
);

	logic flip_edge;
	
	always_ff @ (posedge CLOCK_50)
	begin
	
		flip_edge <= PAGE_SEL;
		
	end
	
	assign PAGE_FLIP = PAGE_SEL ^ flip_edge;
	
endmodule
