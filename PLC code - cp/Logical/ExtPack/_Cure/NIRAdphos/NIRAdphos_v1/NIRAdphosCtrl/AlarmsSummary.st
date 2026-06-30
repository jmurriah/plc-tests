
ACTION AlarmsSummary: 
	
	
	iReasonStop.0 := data.Alarms.xCommsError;
	iReasonStop.1 := data.Alarms.xMaxSurfaceTempModule[1];
	iReasonStop.2 := data.Alarms.xMaxSurfaceTempModule[2];
	iReasonStop.3 := data.Alarms.xFault;
	iReasonStop.4 := data.Alarms.xAnyJam;
	iReasonStop.5 := data.Alarms.xOpcUaWriteError[1] AND data.Status.xEnabledDDC;
	iReasonStop.6 := data.Alarms.xOpcUaWriteError[2] AND data.Status.xEnabledDDC;
	iReasonStop.7 := FALSE;
	
	data.AlSummary.xAlarmStop := iReasonStop > 0 AND data.Status.xEnabledNir;
	IF EDGEPOS(data.AlSummary.xAlarmStop) THEN
		data.AlSummary.iReasonStop[0] := iReasonStop;
		LogStopAlarm;
	ELSIF EDGEPOS(NOT data.Parameters.AutoMode.xStop AND NOT data.AlSummary.xAlarmStop) THEN
		data.AlSummary.iReasonStop[0] := 0;
	END_IF
	
	iReasonCritical.0 := data.Status.Comms.Modules[1].error;
	iReasonCritical.1 := data.Status.Comms.Modules[2].error;
	iReasonCritical.2 := data.Alarms.xSafetyError;
	
	data.AlSummary.xAlarmCritical := iReasonCritical > 0 AND data.Status.xEnabledNir;
	IF EDGEPOS(data.AlSummary.xAlarmCritical) THEN
		data.AlSummary.iReasonCritical := iReasonCritical;
		LogCriticalAlarm;
	ELSIF EDGEPOS(data.Parameters.StateMode=PRINTERGEN_AUTO AND NOT data.AlSummary.xAlarmCritical) THEN
		data.AlSummary.iReasonCritical := 0;
	END_IF
	
	// It is just used for drive alarms
	iAnyAlarm.0 := iReasonStop > 0;
	iAnyAlarm.1 := iReasonCritical > 0;
	data.AlSummary.xAnyAlarm:= 	iAnyAlarm > 0;
	
	// It is just used for drive alarms
	iAnyWarning.0 := FALSE;
	data.AlSummary.xAnyWarning:= iAnyWarning > 0;
	
END_ACTION
