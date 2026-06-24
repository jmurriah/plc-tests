
ACTION AlarmsSummary: 
	
	//Alarms STOP
	iReasonStop.0 := dataHeigh.Alarms.CheckMedia[1];
	iReasonStop.1 := dataHeigh.Alarms.CheckMedia[2];
	
	dataHeigh.AlSummary.xAlarmStop := iReasonStop > 0;
	IF EDGEPOS(dataHeigh.AlSummary.xAlarmStop) THEN
		dataHeigh.AlSummary.iReasonStop[0] := iReasonStop;
	ELSIF EDGEPOS(NOT dataHeigh.parameters.AutoMode.xStop AND NOT dataHeigh.AlSummary.xAlarmStop) THEN
		dataHeigh.AlSummary.iReasonStop[0] := 0;
	END_IF
	
	//Alarms CRITICAL
	iReasonCritical.0 := FALSE;
	
	dataHeigh.AlSummary.xAlarmCritical := iReasonCritical > 0;
	IF dataHeigh.parameters.Mode.xAuto AND EDGEPOS(dataHeigh.AlSummary.xAlarmCritical) THEN
		dataHeigh.AlSummary.iReasonCritical := iReasonCritical;
	ELSIF EDGEPOS(dataHeigh.parameters.Mode.xAuto AND NOT dataHeigh.AlSummary.xAlarmCritical) THEN
		dataHeigh.AlSummary.iReasonCritical := 0;
	END_IF	
	
END_ACTION
