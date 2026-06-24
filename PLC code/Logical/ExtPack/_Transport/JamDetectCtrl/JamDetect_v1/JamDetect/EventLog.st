ACTION LogWarningAlarm:

	stWarningAlarmsLog.Source := ELOG_TYPE_EHD;
	stWarningAlarmsLog.Severity:= ELOG_SEVERITY_INFO;
	stWarningAlarmsLog.Facility:= 0;
	stWarningAlarmsLog.ErrorCode:=0;
	
	IF ctuConsecutiveLowJamDetected[0].Q 	THEN 	stWarningAlarmsLog.Text := 'LowJamDetection > 3 in 1 min JDevice: ';
	ELSIF ctuConsecutiveLowJamDetected[1].Q THEN	stWarningAlarmsLog.Text := 'LowJamDetection > 10 in 30 min JDevice: ';
	END_IF
	
	brsftoa(iIndexJam, ADR(strAuxEventDesc));
	brsstrcat(ADR(stWarningAlarmsLog.Text), ADR(strAuxEventDesc));
		
	gEventLogLoader(EventData := ADR(stWarningAlarmsLog));
	
END_ACTION
