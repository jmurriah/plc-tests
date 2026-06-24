
ACTION LogStopAlarm:

//	iReasonStop.0 := FALSE;
//	iReasonStop.1 := data.Status.Lamps[1].InAlarm;
//	iReasonStop.2 := data.Status.Lamps[2].InAlarm;
//	iReasonStop.3 := data.Status.Lamps[3].InAlarm;
//	iReasonStop.4 := data.Status.Lamps[4].InAlarm;
//	iReasonStop.5 := data.Status.Lamps[5].InAlarm;
//	iReasonStop.6 := data.Status.Lamps[6].InAlarm;

	stEventLog.Source := ELOG_TYPE_ARCLAMP;
	stEventLog.Severity:= ELOG_SEVERITY_ERROR;
	stEventLog.Facility:= 0;
	stEventLog.ErrorCode:=0;
	
	stEventLog.Text := 'ArcLamp.LogStopAlarm';
	
	IF 		iReasonStop.0 THEN stEventLog.Text := '---';
	ELSIF 	iReasonStop.1 THEN stEventLog.Text := 'Error ArcLamp Lamp1';
	ELSIF 	iReasonStop.2 THEN stEventLog.Text := 'Error ArcLamp Lamp2';
	ELSIF 	iReasonStop.3 THEN stEventLog.Text := 'Error ArcLamp Lamp3';
	ELSIF 	iReasonStop.4 THEN stEventLog.Text := 'Error ArcLamp Lamp4';
	ELSIF 	iReasonStop.5 THEN stEventLog.Text := 'Error ArcLamp Lamp5';
	ELSIF 	iReasonStop.6 THEN stEventLog.Text := 'Error ArcLamp Lamp6';
	END_IF
		
	gEventLogLoader(EventData := ADR(stEventLog));
	
END_ACTION

ACTION LogCriticalAlarm:

//	iReasonCritical.0 := data.Alarms.xCommsError;

	stEventLog.Source := ELOG_TYPE_ARCLAMP;
	stEventLog.Severity:= ELOG_SEVERITY_ERROR;
	stEventLog.Facility:= 0;
	stEventLog.ErrorCode:=0;
	
	stEventLog.Text := 'ArcLamp.LogCriticalAlarm';
	
	IF 		iReasonCritical.0 THEN stEventLog.Text := 'ArcLamp Error Comms';
	ELSIF 	iReasonCritical.1 THEN stEventLog.Text := '---';
	END_IF
		
	gEventLogLoader(EventData := ADR(stEventLog));
	
END_ACTION