ACTION LogStopAlarm:

	stStopAlarmsLog.Source := ELOG_TYPE_BAR;
	stStopAlarmsLog.Severity:= ELOG_SEVERITY_INFO;
	stStopAlarmsLog.Facility:= 0;
	stStopAlarmsLog.ErrorCode:=0;
	
	stStopAlarmsLog.Text := 'Inks.LogStopAlarm';
	
	IF iReasonStop.0 THEN stStopAlarmsLog.Text := 'iReasonCritical > 0';
	ELSIF iReasonStop.1 THEN stStopAlarmsLog.Text := 'inks.Al.xAlrHeaterOutFault';
	ELSIF iReasonStop.2 THEN stStopAlarmsLog.Text := 'inks.Al.xAlrPrintHeadPsuFailure';
	ELSIF iReasonStop.3 THEN stStopAlarmsLog.Text := 'inks.Al.xAlrDifCtrlTempExcessive';
	ELSIF iReasonStop.4 THEN stStopAlarmsLog.Text := 'NOT inks.ordersSw.xStartInks';
	ELSIF iReasonStop.5 THEN stStopAlarmsLog.Text := 'inks.parSw.Config.iInkType = 0';
	ELSIF iReasonStop.6 THEN stStopAlarmsLog.Text := 'inks.parSw.Config.iPrintHeadType = 0';
	ELSIF iReasonStop.7 THEN stStopAlarmsLog.Text := 'inks.Al.xAlrNoRecircStop';
	ELSIF iReasonStop.8 THEN stStopAlarmsLog.Text := 'inks.Al.xAlrTankCloseToEmpty';
	ELSIF iReasonStop.9 THEN stStopAlarmsLog.Text := 'inks.Al.xAlrPrintHeadsChillerStopped';
	END_IF
		
	gEventLogLoader(EventData := ADR(stStopAlarmsLog));
	
END_ACTION

ACTION LogCriticalAlarm:

	stEventLogCritical.Source := ELOG_TYPE_BAR;
	stEventLogCritical.Severity:= ELOG_SEVERITY_ERROR;
	stEventLogCritical.Facility:= gIndexInks;
	stEventLogCritical.ErrorCode:=0;
	
	stEventLogCritical.Text := 'Inks.LogCriticalAlarm';
	
	IF 		iReasonCritical.0 THEN stEventLogCritical.Text := 'Bar. xAlrTankEmpty';
	ELSIF 	iReasonCritical.1 THEN stEventLogCritical.Text := 'Bar. xAlrStopRecircNoInk';
	ELSIF 	iReasonCritical.2 THEN stEventLogCritical.Text := 'Bar. xAlrTemp';
	ELSIF 	iReasonCritical.3 THEN stEventLogCritical.Text := 'Bar. xAlrVacuum1';
	ELSIF 	iReasonCritical.4 THEN stEventLogCritical.Text := 'Bar. xAlrVacuum2';
	ELSIF 	iReasonCritical.5 THEN stEventLogCritical.Text := 'Bar. xAlrVacuumSensor1';
	ELSIF 	iReasonCritical.6 THEN stEventLogCritical.Text := 'Bar. xAlrVacuumSensor2';
	ELSIF 	iReasonCritical.7 THEN stEventLogCritical.Text := 'Bar. xAlrTempSensor';
	ELSIF 	iReasonCritical.8 THEN stEventLogCritical.Text := 'Bar. xAlrBrokenMeniscus';
	ELSIF 	iReasonCritical.9 THEN stEventLogCritical.Text := 'Bar. xAlrOverPressure';
	ELSIF 	iReasonCritical.10 THEN stEventLogCritical.Text := 'Bar. xAlrLevelSensorError';
	ELSIF 	iReasonCritical.11 THEN stEventLogCritical.Text := 'Bar. xAlrTankDigitalSensorsError';
	ELSIF 	iReasonCritical.12 THEN stEventLogCritical.Text := 'Bar. xAlrPumpsDCError';
	ELSIF 	iReasonCritical.13 THEN //stEventLog.Text := 'Bar. xAlrTemp';
	ELSIF 	iReasonCritical.14 THEN //stEventLog.Text := 'Bar. xAlrTemp';
	ELSIF 	iReasonCritical.15 THEN //stEventLog.Text := 'Bar. xAlrTemp';
	END_IF
		
	gEventLogLoader(EventData := ADR(stEventLogCritical));
	
END_ACTION
