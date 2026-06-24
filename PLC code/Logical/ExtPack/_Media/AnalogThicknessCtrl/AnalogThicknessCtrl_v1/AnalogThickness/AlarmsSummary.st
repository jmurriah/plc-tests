
ACTION AlarmsSummary: 
	
	//////////////////////////
	////// RESET ALARMS //////
	//////////////////////////	
	// Pending do commands gdata.commands.xReset
	IF data.Commands.xErrorRst THEN
		data.Alarms := stThickAlarmsReseted;
		data.AlSummary := stAlarmsSummaryReseted;
	END_IF
	
	//Alarms STOP
	iReasonStop.0 := data.Alarms.xAlDingConexionError;
	iReasonStop.1 := data.Alarms.xAlDingNotReferenced;
	iReasonStop.2 := data.Alarms.xAlDingDetect;
	iReasonStop.3 := data.Alarms.xAlNoDingDetect;
	iReasonStop.4 := data.Alarms.xAlDingIncoherenceValue;
	iReasonStop.5 := data.Alarms.xAlDingNoDigLaserSensor;
	
	data.AlSummary.xAlarmStop := iReasonStop > 0;
	IF EDGEPOS(data.AlSummary.xAlarmStop) THEN
		data.AlSummary.iReasonStop[0] := iReasonStop;
	ELSIF EDGEPOS(NOT data.Commands.AutoMode.xStop AND NOT data.AlSummary.xAlarmStop) THEN
		data.AlSummary.iReasonStop[0] := 0;
	END_IF
	
	//Alarms CRITICAL
	iReasonCritical.0 := data.Alarms.xAlDingConexionError AND data.Commands.AutoMode.xProdORLab;
	
	data.AlSummary.xAlarmCritical := iReasonCritical > 0;
	IF data.Commands.Mode.xAuto AND EDGEPOS(data.AlSummary.xAlarmCritical) THEN
		data.AlSummary.iReasonCritical := iReasonCritical;
	ELSIF EDGEPOS(data.Commands.Mode.xAuto AND NOT data.AlSummary.xAlarmCritical) THEN
		data.AlSummary.iReasonCritical := 0;
	END_IF	
	
END_ACTION
