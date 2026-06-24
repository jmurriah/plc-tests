
ACTION MotorsMachineState: 

	xManualMovementEnabled := 	(iSystemState=MANUAL) OR
								(iSystemState=JOGGING) OR
								(iSystemState=HOMING_STEP_1) OR
								(iSystemState=HOMING_STEP_2) OR
								(iSystemState=HOMING_STEP_3);
	
	//Check motors are positioned in desired position
	IF (iSystemState=MANUAL) OR (iSystemState=JOGGING) THEN
		AssignJogOrders;
	END_IF
	CheckAnyManualMovement;
	CheckAnyManualOrder;
	
	CheckMotorStopped;
	//CheckMotorReferenced;
	CheckMotorReady;
	CheckMotorPositioned;
	
	
	CASE iSystemState OF
			
		NOT_INITIALIZED:
			ResetMotorsCommands;			
			RemoveOrderMoveAbsolute;	
			
			IF NOT xMotorStopped THEN
				SetStopOrder;
			ELSE
				CheckControllerReady;
				IF xControllerReady THEN
					iSystemState:=POWER_ON;
				END_IF
			END_IF
	
			
		POWER_ON:
			RemoveStopOrder;
			SetPowerOn;
			CheckPowerOn;
			IF xPoweredOn THEN
				//Go directly to wait homing process
				iSystemState:=POWERED;
			END_IF
						

		POWERED:
			IF xMotorReady THEN
				iSystemState := STANDSTILL;			
			END_IF
			
					
		STANDSTILL:
			IF data.commands.Mode.xManual THEN
				iSystemState:=MANUAL;
				
			ELSIF data.commands.Mode.xAuto AND xMotorsReferenced AND data.parameters.xMovementsEnabled THEN
				iSystemState := AUTO;			
			END_IF

		
		MANUAL:
			IF EDGEPOS(data.commands.xReference) THEN
				xMotorsReferenced := FALSE;
				iSystemState := HOMING_STEP_1;
				
			ELSIF xAnyManualMovement THEN
				iSystemState:=JOGGING;
			END_IF
			
			
		JOGGING:
			CheckMotorReady;
			IF NOT xAnyManualOrder THEN
				iSystemState := STANDSTILL;
			END_IF

		
		HOMING_STEP_1:
			//To home directly if both homing sensors are active
			CheckReferencePositionReached;
			IF xReferencePositionReached AND xMotorReady THEN
				iSystemState := HOMING_STEP_2;
			END_IF
			

		HOMING_STEP_2:			
			//Execute home order
			SetHomeOrder;
			IF xMotorReady THEN
				iSystemState := HOMING_STEP_3;
			END_IF
		
		HOMING_STEP_3:
			CheckMotorReferenced;
			IF xMotorsReferenced THEN
				iSystemState := STANDSTILL;
			ELSE
				RemoveHomeOrder;
				iSystemState := HOMING_STEP_2;
			END_IF
		
			
		AUTO:
			RemoveStopOrder;
			IF xMotorReady THEN
				IF NOT xMotorsInPosition THEN
					SetOrderMoveAbsolute;
				END_IF
			ELSE
				iSystemState := NOT_INITIALIZED;
			END_IF
			
			IF data.status.xMoving THEN
				iSystemState := RUNNING;
			END_IF

			
		RUNNING:
			//If the movement is finished or the desired position has changed
			tonMotorStopped(IN:=xMotorStopped, PT:=T#500ms);
			IF xMotorsInPosition OR tonMotorStopped.Q OR data.commands.xStop THEN
				RemoveOrderMoveAbsolute;
				SetStopOrder;
				iSystemState := AUTO;
			END_IF


		ERROR:
			ResetMotorsCommands;
			//SetPowerOff;
			RemoveOrderMoveAbsolute;	
			IF NOT xMotorStopped THEN
				SetStopOrder;
			END_IF
			
			IF NOT xAnyMotorError THEN
				iSystemState:=NOT_INITIALIZED;
			END_IF
	END_CASE
	
	
	//To check motors errors
	CheckAnyError;
	
	IF NOT data.parameters.xMovementsEnabled AND ((iSystemState = RUNNING) OR (iSystemState = AUTO)) THEN 
		RemoveOrderMoveAbsolute;
		iSystemState := STANDSTILL;
	END_IF
	
	//Sending to ERROR
	IF xAnyMotorError OR data.AlSummary.xAlarmCritical THEN
		iSystemState:=ERROR;
	END_IF

	//In Zero mode it goes to not Init
	IF (data.commands.Mode.xZero) THEN 
		iSystemState:=NOT_INITIALIZED; 
	END_IF

	
	//Saving state history
	IF iSystemState<>StateHistory[0] THEN
		FOR iIndexHistory:=iHistoryLines TO 1 BY -1 DO 
			StateHistory[iIndexHistory]:=StateHistory[iIndexHistory-1];
		END_FOR
		StateHistory[0]:=iSystemState;
	END_IF
	
	//State summary
	data.status.xInPosition := xMotorsInPosition;
	data.status.xMoving := NOT xMotorStopped;
	data.status.xReferenced	:= xMotorsReferenced;
	data.status.xReferencing :=	(iSystemState=HOMING_STEP_1) OR (iSystemState=HOMING_STEP_2) OR (iSystemState=HOMING_STEP_3);
	data.status.iSystemState := iSystemState;
	
END_ACTION

ACTION ResetMotorsCommands:
	FOR iIndexIclaMotor:=1 TO iNumIclaMotors DO
		IclaMotors[iIndexIclaMotor].Command.Enable := FALSE;
		IclaMotors[iIndexIclaMotor].Command.JogBackward := FALSE;
		IclaMotors[iIndexIclaMotor].Command.JogForward := FALSE;
		IclaMotors[iIndexIclaMotor].Command.MoveAbsolute := FALSE;
	END_FOR
END_ACTION

ACTION CheckControllerReady:
	xControllerReady:=TRUE;
	FOR iIndexIclaMotor:=1 TO iNumIclaMotors DO
		IF IclaMotors[iIndexIclaMotor].Status.Error.Communication THEN
			xControllerReady:=FALSE;
		END_IF
	END_FOR
END_ACTION

ACTION SetPowerOn:
	FOR iIndexIclaMotor:=1 TO iNumIclaMotors DO
		IclaMotors[iIndexIclaMotor].Command.Enable := TRUE;
	END_FOR
END_ACTION

ACTION SetPowerOff:
	FOR iIndexIclaMotor:=1 TO iNumIclaMotors DO
		IclaMotors[iIndexIclaMotor].Command.Enable := FALSE;
	END_FOR
END_ACTION

ACTION CheckPowerOn:
	xPoweredOn:=TRUE;
	FOR iIndexIclaMotor:=1 TO iNumIclaMotors DO
		IF (IclaMotors[iIndexIclaMotor].Status.IclaStatus<>AXISILE_POWER) AND (IclaMotors[iIndexIclaMotor].Status.IclaStatus<>AXISILE_READY) THEN
			xPoweredOn:=FALSE;
		END_IF
	END_FOR
END_ACTION

ACTION CheckMotorReady:
	xMotorReady:=TRUE;
	FOR iIndexIclaMotor:=1 TO iNumIclaMotors DO
		IF (IclaMotors[iIndexIclaMotor].Status.iDriveStatus<>ICLAST_ENABLE_OPERATION) THEN
			xMotorReady:=FALSE;
		END_IF
	END_FOR
END_ACTION

ACTION SetHomeOrder:
	FOR iIndexIclaMotor:=1 TO iNumIclaMotors DO
		IF IclaMotors[iIndexIclaMotor].Status.iActualVelocity = 0 THEN 
			IclaMotors[iIndexIclaMotor].Command.Home := TRUE;
		END_IF
	END_FOR
END_ACTION

ACTION RemoveHomeOrder:
	FOR iIndexIclaMotor:=1 TO iNumIclaMotors DO
		IclaMotors[iIndexIclaMotor].Command.Home := FALSE;
	END_FOR
END_ACTION


ACTION SetOrderGoingForward:
	data.commands.xMoveForward := TRUE;
END_ACTION

ACTION RemoveOrderGoingForward:
	data.commands.xMoveForward := FALSE;
END_ACTION

ACTION SetOrderGoingBackward:
	data.commands.xMoveBackward := TRUE;
END_ACTION

ACTION RemoveOrderGoingBackward:
	data.commands.xMoveBackward := FALSE;
END_ACTION

ACTION SetOrderMoveAbsolute:
	rCopyPositionDesired := rPositionDesired;
	FOR iIndexIclaMotor:=1 TO iNumIclaMotors DO
		MotorDriveUnit.PositionDesired := data.Motor[iIndexIclaMotor].iDirection * rPositionDesired;
		MotorDriveUnit.Calculation := CALC_POS_PULSES;
		MotorDriveUnit();
		
		IclaMotors[iIndexIclaMotor].Parameter.MoveAbsolute.Position := REAL_TO_DINT(MotorDriveUnit.pulsesPositionDesired);
		IclaMotors[iIndexIclaMotor].Command.MoveAbsolute := TRUE;
	END_FOR
END_ACTION

ACTION RemoveOrderMoveAbsolute:
	FOR iIndexIclaMotor:=1 TO iNumIclaMotors DO
		IclaMotors[iIndexIclaMotor].Command.MoveAbsolute := FALSE;
	END_FOR
END_ACTION

ACTION SetStopOrder:
	FOR iIndexIclaMotor:=1 TO iNumIclaMotors DO
		IclaMotors[iIndexIclaMotor].Command.Stop := TRUE;
	END_FOR
END_ACTION

ACTION RemoveStopOrder:
	FOR iIndexIclaMotor:=1 TO iNumIclaMotors DO
		IclaMotors[iIndexIclaMotor].Command.Stop := FALSE;
	END_FOR
END_ACTION

ACTION AssignJogOrders:
	FOR iIndexIclaMotor:=1 TO iNumIclaMotors DO
		//[RGP] Ehd width fitting exit motor direction is not the same as the one on the entry side due to mechanical assembly.
		//This case does not apply to elevation motors, which are mechanically assembled the same way.
		IF iIndexPairedIclaMotors=2 AND iIndexIclaMotor=2 THEN
			IclaMotors[iIndexIclaMotor].Command.JogBackward := data.commands.xMoveForward AND NOT data.commands.xMoveBackward AND NOT data.Motor[iIndexIclaMotor].Inputs.xMinPositionReached;
			IclaMotors[iIndexIclaMotor].Command.JogForward := data.commands.xMoveBackward AND NOT data.commands.xMoveForward AND NOT data.Motor[iIndexIclaMotor].Inputs.xMaxPositionReached;
		ELSE
			IclaMotors[iIndexIclaMotor].Command.JogForward := data.commands.xMoveForward AND NOT data.commands.xMoveBackward AND NOT data.Motor[iIndexIclaMotor].Inputs.xMinPositionReached;
			IclaMotors[iIndexIclaMotor].Command.JogBackward := data.commands.xMoveBackward AND NOT data.commands.xMoveForward AND NOT data.Motor[iIndexIclaMotor].Inputs.xMaxPositionReached;
		END_IF
	END_FOR
END_ACTION

ACTION CheckAnyManualOrder:
	xAnyManualOrder := 	IclaMotors[1].Command.JogForward OR
						IclaMotors[1].Command.JogBackward OR
						IclaMotors[2].Command.JogForward OR
						IclaMotors[2].Command.JogBackward;
END_ACTION

ACTION CheckAnyManualMovement:
	xAnyManualMovement := FALSE;
	FOR iIndexIclaMotor:=1 TO iNumIclaMotors DO
		IF (IclaMotors[iIndexIclaMotor].Status.IclaStatus = AXISILE_JOG) THEN
			xAnyManualMovement := TRUE;
		END_IF
	END_FOR
END_ACTION

ACTION CheckAnyError:
	xAnyMotorError:=FALSE;
	FOR iIndexIclaMotor:=1 TO iNumIclaMotors DO
		// Not comms
		data.Motor[iIndexIclaMotor].Alarms.xCommsMotorError := FALSE;
		IF (IclaMotors[iIndexIclaMotor].Status.Error.Communication) THEN
			data.Motor[iIndexIclaMotor].Alarms.xCommsMotorError := TRUE;
		END_IF
		
		// Motor Error
		data.Motor[iIndexIclaMotor].Alarms.xMotorError := FALSE;
		IF ((IclaMotors[iIndexIclaMotor].Status.iDriveStatus = ICLAST_ERROR) OR
			IclaMotors[iIndexIclaMotor].Status.Error.ErrorNumber<>0) THEN
			data.Motor[iIndexIclaMotor].Alarms.xMotorError := TRUE;
		END_IF
		
		// Motor Error
		data.Motor[iIndexIclaMotor].Alarms.xControllerNotReady := FALSE;
		IF (IclaMotors[iIndexIclaMotor].Status.iDriveStatus = ICLAST_SWITCH_ON_DISABLED) THEN
			data.Motor[iIndexIclaMotor].Alarms.xControllerNotReady := TRUE;
		END_IF
		
	END_FOR	
END_ACTION

ACTION CheckMotorStopped:
	xMotorStopped := TRUE;
	FOR iIndexIclaMotor:=1 TO iNumIclaMotors DO
		IF (IclaMotors[iIndexIclaMotor].Status.iActualVelocity <> 0) THEN
			xMotorStopped:=FALSE;
		END_IF
	END_FOR
END_ACTION


ACTION CheckReferencePositionReached:
	IF iIndexPairedIclaMotors=1 THEN
		//Elevation motors
		xReferencePositionReached := data.Motor[1].Inputs.xMinPositionReached AND data.Motor[2].Inputs.xMinPositionReached;
	ELSE
		//Width fitting motors
		xReferencePositionReached := data.Motor[1].Inputs.xMaxPositionReached AND data.Motor[2].Inputs.xMaxPositionReached;
	END_IF
END_ACTION

ACTION CheckMotorPositioned:
	xMotorsInPosition := TRUE;
	FOR iIndexIclaMotor:=1 TO iNumIclaMotors DO
		IF (ABS(data.Motor[iIndexIclaMotor].rPositionMotor - rPositionDesired) > data.Motor[iIndexIclaMotor].rMotorResolution) THEN
			xMotorsInPosition := FALSE;
		END_IF
	END_FOR
END_ACTION

ACTION CheckMotorReferenced:
	xMotorsReferenced := TRUE;
	FOR iIndexIclaMotor:=1 TO iNumIclaMotors DO
		IF NOT IclaMotors[iIndexIclaMotor].Status.xReferenced THEN
			xMotorsReferenced := FALSE;
		ELSE
			//Distance between sensors calculated instead of being a hardware defined parameter. Just for testing, this parameters must be defined by mechanical team
			data.Motor[iIndexIclaMotor].rDistanceBetweenSensors := (ABS(data.Motor[iIndexIclaMotor].rHomePosition)*2 + gEdgeHoldDown.Hw.rMinWidthAdjustment) - (data.Motor[iIndexIclaMotor].rMeasuredPositionFrontSide + data.Motor[iIndexIclaMotor].rMeasuredPositionBackSide);
		END_IF
	END_FOR
END_ACTION
