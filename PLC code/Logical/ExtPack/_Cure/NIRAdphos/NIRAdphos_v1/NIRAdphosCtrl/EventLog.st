
ACTION LogStopAlarm:

//	iReasonStop.0 := data.Alarms.xCommsError;
//	iReasonStop.1 := data.Alarms.xMaxSurfaceTempModule[1];
//	iReasonStop.2 := data.Alarms.xMaxSurfaceTempModule[2];
//	iReasonStop.3 := data.Alarms.xFault;
//	iReasonStop.4 := data.Alarms.xAnyJam;
//	iReasonStop.5 := data.Alarms.xOpcUaWriteError[1] AND data.Status.xEnabledDDC;
//	iReasonStop.6 := data.Alarms.xOpcUaWriteError[2] AND data.Status.xEnabledDDC;
	
	stEventLog.Source := ELOG_TYPE_NIR;
	stEventLog.Severity:= ELOG_SEVERITY_ERROR;
	stEventLog.Facility:= 0;
	stEventLog.ErrorCode:=0;
	
	stEventLog.Text := 'NIR.LogStopAlarm';
	
	IF 		iReasonStop.0 THEN stEventLog.Text := 'NirStop. xCommsError';
	ELSIF 	iReasonStop.1 THEN stEventLog.Text := 'NirStop. xMaxSurfaceTempModule[1]';
	ELSIF 	iReasonStop.2 THEN stEventLog.Text := 'NirStop. xMaxSurfaceTempModule[2]';
	ELSIF 	iReasonStop.3 THEN stEventLog.Text := 'NirStop. xFault';
	ELSIF 	iReasonStop.4 THEN stEventLog.Text := 'NirStop. xAnyJam';
	ELSIF 	iReasonStop.5 THEN stEventLog.Text := 'NirStop. xOpcUaWriteError[1]';
	ELSIF 	iReasonStop.6 THEN stEventLog.Text := 'NirStop. xOpcUaWriteError[2]';
	END_IF
		
	gEventLogLoader(EventData := ADR(stEventLog));
	
END_ACTION

ACTION LogCriticalAlarm:

//	iReasonCritical.0 := data.Status.Comms.Modules[1].error;
//	iReasonCritical.1 := data.Status.Comms.Modules[2].error;
//	iReasonCritical.2 := data.Alarms.xSafetyError;

	stEventLog.Source := ELOG_TYPE_NIR;
	stEventLog.Severity:= ELOG_SEVERITY_ERROR;
	stEventLog.Facility:= 0;
	stEventLog.ErrorCode:=0;
	
	stEventLog.Text := 'NIR.LogCriticalAlarm';
	
	IF 		iReasonCritical.0 THEN stEventLog.Text := 'NirCrit. Modules[1].error';
	ELSIF 	iReasonCritical.1 THEN stEventLog.Text := 'NirCrit. Modules[2].error';
	ELSIF 	iReasonCritical.2 THEN stEventLog.Text := 'NirCrit. xSafetyError';
	END_IF
		
	gEventLogLoader(EventData := ADR(stEventLog));
	
END_ACTION