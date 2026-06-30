
ACTION alarmsSound: 
	
	// Alarms reseteable sound management.
	ars_AlrStop.xAlarm:= dataChill.AlSummary.xAlarmStop;
	ars_AlrStop.xSilence:= dataChill.commands.xMute;
	ars_AlrStop();
		
	ars_AlrCritical.xAlarm:= dataChill.AlSummary.xAlarmCritical;
	ars_AlrCritical.xSilence:= dataChill.commands.xMute;
	ars_AlrCritical();
	
	ars_AlrWarning.xAlarm:= dataChill.AlSummary.xAnyWarning;
	ars_AlrWarning.xSilence:= dataChill.commands.xMute;
	ars_AlrWarning();
	
	dataChill.AlSummary.xAlarmSound:= 	//ars_AlrWarning.xAlarmSound OR 
										ars_AlrStop.xAlarmSound OR 
										ars_AlrCritical.xAlarmSound;

END_ACTION
