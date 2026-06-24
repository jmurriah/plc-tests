
ACTION BlockStatePos: 

	// If not in AUTO or MANUAL, no action in this section
	IF Block.Status.BlockState <> BLOCK_MANUAL AND Block.Status.BlockState <> BLOCK_AUTO THEN
		BlockPositionPrevious := BLOCKP_UNDEFINED;
		//These actions were executed originally in "BLOCKP_HOMING_BAR" and "BLOCKP_HOMING_ICLA" states respectively.
		//One of the conditions to execute it was to be in zero state, but the CASE below is not executed when in zero state
		//so adding these actions here before the RETURN
		ResetHomingBar;
		ResetHomingIcla;
		RETURN;
	END_IF
	
	xBlockPosChange := BlockPositionPrevious <> Block.Status.PositionState;
	BlockPositionPrevious := Block.Status.PositionState;

	CASE Block.Status.PositionState OF
		BLOCKP_UNDEFINED:
			ResetKnownPositions;
			AxisBK.Command.QuickStop := FALSE;
			
		BLOCKP_HOMING_ICLA:
			
			//Aborting Icla homing process
			IF (EDGEPOS(Block.commands.xIclaHomeOrderInterrupt) OR Block.commands.Mode.xZero OR IclaBK.Status.xInError) THEN // When printerr is St zero
				ResetHomingIcla;
				Block.Status.PositionState := BLOCKP_UNDEFINED;
			END_IF	
			
			HomingIcla;
			IF Block.Status.Icla.xHomed THEN
				Block.Status.PositionState := BLOCKP_UNDEFINED;
			END_IF
			
			
		BLOCKP_HOMING_BAR:
			
			//Aborting Block Motor homing process
			iCancelHomingBar.0 := NOT Block.In.xIclaSensor OR NOT Block.In.xTrayOut;
			iCancelHomingBar.1 := NOT Block.In.xTrayOut;
			iCancelHomingBar.2 := Block.AlSummary.xAlarmCritical;
			iCancelHomingBar.3 := Block.commands.Mode.xZero;
			iCancelHomingBar.4 := NOT Block.commands.xBarHomeOrder;
			IF iCancelHomingBar > 0 THEN
				ResetHomingBar;
				Block.Status.PositionState := BLOCKP_UNDEFINED;
			END_IF			
			
			HomingBar;
			IF Block.Status.Motor.xBarsHomed THEN
				Block.Status.PositionState := BLOCKP_UNDEFINED;
			END_IF
			
			
		BLOCKP_IN_CAP:
		
		
		BLOCKP_IN_PRINT:
			
			//Send and adjustment in position if needed
			IF ABS(rMotorCurrentPos-rCalcPosDesPrint)>0.01 AND ABS(rMotorAbsPosDesired - rCalcPosDesPrint)>0.01 THEN
				rMotorAbsPosDesiredPrevious := rMotorAbsPosDesired;
				rMotorAbsPosDesired:= rCalcPosDesPrint;
				MoveAbsolute;
			END_IF				
			Block.Status.Position.xReadyToPrint := NOT Block.commands.xForcePreprintingPos;
			
		
		BLOCKP_CLEANING:
			Cleaning;
			
			//Manage cancelling a cleaning
			iCancelCleaning.0 := Block.AlSummary.xAlrSafetySystemGeneral;
			iCancelCleaning.1 := Block.Al.xAlrSafetySystemInBlock;
			iCancelCleaning.2 := Block.Al.xAnyVerticalDriveAlarm;
			iCancelCleaning.3 := Block.Al.xAlrCleanMotor;
			iCancelCleaning.4 := Block.Al.xAlrTraySensor;
			iCancelCleaning.5 := Block.Al.xAlAirVenturi;
			iCancelCleaning.6 := Block.AlSummary.xAlarmStop;
			iCancelCleaning.7 := Block.AlSummary.xAnyAlarm;
			iCancelCleaning.8 := Block.Al.xAlrFrontCurtain;
			iCancelCleaning.9 := Block.Al.xAlrFrontSafety;
			iCancelCleaning.10 := Block.Al.xAlrRearSafety;
			iCancelCleaning.11 := Block.commands.xCleanStop;
			iCancelCleaning.12 := Block.Al.xNoActionDangerCollision;
			IF EDGEPOS(iCancelCleaning > 0) THEN
				iSaveReason := iCancelCleaning;
				iSaveState := nState;
				ResetCleanCycle;
				xCleanInterrupt:=TRUE;
				Block.Status.PositionState := BLOCKP_GOING_TO_CAP;
			END_IF
			

		
		BLOCKP_GOING_TO_CAP:
			GoingToCap;
			IF xInCap THEN
				Block.Status.PositionState := BLOCKP_IN_CAP;
			END_IF
			
		BLOCKP_GOING_TO_PRINT:
			GoingToPrint;
			IF xInPrint THEN
				Block.Status.PositionState := BLOCKP_IN_PRINT;
			END_IF

		BLOCKP_GOING_TO_CLEAN:
			GoingToClean;
			IF xInClean THEN
				Block.Status.PositionState := BLOCKP_IN_CLEAN;
			END_IF
		
	END_CASE
	
	Block.Status.Motor.rMotorAbsPosDesired := rMotorAbsPosDesired;
	
	//Saving state history
	IF Block.Status.PositionState<>StatePosHistory[0] THEN
		ShiftArrayForward(ADR(StatePosHistory), SIZEOF(StatePosHistory), SIZEOF(StatePosHistory[0]), 1, iHistoryLines);
		StatePosHistory[0]:=Block.Status.PositionState;
	END_IF
	
END_ACTION
