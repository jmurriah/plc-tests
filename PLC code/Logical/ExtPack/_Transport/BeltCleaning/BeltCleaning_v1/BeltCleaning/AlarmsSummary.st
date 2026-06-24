
ACTION AlarmsSummary: 
	
	dataBeltClean.AlSummary.iReasonWarning.0 := dataBeltClean.Alarm.xAirTurbDisabled;
	dataBeltClean.AlSummary.iReasonWarning.1 := dataBeltClean.Alarm.xAirTurbDisVSDFault;
	dataBeltClean.AlSummary.iReasonWarning.2 := dataBeltClean.Alarm.xBeltNotEmptyToClean;
	
	dataBeltClean.AlSummary.xAnyWarning := dataBeltClean.AlSummary.iReasonWarning > 0;
	
	
	dataBeltClean.AlSummary.iReasonStop[0].0 := dataBeltClean.Alarm.xBeltIsNotRuning;
	dataBeltClean.AlSummary.iReasonStop[0].1 := dataBeltClean.Alarm.xAirTurbEnVSDFault;
	dataBeltClean.AlSummary.iReasonStop[0].2 := dataBeltClean.Alarm.xWaitingToCleanState;
	dataBeltClean.AlSummary.iReasonStop[0].3 := dataBeltClean.Alarm.xBeltIsNotEmpty;
	
	dataBeltClean.AlSummary.xAlarmStop := dataBeltClean.AlSummary.iReasonStop[0] > 0;
	
	
	dataBeltClean.AlSummary.xAnyAlarm := dataBeltClean.AlSummary.xAlarmCritical OR dataBeltClean.AlSummary.xAlarmStop OR dataBeltClean.AlSummary.xAnyWarning;
	
	IF dataBeltClean.Commands.xReset THEN
		dataBeltClean.Alarm := ResetAlarms;
		dataBeltClean.AlSummary := ResetAlSummary;
	END_IF	
	
	ars_AnyAlarm.xAlarm:= dataBeltClean.AlSummary.xAnyAlarm;
	ars_AnyAlarm.xSilence:=dataBeltClean.Commands.xMute;
	ars_AnyAlarm();
	
	dataBeltClean.AlSummary.xAlarmSound := ars_AnyAlarm.xAlarmSound;
	
END_ACTION
