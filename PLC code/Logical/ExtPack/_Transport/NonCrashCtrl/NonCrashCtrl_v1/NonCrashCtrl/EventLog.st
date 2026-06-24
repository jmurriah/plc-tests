
ACTION LogStopAlarm:

//	iReasonStop.0 := dataNC.Alarms.xAlrComsDrive;
//	iReasonStop.1 := dataNC.Alarms.xAlrDriveError;
//	iReasonStop.2 := dataNC.Alarms.xAlrOvertorque;
//	iReasonStop.3 := dataNC.Alarms.xAlrDiffContact;
//	iReasonStop.4 := dataNC.Alarms.xControllerNotReady;
//	iReasonStop.5 := dataNC.Alarms.xPerimeterNotDefined;
//	iReasonStop.6 := dataNC.Alarms.xGearBoxNotDefined;

	stEventLog.Source := ELOG_TYPE_NONCRASH;
	stEventLog.Severity:= ELOG_SEVERITY_INFO;
	stEventLog.Facility:= iIndexNonCrash;
	stEventLog.ErrorCode:=0;
	
	stEventLog.Text := 'Vacuum.LogStopAlarm';
	
	IF 		iReasonStop.0 THEN stEventLog.Text := 'Vacuum. xAlrComsMotor';
	ELSIF 	iReasonStop.1 THEN stEventLog.Text := 'Vacuum. xAlrDriveError';
	ELSIF 	iReasonStop.2 THEN stEventLog.Text := 'Vacuum. xAlrOvertorque';
	ELSIF 	iReasonStop.3 THEN stEventLog.Text := 'Vacuum. xAlrDiffContact';
	ELSIF 	iReasonStop.4 THEN stEventLog.Text := 'Vacuum. xControllerNotReady';
	ELSIF 	iReasonStop.5 THEN stEventLog.Text := 'Vacuum. xPerimeterNotDefined';
	ELSIF 	iReasonStop.6 THEN stEventLog.Text := 'Vacuum. xGearBoxNotDefined';
	END_IF
		
	gEventLogLoader(EventData := ADR(stEventLog));
	
END_ACTION