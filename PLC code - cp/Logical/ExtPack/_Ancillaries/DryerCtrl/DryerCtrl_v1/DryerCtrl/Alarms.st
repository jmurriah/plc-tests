
ACTION Alarms:

	Dryer.Alarms.xNoDryerPresent:= NOT Dryer.Inputs.xInRemote;
	
	//IF NO Dryer, define that alarm and exit
	IF Dryer.Alarms.xNoDryerPresent THEN
		ResetAlarms;
		Dryer.Alarms.xNoDryerPresent:=TRUE;
	END_IF

	//Error
	IF Dryer.Inputs.xError THEN
		Dryer.Alarms.xError := TRUE;
	END_IF
	
	//Remote
	IF (NOT Dryer.Inputs.xInRemote) AND Dryer.Parameters.xLineInAuto THEN
		Dryer.Alarms.xNotRemote := TRUE;
	END_IF
	
	//Stop request
	IF (Dryer.Inputs.xStopButtonPressed) THEN
		Dryer.Alarms.xStopRequest := TRUE;
	END_IF
	
	//Summary
	Dryer.Alarms.xCriticalAlarm:= 	Dryer.Alarms.xError OR
									Dryer.Alarms.xNotRemote OR 
									Dryer.Alarms.xStopRequest;
	
END_ACTION



ACTION ResetAlarms:
	Dryer.Alarms := AlarmsReseted;
END_ACTION