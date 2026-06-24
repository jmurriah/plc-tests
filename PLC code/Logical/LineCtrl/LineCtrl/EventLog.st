ACTION LogWarningAlarm:

	stWarningAlarmsLog.Source := ELOG_TYPE_GENERAL;
	stWarningAlarmsLog.Severity:= ELOG_SEVERITY_INFO;
	stWarningAlarmsLog.Facility:= 0;
	stWarningAlarmsLog.ErrorCode:=0;
	
	stWarningAlarmsLog.Text := 'Line.LogWarningAlarm';

	IF iReasonWarning.0 THEN stWarningAlarmsLog.Text := 'gMachine.AlSummary.xAnyWarning';
	ELSIF iReasonWarning.1 THEN	stWarningAlarmsLog.Text := 'Feeder.Alarms.xWarningAlarm';
	ELSIF iReasonWarning.2 THEN	stWarningAlarmsLog.Text := 'Primer.Alarms.xWarningAlarm';
	ELSIF iReasonWarning.3 THEN stWarningAlarmsLog.Text := 'Dryer.Alarms.xWarningAlarm';
	ELSIF iReasonWarning.4 THEN stWarningAlarmsLog.Text := 'Stacker.Alarms.xWarningAlarm';
	ELSIF iReasonWarning.5 THEN stWarningAlarmsLog.Text := 'SafetyController.Alarms.xWarningAlarm';
	ELSIF iReasonWarning.6 THEN stWarningAlarmsLog.Text := 'Sarm.Alarms.xWarningAlarm';
	END_IF
		
	gEventLogLoader(EventData := ADR(stWarningAlarmsLog));
	
END_ACTION


ACTION LogStopAlarm:

	stStopAlarmsLog.Source := ELOG_TYPE_GENERAL;
	stStopAlarmsLog.Severity:= ELOG_SEVERITY_INFO;
	stStopAlarmsLog.Facility:= 0;
	stStopAlarmsLog.ErrorCode:=0;
	
	stStopAlarmsLog.Text := 'Line.LogStopAlarm';

	IF iReasonStop.0 THEN stStopAlarmsLog.Text := 'gMachine.AlSummary.xAlarmStop';
	ELSIF iReasonStop.1 THEN stStopAlarmsLog.Text := 'Primer.Alarms.xCriticalAlarm';
	ELSIF iReasonStop.2 THEN stStopAlarmsLog.Text := 'Line.Commands.Stop';
	ELSIF iReasonStop.3 THEN stStopAlarmsLog.Text := 'CuringLed[1].AlSummary.xAlarmStop';
	ELSIF iReasonStop.4 THEN stStopAlarmsLog.Text := 'CuringLed[2].AlSummary.xAlarmStop';
	ELSIF iReasonStop.5 THEN stStopAlarmsLog.Text := 'EdgeHoldDown.AlSummary.xAlarmStop';
	ELSIF iReasonStop.6 THEN stStopAlarmsLog.Text := 'Sarm.Alarms.xCriticalAlarm';
	END_IF
		
	gEventLogLoader(EventData := ADR(stStopAlarmsLog));
	
END_ACTION


ACTION LogCriticalAlarm:

	stCriticalAlarmsLog.Source := ELOG_TYPE_GENERAL;
	stCriticalAlarmsLog.Severity:= ELOG_SEVERITY_ERROR;
	stCriticalAlarmsLog.Facility:=0;
	stCriticalAlarmsLog.ErrorCode:=0;
	
	stCriticalAlarmsLog.Text := 'Line.LogCriticalAlarm';

	IF iReasonCritical.0 THEN stCriticalAlarmsLog.Text := 'gMachine.AlSummary.xAlarmCritical';
	ELSIF iReasonCritical.1 THEN stCriticalAlarmsLog.Text := 'Dryer.Alarms.xCriticalAlarm';
	ELSIF iReasonCritical.2 THEN stCriticalAlarmsLog.Text := 'Stacker.Alarms.xCriticalAlarm';
	ELSIF iReasonCritical.3 THEN stCriticalAlarmsLog.Text := 'SafetyController.Alarms.xCriticalAlarm';
	ELSIF iReasonCritical.4 THEN stCriticalAlarmsLog.Text := 'Line.Alarms.xAlrPrinterNoPowered';
	ELSIF iReasonCritical.5 THEN stCriticalAlarmsLog.Text := 'Line.Alarms.xAlr400VacNok';
	ELSIF iReasonCritical.6 THEN stCriticalAlarmsLog.Text := 'Line.Alarms.xAlr24VdcStartSeqNoPowered';
	ELSIF iReasonCritical.7 THEN stCriticalAlarmsLog.Text := 'gMachine.In.Buttons.xStop';
	ELSIF iReasonCritical.8 THEN stCriticalAlarmsLog.Text := 'OverVarnish.Alarms.xCriticalAlarm';
	ELSIF iReasonCritical.9 THEN stCriticalAlarmsLog.Text := 'CuringLed[1].AlSummary.xAlarmCritical';
	ELSIF iReasonCritical.10 THEN stCriticalAlarmsLog.Text := 'CuringLed[2].AlSummary.xAlarmCritical';
	ELSIF iReasonCritical.11 THEN stCriticalAlarmsLog.Text := 'EdgeHoldDown.AlSummary.xAlarmCritical';
	END_IF
	
	gEventLogLoader(EventData := ADR(stCriticalAlarmsLog));
	
END_ACTION


ACTION LogPrintCommand:

	stPrintCommandLog.Source := ELOG_TYPE_GENERAL;
	stPrintCommandLog.Severity:= ELOG_SEVERITY_INFO;
	stPrintCommandLog.Facility:= 0;
	stPrintCommandLog.ErrorCode:=0;
	
	stPrintCommandLog.Text := 'Line.LogPrintCommand';
		
	gEventLogLoader(EventData := ADR(stPrintCommandLog));
	
END_ACTION


ACTION LogPauseCommand:

	stPauseCommandLog.Source := ELOG_TYPE_GENERAL;
	stPauseCommandLog.Severity:= ELOG_SEVERITY_INFO;
	stPauseCommandLog.Facility:= 0;
	stPauseCommandLog.ErrorCode:=0;
	
	stPauseCommandLog.Text := 'Line.LogPauseCommand';
		
	gEventLogLoader(EventData := ADR(stPauseCommandLog));
	
END_ACTION

ACTION LogCleanCommand:

	stCleanCommandLog.Source := ELOG_TYPE_GENERAL;
	stCleanCommandLog.Severity:= ELOG_SEVERITY_INFO;
	stCleanCommandLog.Facility:= 0;
	stCleanCommandLog.ErrorCode:=0;
	
	stCleanCommandLog.Text := 'Line.LogCleanCommand';
		
	gEventLogLoader(EventData := ADR(stCleanCommandLog));
	
END_ACTION

ACTION LogEmptyBeltCommand:

	stEmptyBeltCommandLog.Source := ELOG_TYPE_GENERAL;
	stEmptyBeltCommandLog.Severity:= ELOG_SEVERITY_INFO;
	stEmptyBeltCommandLog.Facility:= 0;
	stEmptyBeltCommandLog.ErrorCode:=0;
	
	stEmptyBeltCommandLog.Text := 'Line.LogEmptyBeltCommand';
		
	gEventLogLoader(EventData := ADR(stEmptyBeltCommandLog));
	
END_ACTION

ACTION LogStopCommand:

	stStopCommandLog.Source := ELOG_TYPE_GENERAL;
	stStopCommandLog.Severity:= ELOG_SEVERITY_INFO;
	stStopCommandLog.Facility:= 0;
	stStopCommandLog.ErrorCode:=0;
	
	stStopCommandLog.Text := 'Line.LogStopCommand';
		
	gEventLogLoader(EventData := ADR(stStopCommandLog));
	
END_ACTION


ACTION LogStartButton:

	stStartButtonLog.Source := ELOG_TYPE_GENERAL;
	stStartButtonLog.Severity:= ELOG_SEVERITY_INFO;
	stStartButtonLog.Facility:= 0;
	stStartButtonLog.ErrorCode:=0;
	
	stStartButtonLog.Text := 'Line.LogStartButton';
		
	gEventLogLoader(EventData := ADR(stStartButtonLog));
	
END_ACTION


ACTION LogStopButton:

	stStopButtonLog.Source := ELOG_TYPE_GENERAL;
	stStopButtonLog.Severity:= ELOG_SEVERITY_INFO;
	stStopButtonLog.Facility:= 0;
	stStopButtonLog.ErrorCode:=0;
	
	stStopButtonLog.Text := 'Line.LogStopButton';
		
	gEventLogLoader(EventData := ADR(stStopButtonLog));
	
END_ACTION


ACTION LogLineSubStatus:

	stLineSubStatusLog.Source := ELOG_TYPE_GENERAL;
	stLineSubStatusLog.Severity:= ELOG_SEVERITY_INFO;
	stLineSubStatusLog.Facility:= 0;
	stLineSubStatusLog.ErrorCode:=0;
	
	stLineSubStatusLog.Text := 'LogLineSubStatus = ';
	stSubStatus := INT_TO_STRING(Line.SubStatus);
	strcat(ADR(stLineSubStatusLog.Text), ADR(stSubStatus));
	//stLineSubStatusLog.Text := INT_TO_STRING(Line.SubStatus);
		
	gEventLogLoader(EventData := ADR(stLineSubStatusLog));
	
END_ACTION


ACTION LogLineSwStatus:

	stLineStatusSwLog.Source := ELOG_TYPE_GENERAL;
	stLineStatusSwLog.Severity:= ELOG_SEVERITY_INFO;
	stLineStatusSwLog.Facility:= 0;
	stLineStatusSwLog.ErrorCode:=0;
	
	stLineStatusSwLog.Text := 'LogLineSwStatus = ';
	stStatusSw := INT_TO_STRING(Line.StatusSw);
	strcat(ADR(stLineStatusSwLog.Text), ADR(stStatusSw));
	//stLineStatusSwLog.Text := INT_TO_STRING(Line.StatusSw);
		
	gEventLogLoader(EventData := ADR(stLineStatusSwLog));
	
END_ACTION