// 
//  Landing Gear Controller modified for SystemVerilog
//  Author: Jenner Hanni
//
//  Modifications:
//    - uses package for definitions
//    - associative array for scoreboard
//
// 7-state Moore FSM with 5 inputs and 5 outputs.
// 

module TestBench;

  import definitions::*;

  logic Clock, Clear, GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever;
  wire RedLED, GrnLED, Valve, Pump, Timer;
  state_t State, NextState;

  LandingGearController TFSM(Clock, Clear,
                            GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever,
                            RedLED, GrnLED, Valve, Pump, Timer, State, NextState);
  bind LandingGearController FSMassertions LDGA(Clock, State, Clear);


  case_t Testcase;
  logic [4:0] testinput [$];

  // 
  // create scoreboard indexed by state and iterate through all states
  //

  bit Scoreboard[state_t], index = State;

  //
  // Create free running clock
  //

  initial
  begin
    Clock = FALSE;
    forever #CLOCK_WIDTH Clock = ~Clock;
  end

  //
  // set up display
  //

  initial
  begin
    $display("                Time  Testcase | Down Up Taxi TimeUp Lever | RedLED GrnLED Valve Pump Timer | State\n");
    forever @(State) begin
      #1
      $display($time, "   %s   |   %b  %b   %b     %b      %b   |   %b       %b     %b     %b    %b   | %s",
              Testcase, GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever, RedLED, GrnLED, Valve, Pump, Timer, State);
    end
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

  state_t tempState;
  int s;

  initial
  begin

    // Load Cases in testinput[$] queue
    // {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever}

    // Case #1 - Testing for regular operation
    // TAXI-TAKEOFF-GOUP-FLYUP-GODN-TAXI

    testinput[0] = 5'b10100;  
    testinput[1] = 5'b10000;  
    testinput[2] = 5'b00010;
    testinput[3] = 5'b01010;
    testinput[4] = 5'b01011;
    testinput[5] = 5'b10111;

  end

  // 
  // At each negative clock edge, push the next set of input stimulus
  // 

  always_ff @(negedge Clock) begin
    static int j = 0; // specific case in the test 
    static int total_cases = 6;

    if (j < total_cases) begin
      {GearIsDown, GearIsUp, PlaneOnGround, TimeUp, Lever} = testinput[j];
      j++;
    end
    else begin 
      $display("No more cases."); 
      $finish; 
    end
  end

  // walk through the enumerated type and $display all the ones not in the Scoreboard
  // it's exposing the state_t but it's at least extensible

  final begin
    $display("States not seen:");

    tempState = tempState.first;
    do begin
      if (!Scoreboard[tempState]) $display("%s ",tempState);
      tempState = tempState.next;
    end
    while (tempState != tempState.first);
  end

  // update scoreboard upon reaching a state

  always_comb begin
    Scoreboard[State] = 1;
  end


endmodule

