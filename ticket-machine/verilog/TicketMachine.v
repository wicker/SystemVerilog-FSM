//
// Ticket Machine 
// Jenner Hanni
//
// Implements a Moore finite state machine in Verilog
//
// This file handles encoding and behavior of a finite state machine to control
// a mass transit ticketing machine. A One Week Travel ticket costs $40. The 
// machine accepts only $20 and $10 bills and will return all bills if more than
// $40 is placed in the machine. The machine does not make change. 
//
// The four states:  
//         READY (LED on to indicate bills will be accepted)
// 		     DISPENSE (dispenses a ticket once $40 received)
//		     RETURN (return all bills if more than $40 received)
//		     BILL (turns on LED to indicate an incomplete transaction)
// 
// In the original project description, there is no RESET or CLEAR input.
//

module TicketMachine(Clock, Clear, Ten, Twenty, Ready, Dispense, Return, Bill);
input Clock, Clear, Ten, Twenty;
output Ready, Dispense, Return, Bill;
reg Ready, Dispense, Return, Bill;

parameter ON  = 1'b1;
parameter OFF = 1'b0;

// define states using same names and state assignments as state diagram and table
// Using one-hot method, we have one bit per state

parameter // states
	RDY    = 6'b000001,
	DISP   = 6'b000010,
	RTN    = 6'b000100,
	BILL10 = 6'b001000,
	BILL20 = 6'b010000,
	BILL30 = 6'b100000;

reg [5:0] State, NextState;

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
	RDY:	begin
		Ready    = ON;
		Bill     = OFF;
		Dispense = OFF;
		Return   = OFF;
		end

	DISP:	begin
		Ready    = OFF;
		Bill     = OFF;
		Dispense = ON;
		Return   = OFF;
		end

	RTN:	begin
		Ready    = OFF;
		Bill     = OFF;
		Dispense = OFF;
		Return   = ON;
		end

	BILL10:	begin
		Ready    = OFF;
		Bill     = ON;
		Dispense = OFF;
		Return   = OFF;
		end

	BILL20:	begin
		Ready    = OFF;
		Bill     = ON;
		Dispense = OFF;
		Return   = OFF;
		end

	BILL30:	begin
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

