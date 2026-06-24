
ACTION AlarmsSummary: 
	

	//////////////////////////////
	//SUMMARY BELT ALARMS
	//////////////////////////////									
	
	iReasonWarning.0 := Belt.Al.xBeltMotorTemp;
	iReasonWarning.1 := Belt.Al.xBeltDriverTemp;
	iReasonWarning.2 := Belt.Al.xWrnOverTorq;

	Belt.AlSummary.xAnyWarning:= iReasonWarning > 0;
	IF EDGEPOS(Belt.AlSummary.xAnyWarning) THEN
		Belt.AlSummary.iReasonWarning := iReasonWarning;
		LogWarning;
	ELSIF EDGEPOS(NOT Belt.commands.AutoMode.xStop AND NOT Belt.AlSummary.xAlarmStop) THEN
		Belt.AlSummary.iReasonWarning := 0;
	END_IF
	
	
	// Stop alarms are drive alarms but just when are not from safety
	iReasonStop.0 := Belt.Al.xAnyDriveAlarm;
	iReasonStop.1 := Belt.Al.xAlrComDrive;
	iReasonStop.2 := Belt.Al.xAlrPowerBeltError;
	iReasonStop.3 := Belt.Al.xAlrProtDrive;
	iReasonStop.4 := Belt.Al.xAlrOverTorque;
	iReasonStop.5 := Belt.Al.xControllerNotReady;
	iReasonStop.6 := Belt.Al.xEnableVoltageSag;
	
	Belt.AlSummary.xAlarmStop:=	iReasonStop > 0;
	IF EDGEPOS(Belt.AlSummary.xAlarmStop) THEN
		Belt.AlSummary.iReasonStop[0] := iReasonStop;
		LogStopAlarm;
	ELSIF EDGEPOS(NOT Belt.commands.AutoMode.xStop AND NOT Belt.AlSummary.xAlarmStop) THEN
		Belt.AlSummary.iReasonStop[0] := 0;
	END_IF	
	
	
	// Summary Alarms (Critical, Sound, Warnings, Stop )
	iReasonCritical.1 := Belt.Al.xAxisLengthNotDefined;
	iReasonCritical.1 := Belt.Al.xGearBoxNotDefined;
	
	Belt.AlSummary.xAlarmCritical:= iReasonCritical>0;
	//Register the reason of the Critical Alarm
	IF Belt.commands.Mode.xAuto AND EDGEPOS(Belt.AlSummary.xAlarmCritical) THEN
		Belt.AlSummary.iReasonCritical := iReasonCritical;
		LogCriticalAlarm;
	ELSIF EDGEPOS(Belt.commands.Mode.xAuto AND NOT Belt.AlSummary.xAlarmCritical) THEN
		Belt.AlSummary.iReasonCritical := 0;
	END_IF	
	
	Belt.AlSummary.xAlrSafetySystemGeneral := Belt.commands.xExternalSafetyStop;

	Belt.AlSummary.xAnyAlarm:= Belt.AlSummary.xAlarmCritical OR Belt.AlSummary.xAlarmStop OR Belt.AlSummary.xAlrSafetySystemGeneral;
	
	

	// Alarms reseteable sound management.
	ars_AlrStop.xAlarm:= Belt.AlSummary.xAlarmStop;
	ars_AlrStop.xSilence:= Belt.commands.xMute;
	ars_AlrStop();
		
	ars_AlrCritical.xAlarm:= Belt.AlSummary.xAlarmCritical;
	ars_AlrCritical.xSilence:= Belt.commands.xMute;
	ars_AlrCritical();
	
	ars_AlrWarning.xAlarm:= Belt.AlSummary.xAnyWarning;
	ars_AlrWarning.xSilence:= Belt.commands.xMute;
	ars_AlrWarning();
	
	Belt.AlSummary.xAlarmSound:= 	//ars_AlrWarning.xAlarmSound OR 
									ars_AlrStop.xAlarmSound OR 
									ars_AlrCritical.xAlarmSound;

	
END_ACTION
