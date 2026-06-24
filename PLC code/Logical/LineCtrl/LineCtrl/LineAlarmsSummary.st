
ACTION LineAlarmsSummary:

	//////////////////
	// General Summary
	//////////////////

	//Warnings//
	iReasonWarning.0 := gMachine.AlSummary.xAnyWarning;
	iReasonWarning.1 := Feeder.Alarms.xWarningAlarm;
	iReasonWarning.2 := Primer.Alarms.xWarningAlarm;
	iReasonWarning.3 := Dryer.Alarms.xWarningAlarm;
	iReasonWarning.4 := Stacker.Alarms.xWarningAlarm;
	iReasonWarning.5 := SafetyController.Alarms.xWarningAlarm;
	iReasonWarning.6 := Sarm.Alarms.xWarningAlarm;
	
	Line.Alarms.xWarningAlarm :=  iReasonWarning > 0;
	
	//Register the reason of the warning alarm
	IF gMachine.St.Mode.xAuto AND EDGEPOS(Line.Alarms.xWarningAlarm) THEN
		Line.Alarms.iReasonWarning := iReasonWarning;
		LogWarningAlarm;
	ELSIF EDGEPOS(gMachine.St.Mode.xAuto AND NOT Line.Alarms.xWarningAlarm) THEN
		Line.Alarms.iReasonWarning := 0;
	END_IF

	
	//Alarms stop//
	IF gMachine.AutoCmd.xReset THEN
		iReasonStop := 0;
	END_IF
	
	IF (Line.Status <> LINE_STOPPED) THEN
		iReasonStop.0 := gMachine.AlSummary.xAlarmStop;
		iReasonStop.1 := Primer.Alarms.xCriticalAlarm;
		iReasonStop.2 := Line.Commands.Stop;
		iReasonStop.3 := CuringLed[1].AlSummary.xAlarmStop;
		iReasonStop.4 := CuringLed[2].AlSummary.xAlarmStop;
		iReasonStop.5 := EdgeHoldDown.AlSummary.xAlarmStop;
		iReasonStop.6 := Sarm.Alarms.xCriticalAlarm;
	END_IF

	Line.Alarms.xStopAlarm :=  iReasonStop > 0;
	
	//Register the reason of the Stop Alarm
	IF NOT Line.StatusSummary.xControlStopping AND EDGEPOS(Line.Alarms.xStopAlarm) THEN
		Line.Alarms.iReasonStop := iReasonStop;
		LogStopAlarm;
	ELSIF (Line.Status > LINE_STOPPED) THEN
		Line.Alarms.iReasonStop := 0;
	END_IF

	
	//Critical alarms//
	iReasonCritical.0 := gMachine.AlSummary.xAlarmCritical;
	iReasonCritical.1 := Dryer.Alarms.xCriticalAlarm;
	iReasonCritical.2 := Stacker.Alarms.xCriticalAlarm;
	iReasonCritical.3 := SafetyController.Alarms.xCriticalAlarm;
	iReasonCritical.4 := Line.Alarms.xAlrPrinterNoPowered;
	iReasonCritical.5 := Line.Alarms.xAlrOvervoltage;
	iReasonCritical.6 := Line.Alarms.xAlr24VdcStartSeqNoPowered;
	iReasonCritical.7 := gMachine.In.Buttons.xStop;
	iReasonCritical.8 := OverVarnish.Alarms.xCriticalAlarm;
	iReasonCritical.9 := CuringLed[1].AlSummary.xAlarmCritical;
	iReasonCritical.10 := CuringLed[2].AlSummary.xAlarmCritical;
	iReasonCritical.11 := EdgeHoldDown.AlSummary.xAlarmCritical;
	

	Line.Alarms.xCriticalAlarm :=  iReasonCritical > 0;
	
	//Register the reason of the Critical Alarm
	IF gMachine.St.Mode.xAuto AND EDGEPOS(Line.Alarms.xCriticalAlarm) THEN
		Line.Alarms.iReasonCritical := iReasonCritical;
		LogCriticalAlarm;
	ELSIF EDGEPOS(gMachine.St.Mode.xAuto AND NOT Line.Alarms.xCriticalAlarm) THEN
		Line.Alarms.iReasonCritical := 0;
	END_IF
	
	iReasonResetCondition.0 := (NOT Line.Alarms.xWarningAlarm) AND (Line.Alarms.iReasonWarning > 0);
	iReasonResetCondition.1 := (NOT Line.Alarms.xStopAlarm) AND (Line.Alarms.iReasonStop > 0);
	iReasonResetCondition.2 := (NOT Line.Alarms.xCriticalAlarm) AND (Line.Alarms.iReasonCritical > 0);
	
	Line.Alarms.xResetCondition :=  iReasonResetCondition > 0;
	
	xNoAlarmsActive := (NOT Line.Alarms.xCriticalAlarm) AND 
						(NOT Line.Alarms.xStopAlarm); 
	
	LightTower;
	SoundLightTower;
	
END_ACTION

