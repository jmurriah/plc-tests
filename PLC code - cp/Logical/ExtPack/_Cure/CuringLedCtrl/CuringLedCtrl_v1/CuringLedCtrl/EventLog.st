
ACTION LogStopAlarm:

	stEventLog.Source := ELOG_TYPE_LED;
	stEventLog.Severity:= ELOG_SEVERITY_INFO;
	stEventLog.Facility:= iIndexCuringLed;
	stEventLog.ErrorCode:=0;
	
	stEventLog.Text := 'dataLed.StopAlarm';

	IF 		iReasonStop.0 THEN stEventLog.Text := 'dataLed.Alarms.xN2LowFlow';
	ELSIF 	iReasonStop.1 THEN stEventLog.Text := 'dataLed.Alarms.xLampsSlmNotConfigured';
	ELSIF 	iReasonStop.2 THEN stEventLog.Text := 'dataLed.Alarms.xFrontDoorOpened';
	END_IF
		
	gEventLogLoader(EventData := ADR(stEventLog));
	
END_ACTION


ACTION LogCriticalAlarm:

	stEventLogCritical.Source := ELOG_TYPE_LED;
	stEventLogCritical.Severity:= ELOG_SEVERITY_ERROR;
	stEventLogCritical.Facility:= iIndexCuringLed;
	stEventLogCritical.ErrorCode:=0;
	
	stEventLogCritical.Text := 'dataLed.CriticalAlarm';
	
	IF 		iReasonCritical.0 THEN stEventLogCritical.Text := 'dataLed.Alarms.xCureSystemFaulted';
	ELSIF 	iReasonCritical.1 THEN stEventLogCritical.Text := 'errorLampsSLM>0';
	ELSIF 	iReasonCritical.2 THEN stEventLogCritical.Text := 'errorLampsThermal>0';
	ELSIF	iReasonCritical.3 THEN stEventLogCritical.Text := 'dataLed.Alarms.xSerialNumbersNotAssigned';
	ELSIF	iReasonCritical.4 THEN stEventLogCritical.Text := 'dataLed.Alarms.xDetectionProcessFailed';
	ELSIF	iReasonCritical.5 THEN stEventLogCritical.Text := 'dataLed.Alarms.xPowerFailure';
	END_IF
		
	gEventLogLoader(EventData := ADR(stEventLogCritical));
	
END_ACTION

ACTION LogPsuFailure:

	stEventLogPsuFailure.Source := ELOG_TYPE_LED;
	stEventLogPsuFailure.Severity:= ELOG_SEVERITY_ERROR;
	stEventLogPsuFailure.Facility:= iIndexPowerSupply;
	stEventLogPsuFailure.ErrorCode:=0;
	
	stEventLogPsuFailure.Text := 'dataLed.PsuFailure. PSU:';
	brsitoa(iIndexPowerSupply, ADR(strAuxEventDesc));
	brsstrcat(ADR(stEventLogPsuFailure.Text), ADR(strAuxEventDesc));
		
	gEventLogLoader(EventData := ADR(stEventLogPsuFailure));
	
END_ACTION