
ACTION BlockStatePos: 

	xBlockPosChange := BlockPositionPrevious <> Block.Status.PositionState;
	BlockPositionPrevious := Block.Status.PositionState;

	CASE Block.Status.PositionState OF
		BLOCKP_UNDEFINED:
			ResetKnownPositions;
		
			
		BLOCKP_HOMING_BAR:
			
			//Aborting Block Motor homing process
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
			IF ABS(rMotorCurrentPos-rCalcPosDesPrint)>0.01 AND rMotorAbsPosDesired <> rCalcPosDesPrint THEN
				
				rMotorAbsPosDesired:= rCalcPosDesPrint;
				xMotorAbsMovOrder:= TRUE;

			END_IF
			
			Block.Status.Position.xReadyToPrint := rMotorCurrentPos = rCalcPosDesPrint;
		
		
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
		
	END_CASE
	
	
END_ACTION
