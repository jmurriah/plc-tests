
ACTION AlarmSounds: 

	ars_MotorError.xAlarm:= data.Alarms.xMotorError;
	ars_MotorError.xSilence:= data.commands.xMute;
	ars_MotorError();
	
	ars_ComsMotorError.xAlarm:= data.Alarms.xComsMotorError;
	ars_ComsMotorError.xSilence:= data.commands.xMute;
	ars_ComsMotorError();
	
	ars_NotReferenced.xAlarm:= data.Alarms.xNotReferenced;
	ars_NotReferenced.xSilence:= data.commands.xMute;
	ars_NotReferenced();
	
	ars_IncoherPhotocellSystem.xAlarm:= data.Alarms.xIncoherPhotocellSystem;
	ars_IncoherPhotocellSystem.xSilence:= data.commands.xMute;
	ars_IncoherPhotocellSystem();
	
	ars_InvalidAlignmentPosition.xAlarm:= data.Alarms.xAlrInvalidAlignmentPosition;
	ars_InvalidAlignmentPosition.xSilence:= data.commands.xMute;
	ars_InvalidAlignmentPosition();
	
	ars_CriticalPhotocellNotAligned.xAlarm:= data.Alarms.xAlrCriticalPhotocellNotAligned;
	ars_CriticalPhotocellNotAligned.xSilence:= data.commands.xMute;
	ars_CriticalPhotocellNotAligned();
	
	arsContinuousActPDPhcell.xAlarm:= data.Alarms.xContinuousActPDPhcell;
	arsContinuousActPDPhcell.xSilence:= data.commands.xMute;
	arsContinuousActPDPhcell();
	
	data.AlSummary.xAlarmSound:= 	ars_MotorError.xAlarmSound OR
									ars_ComsMotorError.xAlarmSound OR
									ars_NotReferenced.xAlarmSound OR
									ars_IncoherPhotocellSystem.xAlarmSound OR
									ars_InvalidAlignmentPosition.xAlarmSound OR
									ars_CriticalPhotocellNotAligned.xAlarmSound OR
									arsContinuousActPDPhcell.xAlarmSound OR
									(xAnyManualOrder AND gPLC.xBlk_200ms); 

END_ACTION
