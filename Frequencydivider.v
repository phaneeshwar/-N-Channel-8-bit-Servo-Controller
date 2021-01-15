module Frequencydivider #(
      parameter required_clk_frequency = 128000, //default frequency value obtained at the output of the frequency divider circuit, 
		parameter clk_frequency = 500000000    // default input clock frequency.
		)(                                    // Parameter values can be changed according to the user requirements
		  input clk,
		  output reg clkdiv
		  );
//**********************************************************************************************************
//if we required ceil of the calculated count then we can use the below logic.
//**********************************************************************************************************

//**********************************************************************************************************		  
// ceil value		  
//localparam integer clkcycle = ((clk_frequency + required_clk_frequency - 1) / required_clk_frequency); 
//**********************************************************************************************************


//floor value
localparam integer clkcycle = clk_frequency / required_clk_frequency; // to count the number of single cycles
reg[10:0] counter = 0; // initialize the counter value to zero


always @(posedge clk) begin                         //for every positive edge of the clock
    if (counter < (clkcycle / 2)) begin
	     counter <= counter + 1;                     // Increment the counter value
		  clkdiv <= 1;                                // Set the output clk to high upto half of the claculated clkcycle value
		  end
	  else if (counter >= (clkcycle / 2) && counter < clkcycle ) begin  // to check if it is less than clkcycle and greater than half of clkcycle
	      counter <= counter + 1;                    // Increment the counter value
			clkdiv <= 0;                               // Set output to zero for next half of the cycle
			end
		else begin
		    counter <= 0;
		end
end
endmodule


