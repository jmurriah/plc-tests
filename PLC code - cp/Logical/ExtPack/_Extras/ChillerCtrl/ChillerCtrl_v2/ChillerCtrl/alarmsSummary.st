
ACTION alarmsSummary: 
	
	//Alarms Summary
	//Warning
	iReasonWarning.0 := dataChill.Alarm.xInAlarm;
	iReasonWarning.1 := dataChill.Alarm.xAlrEnvTempSensBrokn;
	iReasonWarning.2 := dataChill.Alarm.xAlrTempSensBrokn;
	iReasonWarning.3 := dataChill.Alarm.xNotRunning;
	iReasonWarning.4 := dataChill.Alarm.xCheckChiller;
	
	dataChill.AlSummary.xAnyWarning := iReasonWarning > 0;
	
	
	//Stop
	//iReasonStop.0 := ;
	dataChill.AlSummary.xAlarmStop := iReasonStop > 0;
	IF EDGEPOS(dataChill.AlSummary.xAlarmStop) THEN
		dataChill.AlSummary.iReasonStop[0] := iReasonStop;
		//LogStopAlarm;
	END_IF		
	
	
	//Critical
	//iReasonCritical.0 := ;
	dataChill.AlSummary.xAlarmCritical:= iReasonCritical > 0;
	IF EDGEPOS(dataChill.AlSummary.xAlarmCritical) THEN
		dataChill.AlSummary.iReasonCritical := iReasonCritical;
		//LogCriticalAlarm;
	END_IF
	
	
END_ACTION
