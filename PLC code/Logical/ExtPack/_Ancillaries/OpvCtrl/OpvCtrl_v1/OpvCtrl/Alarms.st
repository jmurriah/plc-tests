
ACTION Alarms:

	OverVarnish.Alarms.xNoOPVPresent:= NOT OverVarnish.Inputs.xOPVPresent;
	
	//IF NO OverVarnish, define that alarm and exit
	IF OverVarnish.Alarms.xNoOPVPresent THEN
		ResetAlarms;
		OverVarnish.Alarms.xNoOPVPresent:=TRUE;
	END_IF

	//OverVarnish No Powered Warning
	IF OverVarnish.Inputs.xNoPowered THEN OverVarnish.Alarms.xNoPowered := TRUE; END_IF
	
	OverVarnish.Alarms.xCoatingLevelLow:=OverVarnish.Inputs.xCoatingLevelLow;

	IF OverVarnish.Inputs.xError THEN
		OverVarnish.Alarms.xError := TRUE;
	END_IF
	
		
	//Saving modbus slave status when comms error raises
	IF EDGEPOS (OverVarnish.Alarms.xCommsError) THEN
		ModSlaveState := OverVarnish.Status.Comms.ModSlaveState;
		LastError := OverVarnish.Status.Comms.LastError;
		LastErrorBlockNum := OverVarnish.Status.Comms.LastErrorBlockNum;
	END_IF
	
	//Alarms related to comms
	IF OverVarnish.Status.Comms.xModuleOk THEN
		//Remote
		IF (NOT OverVarnish.Inputs.Comms.xRemote) AND OverVarnish.Parameters.xLineInAuto THEN
			OverVarnish.Alarms.xNotRemote := TRUE;
		END_IF
		
		//Stop request
		IF OverVarnish.Inputs.Comms.xStopButtonPressed THEN
			OverVarnish.Alarms.xStopRequest := TRUE;
		END_IF
	END_IF

	
	//Data write to ancillaries is critical to be updated properly. So just write block is monitored to raise comms alarm
	//Added ancillary first command used to get it ready to check comms also.
	//Read function not considered as the only variable critical for line process is to acknowledge "belt empty" status and in case of module nOk
	//timer "tonEmptyBelt" is executed
	ton_CommsError.IN := NOT OverVarnish.Status.Comms.xModuleOk AND (NOT OverVarnish.Orders.xDisableWriteBlock OR OverVarnish.Commands.xPrepare);
	ton_CommsError.PT := T#500ms;
	ton_CommsError();
	
	IF ton_CommsError.Q  THEN	
		OverVarnish.Alarms.xCommsError := TRUE;
	END_IF
	

	//Alarms Summary
	//Critical	
	OverVarnish.Alarms.xCriticalAlarm:= OverVarnish.Alarms.xError OR
										OverVarnish.Alarms.xNoPowered OR
										OverVarnish.Alarms.xNotRemote OR
										OverVarnish.Alarms.xStopRequest OR
										OverVarnish.Alarms.xCommsError;
	
	//Warning
	//OverVarnish.Alarms.xWarningAlarm	:=	;
	
END_ACTION



ACTION ResetAlarms:
	OverVarnish.Alarms := AlarmsReseted;
END_ACTION