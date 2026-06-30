
ACTION LogStopAlarm:

//	iReasonStop.0 := Belt.Al.xAnyDriveAlarm;
//	iReasonStop.1 := Belt.Al.xAlrComDrive;
//	iReasonStop.2 := Belt.Al.xAlrPowerBeltError;
//	iReasonStop.3 := Belt.Al.xAlrProtDrive;
//	iReasonStop.4 := Belt.Al.xAlrOverTorque;
//	iReasonStop.5 := Belt.Al.xControllerNotReady;
//	iReasonStop.6 := Belt.Al.xEnableVoltageSag;
	
	stEventLogStop.Source := ELOG_TYPE_BELT;
	stEventLogStop.Severity:= ELOG_SEVERITY_ERROR;
	stEventLogStop.Facility:= 0;
	stEventLogStop.ErrorCode:=0;
	
	stEventLogStop.Text := 'Belt.LogStopAlarm';
	
	IF 		iReasonStop.0 THEN stEventLogStop.Text := 'Belt. xAnyDriveAlarm';
	ELSIF 	iReasonStop.1 THEN stEventLogStop.Text := 'Belt. xAlrComDrive';
	ELSIF 	iReasonStop.2 THEN stEventLogStop.Text := 'Belt. xAlrPowerBeltError';
	ELSIF 	iReasonStop.3 THEN stEventLogStop.Text := 'Belt. xAlrProtDrive';
	ELSIF 	iReasonStop.4 THEN stEventLogStop.Text := 'Belt. xAlrOverTorque';
	ELSIF 	iReasonStop.5 THEN stEventLogStop.Text := 'Belt. xControllerNotReady';
	ELSIF 	iReasonStop.6 THEN stEventLogStop.Text := 'Belt. xEnableVoltageSag';
	END_IF
		
	gEventLogLoader(EventData := ADR(stEventLogStop));
	
END_ACTION

ACTION LogCriticalAlarm:

//	iReasonCritical.0 := Belt.Al.xAxisLengthNotDefined;
//	iReasonCritical.1 := Belt.Al.xGearBoxNotDefined;
	
	stEventLogCritical.Source := ELOG_TYPE_BELT;
	stEventLogCritical.Severity:= ELOG_SEVERITY_ERROR;
	stEventLogCritical.Facility:= 0;
	stEventLogCritical.ErrorCode:=0;
	
	stEventLogCritical.Text := 'Belt.LogCriticalAlarm';
	
	IF 		iReasonCritical.0 THEN stEventLogCritical.Text := 'Belt. xAxisLengthNotDefined';
	ELSIF 	iReasonCritical.1 THEN stEventLogCritical.Text := 'Belt. xGearBoxNotDefined';
	END_IF
		
	gEventLogLoader(EventData := ADR(stEventLogCritical));
	
END_ACTION

ACTION LogWarning:
	
	stEventLogWarning.Source := ELOG_TYPE_BELT;
	stEventLogWarning.Severity:= ELOG_SEVERITY_INFO;
	stEventLogWarning.Facility:= 0;
	stEventLogWarning.ErrorCode:=0;
	
	stEventLogWarning.Text := 'Belt.LogWarning';
	
	IF 	iReasonWarning.0 THEN stEventLogWarning.Text := 'Belt. xBeltMotorTemp';
	ELSIF 	iReasonWarning.1 THEN stEventLogWarning.Text := 'Belt. xBeltDriverTemp';
	ELSIF 	iReasonWarning.2 THEN stEventLogWarning.Text := 'Belt. xWrnOverTorq';
	END_IF
		
	gEventLogLoader(EventData := ADR(stEventLogWarning));
	
END_ACTION