(********************************************************************
 * COPYRIGHT - B&R Spain
 ********************************************************************
 * Program: AxisCtrl
 * File: Commands.st
 * Author: B&R Spain
 * Created: September 19, 2013
 * Modified: February 17, 2016
 ********************************************************************
 * Implementation of program AxisCtrl
 ********************************************************************) 

ACTION ResetMotionCommands:
    (* All motion commands except the Jog ones, the Power and the QuickStop must be reset here *)
    pAxisCtrl.Command.Home              := FALSE;
    pAxisCtrl.Command.HomeAbsEncoder    := FALSE;
    pAxisCtrl.Command.HomeDirect        := FALSE;
    pAxisCtrl.Command.Move.Absolute     := FALSE;
    pAxisCtrl.Command.Move.Additive     := FALSE;
    pAxisCtrl.Command.Move.Velocity     := FALSE;
	pAxisCtrl.Command.Move.Halt         := FALSE;
	pAxisCtrl.Command.Move.GearIn       := FALSE;
	pAxisCtrl.Command.Move.GearOut      := FALSE;	
    pAxisCtrl.Command.Reset             := FALSE;
END_ACTION

ACTION ResetJogCommands:
    (* All Jog commands must be reset here *)
    pAxisCtrl.Command.Jog.ContinuousPos := FALSE;
    pAxisCtrl.Command.Jog.ContinuousNeg := FALSE;
    pAxisCtrl.Command.Jog.StepByStepPos := FALSE;
    pAxisCtrl.Command.Jog.StepByStepNeg := FALSE;
END_ACTION

(* The Power and QuickStop are never reset by this task *)

ACTION ResetExecutes:
    (* The executes of all function blocks used in the main sequence (AxisState) must be reset here *)
    MC_Home_0.Execute             := FALSE;
    MC_Stop_0.Execute             := FALSE;
    MC_MoveAbsolute_0.Execute     := FALSE;
    MC_MoveAbsolute_1.Execute     := FALSE;
    MC_MoveAdditive_0.Execute     := FALSE;
    MC_MoveAdditive_1.Execute     := FALSE;
    MC_MoveVelocity_0.Execute     := FALSE;
    MC_MoveVelocity_1.Execute     := FALSE;
	MC_GearIn_0.Execute           := FALSE;
	MC_GearIn_1.Execute           := FALSE;
	MC_GearOut_x.Execute          := FALSE;
	MC_Halt_0.Execute             := FALSE;
    MC_Halt_1.Execute             := FALSE;
    (* The executes of all other function blocks (e.g. Initialization sequence, error handling...) must not be reset here *)
END_ACTION

ACTION ClearErrorTexts:
    ErrorText[0] := '';
    ErrorText[1] := '';
    ErrorText[2] := '';
    ErrorText[3] := '';
END_ACTION

ACTION SetError29205:
    (* This is to prevent a periodic axis from moving if it has not been homed. *)
    (* It must be done because ACP10 allows periodic axes to move even if they *)
    (* have not been homed since V2.29. This is totally nonsense. *)
    ErrorID := 29205;
    ErrorSource := ERR_SRC_TASK;
    ClearErrorTexts;
    ErrorText[0] := 'The axis is not homed';
    ErrorText[1] := CONCAT('PLCopen_FB: ', ErrorFB);
    ErrorText[2] := 'Check application code and timing';
    AxisErrorState := AX_ERR_STATE_APP_ERROR;
END_ACTION
    
ACTION PowerOff:
	InPosition := FALSE; (* Not necessary, but looks more logical in the watch *)
	InGear := FALSE; (* Not necessary, but looks more logical in the watch *)
    MC_Power_0.Enable := FALSE;
END_ACTION

ACTION PowerOn:
	InPosition := FALSE; (* Not necessary, but looks more logical in the watch *)
	InGear := FALSE; (* Not necessary, but looks more logical in the watch *)
    MC_Power_0.Enable := TRUE;
END_ACTION

ACTION Home:
    HomeValid := FALSE;
    InPosition := FALSE; (* Not necessary, but looks more logical in the watch *)
    MC_Home_0.Position := pAxisCtrl.Parameter.HomePosition;
    MC_Home_0.HomingMode := mcHOME_DEFAULT;
    MC_Home_0.Execute := TRUE;
END_ACTION

ACTION HomeDirect:
    HomeValid := FALSE;
	InPosition := FALSE; (* Not necessary, but looks more logical in the watch *)
	InGear := FALSE; (* Not necessary, but looks more logical in the watch *)
    MC_Home_0.Position := pAxisCtrl.Parameter.HomePosition;
    MC_Home_0.HomingMode := mcHOME_DIRECT;
    MC_Home_0.Execute := TRUE;
END_ACTION

ACTION HomeAbsEncoder:
    HomeValid := FALSE;
	InPosition := FALSE; (* Not necessary, but looks more logical in the watch *)
	InGear := FALSE; (* Not necessary, but looks more logical in the watch *)
    MC_Home_0.HomingMode := mcHOME_RESTORE_POS;
    MC_Home_0.Execute := TRUE;
END_ACTION

ACTION MoveAbsolute_0:
	InPosition := FALSE;
	InGear := FALSE; (* Not necessary, but looks more logical in the watch *)
    IF HomeValid AND DriveStatusFB.HomingOk THEN
        MC_MoveAbsolute_0.Position      := pAxisCtrl.Parameter.Position; 
        MC_MoveAbsolute_0.Velocity      := pAxisCtrl.Parameter.Speed;
        MC_MoveAbsolute_0.Acceleration  := pAxisCtrl.Parameter.Acceleration;
        MC_MoveAbsolute_0.Deceleration  := pAxisCtrl.Parameter.Deceleration;
        MC_MoveAbsolute_0.Direction     := pAxisCtrl.Parameter.Direction;
        MC_MoveAbsolute_0.Execute := TRUE;
    ELSE
        ErrorFB := 'MC_MoveAbsolute';
        SetError29205;
    END_IF
END_ACTION

ACTION MoveAbsolute_1:
	InPosition := FALSE;
	InGear := FALSE; (* Not necessary, but looks more logical in the watch *)
    IF HomeValid AND DriveStatusFB.HomingOk THEN
        MC_MoveAbsolute_1.Position      := pAxisCtrl.Parameter.Position; 
        MC_MoveAbsolute_1.Velocity      := pAxisCtrl.Parameter.Speed;
        MC_MoveAbsolute_1.Acceleration  := pAxisCtrl.Parameter.Acceleration;
        MC_MoveAbsolute_1.Deceleration  := pAxisCtrl.Parameter.Deceleration;
        MC_MoveAbsolute_1.Direction     := pAxisCtrl.Parameter.Direction;
        MC_MoveAbsolute_1.Execute := TRUE;
    ELSE
        ErrorFB := 'MC_MoveAbsolute';
        SetError29205;
    END_IF
END_ACTION

ACTION MoveAdditive_0:
	InPosition := FALSE;
	InGear := FALSE; (* Not necessary, but looks more logical in the watch *)
    IF HomeValid AND DriveStatusFB.HomingOk THEN
        MC_MoveAdditive_0.Distance         := pAxisCtrl.Parameter.Distance;
        MC_MoveAdditive_0.Velocity         := pAxisCtrl.Parameter.Speed;
        MC_MoveAdditive_0.Acceleration     := pAxisCtrl.Parameter.Acceleration;
        MC_MoveAdditive_0.Deceleration     := pAxisCtrl.Parameter.Deceleration;
        MC_MoveAdditive_0.Execute := TRUE;
    ELSE
        ErrorFB := 'MC_MoveAdditive';
        SetError29205;
    END_IF
END_ACTION

ACTION MoveAdditive_1:
	InPosition := FALSE;
	InGear := FALSE; (* Not necessary, but looks more logical in the watch *)
    IF HomeValid AND DriveStatusFB.HomingOk THEN
        MC_MoveAdditive_1.Distance         := pAxisCtrl.Parameter.Distance;
        MC_MoveAdditive_1.Velocity         := pAxisCtrl.Parameter.Speed;
        MC_MoveAdditive_1.Acceleration     := pAxisCtrl.Parameter.Acceleration;
        MC_MoveAdditive_1.Deceleration     := pAxisCtrl.Parameter.Deceleration;
        MC_MoveAdditive_1.Execute := TRUE;
    ELSE
        ErrorFB := 'MC_MoveAdditive';
        SetError29205;
    END_IF
END_ACTION
        
ACTION MoveVelocity_0:
	InPosition := FALSE; (* Not necessary, but looks more logical in the watch *)
	InGear := FALSE; (* Not necessary, but looks more logical in the watch *)
    IF HomeValid AND DriveStatusFB.HomingOk THEN
        MC_MoveVelocity_0.Velocity         := pAxisCtrl.Parameter.Speed;
        MC_MoveVelocity_0.Acceleration     := pAxisCtrl.Parameter.Acceleration;
        MC_MoveVelocity_0.Deceleration     := pAxisCtrl.Parameter.Deceleration;
        MC_MoveVelocity_0.Direction        := pAxisCtrl.Parameter.Direction;
        MC_MoveVelocity_0.Execute := TRUE;
    ELSE
        ErrorFB := 'MC_MoveVelocity';
        SetError29205;
    END_IF
END_ACTION

ACTION MoveVelocity_1:
	InPosition := FALSE; (* Not necessary, but looks more logical in the watch *)
	InGear := FALSE; (* Not necessary, but looks more logical in the watch *)
    IF HomeValid AND DriveStatusFB.HomingOk THEN
        MC_MoveVelocity_1.Velocity         := pAxisCtrl.Parameter.Speed;
        MC_MoveVelocity_1.Acceleration     := pAxisCtrl.Parameter.Acceleration;
        MC_MoveVelocity_1.Deceleration     := pAxisCtrl.Parameter.Deceleration;
        MC_MoveVelocity_1.Direction        := pAxisCtrl.Parameter.Direction;
        MC_MoveVelocity_1.Execute := TRUE;
    ELSE
        ErrorFB := 'MC_MoveVelocity';
        SetError29205;
    END_IF
END_ACTION

ACTION MoveGearIn_0:
	InPosition := FALSE; (* Not necessary, but looks more logical in the watch *)
	InGear := FALSE;
	IF HomeValid AND DriveStatusFB.HomingOk THEN
		MC_GearIn_0.Acceleration         := pAxisCtrl.Parameter.Acceleration;
		MC_GearIn_0.Deceleration         := pAxisCtrl.Parameter.Deceleration;
		MC_GearIn_0.RatioNumerator         := pAxisCtrl.Parameter.GearRatioNum;
		MC_GearIn_0.RatioDenominator     := pAxisCtrl.Parameter.GearRationDen;
		MC_GearIn_0.Execute := TRUE;
		MC_GearOut_x.Execute := FALSE;    (* Resets the execute to allow a gear out later on *)
	ELSE
		ErrorFB := 'MC_GearIn';
		SetError29205;
	END_IF
END_ACTION

ACTION MoveGearIn_1:
	InPosition := FALSE; (* Not necessary, but looks more logical in the watch *)
	InGear := FALSE;
	IF HomeValid AND DriveStatusFB.HomingOk THEN
		MC_GearIn_1.Acceleration         := pAxisCtrl.Parameter.Acceleration;
		MC_GearIn_1.Deceleration         := pAxisCtrl.Parameter.Deceleration;
		MC_GearIn_1.RatioNumerator         := pAxisCtrl.Parameter.GearRatioNum;
		MC_GearIn_1.RatioDenominator     := pAxisCtrl.Parameter.GearRationDen;
		MC_GearIn_1.Execute := TRUE;
		MC_GearOut_x.Execute := FALSE;    (* Resets the execute to allow a gear out later on *)
	ELSE
		ErrorFB := 'MC_GearIn';
		SetError29205;
	END_IF
END_ACTION

ACTION MoveGearOut_x:
	InPosition := FALSE; (* Not necessary, but looks more logical in the watch *)
	InGear := FALSE;
	MC_GearOut_x.Execute := TRUE;
END_ACTION

ACTION MoveHalt_0:
	InPosition := FALSE;
	InGear := FALSE; (* Not necessary, but looks more logical in the watch *)
    MC_Halt_0.Deceleration := pAxisCtrl.Parameter.Deceleration;
    MC_Halt_0.Execute := TRUE;
END_ACTION

ACTION MoveHalt_1:
	InPosition := FALSE;
	InGear := FALSE; (* Not necessary, but looks more logical in the watch *)
    MC_Halt_1.Deceleration := pAxisCtrl.Parameter.Deceleration;
    MC_Halt_1.Execute := TRUE;
END_ACTION

ACTION MoveManualStepByStepPos:
	InPosition := FALSE;
	InGear := FALSE; (* Not necessary, but looks more logical in the watch *)
    IF HomeValid AND DriveStatusFB.HomingOk THEN
        MC_MoveAdditive_0.Distance         := MAX(0, pAxisCtrl.Parameter.JogStep); (* If Step is not positive, it does not move *)
        MC_MoveAdditive_0.Velocity         := pAxisCtrl.Parameter.JogSpeed;
        MC_MoveAdditive_0.Acceleration     := pAxisCtrl.Parameter.Acceleration;
        MC_MoveAdditive_0.Deceleration     := pAxisCtrl.Parameter.Deceleration;
        MC_MoveAdditive_0.Execute := TRUE;
    ELSE
        ErrorFB := 'MC_MoveAdditive';
        SetError29205;
    END_IF
END_ACTION

ACTION MoveManualStepByStepNeg:
	InPosition := FALSE;
	InGear := FALSE; (* Not necessary, but looks more logical in the watch *)
    IF HomeValid AND DriveStatusFB.HomingOk THEN
        MC_MoveAdditive_1.Distance         := MIN(0, -pAxisCtrl.Parameter.JogStep); (* If Step is not positive, it does not move *)
        MC_MoveAdditive_1.Velocity         := pAxisCtrl.Parameter.JogSpeed;
        MC_MoveAdditive_1.Acceleration     := pAxisCtrl.Parameter.Acceleration;
        MC_MoveAdditive_1.Deceleration     := pAxisCtrl.Parameter.Deceleration;
        MC_MoveAdditive_1.Execute := TRUE;
    ELSE
        ErrorFB := 'MC_MoveAdditive';
        SetError29205;
    END_IF
END_ACTION
        
ACTION MoveManualContinuousPos:
	InPosition := FALSE; (* Not necessary, but looks more logical in the watch *)
	InGear := FALSE; (* Not necessary, but looks more logical in the watch *)
    IF HomeValid AND DriveStatusFB.HomingOk THEN
        MC_MoveVelocity_0.Velocity         := pAxisCtrl.Parameter.JogSpeed;
        MC_MoveVelocity_0.Acceleration     := pAxisCtrl.Parameter.Acceleration;
        MC_MoveVelocity_0.Deceleration     := pAxisCtrl.Parameter.Deceleration;
        MC_MoveVelocity_0.Direction        := mcPOSITIVE_DIR;
        MC_MoveVelocity_0.Execute := TRUE;
    ELSE
        ErrorFB := 'MC_MoveVelocity';
        SetError29205;
    END_IF
END_ACTION

ACTION MoveManualContinuousNeg:
	InPosition := FALSE; (* Not necessary, but looks more logical in the watch *)
	InGear := FALSE; (* Not necessary, but looks more logical in the watch *)
    IF HomeValid AND DriveStatusFB.HomingOk THEN
        MC_MoveVelocity_1.Velocity         := pAxisCtrl.Parameter.JogSpeed;
        MC_MoveVelocity_1.Acceleration     := pAxisCtrl.Parameter.Acceleration;
        MC_MoveVelocity_1.Deceleration     := pAxisCtrl.Parameter.Deceleration;
        MC_MoveVelocity_1.Direction        := mcNEGATIVE_DIR;
        MC_MoveVelocity_1.Execute := TRUE;
    ELSE
        ErrorFB := 'MC_MoveVelocity';
        SetError29205;
    END_IF
END_ACTION

ACTION MoveManualStop:
	InPosition := FALSE; (* Not necessary, but looks more logical in the watch *)
	InGear := FALSE; (* Not necessary, but looks more logical in the watch *)
    MC_Halt_0.Deceleration := pAxisCtrl.Parameter.Deceleration;
    MC_Halt_0.Execute := TRUE;
END_ACTION

ACTION QuickStop:
    (* Deceleration is set to 0 to use the axis' limit deceleration *)
    (* This is done because once an MC_Stop is commanded, it cannot  *)
    (* be aborted by another MC_Stop FBK and this can become risky *)
    (* when the deceleration of a first stop would not be high enough *)
    (* and a further MC_Stop with higher deceleration would be necessary *)
    (* Therefore, the MC_Stop is only intended as a quickstop *)
	InPosition := FALSE; (* Not necessary, but looks more logical in the watch *)
	InGear := FALSE; (* Not necessary, but looks more logical in the watch *)
    MC_Stop_0.Deceleration := 0; //pAxisCtrl.Parameter.Deceleration;
    MC_Stop_0.Execute := TRUE;
END_ACTION

ACTION Reset:
	InPosition := FALSE; (* Not necessary, but looks more logical in the watch *)
	InGear := FALSE; (* Not necessary, but looks more logical in the watch *)
    MC_Reset_0.Execute := TRUE;
END_ACTION
