
ACTION Alarms: 
	
	//WARNING
	IF NOT dataBeltClean.ParSw.xAirTurbineEnabled THEN
		dataBeltClean.Alarm.xAirTurbDisabled := TRUE;
	END_IF
	IF NOT dataBeltClean.Inputs.xAirTurbVSDAvailable THEN
		dataBeltClean.Alarm.xAirTurbDisVSDFault := TRUE;
	END_IF
	IF dataBeltClean.Commands.xAcceptRequest AND NOT dataBeltClean.Parameters.xBeltEmpty THEN
		dataBeltClean.Alarm.xBeltNotEmptyToClean := TRUE;
	END_IF
	
	//STOP
	IF (dataBeltClean.Status.State = BCLEAN_CLEANING OR dataBeltClean.Status.State = BCLEAN_DRYING) AND NOT dataBeltClean.Parameters.xBeltRunning THEN
		dataBeltClean.Alarm.xBeltIsNotRuning := TRUE;
	END_IF
	IF dataBeltClean.ParSw.xAirTurbineEnabled AND NOT dataBeltClean.Inputs.xAirTurbVSDAvailable THEN
		dataBeltClean.Alarm.xAirTurbEnVSDFault := TRUE;
	END_IF
	IF ton_WaitingToCleanState.Q THEN
		dataBeltClean.Alarm.xWaitingToCleanState := TRUE;
	END_IF
	
	IF dataBeltClean.Status.xCleaning AND NOT dataBeltClean.Parameters.xBeltEmpty THEN
		dataBeltClean.Alarm.xBeltIsNotEmpty := TRUE;
	END_IF
	

END_ACTION
