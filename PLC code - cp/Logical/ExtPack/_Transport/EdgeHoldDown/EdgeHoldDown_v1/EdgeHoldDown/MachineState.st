
ACTION MachineState: 

	data.parameters.rBarsOffset := LIMIT(data.Hw.iMinBarsOffset, data.parSw.rBarsOffset, data.Hw.iMaxBarsOffset);
	rHeighAdjustPosition := (data.parameters.rBarsHeighSp + data.parameters.rBarsOffset);
	rWidthAdjustPosition := (data.parameters.rWidthSp - data.parSw.iOverlap*2); //Multiplied by two so overlap refers to each metal band/strap
	rWidthAdjustPosition := (rWidthAdjustPosition-data.Hw.rMinWidthAdjustment)/2;
	
	//Saving ski position
	data.status.rSkiPosition := AdjustmentSystem[1].Motor[1].rPositionMotor - data.parameters.rDistanceMetalBandToSki;
	
	data.status.rBlockPrePrintingPosition := rHeighAdjustPosition*2; //Setting a big margin to avoid to damage printheads when moving ehd metal bands
	
	CheckMotorsInPosition;
	CheckMotorsInRestingPosition;
	CheckMotorsInAdjustedPosition;
	
	
	CASE iSystemState OF
		EHD_STOPPED:
			ResetSwOrders;
			
			//Resetting orders (zero state)
			data.orders.xAdjustToMedia:=FALSE;
			data.orders.xResetPosition:=FALSE;
			
			//Manual mode
			IF (data.commands.Mode.xManual) THEN 
				iSystemState:=EHD_MANUAL;
	
			//Auto
			ELSIF data.commands.Mode.xAuto AND data.status.xReferenced THEN
				iSystemState:=EHD_IDLE;
			END_IF
				
			
		EHD_MANUAL:
			//Setting parameters that depend on ehd mode
			AdjustmentSystem[1].parameters.iMisalignmentTolerance := iMisalignmentToleranceInManual;
			AdjustmentSystem[2].parameters.iMisalignmentTolerance := iMisalignmentToleranceInManual;
			
			//Logic ctrl
			ManualLogic;
			
			
		EHD_IDLE:
			//Setting parameters that depend on ehd mode
			AdjustmentSystem[1].parameters.iMisalignmentTolerance := iMisalignmentToleranceInAuto;
			AdjustmentSystem[2].parameters.iMisalignmentTolerance := iMisalignmentToleranceInAuto;
			
			//Logic ctrl
			AutoLogic;
			
			
		EHD_ERROR:
			ResetSwOrders;
			IF NOT xAnyError THEN
				iSystemState := EHD_STOPPED;
			END_IF
	END_CASE
	
	
	IF NOT data.parameters.xEnableMovements OR (iSystemState=EHD_STOPPED) THEN
		AdjustmentSystem[1].parameters.xMovementsEnabled := FALSE;
		AdjustmentSystem[2].parameters.xMovementsEnabled := FALSE;
	
	//In automatic enable depends on motor positions
	ELSIF (iSystemState=EHD_IDLE) THEN
		
															//Enable in case metal bands are not high enough to damage photocells chassis
		AdjustmentSystem[1].parameters.xMovementsEnabled :=	(AdjustmentSystem[1].Motor[1].rPositionMotor <= (data.Hw.rMaxDistanceMetalBandToBelt - iSafetyOffset)) OR
															//Enable movements in case where metal bands are not below photocells lasers
															(AdjustmentSystem[2].Motor[1].rPositionMotor <= gMachine.Pt.Hw.iWidth);
		
		AdjustmentSystem[2].parameters.xMovementsEnabled := (data.status.rSkiPosition >= (iSafetyOffset - AdjustmentSystem[2].Motor[1].rMotorResolution));
	
	ELSE
		
		AdjustmentSystem[1].parameters.xMovementsEnabled := TRUE;
		AdjustmentSystem[2].parameters.xMovementsEnabled := TRUE;
	END_IF
		
	
	//In Zero mode it goes to not Init
	IF (data.commands.Mode.xZero) THEN 
		iSystemState:=EHD_STOPPED;
		
	ELSIF xAnyError THEN
		iSystemState:=EHD_ERROR;
	END_IF

	
	//Saving state history
	IF iSystemState<>StateHistory[0] THEN
		FOR iIndexHistory:=iHistoryLines TO 1 BY -1 DO 
			StateHistory[iIndexHistory]:=StateHistory[iIndexHistory-1];
		END_FOR
		StateHistory[0]:=iSystemState;
	END_IF
	
	
	//AutoLogic ctrl
	IF iSystemState<>EHD_IDLE THEN
		iSystemAutoState := EHD_OUT_OF_AUTO;
	END_IF
	
	//State summary
	data.status.iSystemState:=iSystemState;
	data.status.xMoving := AdjustmentSystem[1].status.xMoving OR AdjustmentSystem[2].status.xMoving;
	data.status.xReferenced := AdjustmentSystem[1].status.xReferenced AND AdjustmentSystem[2].status.xReferenced;
	data.status.xReferencing := AdjustmentSystem[1].status.xReferencing OR AdjustmentSystem[2].status.xReferencing;
	data.status.xReady := data.parameters.xEnableMovements AND data.status.xEnabled;
	data.status.xAdjusting := (iSystemAutoState = EHD_ADJUSTING_STEP_1) OR (iSystemAutoState = EHD_ADJUSTING_STEP_2) OR (iSystemAutoState = EHD_ADJUSTING_STEP_3);
	data.status.xGoingRestPosition := (iSystemAutoState = EHD_RESTING_STEP_1) OR (iSystemAutoState = EHD_RESTING_STEP_2) OR (iSystemAutoState = EHD_RESTING_STEP_3);
	
	
	data.commands.xStop := FALSE;
	
END_ACTION


ACTION ManualLogic:
	IF data.parameters.xEnableMovements THEN
		//Commands
		//Reference systems
		AdjustmentSystem[1].commands.xReference:= data.commandsSw.xReference;
		AdjustmentSystem[2].commands.xReference:= data.commandsSw.xReference;
		
		//Movements
		IF NOT AdjustmentSystem[1].status.xReferencing AND NOT AdjustmentSystem[1].commands.xReference THEN
			AdjustmentSystem[1].commands.xMoveBackward := data.ordersSw.xMoveUp;
			AdjustmentSystem[1].commands.xMoveForward := data.ordersSw.xMoveDown;
		END_IF
		
		IF NOT AdjustmentSystem[2].status.xReferencing AND NOT AdjustmentSystem[2].commands.xReference THEN
			AdjustmentSystem[2].commands.xMoveBackward := data.ordersSw.xMoveBackward; //To move metal bands to the edge of the belt
			AdjustmentSystem[2].commands.xMoveForward := data.ordersSw.xMoveForward; //To move metal bands to the center of the belt
		END_IF
		
		//Alarm excessive manual commands activated 
		tonMaxTimeJogging.IN:= 	(data.ordersSw.xMoveBackward OR
								data.ordersSw.xMoveForward OR
								data.ordersSw.xMoveDown OR
								data.ordersSw.xMoveUp);
		tonMaxTimeJogging.PT:= T#5S;
		tonMaxTimeJogging();
			
		// Stopping all
		IF tonMaxTimeJogging.Q THEN
			ResetSwOrders;
		END_IF
	END_IF
	
	
	IF data.status.xReferencing THEN
		data.commandsSw.xReference := FALSE;
	END_IF
	
END_ACTION

ACTION AutoLogic:
	
	CASE iSystemAutoState OF
		
		EHD_OUT_OF_AUTO:
			iSystemAutoState := EHD_MOVEMENTS_NOT_ENABLED;
		
		EHD_MOVEMENTS_NOT_ENABLED:
			AdjustmentSystem[1].commands.xStop := TRUE;
			AdjustmentSystem[2].commands.xStop := TRUE;
			IF data.parameters.xEnableMovements THEN
				iSystemAutoState := EHD_READY;
			END_IF
			
			
		EHD_READY:
			//To review how to reset these commands using an action instead of assigning FALSE here.
			AdjustmentSystem[1].commands.xStop := FALSE;
			AdjustmentSystem[2].commands.xStop := FALSE;
			IF (EDGEPOS(data.orders.xResetPosition) OR NOT data.parSw.xEnable) AND NOT data.status.xInRestingPosition THEN
				AdjustmentSystem[1].parameters.rPositionDesired := data.parameters.rDistanceMetalBandToSki + iSafetyOffset;	
				iSystemAutoState := EHD_RESTING_STEP_1;
				
			ELSIF EDGEPOS(data.orders.xAdjustToMedia) AND NOT data.status.xAdjustedToMedia THEN
				IF AdjustmentSystem[2].parameters.rPositionDesired <> rWidthAdjustPosition THEN
					//Assigning resting position as desired position to move metal bands in cross direction				
					AdjustmentSystem[1].parameters.rPositionDesired := data.parameters.rDistanceMetalBandToSki + iSafetyOffset;	
					iSystemAutoState := EHD_ADJUSTING_STEP_1;
				ELSE
					//Going to state where desired heigh position is set as desired position to move metal bands in vertical direction	
					iSystemAutoState := EHD_ADJUSTING_STEP_2;
				END_IF
			END_IF
			
		
		EHD_ADJUSTING_STEP_1:			
			//Moving system up. Waiting to arrive to desired position	
			IF AdjustmentSystem[1].status.xInPosition THEN
				AdjustmentSystem[2].parameters.rPositionDesired := rWidthAdjustPosition;
				iSystemAutoState := EHD_ADJUSTING_STEP_2;
			END_IF	
			
		
		EHD_ADJUSTING_STEP_2:			
			//Moving system to widht adjust position. Waiting to arrive to desired position
			IF AdjustmentSystem[2].status.xInPosition THEN
				AdjustmentSystem[1].parameters.rPositionDesired := rHeighAdjustPosition;
				iSystemAutoState := EHD_ADJUSTING_STEP_3;
			END_IF
		
		
		EHD_ADJUSTING_STEP_3:			
			//Moving up system to height adjust position. Waiting to arrive to desired position
			IF AdjustmentSystem[1].status.xInPosition THEN
				iSystemAutoState := EHD_READY;
			END_IF
						
		
		EHD_RESTING_STEP_1:
			//Moving system down. Waiting to arrive to desired position
			IF AdjustmentSystem[1].status.xInPosition THEN
				AdjustmentSystem[2].parameters.rPositionDesired := AdjustmentSystem[2].parameters.rMechPositionMax;
				iSystemAutoState := EHD_RESTING_STEP_2;
			END_IF
			
			
		EHD_RESTING_STEP_2:
			//Moving system to width resting position. Waiting to arrive to desired position
			IF AdjustmentSystem[2].status.xInPosition THEN
				AdjustmentSystem[1].parameters.rPositionDesired := AdjustmentSystem[1].parameters.rMechPositionMin;
				iSystemAutoState := EHD_RESTING_STEP_3;
			END_IF
		
		
		EHD_RESTING_STEP_3:
			//Moving system to height resting position. Waiting to arrive to desired position
			IF AdjustmentSystem[1].status.xInPosition THEN
				iSystemAutoState := EHD_READY;
			END_IF	
		
	END_CASE
	
	AdjustmentSystem[1].parameters.rPositionDesired := LIMIT(AdjustmentSystem[1].parameters.rMechPositionMin,AdjustmentSystem[1].parameters.rPositionDesired, AdjustmentSystem[1].parameters.rMechPositionMax);
	AdjustmentSystem[2].parameters.rPositionDesired := LIMIT(AdjustmentSystem[2].parameters.rMechPositionMin,AdjustmentSystem[2].parameters.rPositionDesired, AdjustmentSystem[2].parameters.rMechPositionMax);
	
	//To stop process taking place when any stop alarm is raised
	iCancelMovement.0 := data.AlSummary.xAlarmStop;
	iCancelMovement.1 := data.commands.xStop;
	iCancelMovement.2 := NOT data.parameters.xEnableMovements;
	
	IF iCancelMovement>0 THEN
		iSystemAutoState := EHD_MOVEMENTS_NOT_ENABLED;
	END_IF	
	
END_ACTION

ACTION CheckMotorsInPosition:
	
	data.status.xInPosition := (ABS(AdjustmentSystem[1].parameters.rPositionDesired-AdjustmentSystem[1].Motor[1].rPositionMotor)<AdjustmentSystem[1].Motor[1].rMotorResolution) AND
								(ABS(AdjustmentSystem[1].parameters.rPositionDesired-AdjustmentSystem[1].Motor[2].rPositionMotor)<AdjustmentSystem[1].Motor[2].rMotorResolution) AND
								(ABS(AdjustmentSystem[2].parameters.rPositionDesired-AdjustmentSystem[2].Motor[1].rPositionMotor)<AdjustmentSystem[2].Motor[1].rMotorResolution) AND
								(ABS(AdjustmentSystem[2].parameters.rPositionDesired-AdjustmentSystem[2].Motor[2].rPositionMotor)<AdjustmentSystem[2].Motor[2].rMotorResolution);
END_ACTION

ACTION CheckMotorsInAdjustedPosition:
	
	data.status.xAdjustedToMedia := (ABS(rHeighAdjustPosition-AdjustmentSystem[1].Motor[1].rPositionMotor)<AdjustmentSystem[1].Motor[1].rMotorResolution) AND
									(ABS(rHeighAdjustPosition-AdjustmentSystem[1].Motor[2].rPositionMotor)<AdjustmentSystem[1].Motor[2].rMotorResolution) AND
									(ABS(rWidthAdjustPosition-AdjustmentSystem[2].Motor[1].rPositionMotor)<AdjustmentSystem[2].Motor[1].rMotorResolution) AND
									(ABS(rWidthAdjustPosition-AdjustmentSystem[2].Motor[2].rPositionMotor)<AdjustmentSystem[2].Motor[2].rMotorResolution);
END_ACTION

ACTION CheckMotorsInRestingPosition:
	
	data.status.xInRestingPosition := (ABS(AdjustmentSystem[1].parameters.rMechPositionMin-AdjustmentSystem[1].Motor[1].rPositionMotor)<AdjustmentSystem[1].Motor[1].rMotorResolution) AND
										(ABS(AdjustmentSystem[1].parameters.rMechPositionMin-AdjustmentSystem[1].Motor[2].rPositionMotor)<AdjustmentSystem[1].Motor[2].rMotorResolution) AND
										(ABS(AdjustmentSystem[2].parameters.rMechPositionMax-AdjustmentSystem[2].Motor[1].rPositionMotor)<AdjustmentSystem[2].Motor[1].rMotorResolution) AND
										(ABS(AdjustmentSystem[2].parameters.rMechPositionMax-AdjustmentSystem[2].Motor[2].rPositionMotor)<AdjustmentSystem[2].Motor[2].rMotorResolution);
END_ACTION