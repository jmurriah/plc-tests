
ACTION LogStopAlarm:
	
	stEventLog.Source := ELOG_TYPE_TRANS_VACUUM;
	stEventLog.Severity:= ELOG_SEVERITY_INFO;
	stEventLog.Facility:= iIndexTransVacuum;
	stEventLog.ErrorCode:=0;
	
	stEventLog.Text := 'Vacuum.LogStopAlarm';
	
	IF 		iReasonStop.0 THEN stEventLog.Text := 'Vacuum. xAlrVacuumSensor';
	ELSIF 	iReasonStop.1 THEN stEventLog.Text := 'Vacuum. xAlrComsBlower';
	ELSIF 	iReasonStop.2 THEN stEventLog.Text := 'Vacuum. xAlrDriveBlowerError';
	ELSIF 	iReasonStop.3 THEN stEventLog.Text := 'Vacuum. xAlrOvertorque';
	ELSIF 	iReasonStop.4 THEN stEventLog.Text := 'Vacuum. xAlrJointSystemPressure';
	ELSIF 	iReasonStop.5 THEN stEventLog.Text := 'Vacuum. xAlrBlowersAnyCB';
	ELSIF 	iReasonStop.6 THEN stEventLog.Text := 'Vacuum. xAlrBlowerCB[1]';
	ELSIF 	iReasonStop.7 THEN stEventLog.Text := 'Vacuum. xAlrBlowerCB[2]';
	END_IF
		
	gEventLogLoader(EventData := ADR(stEventLog));
	
END_ACTION