
ACTION alarms: 
	
	//Reset Alarms with an external order to reset
	IF dataChill.commands.xReset THEN
		ResetAlarms;
	END_IF
	
	//Alarm: Chiller not running	
	TON_DelayChillerNotRun.IN := dataChill.St.xRunning AND NOT dataChill.In.xPowered;
	TON_DelayChillerNotRun.PT := t#20s;
	TON_DelayChillerNotRun();
	
	IF TON_DelayChillerNotRun.Q THEN
		dataChill.Alarm.xNotRunning := TRUE;	//High Temperature Alarm Or not feedback
	END_IF
	
	//Alarm: Chiller in alarm
	TON_DelayChillerInAlarm.IN := dataChill.In.xAlarm;
	TON_DelayChillerInAlarm.PT := t#10s;
	TON_DelayChillerInAlarm();
	
	IF TON_DelayChillerInAlarm.Q THEN
		dataChill.Alarm.xInAlarm := TRUE;
	END_IF
	
	
	CASE dataChill.Parameters.SystemType OF
		
		CHILLERSYS_DIRECT:

			
		CHILLERSYS_WATERMANIFOLD:
			AlarmsWaterManifold;
		
	END_CASE
	
	
	
END_ACTION

ACTION ResetAlarms:
	dataChill.AlSummary:= stChillerAlarmsSummaryReseted;
	dataChill.Alarm:= stChillerAlarmsReseted;
END_ACTION

ACTION AlarmsWaterManifold:
	
	//Alarm: Chiller enviorenment temperature sensor error
	TON_DelayChillerEnvSensError.IN := dataChill.In.WaterManifold.xTempEnvSensError;
	TON_DelayChillerEnvSensError.PT := t#5s;
	TON_DelayChillerEnvSensError();
	
	IF TON_DelayChillerEnvSensError.Q THEN	
		dataChill.Alarm.xAlrEnvTempSensBrokn := TRUE;
	END_IF
	

	//Alarm: Chiller water temperature sensor error
	TON_DelayChillerWatSensError.IN := dataChill.In.WaterManifold.xTempWatSensError;
	TON_DelayChillerWatSensError.PT := t#5s;
	TON_DelayChillerWatSensError();
	
	IF TON_DelayChillerWatSensError.Q THEN
		dataChill.Alarm.xAlrTempSensBrokn	:= TRUE;
	END_IF
	

	// show SP update message
	TON_DelayCheckChiller.IN := dataChill.St.xRunning;
	TON_DelayCheckChiller.PT := T#15m; //Time for the Chiller to arrive to Temperature
	TON_DelayCheckChiller();
	
	tonEstabCheck.IN := TON_DelayCheckChiller.Q AND (dataChill.Parameters.rTempSetPoint < dataChill.St.WaterManifold.rManifoldTemp);
	tonEstabCheck.PT := t#5s;
	tonEstabCheck();
	
	IF tonEstabCheck.Q THEN
		dataChill.Alarm.xCheckChiller := TRUE;
	END_IF	

END_ACTION
