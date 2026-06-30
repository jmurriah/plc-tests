ACTION LogWarningAlarm:

	stWarningAlarmsLog.Source := ELOG_TYPE_DETECTION;
	stWarningAlarmsLog.Severity:= ELOG_SEVERITY_INFO;
	stWarningAlarmsLog.Facility:= 0;
	stWarningAlarmsLog.ErrorCode:=0;
	
	stWarningAlarmsLog.Text := 'nSensorWarningAlarm';
	
	IF iReasonWarning.0 THEN stWarningAlarmsLog.Text := 'data.Alarms.xReferencing';
	ELSIF iReasonWarning.1 THEN	stWarningAlarmsLog.Text := 'data.Alarms.xNotReferenced';
	ELSIF iReasonWarning.2 THEN	stWarningAlarmsLog.Text := 'data.Alarms.xAlrWarpMedia';
	END_IF
		
	gEventLogLoader(EventData := ADR(stWarningAlarmsLog));
	
END_ACTION


ACTION LogStopAlarm:

	stStopAlarmsLog.Source := ELOG_TYPE_DETECTION;
	stStopAlarmsLog.Severity:= ELOG_SEVERITY_INFO;
	stStopAlarmsLog.Facility:= 0;
	stStopAlarmsLog.ErrorCode:=0;
	
	stStopAlarmsLog.Text := 'nSensorStopAlarm';
	
	IF iReasonStop.0 THEN stStopAlarmsLog.Text := 'data.Alarms.xMotorError';
	ELSIF iReasonStop.1 THEN stStopAlarmsLog.Text := 'data.Alarms.xComsMotorError';
	ELSIF iReasonStop.2 THEN stStopAlarmsLog.Text := 'data.Alarms.xNotReferenced';
	ELSIF iReasonStop.3 THEN stStopAlarmsLog.Text := 'data.Alarms.xIncoherPhotocellSystem';
	ELSIF iReasonStop.4 THEN stStopAlarmsLog.Text := 'data.Alarms.xAlrInvalidAlignmentPosition';
	ELSIF iReasonStop.5 THEN stStopAlarmsLog.Text := 'data.Alarms.xAlrCriticalPhotocellNotAligned';
	END_IF
		
	gEventLogLoader(EventData := ADR(stStopAlarmsLog));
	
END_ACTION


ACTION LogCriticalAlarm:

	stCriticalAlarmsLog.Source := ELOG_TYPE_DETECTION;
	stCriticalAlarmsLog.Severity:= ELOG_SEVERITY_ERROR;
	stCriticalAlarmsLog.Facility:= 0;
	stCriticalAlarmsLog.ErrorCode:=0;
	
	stCriticalAlarmsLog.Text := 'nSensorCriticalAlarm';
	
	IF iReasonCritical.0 THEN stCriticalAlarmsLog.Text := 'data.Alarms.xPositionOutOfRange';
//	ELSIF iReasonCritical.1 THEN stCriticalAlarmsLog.Text := '';
//	ELSIF iReasonCritical.2 THEN stCriticalAlarmsLog.Text := '';
//	ELSIF iReasonCritical.3 THEN stCriticalAlarmsLog.Text := '';
//	ELSIF iReasonCritical.4 THEN stCriticalAlarmsLog.Text := '';
//	ELSIF iReasonCritical.5 THEN stCriticalAlarmsLog.Text := '';
	END_IF
	
	gEventLogLoader(EventData := ADR(stCriticalAlarmsLog));
	
END_ACTION