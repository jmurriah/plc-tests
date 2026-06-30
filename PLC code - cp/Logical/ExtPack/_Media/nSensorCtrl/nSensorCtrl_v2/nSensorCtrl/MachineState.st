
ACTION MachineState: 

	//Alignment photocells process
	tonAlignmentProcess.IN := (data.status.iSystemState=STP_CHECK_ALIGNMENT_STEP_3);
	tonAlignmentProcess.PT := t#2S;
	tonAlignmentProcess();
	
	CASE data.status.iSystemState OF
			
		STP_NOT_INITIALIZED:
			ResetCommands;
			ResetPhotocellAlignment;
			data.status.xReferencing :=	FALSE;
			
			IF NOT data.status.xReferenced THEN
				data.status.xSensorValidAlignPos := data.parameters.AlignmentProcess = STP_ALIGNMENT_NO_REQUIRED;
			END_IF
			
			RemoveOrderMoveAbsolute;
			SetStopOrder;
			IF xMotorStopped THEN
				RemoveStopOrder;
				CheckControllerReady;
				IF xControllerReady THEN
					data.status.iSystemState:=STP_POWER_ON;
				END_IF
			END_IF
	
		STP_POWER_ON:
			SetPowerOn;
			// It does HomeDirect to steppers when are power up is done
			CheckPowerOn;
			CASE data.parameters.MotorType OF
				STP_STEPPER:
					IF xPoweredOn AND NOT data.status.xReferenced THEN
						// Home Direct to enable movements
						data.status.iSystemState:=STP_HOME_DIR;
				
						// When Phocells are referenced and return from Zero (Man or Auto)
					ELSIF Stepper.Status.PowerOn AND StepperGear.Status.PowerOn AND data.status.xReferenced AND StepperGear.Status.PLCopenState.StandStill THEN 
						data.status.iSystemState:=STP_GEARING;
					END_IF
				STP_ICLA:
					IF xPoweredOn THEN
						//Go directly to wait homing process
						data.status.iSystemState:=STP_GEARED;
					END_IF
			END_CASE
			
		STP_HOME_DIR:
			// Home position. Just send the order when the axis is ready
			IF Stepper.Status.PLCopenState.StandStill THEN
				Stepper.Parameter.HomePosition:=30;
				Stepper.Command.HomeDirect:=TRUE; 
			END_IF
			IF StepperGear.Status.PLCopenState.StandStill THEN
				StepperGear.Parameter.HomePosition:=30;								
				StepperGear.Command.HomeDirect:=TRUE;
			END_IF
			
			IF Stepper.Status.HomeOK AND StepperGear.Status.HomeOK THEN
				data.status.iSystemState:=STP_GEARING;
			END_IF
						
		STP_GEARING:		
			StepperGear.Parameter.GearRatioNum:=1;
			StepperGear.Parameter.GearRationDen:=1;

			IF StepperGear.Status.PLCopenState.StandStill THEN
				StepperGear.Command.Move.GearIn:=TRUE;
			ELSIF StepperGear.Status.PLCopenState.SynchronizedMotion THEN
				data.status.iSystemState:=STP_GEARED;
			END_IF
			

		STP_GEARED:
			IF EDGEPOS(data.commandsSw.xReference) AND data.status.xAllPhotoInactive THEN
				data.commandsSw.xReference := FALSE;
				data.status.iSystemState := STP_HOMING_STEP_1;
			END_IF
			
			CheckMotorReady;
			IF data.status.xReferenced AND xMotorReady THEN
				CASE data.parameters.AlignmentProcess OF
					STP_ALIGNMENT_NO_REQUIRED:
						data.status.iSystemState := STP_STANDSTILL;
							
					STP_ALIGNMENT_REQUIRED:
						IF data.status.xSensorValidAlignPos THEN
							data.status.iSystemState := STP_STANDSTILL;
						ELSIF data.status.xReferencing THEN
							data.status.iSystemState := STP_SEARCH_ALIGNMENT_POS_STEP_1;
						END_IF
				END_CASE
			END_IF
					
			IF xMotorReady AND data.commands.Mode.xManual AND 
				(data.ordersSw.xMoveDown OR data.ordersSw.xMoveUp) THEN
				data.status.iSystemState:=STP_JOGGING;
			END_IF	
			
		STP_HOMING_STEP_1:
			data.status.xReferencing := TRUE;
			data.status.xReferenced	:= FALSE;
			
			IF data.parameters.xHomingEnabled THEN
			
				SetOrderGoingDown;
	
				//Stop going down when sensor to reference detects
				IF data.Inputs.Signals.xPhotoCells[data.parameters.iSensorToReference] THEN
					RemoveOrderGoingDown; // Launched stop movement
	
					//Once the jog is finished, we need to move up slowly to get the real position
					CheckMotorReady;
					IF xMotorReady THEN
						data.status.iSystemState := STP_HOMING_STEP_2;
					END_IF			
				END_IF
			END_IF
			

		STP_HOMING_STEP_2:
			SetOrderGoingUp; // Launched movement
			
			//Moving slowly up to get the sensor again
			IF NOT data.Inputs.Signals.xPhotoCells[data.parameters.iSensorToReference] THEN
				// Movements finished
				RemoveOrderGoingUp; // Launched stop movement
				data.Alarms.xIncoherPhotocellSystem := FALSE;

				//Once the jog is finished, we need to gearOut to be able to do the Homing
				CheckMotorReady;
				IF xMotorReady THEN
				
					CASE data.parameters.MotorType OF
						STP_STEPPER:
							//Calculate the pulses of the HomingPosition
							MotorDriveUnit.HomePositionDesired:=data.parSw.rThicknessReference;
							MotorDriveUnit.Calculation:=CALC_HOMEPOS_PULSES;
							MotorDriveUnit();
							
							Stepper.Parameter.HomePosition := MotorDriveUnit.pulsesHomePositionDesired;
							StepperGear.Parameter.HomePosition := Stepper.Parameter.HomePosition;
							StepperGear.Command.Move.GearOut := TRUE;
							data.status.iSystemState := STP_HOMING_STEP_3;
													
						STP_ICLA:
							//Calculate the pulses of the HomingPosition
							MotorDriveUnit.HomePositionDesired:=(-1) * data.parSw.rThicknessReference;
							MotorDriveUnit.Calculation:=CALC_HOMEPOS_PULSES;
							MotorDriveUnit();
							
							IF Icla.Status.iActualVelocity = 0 THEN 
								Icla.Parameter.Home.Position := REAL_TO_DINT(MotorDriveUnit.pulsesHomePositionDesired);
								Icla.Command.Home := TRUE;
							END_IF
						
							IF Icla.Status.xReferenced THEN data.status.iSystemState := STP_HOMING_STEP_3; END_IF
				
					END_CASE
				END_IF			
			END_IF			
			

		STP_HOMING_STEP_3:
			CASE data.parameters.MotorType OF
				STP_STEPPER:
					//Send a QuickStop to avoid the ContinuousMotion status after the GearOut
					StepperGear.Command.QuickStop := StepperGear.Status.PLCopenState.ContinuousMotion;
			
					IF Stepper.Status.PLCopenState.StandStill AND StepperGear.Status.PLCopenState.StandStill THEN
						// Home Direct	
						Stepper.Command.HomeDirect:=TRUE;
						StepperGear.Command.HomeDirect:=TRUE;
						data.status.iSystemState := STP_HOMING_STEP_4;
					END_IF
							
				STP_ICLA:
					IF ABS(rPositionMotorMm - data.parSw.rThicknessReference) < 0.10 THEN
						//data.status.xReferencing := FALSE;
						data.status.xReferenced	:= TRUE;
						data.status.iSystemState := STP_GEARED;
					ELSE
						Icla.Command.Home := FALSE;
						data.status.iSystemState := STP_HOMING_STEP_2;
					END_IF
			END_CASE
			

		STP_HOMING_STEP_4:
			IF EDGEPOS(Stepper.Status.HomeOK AND StepperGear.Status.HomeOK) THEN
				data.status.xReferencing := FALSE;
				data.status.xReferenced	:= TRUE;
				data.status.iSystemState := STP_GEARING;
			END_IF
		
		
		STP_SEARCH_ALIGNMENT_POS_STEP_1:
			xAlignmentPositionSet := FALSE;
			SetOrderGoingUp;
			// Gauge is going to be higher than this position. Checking SensorToReference state from it.
			IF (rPositionMotorMm > data.parameters.rSensorPositionSearchAlignment) AND (data.Inputs.Signals.xPhotoCells[data.parameters.iSensorToReference]) THEN
				RemoveOrderGoingUp; // Launched stop movement
				data.status.iSystemState := STP_SEARCH_ALIGNMENT_POS_STEP_2;
			END_IF
		
			
		STP_SEARCH_ALIGNMENT_POS_STEP_2:
			SetOrderGoingUp; //Moving slowly up to get the sensor again
			IF NOT data.Inputs.Signals.xPhotoCells[data.parameters.iSensorToReference] THEN
				RemoveOrderGoingUp; // Launched stop movement
				rSensorPositionAlignmentMin := rPositionMotorMm;
				data.status.iSystemState := STP_SEARCH_ALIGNMENT_POS_STEP_3;
			END_IF
		
		
		STP_SEARCH_ALIGNMENT_POS_STEP_3:
			SetOrderGoingUp; //Moving slowly up to get the sensor again
			IF (data.Inputs.Signals.xPhotoCells[data.parameters.iSensorToReference]) THEN
				RemoveOrderGoingUp; // Launched stop movement
				rSensorPositionAlignmentMax := rPositionMotorMm;
				SetAlignmentPosition;
				data.status.rSensorPositionAlignment := rSensorPositionAlignment;
				data.status.xReferencing := FALSE;
				data.status.iSystemState := STP_STANDSTILL;
			END_IF
			
					
		STP_STANDSTILL:
			CheckAnyManualOrder;
			IF EDGEPOS(data.commandsSw.xReference) AND data.status.xAllPhotoInactive THEN
				data.commandsSw.xReference	:= FALSE;
				data.status.xReferenced	:= FALSE;
				data.status.xSensorValidAlignPos := FALSE;
				data.status.iSystemState	:= STP_HOMING_STEP_1;
				
			ELSIF data.commands.Mode.xManual AND xAnyManualOrder THEN
				data.status.iSystemState:=STP_JOGGING;
				
			ELSIF data.commands.Mode.xAuto THEN
				CASE data.parameters.AlignmentProcess OF
					STP_ALIGNMENT_NO_REQUIRED:
						data.status.iSystemState := STP_AUTO;
							
					STP_ALIGNMENT_REQUIRED:
						//First time machine goes to AUTO mode, to check alignment
						IF  data.status.xSensorValidAlignPos AND (NOT data.status.xAlignmentChecked) THEN
							data.status.iSystemState := STP_CHECK_ALIGNMENT_STEP_1;
							
						ELSIF data.status.xAlignmentChecked THEN
							data.status.iSystemState := STP_AUTO;
						END_IF
				END_CASE
			END_IF

			
		STP_JOGGING:
			// Stopping all
			IF tonMaxTimeJogging.Q THEN
				data.ordersSw.xMoveDown		:=	FALSE;
				data.ordersSw.xMoveUp		:=	FALSE;	
			END_IF

			AssignJogOrders;
			
			CheckMotorReady;
			CheckAnyManualOrder;
			IF data.status.xReferenced AND xMotorReady AND NOT xAnyManualOrder THEN
				data.status.iSystemState	:= STP_STANDSTILL;
				
			ELSIF NOT data.status.xReferenced AND xMotorReady AND NOT xAnyManualOrder THEN
				data.status.iSystemState	:= STP_GEARED;
				
			END_IF

			
		STP_AUTO:
			IF NOT data.status.xInPosition THEN
				IF data.parameters.MotorType = STP_STEPPER THEN
					MotorDriveUnit.PositionDesired := rSensorPositionDesired;
				ELSE
					MotorDriveUnit.PositionDesired := (-1) * rSensorPositionDesired;
				END_IF
				MotorDriveUnit.Calculation := CALC_POS_PULSES;
				MotorDriveUnit();
				SetOrderMoveAbsolute;
				data.status.iSystemState := STP_RUNING;
			END_IF

						
		STP_CHECK_ALIGNMENT_STEP_1:
			//When the movement is finished
			IF data.parameters.MotorType = STP_STEPPER THEN
				MotorDriveUnit.PositionDesired := rSensorPositionAlignment;
			ELSE
				MotorDriveUnit.PositionDesired := (-1) * rSensorPositionAlignment;
			END_IF
			MotorDriveUnit.Calculation := CALC_POS_PULSES;
			MotorDriveUnit();
			SetOrderMoveAbsolute;
			data.status.iSystemState := STP_CHECK_ALIGNMENT_STEP_2;
			
			
		STP_CHECK_ALIGNMENT_STEP_2:
			//When the movement is finished
			IF (ABS(rPositionMotorMm-rSensorPositionAlignment)<0.25)  THEN
				data.status.iSystemState := STP_CHECK_ALIGNMENT_STEP_3;
			END_IF
			
			//Sensor alignment checking process cancelled when print order is set
			ReviewCancelCheckAlignment;
			
		STP_CHECK_ALIGNMENT_STEP_3:			
			IF tonAlignmentProcess.Q THEN
				CheckPhotocellsAlignment;
				tonAlignmentProcess(IN := FALSE); //Clean the timer for next time in this stage
			
			//Due to issue DELOREAN-1129. Motor stays in this state. To exit, go to zero mode, then "xAlignmentChecked" is set to FALSE check process is executed when going to auto again.
			ELSIF data.status.xAlignmentChecked THEN
				data.status.iSystemState := STP_CHECK_ALIGNMENT_STEP_4;
			END_IF
		
			//Sensor alignment checking process cancelled when print order is set
			ReviewCancelCheckAlignment;
		
		STP_CHECK_ALIGNMENT_STEP_4:
			IF (NOT data.Alarms.xAlrCriticalPhotocellNotAligned) OR data.commands.Mode.xZero THEN
				data.status.iSystemState := STP_CHECK_ALIGNMENT_STEP_5;
			ELSIF data.commands.xErrorRst THEN
				ResetPhotocellAlignment;
				data.status.iSystemState := STP_CHECK_ALIGNMENT_STEP_3;
			END_IF
			
		STP_CHECK_ALIGNMENT_STEP_5:
			// Code from AUTO (previously from STP_CHECK_ALIGNMENT_STEP_4 to StandStill>>Auto
			IF NOT data.status.xInPosition THEN
				IF data.parameters.MotorType = STP_STEPPER THEN
					MotorDriveUnit.PositionDesired := rSensorPositionDesired;
				ELSE
					MotorDriveUnit.PositionDesired := (-1) * rSensorPositionDesired;
				END_IF
				MotorDriveUnit.Calculation := CALC_POS_PULSES;
				MotorDriveUnit();
				SetOrderMoveAbsolute;
				data.status.iSystemState := STP_CHECK_ALIGNMENT_STEP_6;
			END_IF

		STP_CHECK_ALIGNMENT_STEP_6:
			// Code from RUNNING. Previously from Auto>>Running
			//If the movement is finished or the desired position has changed
			tonMotorStopped(IN:=xMotorStopped, PT:=T#500ms);
			IF (data.status.xInPosition OR tonMotorStopped.Q) THEN
				RemoveOrderMoveAbsolute;
				data.status.iSystemState := STP_AUTO;
				tonMotorStopped(IN:=FALSE);
			END_IF
			
		STP_RUNING:
			//If the movement is finished or the desired position has changed
			tonMotorStopped(IN:=xMotorStopped, PT:=T#500ms);
			IF (data.status.xInPosition OR tonMotorStopped.Q) THEN
				RemoveOrderMoveAbsolute;
				data.status.iSystemState := STP_AUTO;
				tonMotorStopped(IN:=FALSE);
			END_IF


		STP_ERROR:
			ResetCommands;
			SetPowerOff;
			
			IF data.parameters.MotorType = STP_STEPPER THEN
				Stepper.Command.Reset := Stepper.Status.ControllerReady AND Stepper.Status.ErrorID<>0 AND data.commands.xErrorRst;
				Stepper.Command.ErrorAcknowledge :=	Stepper.Status.ErrorID<>0 AND data.commands.xErrorRst;
	
				StepperGear.Command.Reset := StepperGear.Status.ControllerReady AND StepperGear.Status.ErrorID<>0 AND data.commands.xErrorRst;
				StepperGear.Command.ErrorAcknowledge := StepperGear.Status.ErrorID<>0 AND data.commands.xErrorRst;
			END_IF

			data.status.xReferencing :=	FALSE;

			IF NOT data.status.xMotorError THEN data.status.iSystemState:=STP_NOT_INITIALIZED; END_IF;


	END_CASE
	
	//Sending nLaser to ERROR
	CASE data.parameters.MotorType OF
		STP_STEPPER:
			// Force state in Error/Zero state
			IF ((xAnyErrorStepper OR data.AlSummary.xAnyAlarm) AND (Stepper.Status.ErrorID<>31221)) OR tonTimeOutGearing.Q THEN
				data.status.iSystemState:=STP_ERROR;
			END_IF
		
		STP_ICLA:
			IF ((Icla.Status.iDriveStatus = ICLAST_ERROR) OR data.AlSummary.xAnyAlarm) THEN
				data.status.iSystemState:=STP_ERROR;
			END_IF
	END_CASE

	//In Zero mode it goes to not Init
	IF (data.commands.Mode.xZero) THEN 
		data.status.iSystemState:=STP_NOT_INITIALIZED; 
	END_IF;
	
	iReasonCheckingAlignment.0 := data.status.iSystemState = STP_CHECK_ALIGNMENT_STEP_1;
	iReasonCheckingAlignment.1 := data.status.iSystemState = STP_CHECK_ALIGNMENT_STEP_2;
	iReasonCheckingAlignment.2 := data.status.iSystemState = STP_CHECK_ALIGNMENT_STEP_3;
	iReasonCheckingAlignment.3 := data.status.iSystemState = STP_CHECK_ALIGNMENT_STEP_4;
	iReasonCheckingAlignment.4 := data.status.iSystemState = STP_CHECK_ALIGNMENT_STEP_5;
	iReasonCheckingAlignment.5 := data.status.iSystemState = STP_CHECK_ALIGNMENT_STEP_6;
	data.status.xCheckingAlignment := iReasonCheckingAlignment > 0;
	
	//Silvia: delay gearing motors.
	tonTimeOutGearing.IN:=data.status.iSystemState=STP_GEARING;
	tonTimeOutGearing.PT:=t#4s;
	tonTimeOutGearing();

	//Alarm excessive photecell activated 
	tonMaxTimeJogging.IN:= (data.ordersSw.xMoveDown OR data.ordersSw.xMoveUp);
	tonMaxTimeJogging.PT:= T#5S;
	tonMaxTimeJogging();
	
	//Saving state history
	IF data.status.iSystemState<>StateHistory[0] THEN
		FOR iIndexHistory:=iHistoryLines TO 1 BY -1 DO 
			StateHistory[iIndexHistory]:=StateHistory[iIndexHistory-1];
		END_FOR;
		StateHistory[0]:=data.status.iSystemState;
	END_IF
	
END_ACTION

ACTION ResetCommands: 
	IF data.parameters.MotorType = STP_STEPPER THEN
		StepperGear.Command.Power      := FALSE;
		Stepper.Command.QuickStop	   := FALSE;
		StepperGear.Command.QuickStop  := FALSE;
		Stepper.Command.Jog.ContinuousPos	:=	FALSE;
		Stepper.Command.Jog.ContinuousNeg	:=	FALSE;
	ELSIF data.parameters.MotorType = STP_ICLA THEN
		Icla.Command.Enable := FALSE;
		Icla.Command.JogBackward := FALSE;
		Icla.Command.JogForward := FALSE;
		Icla.Command.MoveAbsolute := FALSE;
	END_IF
	data.commandsSw := ResetCommandsSw;
END_ACTION

ACTION CheckControllerReady:
	CASE data.parameters.MotorType OF
		STP_STEPPER:
			xControllerReady := Stepper.Status.ControllerReady AND StepperGear.Status.ControllerReady;
		STP_ICLA:
			xControllerReady := NOT Icla.Status.Error.Communication;
	END_CASE
END_ACTION

ACTION SetPowerOn:
	CASE data.parameters.MotorType OF
		STP_STEPPER:
			Stepper.Command.Power:=TRUE;
			StepperGear.Command.Power:=TRUE;
		STP_ICLA:
			Icla.Command.Enable := TRUE;
	END_CASE
END_ACTION

ACTION SetPowerOff:
	CASE data.parameters.MotorType OF
		STP_STEPPER:
			Stepper.Command.Power:=FALSE;
			StepperGear.Command.Power:=FALSE;
		STP_ICLA:
			Icla.Command.Enable := FALSE;
	END_CASE
END_ACTION

ACTION CheckPowerOn:
	CASE data.parameters.MotorType OF
		STP_STEPPER:
			xPoweredOn := Stepper.Status.PowerOn AND StepperGear.Status.PowerOn;
		STP_ICLA:
			xPoweredOn := Icla.Status.IclaStatus = AXISILE_POWER OR Icla.Status.IclaStatus = AXISILE_READY;
	END_CASE
END_ACTION

ACTION CheckMotorReady:
	CASE data.parameters.MotorType OF
		STP_STEPPER:
			xMotorReady := Stepper.Status.PLCopenState.StandStill AND StepperGear.Status.PLCopenState.SynchronizedMotion;
		STP_ICLA:
			xMotorReady := Icla.Status.iDriveStatus = ICLAST_ENABLE_OPERATION;
	END_CASE
END_ACTION

ACTION SetOrderGoingDown:
	CASE data.parameters.MotorType OF
		STP_STEPPER:
			Stepper.Command.Jog.ContinuousNeg := TRUE;

		STP_ICLA:
			Icla.Command.JogForward := TRUE;
	END_CASE
END_ACTION

ACTION RemoveOrderGoingDown:
	CASE data.parameters.MotorType OF
		STP_STEPPER:
			Stepper.Command.Jog.ContinuousNeg := FALSE;

		STP_ICLA:
			Icla.Command.JogForward := FALSE;
	END_CASE
END_ACTION

ACTION SetOrderGoingUp:
	CASE data.parameters.MotorType OF
		STP_STEPPER:
			Stepper.Command.Jog.ContinuousPos := TRUE;

		STP_ICLA:
			Icla.Command.JogBackward := TRUE;
	END_CASE
END_ACTION

ACTION RemoveOrderGoingUp:
	CASE data.parameters.MotorType OF
		STP_STEPPER:
			Stepper.Command.Jog.ContinuousPos := FALSE;

		STP_ICLA:
			Icla.Command.JogBackward := FALSE; 
	END_CASE
END_ACTION

ACTION SetOrderMoveAbsolute:
	CASE data.parameters.MotorType OF
		STP_STEPPER:
			Stepper.Parameter.Position := MotorDriveUnit.pulsesPositionDesired;
			Stepper.Command.Move.Absolute := TRUE;

		STP_ICLA:
			Icla.Parameter.MoveAbsolute.Position := REAL_TO_DINT(MotorDriveUnit.pulsesPositionDesired);
			Icla.Command.MoveAbsolute := TRUE;
	END_CASE
END_ACTION

ACTION RemoveOrderMoveAbsolute:
	CASE data.parameters.MotorType OF
		STP_STEPPER:
			Stepper.Command.Move.Absolute := FALSE;

		STP_ICLA:
			Icla.Command.MoveAbsolute := FALSE;
						
	END_CASE
END_ACTION

ACTION SetStopOrder:
	CASE data.parameters.MotorType OF
		STP_STEPPER:
			Stepper.Command.QuickStop := TRUE;

		STP_ICLA:
			Icla.Command.Stop := TRUE;
						
	END_CASE
END_ACTION

ACTION RemoveStopOrder:
	CASE data.parameters.MotorType OF
		STP_STEPPER:
			Stepper.Command.QuickStop := FALSE;

		STP_ICLA:
			Icla.Command.Stop := FALSE;
						
	END_CASE
END_ACTION

ACTION AssignJogOrders:
	CASE data.parameters.MotorType OF
		STP_STEPPER:
			Stepper.Command.Jog.ContinuousPos	:=	data.ordersSw.xMoveUp;
			Stepper.Command.Jog.ContinuousNeg	:=	data.ordersSw.xMoveDown AND NOT Stepper.Command.Jog.ContinuousPos;

		STP_ICLA:
			Icla.Command.JogForward := data.ordersSw.xMoveDown AND NOT data.ordersSw.xMoveUp;
			Icla.Command.JogBackward := NOT data.ordersSw.xMoveDown AND data.ordersSw.xMoveUp;

	END_CASE
END_ACTION

ACTION CheckAnyManualOrder:
	xAnyManualOrder := data.ordersSw.xMoveUp OR data.ordersSw.xMoveDown;
END_ACTION

ACTION SetAlignmentPosition:
	rSensorPositionAlignment := (rSensorPositionAlignmentMax + rSensorPositionAlignmentMin)/2;
	data.status.xSensorValidAlignPos := (data.parameters.rSensorMechPositionAlignmentMin < rSensorPositionAlignment) AND (rSensorPositionAlignment < data.parameters.rSensorMechPositionAlignmentMax);
	xAlignmentPositionSet := rSensorPositionAlignment>0;
END_ACTION

ACTION CheckPhotocellsAlignment:
	FOR iIndexSensor:=1 TO data.parameters.iSensorQuantity DO
		data.status.xPhotoCellsNotAligned[iIndexSensor] := data.Inputs.Signals.xPhotoCells[iIndexSensor];
	END_FOR
	
	data.status.xAlignmentChecked := TRUE;
END_ACTION

ACTION ResetPhotocellAlignment:
	data.status.xAlignmentChecked := FALSE;
END_ACTION

ACTION CancelAlignment:
	data.status.xAlignmentChecked := TRUE;
END_ACTION

ACTION ReviewCancelCheckAlignment:
	IF (data.commands.xCancelAlignmentCheck) THEN
		CancelAlignment;
		RemoveOrderMoveAbsolute; //Allow a new edge and going to final position
		SetStopOrder;
		IF xMotorStopped THEN
			RemoveStopOrder;
			data.status.iSystemState:=STP_STANDSTILL;
		END_IF
	END_IF
END_ACTION
