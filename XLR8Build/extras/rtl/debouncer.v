

// Assumes a 16MHz clock
module debouncer(

    input in_signal,
    input clk,
    output out_signal

);

   parameter LOW = 1'b0;
	parameter HIGH = 1'b1;
	parameter num_clks = 40;

	
	reg[7:0] feedback_reg = 0;
	reg       state = 1;
	
	
	always @(posedge clk) begin
	    //feedback_reg <= feedback_reg << 1;
		 //feedback_reg[0] <= in_signal;
		 if ((in_signal && state == 1'b0) || (~in_signal && state == 1'b1)) begin
		     feedback_reg <= feedback_reg + 8'b00000001;
		 end
		 else begin
		     feedback_reg <= {8{1'b0}};
		 end
		 // Look for high signal (Must be high for 10 consecutive clocks)
		 if(state == 1'b0) begin
		      //if(feedback_reg == {160{1'b1}}) begin
			  if (feedback_reg == 40) begin
		         out_signal <= HIGH;
			      state <= 1;
		     end
		 end
		 // Look for low signal (Must be low for 10 consecutive clocks)
		 else if(state == 1'b1) begin
			  //if(feedback_reg == {160{1'b0}}) begin
			  if (feedback_reg == 40) begin
			      state <= 0;
					out_signal <= LOW;
			  end
		 end
	end


endmodule