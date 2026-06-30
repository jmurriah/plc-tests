
ACTION JamAlarmsSound: 
	
	
	//Auto reset sound management. All alarms need to work with mute option
	ars_AlrJamDetectionSound(xAlarm:=JamDetect.AlSummary.xAlarmStop, xSilence:=JamDetect.Commands.xMuteAlarms);
	
	
	//AutoReset alarms.
		
		JamDetect.AlSummary.xAlarmSound:=ars_AlrJamDetectionSound.xAlarmSound;
				
	

END_ACTION
