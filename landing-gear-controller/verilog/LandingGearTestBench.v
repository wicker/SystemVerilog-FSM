//
// Testbench for LandingGearController
// Jenner Hanni <jeh.wicker@gmail.com>
//
// See the attached 'testcases' document for a description of the test cases
//

module TestBench;
reg Clock, Clear, GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever;
wire RedLED, GrnLED, Valve, Pump, Timer;

parameter TRUE   = 1'b1;
parameter FALSE  = 1'b0;
parameter CLOCK_CYCLE  = 2;
parameter CLOCK_WIDTH  = CLOCK_CYCLE/2;
parameter IDLE_CLOCKS  = 1;

LandingGearController TFSM(Clock, Clear,
                          GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever,
                          RedLED, GrnLED, Valve, Pump, Timer);

//
// set up monitor
//

initial
begin
$display("                Time Clear | Down Up Taxi TimeUp Lever | RedLED GrnLED Valve Pump Timer\n");
$monitor($time, "   %b   |   %b  %b   %b     %b      %b   |   %b       %b     %b     %b    %b",Clear, GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever, RedLED, GrnLED, Valve, Pump, Timer);
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
// Generate Clear signal for two cycles
//

initial
begin
Clear = TRUE;
repeat (IDLE_CLOCKS) @(negedge Clock);
Clear = FALSE;
end

//
// Generate stimulus after waiting for reset
//

initial
begin

// Case #1 - Testing for regular operation
// TAXI-TUP-TDN-TUP-TAXI-TDN-TAXI-TDN-GOUP-FLYUP-GODN-FLYDN-TAXI
$display("\nCase #1\n");
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10000;  
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10001; 
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10000;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10100;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10001;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10100;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10001;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b00010;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b01010;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b00011;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10011;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10100;

Clear = TRUE;
repeat (IDLE_CLOCKS) @(negedge Clock);
Clear = FALSE;

// Case #2 - Testing for regular operation
// TAXI-TUP-GOUP-FLYUP-GODN-TAXI
$display("\nCase #2\n");
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10000;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b00010;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b01010;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b00011;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10100;

Clear = TRUE;
repeat (IDLE_CLOCKS) @(negedge Clock);
Clear = FALSE;

// Case #3 - Testing for regular operation
// TAXI-TDN-GOUP-FLYUP-GODN-TAXI
$display("\nCase #3\n");
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10001;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b00010;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b01010;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b00011;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10100;

Clear = TRUE;
repeat (IDLE_CLOCKS) @(negedge Clock);
Clear = FALSE;

// Case #4 - Testing for regular operation
// TAXI-TUP-FLYDN-GOUP-FLYUP-GODN-TAXI
$display("\nCase #4\n");
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10000;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10011;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b00010;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b01010;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b00011;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10100;

Clear = TRUE;
repeat (IDLE_CLOCKS) @(negedge Clock);
Clear = FALSE;

// Case #5 - Testing for regular operation
// TAXI-TDN-FLYDN-TAXI
$display("\nCase #5\n");
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10001;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10011;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10100;

Clear = TRUE;
repeat (IDLE_CLOCKS) @(negedge Clock);
Clear = FALSE;

// Case #6 - Verify TimeUp and Lever are don't cares when transitioning to TAXI
// TAXI-TUP-TAXI 
$display("\nCase #6\n");
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10000;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10101;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10000;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10110;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10000;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10111;

Clear = TRUE;
repeat (IDLE_CLOCKS) @(negedge Clock);
Clear = FALSE;

// Case #7 - Verify TimeUp and Lever are don't cares when transitioning to TAXI
// TAXI-TDN-TAXI 
$display("\nCase #7\n");
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10001;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10101;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10001;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10110;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10001;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10111;

Clear = TRUE;
repeat (IDLE_CLOCKS) @(negedge Clock);
Clear = FALSE;

// Case #8 - Verify TimeUp and Lever are don't cares when transitioning to TAXI
// TAXI-TDN-FLYDN-TAXI
$display("\nCase #8\n");
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10001;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10011;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10101;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10001;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10011;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10110;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10001;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10011;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10111;

Clear = TRUE;
repeat (IDLE_CLOCKS) @(negedge Clock);
Clear = FALSE;

// Case #9 - Verify TimeUp and Lever are don't cares when transitioning to TAXI
// TAXI-TUP-GOUP-FLYUP-GODN-TAXI 
$display("\nCase #9\n");
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10000;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b00010;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b01010;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b00011;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10101;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10000;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b00010;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b01010;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b00011;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10110;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10000;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b00010;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b01010;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b00011;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10111;

Clear = TRUE;
repeat (IDLE_CLOCKS) @(negedge Clock);
Clear = FALSE;

// Case #10 - Verify timer is ignored even if accidentally reset during flight until landing
// TAXI-TUP-TUP-GOUP-GOUP-FLYUP-FLYUP-GODN-GODN-TAXI
$display("\nCase #10\n");
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10000;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b00000;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b00010;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b00000;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b01010;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b01000;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b00011;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b00001;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10100;

Clear = TRUE;
repeat (IDLE_CLOCKS) @(negedge Clock);
Clear = FALSE;

// Case #11 - Verify pilot lever is ignored during gear extension/retraction
// TAXI-TUP-GOUP-GOUP-FLYUP-GODN-GODN-TAXI
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10000;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b00010;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b00011;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b01010;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b00011;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b00010;
repeat (1) @(negedge Clock); {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = 5'b10100;

$stop;
end

endmodule

