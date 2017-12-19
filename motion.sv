module motion(
	
	 input logic [2:0] USER_INPUT,
	 input logic [8:0] current_pos_x,
	 input logic [8:0] current_pos_y,
	 
	 output logic [8:0] next_pos_x,
	 output logic [8:0] next_pos_y

);

	always_comb
	begin
		
		case(USER_INPUT)
			
			 //up
			 3'b001:
			 begin
				next_pos_x = current_pos_x;
				next_pos_y = current_pos_y - 2;
			 end
			
			//left
			 3'b010:
			 begin
				next_pos_x = current_pos_x - 2;
				next_pos_y = current_pos_y;
			 end
			 
			 //down
			 3'b100:
			 begin
				next_pos_x = current_pos_x;
				next_pos_y = current_pos_y + 2;
			 end
			 
			 //right
			 3'b101:
			 begin
				next_pos_x = current_pos_x + 2;
				next_pos_y = current_pos_y;
			 end
			 
		    default:
			 begin
				next_pos_x = current_pos_x;
				next_pos_y = current_pos_y;
			 end
			
		endcase
		
	end
	
endmodule 