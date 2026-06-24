
ACTION AlarmsSummary: 
	
	
	//RESET ALARMS
	IF data.commands.xErrorRst THEN
		data.Alarms := stAlarmsReseted;
		data.AlSummary := stAlarmSummaryReseted;
	END_IF
	
	//Invalid position
	IF data.status.xReferenced AND data.status.xMoving THEN
		IF (rPositionMotorMm > (data.parameters.rMechPositionMax + data.Motor[1].rMotorResolution)) OR ((rPositionMotorMm < data.parameters.rMechPositionMin - data.Motor[1].rMotorResolution)) THEN
			data.Alarms.xPositionOutOfRange := TRUE;
		END_IF
	END_IF
	
	//Alarm Not referenced
	data.Alarms.xNotReferenced:= NOT data.status.xReferenced;
	
	//////////////////////////////////////////
	//To review in next releases how to share with SW an alarm per motor and not per adjustment system. To improve troubleshooting
	
	//Error general. Check error id for more information
	data.Alarms.xMotorError:=data.Motor[1].Alarms.xMotorError OR data.Motor[2].Alarms.xMotorError;
	
	//Enables (STO)
	IF data.Inputs.xSafetyEnable AND NOT data.commands.Mode.xZero THEN
		data.Alarms.xControllerNotReady :=  data.Motor[1].Alarms.xControllerNotReady OR data.Motor[2].Alarms.xControllerNotReady;
	END_IF
	
	//Comms
	data.Alarms.xCommsMotorError:=data.Motor[1].Alarms.xCommsMotorError OR data.Motor[2].Alarms.xCommsMotorError;
	
	xAnyMotorError := data.Alarms.xMotorError OR data.Alarms.xCommsMotorError;

	//////////////////////////////////////////
	
	//Motors not aligned
	data.Alarms.xNotAligned := ABS(data.Motor[1].rPositionMotor-data.Motor[2].rPositionMotor) > data.parameters.iMisalignmentTolerance;
		
	
	//Inconsistency between position measured (analogic input) and motor position information (motors encoder)	
	iPositionMeasuredInconsistency.0 := ABS(data.Motor[1].rMetalStrapPos-data.Motor[1].rMeasuredDistanceMetalStraps) > data.parameters.iPositionResolution;
	iPositionMeasuredInconsistency.1 := ABS(data.Motor[2].rMetalStrapPos-data.Motor[2].rMeasuredDistanceMetalStraps) > data.parameters.iPositionResolution;
	
	IF iPositionMeasuredInconsistency>0 AND data.parameters.xPositionSensorInstalled AND xMotorStopped THEN
		data.Alarms.xPositionMeasuredInconsistency := TRUE;
	END_IF
	
	IF EDGEPOS(data.Alarms.xPositionMeasuredInconsistency) THEN
		rInputMeasuredDifference := (data.Motor[1].rMetalStrapPos-data.Motor[1].rMeasuredDistanceMetalStraps);
		rOutputMeasuredDifference := (data.Motor[2].rMetalStrapPos-data.Motor[2].rMeasuredDistanceMetalStraps);
	END_IF
	
	
	//Alarms summary								
	//Stop
	iReasonStop.0 := data.Alarms.xMotorError;
	iReasonStop.1 := data.Alarms.xCommsMotorError;
	iReasonStop.2 := data.Alarms.xNotReferenced;
	iReasonStop.3 := xAnyMotorError;
	//iReasonStop.4 := data.Alarms.xPositionMeasuredInconsistency;
	
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
	
	
	//Warning
	// It is just used for drive alarms
	//iAnyWarning.0 := ;
	data.AlSummary.xAnyWarning:= iAnyWarning > 0;
	
	IF EDGEPOS(data.AlSummary.xAnyWarning) THEN
		data.AlSummary.iReasonWarning := iAnyWarning;
		LogWarningAlarm;
	ELSIF EDGEPOS(NOT data.AlSummary.xAnyWarning) THEN
		data.AlSummary.iReasonWarning := 0;
	END_IF
	
END_ACTION
