module Pwm_channel # (
     parameter required_clk_frequency = 128000, //input clock frequency for the pwm channel
     parameter timeperiod = 0.02,                // timeperiod of the signal
	  parameter min_duty_cycle = 0.0005           // minimum duty cycle
	  )(                                          // Parameter values can be changed by the user in the top level entity
	  input clkdiv,           // clock input, it comes from frequency divider module
	  input load,             // to latch the duty cycle
	  input [7:0] dutycycle,  // 8-bit dutycycle, it is used to change the width of the duty cycle
	  output reg Pwmout       // Pwm channel output is defined
	  );
	  
reg [7:0] duty = 0;        // intialize a seperate dummy variable, used to store the value of the duty cycle
reg [11:0] counter = 0;    // counter is used to obtaine required delay


localparam integer clkdiv_period = (required_clk_frequency * timeperiod);      // calculate the time period
localparam integer mincycle_count = (required_clk_frequency * min_duty_cycle); // to calculate mininmum duty cycle to be maintained at the output

always @(posedge load ) begin  // it checks whenever the latch signal is given
       duty <= dutycycle;      // if it detects the latch signal it would store the value
		 end
		 
always @(posedge clkdiv) begin     // check for every positive edge of clock

          if ( counter < (mincycle_count + duty)) begin  // to maintain min 0.5ms and in addition duty value is added. so counter is used to set that much
	          Pwmout <= 1;                                // delay and the output should be high for that delay
			    counter<= counter + 1;               // increment the counter
			 end
			
		   else if ((counter < clkdiv_period) && (counter >= (mincycle_count + duty))) begin // for values greater than duty cycle and lesser than the total period
		       Pwmout <= 0;                   // set logic 0 for remaining time of period
			    counter<= counter + 1;        // increment the counter
			 end
			 
		   else begin
		      counter <= 0;        // make it zero for remaing time
			   Pwmout <= 0;
         end
     end

endmodule


