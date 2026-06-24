
ACTION AlarmsSummary: 
	
	//////////////////////////
	////// RESET ALARMS //////
	//////////////////////////	
	// Pending do commands gdata.commands.xReset
	IF data.commands.xErrorRst THEN
		data.Alarms := stnSensorsAlarmsReseted;
		data.AlSummary := stnSensorsAlarmSummaryReseted;
	END_IF
	
	//Invalid positions
	data.Alarms.xAlrInvalidAlignmentPosition:= NOT data.status.xSensorValidAlignPos AND (data.parameters.AlignmentProcess = STP_ALIGNMENT_REQUIRED);
	
	//MaxPositionReached just while searching alignement
	iStateToCheckPosition.0 := data.status.iSystemState = STP_SEARCH_ALIGNMENT_POS_STEP_1;
	iStateToCheckPosition.1 := data.status.iSystemState = STP_SEARCH_ALIGNMENT_POS_STEP_2;
	iStateToCheckPosition.2 := data.status.iSystemState = STP_SEARCH_ALIGNMENT_POS_STEP_3;
	iStateToCheckPosition.3 := data.status.iSystemState = STP_RUNING AND data.status.xReferenced;
	iStateToCheckPosition.4 := data.status.iSystemState = STP_STANDSTILL;
	
	IF iStateToCheckPosition > 0 THEN 
		iLastStateToCheckPosition := iStateToCheckPosition;
	
		IF ((rPositionMotorMm > data.parameters.rSensorMechPositionMax) OR (rPositionMotorMm < data.parameters.rSensorMechPositionMin)) THEN
			data.Alarms.xPositionOutOfRange := TRUE;
		END_IF
	END_IF
	
	IF NOT data.Alarms.xAlrInvalidAlignmentPosition THEN
		//Operational photocells must be evaluated too: detecting ones and first enabled for mounted alarm
		FOR iIndexSensor:=1 TO data.parameters.iSensorQuantity DO
			IF data.status.xPhotoCellsNotAligned[iIndexSensor] THEN 
				IF ((NOT data.parameters.Sensors[iIndexSensor].xMountedMedia) OR (NOT data.parameters.Sensors[iIndexSensor-1].xMountedMedia)) THEN
					data.Alarms.xAlrCriticalPhotocellNotAligned:= TRUE;
					data.Alarms.xPhotoCellsNotAlignedWarning[iIndexSensor]:= FALSE;
					data.Alarms.xPhotoCellsNotAlignedError[iIndexSensor]:= TRUE;
				ELSE
					data.Alarms.xPhotoCellsNotAlignedWarning[iIndexSensor]:= TRUE;
					data.Alarms.xPhotoCellsNotAlignedError[iIndexSensor]:= FALSE;
				END_IF
			END_IF
		END_FOR
	END_IF
	
	//Alarm Not referenced
	data.Alarms.xNotReferenced:= NOT data.status.xReferenced;
	
	
	// Incoherence Photocells system
	data.status.xSensorsSeparatedInProcessDir := data.parameters.rDistanceBetweenSensors > 0;
	
	IF data.commands.xCheckMounted THEN
		IF data.status.xSensorsSeparatedInProcessDir THEN
			IncoherenceSensor := 0;
			FOR iIndexSensor:=2 TO data.parameters.iSensorQuantity DO
				IF NOT data.Inputs.Signals.xPhotoCells[iIndexSensor-1] AND data.Inputs.Signals.xPhotoCells[iIndexSensor] AND NOT xPhotoInputsPrev[iIndexSensor] THEN
					data.Alarms.xPhotoCellsDetectionIncoherence[iIndexSensor] := TRUE; 
					//These alarms are not considered in alarm sound action. Is just a warning and this avoid to make printer sound very often.
					//To leave it this way till full tested in field
				END_IF
			END_FOR
				
		ELSE
			IncoherenceSensor.0 := NOT data.Inputs.Signals.xPhotoCells[1] AND data.Inputs.Signals.xPhotoCells[2];
			IncoherenceSensor.1 := NOT data.Inputs.Signals.xPhotoCells[2] AND data.Inputs.Signals.xPhotoCells[3];
			IncoherenceSensor.2 := NOT data.Inputs.Signals.xPhotoCells[3] AND data.Inputs.Signals.xPhotoCells[4];
			IncoherenceSensor.3 := NOT data.Inputs.Signals.xPhotoCells[4] AND data.Inputs.Signals.xPhotoCells[5];
			IncoherenceSensor.4 := NOT data.Inputs.Signals.xPhotoCells[5] AND data.Inputs.Signals.xPhotoCells[6];
				
			TON_DelayIncoherrPhotocell.IN:= IncoherenceSensor>0 AND data.commands.AutoMode.xProdORLab;
			TON_DelayIncoherrPhotocell.PT:= T#500ms;
			TON_DelayIncoherrPhotocell();
			
			IF TON_DelayIncoherrPhotocell.Q THEN
				data.Alarms.xIncoherPhotocellSystem:= TRUE;
			END_IF
		END_IF
	END_IF	
			
	// Not comms
	CASE data.parameters.MotorType OF
		STP_STEPPER:
			data.Alarms.xComsMotorError:= (NOT data.status.xBackModuleOk OR NOT data.status.xFrontModuleOk OR Stepper.Status.ErrorID=29365);

		STP_ICLA:
			data.Alarms.xComsMotorError:= Icla.Status.Error.Communication;
	END_CASE
	

	// Motor Error (Stepper or StepperGear)
	CASE data.parameters.MotorType OF
		STP_STEPPER:
			data.Alarms.xMotorError :=	data.status.xMotorError;

		STP_ICLA:
			data.Alarms.xMotorError := Icla.Status.Error.ErrorNumber<>0;
			data.Alarms.xControllerNotReady := Icla.Status.iDriveStatus = ICLAST_SWITCH_ON_DISABLED AND data.Inputs.Signals.xSafetyEnable AND NOT data.commands.Mode.xZero;
	END_CASE
	
	
	//Warp media
	iWarpMediaSensor := data.parameters.iSensorQuantity-1;
	xWarpSensorActive := data.Inputs.Signals.xPhotoCells[iWarpMediaSensor];
	
	IF data.commands.xCheckMounted AND EDGEPOS(xWarpSensorActive) THEN
		IF NOT xWarpMediaPresent THEN
			iCounterWarpMedia := iCounterWarpMedia+1;
			xWarpMediaPresent := TRUE;
		END_IF
	
	ELSIF NOT xWarpSensorActive THEN
		xWarpMediaPresent := FALSE;
	END_IF
	
	IF (iCounterWarpMedia=iMaxWarpMedia) THEN data.Alarms.xAlrWarpMedia:=TRUE; END_IF
	
	IF NOT data.commands.LineStatusSummary.xPrinting THEN iCounterWarpMedia:=0; END_IF
	
	//Continuous Reading PD Phcell
	IF data.parameters.MotorType = STP_STEPPER THEN	
		TON_ContinuousActPDPhcell.IN := data.Inputs.Signals.xPhotoCells[1] AND data.commands.AutoMode.xProdORLab AND NOT data.commands.AutoMode.xPause;
		TON_ContinuousActPDPhcell.PT := T#30s;
		TON_ContinuousActPDPhcell();
		
		IF TON_ContinuousActPDPhcell.Q THEN
			data.Alarms.xContinuousActPDPhcell := TRUE;
		END_IF
	END_IF
		
	//////////////////////////
	////// ALARMS SUMMARY////
	/////////////////////////								
	
	//Stop
	iReasonStop.0 := data.Alarms.xMotorError;
	iReasonStop.1 := data.Alarms.xComsMotorError;
	iReasonStop.2 := data.Alarms.xNotReferenced;
	iReasonStop.3 := data.Alarms.xIncoherPhotocellSystem;
	iReasonStop.4 := data.Alarms.xAlrInvalidAlignmentPosition;
	iReasonStop.5 := data.Alarms.xAlrCriticalPhotocellNotAligned;
	
	data.AlSummary.xAlarmStop := iReasonStop > 0;
	IF EDGEPOS(data.AlSummary.xAlarmStop) THEN
		data.AlSummary.iReasonStop[0] := iReasonStop;
		LogStopAlarm;
	ELSIF EDGEPOS(NOT data.commands.AutoMode.xStop AND NOT data.AlSummary.xAlarmStop) THEN
		data.AlSummary.iReasonStop[0] := 0;
	END_IF
	
	
	//Critical
	iReasonCritical.0 := data.Alarms.xPositionOutOfRange;
	
	data.AlSummary.xAlarmCritical := iReasonCritical > 0;
	IF EDGEPOS(data.AlSummary.xAlarmCritical) THEN
		data.AlSummary.iReasonCritical := iReasonCritical;
		LogCriticalAlarm;
	ELSIF EDGEPOS(data.commands.Mode.xAuto AND NOT data.AlSummary.xAlarmCritical) THEN
		data.AlSummary.iReasonCritical := 0;
	END_IF
	
	
	// It is just used for drive alarms
	iAnyAlarm.0 := data.Alarms.xMotorError;
	iAnyAlarm.1 := data.Alarms.xComsMotorError;
	iAnyAlarm.2 := data.Alarms.xPositionOutOfRange AND data.commands.Mode.xAuto;
	
	data.AlSummary.xAnyAlarm:= 	iAnyAlarm > 0;
	
	//Warning
	// It is just used for drive alarms
	iAnyWarning.0 := data.status.xReferencing;
	iAnyWarning.1 := data.Alarms.xNotReferenced;
	iAnyWarning.2 := data.Alarms.xAlrWarpMedia;
	data.AlSummary.xAnyWarning:= iAnyWarning > 0;
	
	IF EDGEPOS(data.AlSummary.xAnyWarning) THEN
		data.AlSummary.iReasonWarning := iAnyWarning;
		LogWarningAlarm;
	ELSIF EDGEPOS(NOT data.AlSummary.xAnyWarning) THEN
		data.AlSummary.iReasonWarning := 0;
	END_IF
	
END_ACTION
