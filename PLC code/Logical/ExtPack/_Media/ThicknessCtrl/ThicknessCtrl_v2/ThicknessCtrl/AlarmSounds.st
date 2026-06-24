
ACTION AlarmSounds: 
	
	FOR iIndexCheck:=1 TO MAX_LAST_CHECKMEDIA DO
		ars_CheckMedia[iIndexCheck].xAlarm:= dataHeigh.Alarms.CheckMedia[iIndexCheck];
		ars_CheckMedia[iIndexCheck].xSilence:= dataHeigh.Commands.xMute;
		ars_CheckMedia[iIndexCheck]();
	END_FOR		

	ars_NoThicknessSystemInstalled.xAlarm:= dataHeigh.Alarms.xNoThicknessInstalled;
	ars_NoThicknessSystemInstalled.xSilence:= dataHeigh.Commands.xMute;
	ars_NoThicknessSystemInstalled();
	
	iReasonSound.0 := ars_CheckMedia[1].xAlarmSound;
	iReasonSound.1 := ars_CheckMedia[2].xAlarmSound;
	iReasonSound.2 := ars_NoThicknessSystemInstalled.xAlarmSound;
	dataHeigh.AlSummary.xAlarmSound := iReasonSound > 0;

END_ACTION
