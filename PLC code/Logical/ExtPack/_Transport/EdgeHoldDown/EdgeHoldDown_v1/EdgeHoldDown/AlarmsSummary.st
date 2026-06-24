
ACTION AlarmsSummary: 
	
	//////////////////////////
	////// RESET ALARMS //////
	//////////////////////////	
	// Pending do commands gdata.commands.xReset
	IF data.commands.xErrorRst THEN
		data.Alarms := stAlarmsReseted;
		data.AlSummary := stEhdAlarmSummaryReseted;
	END_IF
		
	
	//Alarms
	IF data.status.xMoving AND NOT data.parameters.xEnableMovements THEN
		data.Alarms.xMovementsNotEnabled:=TRUE;
	END_IF
	
	IF data.status.xAdjustedToMedia AND data.inputs.xJam THEN
		data.Alarms.xJam:=TRUE;
	END_IF
	
	IF data.orders.xAdjustToMedia THEN
		IF ((AdjustmentSystem[1].parameters.rMechPositionMax + 2) < AdjustmentSystem[1].parameters.rPositionDesired) OR
			((AdjustmentSystem[1].parameters.rMechPositionMin - 2) > AdjustmentSystem[1].parameters.rPositionDesired) OR
			((AdjustmentSystem[2].parameters.rMechPositionMax + 2) < AdjustmentSystem[2].parameters.rPositionDesired) OR
			((AdjustmentSystem[2].parameters.rMechPositionMin - 2) > AdjustmentSystem[2].parameters.rPositionDesired) THEN
			
			data.Alarms.xParametersOutOfRange:=TRUE;
		END_IF
	END_IF
			
	
	
	//Alarms summary							
	//Stop
	iReasonStop.0 := AdjustmentSystem[1].AlSummary.xAlarmStop;
	iReasonStop.1 := AdjustmentSystem[2].AlSummary.xAlarmStop;
	iReasonStop.2 := data.Alarms.xNotReferenced;
	iReasonStop.3 := data.Alarms.xParametersOutOfRange;
	
	data.AlSummary.xAlarmStop := iReasonStop > 0;
	IF EDGEPOS(data.AlSummary.xAlarmStop) THEN
		data.AlSummary.iReasonStop[0] := iReasonStop;
		LogStopAlarm;
	ELSIF EDGEPOS(NOT data.commands.AutoMode.xStop AND NOT data.AlSummary.xAlarmStop) THEN
		data.AlSummary.iReasonStop[0] := 0;
	END_IF
	
	
	//Critical
	iReasonCritical.0 := AdjustmentSystem[1].AlSummary.xAlarmCritical;
	iReasonCritical.1 := AdjustmentSystem[2].AlSummary.xAlarmCritical;
	iReasonCritical.2 := data.Alarms.xMovementsNotEnabled;
	iReasonCritical.3 := data.Alarms.xJam;
	
	data.AlSummary.xAlarmCritical := iReasonCritical > 0;
	IF EDGEPOS(data.AlSummary.xAlarmCritical) THEN
		data.AlSummary.iReasonCritical := iReasonCritical;
		LogCriticalAlarm;
	ELSIF EDGEPOS(data.commands.Mode.xAuto AND NOT data.AlSummary.xAlarmCritical) THEN
		data.AlSummary.iReasonCritical := 0;
	END_IF
	
	
	//Warning
	// It is just used for drive alarms
	iAnyWarning.0 := AdjustmentSystem[1].AlSummary.xAnyWarning;
	iAnyWarning.1 := AdjustmentSystem[2].AlSummary.xAnyWarning;

	
	data.AlSummary.xAnyWarning:= iAnyWarning > 0;
	IF EDGEPOS(data.AlSummary.xAnyWarning) THEN
		data.AlSummary.iReasonWarning := iAnyWarning;
		LogWarningAlarm;
	ELSIF EDGEPOS(NOT data.AlSummary.xAnyWarning) THEN
		data.AlSummary.iReasonWarning := 0;
	END_IF
	
END_ACTION
