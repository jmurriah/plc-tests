
ACTION LogCriticalAlarm:
	
	stEventLogCritical.Source := ELOG_TYPE_GENERAL;
	stEventLogCritical.Severity:= ELOG_SEVERITY_ERROR;
	stEventLogCritical.Facility:= 0;
	stEventLogCritical.ErrorCode:=0;
	
	stEventLogCritical.Text := 'Gen.LogCriticalAlarm';
	
	IF 		iReasonCritical.0 THEN stEventLogCritical.Text := 'Gen Critical. xAlrSafetySystemGeneral';
	ELSIF 	iReasonCritical.1 THEN stEventLogCritical.Text := 'Gen Critical. Belt Crical Alarm';
	ELSIF 	iReasonCritical.2 THEN stEventLogCritical.Text := 'Gen Critical. NIR Crical Alarm';
	ELSIF 	iReasonCritical.3 THEN stEventLogCritical.Text := 'Gen Critical. ARC LAMP Crical Alarm';
	ELSIF 	iReasonCritical.4 THEN stEventLogCritical.Text := 'Gen Critical. TransVacuum Crical Alarm';
	END_IF
		
	gEventLogLoader(EventData := ADR(stEventLogCritical));
	
END_ACTION

ACTION LogStopDryingAlarm:

	stEventLogStopDrying.Source := ELOG_TYPE_GENERAL;
	stEventLogStopDrying.Severity:= ELOG_SEVERITY_ERROR;
	stEventLogStopDrying.Facility:= 0;
	stEventLogStopDrying.ErrorCode:=0;
	
	stEventLogStopDrying.Text := 'Gen.LogStopDryingAlarm';
	
	IF 		iReasonStopDrying.0 THEN stEventLogStopDrying.Text := 'Gen StopDrying. xAlrBeltOvertorque';
	ELSIF 	iReasonStopDrying.1 THEN stEventLogStopDrying.Text := 'Gen StopDrying. xAlrBeltOverTempFast';
	ELSIF 	iReasonStopDrying.2 THEN stEventLogStopDrying.Text := 'Gen StopDrying. xAlrBeltOverTempSlow';
	END_IF
		
	gEventLogLoader(EventData := ADR(stEventLogStopDrying));
	
END_ACTION

ACTION LogOutOfAuto:
	
	stEventLogOutAuto.Source := ELOG_TYPE_GENERAL;
	stEventLogOutAuto.Severity:= ELOG_SEVERITY_INFO;
	stEventLogOutAuto.Facility:= 0;
	stEventLogOutAuto.ErrorCode:=0;
	
	stEventLogOutAuto.Text := 'Gen.LogOutOfAuto';
	
	IF 		iReasonOut.0 AND enPrinterState=PRINTERGEN_MANUAL THEN stEventLogOutAuto.Text := 'OutOfMan. Selector to Zero';
	ELSIF 	iReasonOut.0 AND enPrinterState=PRINTERGEN_AUTO THEN stEventLogOutAuto.Text := 'OutOfAuto. Selector to Zero';
	ELSIF 	iReasonOut.1 THEN stEventLogOutAuto.Text := 'OutOfAuto. Selector NOT Auto';
	ELSIF 	iReasonOut.2 THEN stEventLogOutAuto.Text := 'OutOfMan. Selector NOT Manual';
	ELSIF 	iReasonOut.3 THEN stEventLogOutAuto.Text := 'OutOfAuto. Critical Alarm';
	ELSIF 	iReasonOut.4 AND enPrinterState=PRINTERGEN_MANUAL THEN stEventLogState.Text := 'OutOfMan. Emergency alarm';
	ELSIF 	iReasonOut.4 AND enPrinterState=PRINTERGEN_AUTO THEN stEventLogOutAuto.Text := 'OutOfAuto. Emergency alarm';
	END_IF
		
	gEventLogLoader(EventData := ADR(stEventLogOutAuto));
	
END_ACTION

ACTION LogNewState:

	stEventLogState.Source := ELOG_TYPE_GENERAL;
	stEventLogState.Severity:= ELOG_SEVERITY_INFO;
	stEventLogState.Facility:= 0;
	stEventLogState.ErrorCode:=0;

	stEventLogState.Text := 'NewState. Unknown';
	
	CASE DryerStatus OF
		DRYERMACH_STOPPED: 				stEventLogState.Text := 'NewState. Stopped';
		DRYERMACH_STOPPING_TRANSPORT:	stEventLogState.Text := 'NewState. StoppingTransport';
		DRYERMACH_PREPARINGTOMOVE:		stEventLogState.Text := 'NewState. PreparingToMove';
		DRYERMACH_MOVING:				stEventLogState.Text := 'NewState. Moving';
		DRYERMACH_PREPARING:			stEventLogState.Text := 'NewState. Preparing';
		DRYERMACH_PREPARED:				stEventLogState.Text := 'NewState. Prepared';
		DRYERMACH_STARTING:				stEventLogState.Text := 'NewState. Starting';
		DRYERMACH_DRYING:				stEventLogState.Text := 'NewState. Drying';
		DRYERMACH_STOPPING_DRYING:		stEventLogState.Text := 'NewState. StoppinDrying';
	END_CASE;
		
	gEventLogLoader(EventData := ADR(stEventLogState));
	
END_ACTION

ACTION LogStopAlarm:

	//Alarms stop//
	stEventLog.Source := ELOG_TYPE_GENERAL;
	stEventLog.Severity:= ELOG_SEVERITY_ERROR;
	stEventLog.Facility:= 0;
	stEventLog.ErrorCode:=0;
	
	stEventLog.Text := 'Gen.LogStopAlarm';
	
	IF 		iReasonStopGen.0 THEN stEventLog.Text := 'Gen Stop. xAlarmAir1';
	ELSIF 	iReasonStopGen.1 THEN stEventLog.Text := 'Gen Stop. xAlarmComPcPLC';
	ELSIF 	iReasonStopGen.2 THEN stEventLog.Text := 'Gen Stop. xAlarmMountedMedia';
	ELSIF 	iReasonStopGen.3 THEN stEventLog.Text := 'Gen Stop. xAlrBeltOvertorque';
	ELSIF 	iReasonStopGen.4 THEN stEventLog.Text := 'Gen Stop. xAlrBeltOverTempFast';
	ELSIF 	iReasonStopGen.5 THEN stEventLog.Text := 'Gen Stop. xAlrBeltOverTempSlow';
	ELSIF 	iReasonStopGen.6 THEN stEventLog.Text := 'Gen Stop. Belt.AlarmStop';
	ELSIF 	iReasonStopGen.7 THEN stEventLog.Text := 'Gen Stop. SimpleBlock[1].xAlarmStop';
	ELSIF 	iReasonStopGen.8 THEN stEventLog.Text := 'Gen Stop. NirAdphos.AlarmStop';
	ELSIF 	iReasonStopGen.9 THEN stEventLog.Text := 'Gen Stop. ArcLampGew.AlarmStop';
	ELSIF 	iReasonStopGen.10 THEN stEventLog.Text := 'Gen Stop. gTransVacuum[1].AlarmStop';
	ELSIF 	iReasonStopGen.11 THEN stEventLog.Text := 'Gen Stop. NirAdphos.AnyJam';
	ELSIF 	iReasonStopGen.12 THEN stEventLog.Text := 'Gen Stop. ArcLampGew.Jam';
	END_IF
		
	gEventLogLoader(EventData := ADR(stEventLog));
	
END_ACTION