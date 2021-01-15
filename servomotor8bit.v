`include "clog2.v"

module servomotor8bit #(             // All the parameters mentioned below can be varied by the user as per his requirements
     parameter min_duty_cycle = 0.0005,//min duty cycle required for the zeroth bit, 
	  parameter timeperiod = 0.02,      // to set timeperiod of the output signal
	  parameter required_clk_frequency = 128000, // clock enable signal used as input clock for the pwm channel
	  parameter n_channels = 4,                // To set Number of PWM channels 
	  parameter clk_frequency = 50000000,     // to set the input clock
	  parameter nbits = `clog2(n_channels)   //  to determine the number of address bits based on number of channels
	  )(
	  input [nbits-1:0] address,      // input the address line
	  input latch,                    // latch signal to load the duty cycle value
	  input clk,                      // input clock
	  input [7:0] dutycycle,          // 8-bit duty cycle
	  output [n_channels-1:0] PwmOut  // N-Pwm channel
	  );

wire clkdiv;                // used to connect frequency divider model and pwm channel
wire [n_channels-1:0] load;  // it is used to connect address decoder output to the pwm channel
	  
Frequencydivider # (                                          // Instantiating frequency divider module 
      .required_clk_frequency (required_clk_frequency ),
		.clk_frequency (clk_frequency )
		) block1 (
		.clk (clk ),
		.clkdiv (clkdiv )
	   );
		
Address_Decoder # (                                           // Instantiating Address Decoder
      .channels (n_channels),
		.nbits    (nbits     )
		) block2 (
		.clk      (clk       ),
		.address (address    ),
		.latch   (latch      ),
		.load    (load       )
		);
	
genvar i;  // create a variable, used in the generate block

generate // generate block helps us to instantiate N number of channels.
      for (i=0 ; i < n_channels ; i = i + 1) begin: pwm_loop
		       
		         Pwm_channel #(
				    .required_clk_frequency (required_clk_frequency ),   // give required parameters to the model
					 .timeperiod (timeperiod ),
					 .min_duty_cycle (min_duty_cycle )
					 ) block3 (
					 .clkdiv  (clkdiv ),
					 .load    (load[i] ),
					 .dutycycle (dutycycle ),
					 .Pwmout (PwmOut[i] )
					 );
					 end
endgenerate


	
endmodule
				   
		
		
  