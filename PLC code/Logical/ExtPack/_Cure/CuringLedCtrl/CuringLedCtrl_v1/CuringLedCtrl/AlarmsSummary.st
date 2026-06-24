
ACTION AlarmsSummary: 

	//Alarms Summary
	//Warning
	iReasonWarning.0 := dataLed.Alarms.xN2HighFlow;
	iReasonWarning.1 := dataLed.Alarms.xSerialNumbersRepeated;
	
	dataLed.AlSummary.xAnyWarning := iReasonWarning > 0;
	
	
	//Stop
	iReasonStop.0 := dataLed.Alarms.xN2LowFlow;
	iReasonStop.1 := dataLed.Alarms.xLampsSlmNotConfigured;
	iReasonStop.2 := dataLed.Alarms.xFrontDoorOpened;
	
	dataLed.AlSummary.xAlarmStop :=	iReasonStop > 0;
	IF EDGEPOS(dataLed.AlSummary.xAlarmStop) THEN
		dataLed.AlSummary.iReasonStop[0] := iReasonStop;
		LogStopAlarm;
	ELSIF EDGEPOS(NOT dataLed.Parameters.AutoMode.xStop AND NOT dataLed.AlSummary.xAlarmStop) THEN
		dataLed.AlSummary.iReasonStop[0] := 0;
	END_IF		
	
	
	//Critical
	iReasonCritical.0 := dataLed.Alarms.xCureSystemFaulted;
	iReasonCritical.1 := errorLampsSLM>0;
	iReasonCritical.2 := errorLampsThermal>0;
	iReasonCritical.3 := dataLed.Alarms.xSerialNumbersNotAssigned;
	iReasonCritical.4 := dataLed.Alarms.xDetectionProcessFailed;
	iReasonCritical.5 := dataLed.Alarms.xPowerFailure;
	
	dataLed.AlSummary.xAlarmCritical:= iReasonCritical > 0 AND dataLed.Parameters.Mode.xAuto;
	IF EDGEPOS(dataLed.AlSummary.xAlarmCritical) THEN
		dataLed.AlSummary.iReasonCritical := iReasonCritical;
		LogCriticalAlarm;
	ELSIF EDGEPOS(dataLed.Parameters.Mode.xAuto AND iReasonCritical=0) THEN
		dataLed.AlSummary.iReasonCritical := 0;
	END_IF
	
END_ACTION

