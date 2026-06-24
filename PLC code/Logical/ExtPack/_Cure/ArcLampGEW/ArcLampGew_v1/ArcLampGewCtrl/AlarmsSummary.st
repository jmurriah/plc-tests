
ACTION AlarmsSummary: 
	
	
	iReasonStop.0 := data.Alarms.xJam;
	iReasonStop.1 := data.Status.Lamps[1].InAlarm;
	iReasonStop.2 := data.Status.Lamps[2].InAlarm;
	
	data.AlSummary.xAlarmStop := iReasonStop > 0 AND data.Status.xEnabledArcLamp;
	IF EDGEPOS(data.AlSummary.xAlarmStop) THEN
		data.AlSummary.iReasonStop[0] := iReasonStop;
		LogStopAlarm;
	ELSIF EDGEPOS(NOT data.Parameters.AutoMode.xStop AND NOT data.AlSummary.xAlarmStop) THEN
		data.AlSummary.iReasonStop[0] := 0;
	END_IF
	
	iReasonCritical.0 := data.Alarms.xCommsError;
	
	data.AlSummary.xAlarmCritical := iReasonCritical > 0 AND data.Status.xEnabledArcLamp;
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
