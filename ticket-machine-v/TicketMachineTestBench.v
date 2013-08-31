//
// Ticket Machin Testbench
// Jenner Hanni
//
// Implements a testbench for a Moore finite state machine in Verilog
//
// This file provides a testbench capable of exhaustive testing of the 
// TicketMachine.v file. Further comments available in that file. 
// 

module TestBench;
reg Clock, Clear, Ten, Twenty;
wire Ready, Dispense, Return, Bill;

parameter TRUE   = 1'b1;
parameter FALSE  = 1'b0;
parameter CLOCK_CYCLE  = 10;
parameter CLOCK_WIDTH  = CLOCK_CYCLE/2;
parameter IDLE_CLOCKS  = 2;

// instantiate an object of type TicketMachine to test

TicketMachine TFSM(Clock, Clear, Ten, Twenty, Ready, Dispense, Return, Bill);

//
// set up monitor
//

initial
begin
forever @(posedge Clock) begin 
#1
$display($time, "    %b    %b        %b     %b       %b  %b",Ten,Twenty,Ready,Dispense,Return,Bill);
end
end

//
// Create free running clock
//

initial
begin
Clock = FALSE;
forever #CLOCK_WIDTH Clock = ~Clock;
end

//
// Generate stimulus after waiting for reset
//

initial
begin

Clear = 1;
repeat (2) @(negedge Clock); 
Clear = 0;
repeat (1) @(negedge Clock); {Ten,Twenty} = 2'b10;   // case #1
repeat (1) @(negedge Clock); {Ten,Twenty} = 2'b10;   // exact change with 10+10+10+10
repeat (1) @(negedge Clock); {Ten,Twenty} = 2'b10;
repeat (1) @(negedge Clock); {Ten,Twenty} = 2'b10;

repeat (1) @(negedge Clock); {Ten,Twenty} = 2'b01;   // case #2 
repeat (1) @(negedge Clock); {Ten,Twenty} = 2'b01;   // exact change with 20+20

repeat (1) @(negedge Clock); {Ten,Twenty} = 2'b10;   // case #3
repeat (1) @(negedge Clock); {Ten,Twenty} = 2'b10;   // exact change with 10+10+20 
repeat (1) @(negedge Clock); {Ten,Twenty} = 2'b01;

repeat (1) @(negedge Clock); {Ten,Twenty} = 2'b10;   // case #4
repeat (1) @(negedge Clock); {Ten,Twenty} = 2'b01;   // exact change with 10+20+10
repeat (1) @(negedge Clock); {Ten,Twenty} = 2'b10;

repeat (1) @(negedge Clock); {Ten,Twenty} = 2'b01;   // case #5
repeat (1) @(negedge Clock); {Ten,Twenty} = 2'b10;   // exact change with 20+10+10
repeat (1) @(negedge Clock); {Ten,Twenty} = 2'b10;

repeat (1) @(negedge Clock); {Ten,Twenty} = 2'b10;   // case #6
repeat (1) @(negedge Clock); {Ten,Twenty} = 2'b01;   // overshoot with 10+20+20
repeat (1) @(negedge Clock); {Ten,Twenty} = 2'b01;

repeat (1) @(negedge Clock); {Ten,Twenty} = 2'b10;   // case #7
repeat (1) @(negedge Clock); {Ten,Twenty} = 2'b01;   // overshoot with 10+20+20
repeat (1) @(negedge Clock); {Ten,Twenty} = 2'b01;

repeat (1) @(negedge Clock); {Ten,Twenty} = 2'b01;   // case #8
repeat (1) @(negedge Clock); {Ten,Twenty} = 2'b10;   // overshoot with 20+10+20
repeat (1) @(negedge Clock); {Ten,Twenty} = 2'b01;

repeat (1) @(negedge Clock); {Ten,Twenty} = 2'b10;   // case #9
repeat (1) @(negedge Clock); {Ten,Twenty} = 2'b10;   // overshoot with 10+10+10+20
repeat (1) @(negedge Clock); {Ten,Twenty} = 2'b10;
repeat (1) @(negedge Clock); {Ten,Twenty} = 2'b01;

repeat (1) @(negedge Clock); {Ten,Twenty} = 2'b00;   // case #10 - explicit no bills

repeat (1) @(negedge Clock); {Ten,Twenty} = 2'b11;   // case #11 - LUDICROUS CASE
    				                                         // failure in laws of physics
$stop;
end

endmodule

