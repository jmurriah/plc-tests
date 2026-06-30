
ACTION AlarmSounds: 

	// Alarms reseteable sound management.
	ars_AlrStop.xAlarm:= data.AlSummary.xAlarmStop;
	ars_AlrStop.xSilence:= data.commands.xMute;
	ars_AlrStop();
		
	ars_AlrCritical.xAlarm:= data.AlSummary.xAlarmCritical;
	ars_AlrCritical.xSilence:= data.commands.xMute;
	ars_AlrCritical();
	
	ars_AlrWarning.xAlarm:= data.AlSummary.xAnyWarning;
	ars_AlrWarning.xSilence:= data.commands.xMute;
	ars_AlrWarning();
	
	data.AlSummary.xAlarmSound:= 	//ars_AlrWarning.xAlarmSound OR 
									ars_AlrStop.xAlarmSound OR 
									ars_AlrCritical.xAlarmSound OR
									(xAnyManualOrder AND gPLC.xBlk_200ms); 

END_ACTION
