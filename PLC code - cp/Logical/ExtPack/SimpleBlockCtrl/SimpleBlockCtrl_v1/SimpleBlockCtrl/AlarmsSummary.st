
ACTION AlarmsSummary: 
	
	// Stop Alarms. The machine goes to Automatic-Stop.
	iReasonStop.0 := Block.Al.xAnyDriveAlarm;
	iReasonStop.1 := Block.Al.xAlrBarMtrNoRef;
	iReasonStop.2 := Block.Al.xAlrComBarMtr;
	
	Block.AlSummary.xAlarmStop:= iReasonStop > 0;
	IF EDGEPOS(Block.AlSummary.xAlarmStop) THEN
		Block.AlSummary.iReasonStop[0] := iReasonStop;
		LogStopAlarm;
	ELSIF EDGEPOS(NOT Block.commands.AutoMode.xStop AND NOT Block.AlSummary.xAlarmStop) THEN
		Block.AlSummary.iReasonStop[0] := 0;
	END_IF
	
	
	// Out of Automatic Alarms. The machine goes to Standby mode.
	iReasonCritical.0 := (Block.Al.xAlrSafetySystemInBlock AND Block.Status.xEnabledMovements);
	iReasonCritical.1 := Block.Al.xAlrDriveProtection;
	Block.AlSummary.xAlarmCritical:= iReasonCritical > 0;
	
	//Register the reason of the Critical Alarm
	IF Block.commands.Mode.xAuto AND EDGEPOS(Block.AlSummary.xAlarmCritical) THEN
		Block.AlSummary.iReasonCritical := iReasonCritical;
		LogCriticalAlarm;
	ELSIF EDGEPOS(Block.commands.Mode.xAuto AND NOT Block.AlSummary.xAlarmCritical) THEN
		Block.AlSummary.iReasonCritical := 0;
	END_IF
	
									 
	// Any alarm	
	Block.AlSummary.xAnyAlarm:= Block.AlSummary.xAlarmStop OR Block.AlSummary.xAlarmCritical;

	// Warning alarms (used in AlarmaAvisoExterno)
	iReasonAnyWarning.5 := Block.Al.xBarDriverTemp;
	iReasonAnyWarning.6 := Block.Al.xBarMotorTemp;
	iReasonAnyWarning.7 := Block.Al.xAlrCheckHomingSensor;
	iReasonAnyWarning.8 := Block.Al.xAlrBlockReachedMaxPosition;
	iReasonAnyWarning.13 := Block.Al.xAlrReferenceIncoherence;
	Block.AlSummary.xAnyWarning:= iReasonAnyWarning > 0 ;
	
	//Alarm Safety System General
	iReasonSafetyGeneral.1 := Block.Al.xAlrSafetySystemInBlock;
	Block.AlSummary.xAlrSafetySystemGeneral:= iReasonSafetyGeneral > 0;
	
END_ACTION
