//
// Ticket Machine modified for SystemVerilog
// Jenner Hanni
//
// This file handles encoding and behavior of a finite state machine to control
// a mass transit ticketing machine. A One Week Travel ticket costs $40. The 
// machine accepts only $20 and $10 bills and will return all bills if more than
// $40 is placed in the machine. The machine does not make change. 
//
// Improvements in SystemVerilog:
//    - use of a package
//
// The four states:  READY (LED on to indicate bills will be accepted)
// 		     DISPENSE (dispenses a ticket once $40 received)
//		     RETURN (return all bills if more than $40 received)
//		     BILL (turns on LED to indicate an incomplete transaction)
// 

package definitions;

  parameter VERSION = "1.1";

  parameter ON  = 1'b1;
  parameter OFF = 1'b0;

  enum logic [5:0] {RDY, BILL10, BILL20, BILL30, DISP, RTN} State, NextState;
  enum {CASE[9]} Testcase;

  parameter TRUE = 1'b1;
  parameter FALSE = 1'b0;
  parameter CLOCK_CYCLE = 20ms;
  parameter CLOCK_WIDTH = CLOCK_CYCLE/2;
  parameter IDLE_CLOCKS = 2ms;

endpackage

module TicketVendorBotOneHot (input Clock,
                              input Clear,
                              input Ten,
                              input Twenty, 
                              output reg Ready,
                              output reg Dispense,
                              output reg Return,
                              output reg Bill);

  import definitions::*;

  //
  // Update state or reset on every + clock edge
  // We have no clear
  //

  always @(posedge Clock)
  begin 
   if (Clear)
	  State <= RDY;
   else
	  State <= NextState;
  end

  //
  // Outputs depend only upon state (Moore machine)
  //

  always @(State)
  begin
  case (State)
	  RDY:	  begin
	    Ready    = ON;
		  Bill     = OFF;
		  Dispense = OFF;
		  Return   = OFF;
		  end

	  DISP:	  begin
		  Ready    = OFF;
		  Bill     = OFF;
		  Dispense = ON;
		  Return   = OFF;
		  end

	  RTN:	  begin
		  Ready    = OFF;
		  Bill     = OFF;
		  Dispense = OFF;
		  Return   = ON;
		  end

	  BILL10: begin
		  Ready    = OFF;
		  Bill     = ON;
		  Dispense = OFF;
		  Return   = OFF;
		  end

	  BILL20: begin
		  Ready    = OFF;
		  Bill     = ON;
		  Dispense = OFF;
		  Return   = OFF;
		  end

	  BILL30: begin
		  Ready    = OFF;
		  Bill     = ON;
		  Dispense = OFF;
		  Return   = OFF;
		  end

  endcase
  end



  //
  // Next state generation logic
  //

  always @(State or Ten or Twenty)
  begin
  case (State)
	  RDY:	begin
		  if (Ten)
			  NextState = BILL10;
		  else if (Twenty)
			  NextState = BILL20;
		  else
			  NextState = RDY;
		  end

	  BILL10:	begin
		  if (Ten)
			  NextState = BILL20;
		  else if (Twenty)
			  NextState = BILL30;
		  else
			  NextState = BILL10;
		  end

	  BILL20:	begin
		  if (Ten)
			  NextState = BILL30;
		  else if (Twenty)
			  NextState = DISP;
		  else
			  NextState = BILL20;
		  end

	  BILL30:	begin
		  if (Ten)
			  NextState = DISP;
		  else if (Twenty)
			  NextState = RTN;
		  else
			  NextState = BILL30;
		  end

	  DISP:	begin
			  NextState = RDY;
		  end

	  RTN:	begin
			  NextState = RDY;
		  end

  endcase
  end


endmodule

