ACTION LogWarningAlarm:

	stWarningAlarmsLog.Source := ELOG_TYPE_PAIRED_ICLA;
	stWarningAlarmsLog.Severity:= ELOG_SEVERITY_INFO;
	stWarningAlarmsLog.Facility:= 0;
	stWarningAlarmsLog.ErrorCode:=0;
	
	stWarningAlarmsLog.Text := 'PairedIcla.LogWarningAlarm';
	
	IF iReasonWarning.0 THEN stWarningAlarmsLog.Text := 'data.Alarms.xReferencing';
	END_IF
		
	gEventLogLoader.EventData := ADR(stWarningAlarmsLog);
	gEventLogLoader();
END_ACTION


ACTION LogStopAlarm:

	stStopAlarmsLog.Source := ELOG_TYPE_PAIRED_ICLA;
	stStopAlarmsLog.Severity:= ELOG_SEVERITY_INFO;
	stStopAlarmsLog.Facility:= 0;
	stStopAlarmsLog.ErrorCode:=0;
	
	stStopAlarmsLog.Text := 'PairedIcla.LogStopAlarm';
	
	IF iReasonStop.0 THEN stStopAlarmsLog.Text := 'data.Alarms.xMotorError';
	ELSIF iReasonStop.1 THEN stStopAlarmsLog.Text := 'data.Alarms.xComsMotorError';
	ELSIF iReasonStop.2 THEN stStopAlarmsLog.Text := 'data.Alarms.xNotReferenced';
	END_IF
		
	gEventLogLoader.EventData := ADR(stStopAlarmsLog);
	gEventLogLoader();
END_ACTION


ACTION LogCriticalAlarm:

	stCriticalAlarmsLog.Source := ELOG_TYPE_PAIRED_ICLA;
	stCriticalAlarmsLog.Severity:= ELOG_SEVERITY_ERROR;
	stCriticalAlarmsLog.Facility:= 0;
	stCriticalAlarmsLog.ErrorCode:=0;
	
	stCriticalAlarmsLog.Text := 'PairedIcla.LogCriticalAlarm';
	
	IF iReasonCritical.0 THEN stCriticalAlarmsLog.Text := 'data.Alarms.xPositionOutOfRange';
//	ELSIF iReasonCritical.1 THEN stCriticalAlarmsLog.Text := '';
//	ELSIF iReasonCritical.2 THEN stCriticalAlarmsLog.Text := '';
//	ELSIF iReasonCritical.3 THEN stCriticalAlarmsLog.Text := '';
//	ELSIF iReasonCritical.4 THEN stCriticalAlarmsLog.Text := '';
//	ELSIF iReasonCritical.5 THEN stCriticalAlarmsLog.Text := '';
	END_IF
	
	gEventLogLoader.EventData := ADR(stCriticalAlarmsLog);
	gEventLogLoader();
END_ACTION