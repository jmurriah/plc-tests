
ACTION Alarms:

	Primer.Alarms.xNoPrimerPresent:= NOT Primer.Inputs.xPrimerPresent;
	
	//IF NO Primer, define that alarm and exit
	IF Primer.Alarms.xNoPrimerPresent THEN
		ResetAlarms;
		Primer.Alarms.xNoPrimerPresent:=TRUE;
	END_IF

	//Primer No Powered Warning
	IF Primer.Inputs.xNoPowered THEN Primer.Alarms.xNoPowered := TRUE; END_IF
	
	Primer.Alarms.xCoatingLevelLow:=Primer.Inputs.xCoatingLevelLow;

	IF Primer.Inputs.xError THEN
		Primer.Alarms.xError := TRUE;
	END_IF
	
	//Saving modbus slave status when comms error raises
	IF EDGEPOS (Primer.Alarms.xCommsError) THEN
		ModSlaveState := Primer.Status.Comms.ModSlaveState;
		LastError := Primer.Status.Comms.LastError;
		LastErrorBlockNum := Primer.Status.Comms.LastErrorBlockNum;
	END_IF
	
	//Alarms related to comms
	IF Primer.Status.Comms.xModuleOk THEN
		//Remote
		IF NOT Primer.Inputs.Comms.xRemote AND Primer.Parameters.xLineInAuto THEN
			Primer.Alarms.xNotRemote := TRUE;
		END_IF
		//Stop request
		IF Primer.Inputs.Comms.xStopButtonPressed THEN
			Primer.Alarms.xStopRequest := TRUE;
		END_IF
	END_IF

	
	//Data write to ancillaries is critical to be updated properly. So just write block is monitored to raise comms alarm
	//Added ancillary first command used to get it ready to check comms also.
	//Read function not considered as the only variable critical for line process is to acknowledge "belt empty" status and in case of module nOk
	//timer "tonEmptyBelt" is executed
	ton_CommsError.IN := NOT Primer.Status.Comms.xModuleOk AND (NOT Primer.Orders.xDisableWriteBlock OR Primer.Commands.xPrepare);
	ton_CommsError.PT := T#500ms;
	ton_CommsError();
	
	IF ton_CommsError.Q  THEN	
		Primer.Alarms.xCommsError := TRUE;
	END_IF
	
	//Alarms Summary
	//Critical	
	Primer.Alarms.xCriticalAlarm:= 	Primer.Alarms.xError OR
									Primer.Alarms.xNoPowered OR
									Primer.Alarms.xNotRemote OR
									Primer.Alarms.xStopRequest OR
	
									Primer.Alarms.xCommsError;
	
	//Warning
	//Primer.Alarms.xWarningAlarm	:=	;
	
END_ACTION



ACTION ResetAlarms:
	Primer.Alarms := AlarmsReseted;
END_ACTION