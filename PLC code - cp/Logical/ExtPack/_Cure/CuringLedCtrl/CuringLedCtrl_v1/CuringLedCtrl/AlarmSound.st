
ACTION AlarmSound: 
	
	// Alarms reseteable sound management.
	ars_AlrStop.xAlarm:= dataLed.AlSummary.xAlarmStop;
	ars_AlrStop.xSilence:= dataLed.Commands.Mute;
	ars_AlrStop();
		
	ars_AlrCritical.xAlarm:= dataLed.AlSummary.xAlarmCritical;
	ars_AlrCritical.xSilence:= dataLed.Commands.Mute;
	ars_AlrCritical();
	
	ars_AlrWarning.xAlarm:= dataLed.AlSummary.xAnyWarning;
	ars_AlrWarning.xSilence:= dataLed.Commands.Mute;
	ars_AlrWarning();
	
	dataLed.AlSummary.xAlarmSound:= //ars_AlrWarning.xAlarmSound OR 
									ars_AlrStop.xAlarmSound OR 
									ars_AlrCritical.xAlarmSound;
	
END_ACTION

