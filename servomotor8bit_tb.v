`timescale 1 ns / 100 ps

module servomotor8bit_tb;              // define the testbench module
      
		reg [1:0] address = 2'b00;          // create a reg for inputs
		reg clk = 0;
		reg [7:0] dutycycle = 8'h00;
		reg latch = 1'b0;
		wire [3:0] PwmOut;       // wire for the outputs
		
		localparam min_duty_cycle = 0.005;                        // initialize the parameter mininmum duty cycle to 0.5ms or any other value
		localparam timeperiod = 0.02;                             // initialize the parameter timeperiod, to set the period of the output signal

		localparam n_channels = 4;                                // to define number of channels
		localparam nbits = 2;                                     // define number of bits

		localparam required_clk_frequency = 128000;		          // this frequency defined will be input to the pwm channel
		localparam clk_frequency = 50000000;                      // to set input clock frequency to 50 Mhz
		
		

 servomotor8bit # (                                                        // Instantiate the main module
          .min_duty_cycle (min_duty_cycle),
	       .timeperiod  (timeperiod),
	       .required_clk_frequency (required_clk_frequency),
	       .n_channels (n_channels),
	       .clk_frequency (clk_frequency),
	       .nbits  (nbits)

         ) dut (
          .address (address),
		  .clk     (clk    ),
		  .dutycycle   (dutycycle ),
		  .latch (latch),
		  .PwmOut   (PwmOut    )
		  
		  );
 
 localparam frequency = (1000000000/(2*clk_frequency));    // this will set the pulse width of the clock in nano seconds
 always #frequency clk = ~clk;                            // to toggle the clock input
 
 initial begin                                             // this is where the execution of the inputs will begin
        
		   clk = 1'b0;                                    //set input clock to 0 initially 
		   latch = 1;                                     // latch is set to logic one because it is active low
            
			#1000000;                                     // delay
			address = 2'b00;                              //select the pwm channel by giving the address
			dutycycle = 8'hFF;                            // set the duty cycle
			latch = 0;                                    // give latch 0, as it is active low, output is high
			@(posedge clk);
			latch = 1;

			#50000000;
			address = 2'b01;
			dutycycle = 8'hFF;
			latch = 0;
			@(posedge clk);
			latch = 1;

			#50000000;
			address = 2'b10;
			dutycycle = 8'hFF;
			latch = 0;
			@(posedge clk);
			latch = 1;

			#50000000;
			address = 2'b11;
			dutycycle = 8'hFF;
			latch = 0;
			@(posedge clk);
			latch = 1;
            
		   	$display("%b ns\tSimulation Finished",$time);
			
	end
endmodule







