// 
//  Landing Gear Controller modified for SystemVerilog
//  Author: Jenner Hanni
//
//  Modifications:
//    - package for definitions
//    - assertions
//
// 7-state Moore FSM with 5 inputs and 5 outputs.
// 

package definitions;

  parameter VERSION = "1.0";

  parameter YES = 1'b1;
  parameter ON = 1'b1;
  parameter DOWN = 1'b1;
  parameter RESET = 1'b1;

  parameter NO = 1'b0;
  parameter OFF = 1'b0;
  parameter UP = 1'b0;
  parameter COUNT = 1'b0;

  parameter CLOCK_CYCLE  = 1ms;
  parameter CLOCK_WIDTH  = CLOCK_CYCLE/2;
  parameter IDLE_CLOCKS  = 1;

  parameter STATES = 5; // number of states - 1
  parameter CASES = 1;

  typedef enum {CASE[1]} case_t;
  typedef enum {TAXI, TAKEOFF, GOUP, GODN, FLYUP, FLYDN} state_t;

  parameter TRUE = 1'b1;
  parameter FALSE = 1'b0;

endpackage

module LandingGearController(Clock, Clear, 
                             GearIsDown, GearIsUp, PlaneOnGround, TimeUp, PilotLever,
                             RedLED, GrnLED, Valve, Pump, Timer, State, NextState);

  import definitions::*;

  input logic Clock, Clear, GearIsDown, GearIsUp, PlaneOnGround, TimeUp, PilotLever;
  output logic RedLED, GrnLED, Valve, Pump, Timer;
  output state_t State, NextState; 

  //
  // Updates state or reset on every positive clock edge
  //

  always_ff @(posedge Clock)
  begin
  if (Clear)
    State <= TAXI;
  else
    State <= NextState;
  end

  //
  // State Descriptions
  //
  // TAXI  Plane is on the ground -- this is the only state to reset the timer
  // TUP   Plane has taken off and requested the gear up but less than two seconds
  // TDN   Plane has taken off but not requested the gear up with less than two seconds
  // GOUP  Plane is in flight; gear is in motion being retracted
  // GODN  Plane is in flight; gear is in motion being extended
  // FLYUP Plane is in flight with the gear retracted
  // FLYDN Plane is in flight with the gear extended
  //

  always_comb begin
  case (State)
    TAXI: begin
      RedLED = OFF;
      GrnLED = ON;
      Valve  = DOWN;
      Pump   = OFF;
      Timer  = RESET;
      end

    TAKEOFF: begin
      RedLED = OFF;
      GrnLED = ON;
      Valve  = DOWN;
      Pump   = OFF;
      Timer  = COUNT;
      end

    GOUP: begin
      RedLED = ON;
      GrnLED = OFF;
      Valve  = UP;
      Pump   = ON;
      Timer  = COUNT;
      end

    GODN: begin
      RedLED = ON;
      GrnLED = OFF;
      Valve  = DOWN;
      Pump   = ON;
      Timer  = COUNT;
      end

    FLYUP: begin
      RedLED = OFF;
      GrnLED = OFF;
      Valve  = UP;
      Pump   = OFF;
      Timer  = COUNT;
      end

    FLYDN: begin
      RedLED = OFF;
      GrnLED = ON;
      Valve  = DOWN;
      Pump   = OFF;
      Timer  = COUNT;
      end

  endcase
  end

  //
  // Next state generation logic
  //

  always_comb begin
  case (State)
    TAXI: begin
      if (!PlaneOnGround)
        NextState = TAKEOFF;
      else
        NextState = TAXI;
      end

    TAKEOFF: begin
      if (PlaneOnGround)
        NextState = TAXI;
      else if (TimeUp) begin
        if (!PilotLever)
          NextState = GODN;
//          NextState = GOUP;
        else 
          NextState = FLYDN;
      end
      else 
        NextState = TAKEOFF; 
      end

    GOUP: begin
      if (GearIsUp == YES) begin
        goup_a : assert ((GearIsUp & GearIsDown) != 1);
        NextState = FLYUP;
      end
      else 
        NextState = GOUP;
      end

    GODN: begin
      if (PlaneOnGround == YES && GearIsDown == YES) begin
        godn_a1 : assert ((GearIsUp & GearIsDown) != 1);
        NextState = TAXI;
      end
      else if (GearIsDown == YES) begin
        godn_a2 : assert ((GearIsUp & GearIsDown) != 1);
        NextState = FLYDN;
      end
      else 
        NextState = GODN;
      end

    FLYUP: begin
      if (PilotLever == DOWN)
        NextState = GODN;
      else
        NextState = FLYUP;
      end

    FLYDN: begin
      if (PlaneOnGround == YES) 
        NextState = TAXI;
      else if (PilotLever == UP)
        NextState = GOUP;
      else
        NextState = FLYDN;
      end
  endcase
  end


endmodule

module FSMassertions(Clock, State, Clear);

  import definitions::*;

  input logic Clock, Clear;
  input state_t State;

  // when the state is entered, use concurrent assertion to check that the 
  // previous state was a legal predecessor state for that state

  // verify TAKEOFF state was entered from TAXI state
  property p_fsm_takeoff;
  @(posedge Clock) disable iff (Clear)
    State == TAKEOFF |-> $past(State) == TAXI;
  endproperty
  ap_fsm_takeoff : assert property (p_fsm_takeoff);

  // verify GOUP state was entered from TAKEOFF or FLYDN state
  property p_fsm_goup;
  @(posedge Clock) disable iff (Clear)
    State == GOUP |-> $past(State) == TAKEOFF || $past(State) == FLYDN || $past(State) == GOUP; 
  endproperty
  ap_fsm_goup : assert property (p_fsm_goup);

  // verify GODN state was entered from FLYUP state
  property p_fsm_godn;
  @(posedge Clock) disable iff (Clear)
    State == GODN |-> $past(State) == FLYUP || $past(State) == GODN; 
  endproperty
  ap_fsm_godn : assert property (p_fsm_godn);

  // verify FLYDN state was entered from TAKEOFF or GODN states
  property p_fsm_flydn;
  @(posedge Clock) disable iff (Clear)
    State == FLYDN |-> $past(State) == TAKEOFF || $past(State) == GODN || $past(State) == FLYDN;
  endproperty
  ap_fsm_flydn : assert property (p_fsm_flydn);

  // verify FLYUP state was entered from GOUP state
  property p_fsm_flyup;
  @(posedge Clock) disable iff (Clear)
    State == FLYUP |-> $past(State) == GOUP || $past(State) == FLYUP;
  endproperty
  ap_fsm_flyup : assert property (p_fsm_flyup);

  // verify TAXI state was entered from TAXI, FLYDN, or GODN states
  property p_fsm_taxi;
  @(posedge Clock) disable iff (Clear)
    State == TAXI |-> $past(State) == TAXI || $past(State) == FLYDN || $past(State) == GODN || $past(State) == TAXI;
  endproperty
  ap_fsm_taxi : assert property (p_fsm_taxi);


endmodule
