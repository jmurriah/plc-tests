
ACTION BlowerAlarms: 
	
	
	//Comunication Alarm
	IF Blower.Status.ErrorComms THEN
		dataVacc.Alarms.xAlrComsBlower := TRUE;
		dataVacc.Alarms.xAlrCommsBlower[uiIndex] := TRUE;
	END_IF
	
	tonCheckAlarms.IN := dataVacc.Inputs.xSafetyEnable;
	tonCheckAlarms.PT := T#3000ms;
	tonCheckAlarms();	
	
	//Driver Blower Error
	IF tonCheckAlarms.Q AND NOT dataVacc.Alarms.xAlrComsBlower AND 
		((Blower.Status.ErrorID <> 0 AND Blower.Status.ErrorID <> 20625) OR Blower.Status.StatusErrorStop) THEN
			dataVacc.Alarms.xAlrDriveBlowerError := TRUE;
			dataVacc.Alarms.xAlrBlowerError[uiIndex] := TRUE;
	END_IF

	//Separate CB Blower Alarm
	IF tonCheckAlarms.Q AND NOT Blower.ElecSignals.In.xBreakerOK THEN
		dataVacc.Alarms.xAlrBlowerCB[uiIndex] := TRUE;
	END_IF
	
	IF FALSE THEN
		dataVacc.Alarms.xAlrOvertorque := TRUE;
	END_IF
	
	//Alarm if the blower has a speed configure higher than 0, has order to move and is stopped
	//Using Orders.PowerOn because Commands.MovePositive and Commands.MoveNegative are just edges
	tonBlowerNotRunning[uiIndex].IN := StatusCtrl <> TRANSVAC_OFF AND Blower.Parameters.Velocity > 40.0 AND ABS(Blower.Status.ActVelocity) < 40.0;
	tonBlowerNotRunning[uiIndex].PT := T#5s;
	tonBlowerNotRunning[uiIndex]();
	IF tonBlowerNotRunning[uiIndex].Q THEN
		dataVacc.Alarms.xAlrBlowerNotRunning[uiIndex] := TRUE;
	END_IF
	
END_ACTION