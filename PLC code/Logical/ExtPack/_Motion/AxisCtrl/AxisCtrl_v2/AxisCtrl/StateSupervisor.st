(********************************************************************
 * COPYRIGHT - B&R Spain
 ********************************************************************
 * Program: AxisCtrl
 * File: StateSupervisor.st
 * Author: B&R Spain
 * Created: September 19, 2013
 * Modified: April 28, 2017
 ********************************************************************
 * Implementation of action StateSupervisor
 ******************************************************************** 
 * Whenever an agent outside this program (e.g. the Test Window) or 
 * the CNC manager would perform a command that would cause a state 
 * change or whenever an unexpected error would occur, this state 
 * supervisor would find which is the resulting axis state.
 ********************************************************************)

ACTION StateSupervisor: 
    
    (* Detects exceptions, where axis states are not the expected ones *)
    CASE AxisState OF
        
        (* States where the PLCopen state must be Disabled *)
        AX_STATE_DISABLED:
            TON_Exception.PT := TIMEOUT_STATE_EXCEPTION;
            (* Virtual axes cannot be in disabled state therefore they are allowed to be in standstill *)
            IF AxisIsVirtual THEN
                TON_Exception.IN := NOT(MC_ReadStatus_0.Disabled OR MC_ReadStatus_0.StandStill);
            ELSE
                TON_Exception.IN := NOT(MC_ReadStatus_0.Disabled);
            END_IF
            
        AX_STATE_UK_DISABLED:
            TON_Exception.PT := T#0ms;
            (* Virtual axes cannot be in disabled state therefore they are allowed to be in standstill *)
            IF AxisIsVirtual THEN
                TON_Exception.IN := NOT(MC_ReadStatus_0.Disabled OR MC_ReadStatus_0.StandStill);
            ELSE
                TON_Exception.IN := NOT(MC_ReadStatus_0.Disabled);
            END_IF
            
        (* States where the PLCopen state must be Homing *)
        AX_STATE_HOMING_NO_POWER, AX_STATE_HOMING:
            TON_Exception.PT := TIMEOUT_STATE_EXCEPTION;
            TON_Exception.IN := NOT(MC_ReadStatus_0.Homing);
            
        AX_STATE_UK_HOMING:
            TON_Exception.PT := T#0ms;
            TON_Exception.IN := NOT(MC_ReadStatus_0.Homing);
            
        (* States where the PLCopen state must be Standstill *)
        AX_STATE_STANDSTILL, AX_STATE_JOG_SS_HALTED:
            TON_Exception.PT := TIMEOUT_STATE_EXCEPTION;
            TON_Exception.IN := NOT(MC_ReadStatus_0.StandStill);
            
        AX_STATE_UK_STANDSTILL:
            TON_Exception.PT := T#0ms;
            TON_Exception.IN := NOT(MC_ReadStatus_0.StandStill);
            
        (* States where the PLCopen state must be ContinuousMotion *)
        AX_STATE_JOGGING_POS, AX_STATE_JOGGING_NEG,
        AX_STATE_MOVING_VELOCITY_0, AX_STATE_MOVING_VELOCITY_1:
            TON_Exception.PT := TIMEOUT_STATE_EXCEPTION;
            TON_Exception.IN := NOT(MC_ReadStatus_0.ContinuousMotion);
            
        AX_STATE_UK_CONTINUOUS_MOTION:
            TON_Exception.PT := T#0ms;
            TON_Exception.IN := NOT(MC_ReadStatus_0.ContinuousMotion);
            
        (* States where the PLCopen state must be DiscreteMotion *)
        AX_STATE_JOGGING_SS_POS, AX_STATE_JOGGING_SS_NEG, AX_STATE_HALTING_JOG,
        AX_STATE_MOVING_ABSOLUTE_0, AX_STATE_MOVING_ABSOLUTE_1,
        AX_STATE_MOVING_ADDITIVE_0, AX_STATE_MOVING_ADDITIVE_1,
        AX_STATE_HALTING_0, AX_STATE_HALTING_1:
            TON_Exception.PT := TIMEOUT_STATE_EXCEPTION;
            TON_Exception.IN := NOT(MC_ReadStatus_0.DiscreteMotion);
            
        AX_STATE_UK_DISCRETE_MOTION:
            TON_Exception.PT := T#0ms;
            TON_Exception.IN := NOT(MC_ReadStatus_0.DiscreteMotion);
            
        (* States where the PLCopen state must be SynchronizedMotion *)
		AX_STATE_MOVING_GEAR_0, AX_STATE_MOVING_GEAR_1:
			TON_Exception.PT := TIMEOUT_STATE_EXCEPTION;
			TON_Exception.IN := NOT(MC_ReadStatus_0.SynchronizedMotion);
		
		AX_STATE_UK_SYNCHRONIZED_MOTION:
            TON_Exception.PT := T#0ms;
            TON_Exception.IN := NOT(MC_ReadStatus_0.SynchronizedMotion);
            
        (* States where the PLCopen state must be Stopping *)
        AX_STATE_STOPPING:
            TON_Exception.PT := TIMEOUT_STATE_EXCEPTION;
            TON_Exception.IN := NOT(MC_ReadStatus_0.Stopping);
            
        AX_STATE_UK_STOPPING:
            TON_Exception.PT := T#0ms;
            TON_Exception.IN := NOT(MC_ReadStatus_0.Stopping);
            
        (* States where the PLCopen state must be ErrorStop *)
        AX_STATE_UK_ERROR_STOP:
            TON_Exception.PT := T#0ms;
            TON_Exception.IN := NOT(MC_ReadStatus_0.Errorstop);
            
        (* States which should be a fast transition *)
        AX_STATE_SWITCHING_OFF, AX_STATE_SWITCHING_ON:
            TON_Exception.PT := TIMEOUT_SWITCH_ON_OFF;
            TON_Exception.IN := TRUE;
            
        (* State where the PLCopen state must be determined immediately *)
        AX_STATE_UNKNOWN:            
            TON_Exception.PT := T#0ms;
            TON_Exception.IN := TRUE;
            
        (* States where no state discrepancy is checked. No need to specify them *)
        ELSE
            
            (* ATTENTION! Program can stop working in these states *)
            (* To "protect" the program against hangs, add all newly *)
            (* created states wherever they should be in this CASE *)
            TON_Exception.IN := FALSE;
            
            (* In order not to get an error message, the following section can be commented out *)
            ErrorID := 50002;
            ClearErrorTexts;
            ErrorText[0] := 'At least an state has not been defined in the state supervisor';
            ErrorText[1] := 'ATTENTION: If a state is not defined, program may hang';
            AxisErrorState := AX_ERR_STATE_APP_ERROR;
            (* If desired, the following section can be uncommented to stop the axis as well *)
            //QuickStop;
            //AxisState := AX_STATE_UNKNOWN;
            
    END_CASE
    
    TON_Exception();
    
    (* Exception occurred *)
    IF TON_Exception.Q THEN
        TON_Exception.IN := FALSE;
        TON_Exception(); (* To be able to start right on the next cycle *)
        (* If the power should be off and MC_Power.Enable = 0   *)
        (* but the power is on because the Test Window did it,  *)
        (* since the MC_Power.Enable needs a negative edge to   *)
        (* switch it off, it must be enabled first              *)
        IF AxisState = AX_STATE_DISABLED THEN
            PowerOn;
        END_IF
        ResetExecutes;
        ResetMotionCommands;
        ResetJogCommands;
        DetermineState;
    END_IF
    
END_ACTION



(* Determines which is the actual PLCopen state *)
ACTION DetermineState:
    
    IF MC_ReadStatus_0.Valid THEN
        IF MC_ReadStatus_0.Disabled THEN
            (* If the power should be on and MC_Power.Enable = 1    *)
            (* but the power is off because the Test Window did it, *)
            (* since the MC_Power.Enable needs a positive edge to   *)
            (* switch it on, it must be disabled first              *)
            PowerOff;
            AxisState := AX_STATE_UK_DISABLED;
        ELSIF MC_ReadStatus_0.StandStill THEN
            AxisState := AX_STATE_UK_STANDSTILL;
        ELSIF MC_ReadStatus_0.Homing THEN
            AxisState := AX_STATE_UK_HOMING;
        ELSIF MC_ReadStatus_0.DiscreteMotion THEN
            AxisState := AX_STATE_UK_DISCRETE_MOTION;
        ELSIF MC_ReadStatus_0.ContinuousMotion THEN
            AxisState := AX_STATE_UK_CONTINUOUS_MOTION;
        ELSIF MC_ReadStatus_0.SynchronizedMotion THEN
            AxisState := AX_STATE_UK_SYNCHRONIZED_MOTION;
        ELSIF MC_ReadStatus_0.Stopping THEN
            AxisState := AX_STATE_UK_STOPPING;
        ELSIF MC_ReadStatus_0.Errorstop THEN
            AxisState := AX_STATE_UK_ERROR_STOP;
        ELSE
            AxisState := AX_STATE_UNKNOWN;
        END_IF
    ELSE
        AxisState := AX_STATE_UNKNOWN;
    END_IF
    
END_ACTION
