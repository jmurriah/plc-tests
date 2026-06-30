ACTION LogWarningAlarm:

	stWarningAlarmsLog.Source := ELOG_TYPE_EHD;
	stWarningAlarmsLog.Severity:= ELOG_SEVERITY_INFO;
	stWarningAlarmsLog.Facility:= 0;
	stWarningAlarmsLog.ErrorCode:=0;
	
	stWarningAlarmsLog.Text := 'EHD.LogWarningAlarm';
	
	IF iReasonWarning.0 THEN stWarningAlarmsLog.Text := 'AdjustmentSystem[1].AlSummary.xAnyWarning';
	ELSIF iReasonWarning.1 THEN	stWarningAlarmsLog.Text := 'AdjustmentSystem[2].AlSummary.xAnyWarning';
	END_IF
		
	gEventLogLoader(EventData := ADR(stWarningAlarmsLog));
	
END_ACTION


ACTION LogStopAlarm:

	stStopAlarmsLog.Source := ELOG_TYPE_EHD;
	stStopAlarmsLog.Severity:= ELOG_SEVERITY_INFO;
	stStopAlarmsLog.Facility:= 0;
	stStopAlarmsLog.ErrorCode:=0;
	
	stStopAlarmsLog.Text := 'EHD.LogStopAlarm';
	
	IF iReasonStop.0 THEN stStopAlarmsLog.Text := 'AdjustmentSystem[1].AlSummary.xAlarmStop';
	ELSIF iReasonStop.1 THEN stStopAlarmsLog.Text := 'AdjustmentSystem[2].AlSummary.xAlarmStop';
	ELSIF iReasonStop.2 THEN stStopAlarmsLog.Text := 'data.Alarms.xNotReferenced';
	ELSIF iReasonStop.3 THEN stStopAlarmsLog.Text := 'data.Alarms.xParametersOutOfRange';
	END_IF
		
	gEventLogLoader(EventData := ADR(stStopAlarmsLog));
	
END_ACTION


ACTION LogCriticalAlarm:

	stCriticalAlarmsLog.Source := ELOG_TYPE_EHD;
	stCriticalAlarmsLog.Severity:= ELOG_SEVERITY_ERROR;
	stCriticalAlarmsLog.Facility:= 0;
	stCriticalAlarmsLog.ErrorCode:=0;
	
	stWarningAlarmsLog.Text := 'EHD.LogCriticalAlarm';
	
	IF iReasonCritical.0 THEN stWarningAlarmsLog.Text := 'AdjustmentSystem[1].AlSummary.xAlarmCritical';
	ELSIF iReasonCritical.1 THEN stWarningAlarmsLog.Text := 'AdjustmentSystem[2].AlSummary.xAlarmCritical';
	ELSIF iReasonCritical.2 THEN stWarningAlarmsLog.Text := 'data.Alarms.xMovementsNotEnabled';
	ELSIF iReasonCritical.3 THEN stWarningAlarmsLog.Text := 'data.Alarms.xJam';
	END_IF
	
	gEventLogLoader(EventData := ADR(stCriticalAlarmsLog));
	
END_ACTION