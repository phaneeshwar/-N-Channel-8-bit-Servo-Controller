module Address_Decoder # (    // this module behave like a dmux
      parameter channels = 4, // number of channels are parametrized and 4 is set as default value
		parameter nbits = 2 // width of address bits and 2 is set as default value 
		)(
		 input clk,                       // input clock
		 input [nbits-1:0] address,       // input address line
		 input latch,                     // latch signal
		 output reg [channels-1:0] load   // output of the Address decoder, the width of the output is equal to number of channels
		 );
		 
integer i;    // this variable is used in the for loop 


always @(posedge clk) begin             // check for every positive edge of the clock
      
for (i = 0; i < channels; i = i + 1) begin   // this loop is used to connect appropriate output line to the input latch
   if (address == i) begin                   
	   load[address] <= ~latch; 
      		// latch value is negated and given to the addressed channel, as it would be usefull when testing the hardware 
	end
	
	else begin
	load[i] <= 0;	// set bit zero for remaining output lines
	end
	
	end
end	



endmodule
	     
		