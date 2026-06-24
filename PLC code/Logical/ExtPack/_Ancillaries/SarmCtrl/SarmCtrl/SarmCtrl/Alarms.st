
ACTION Alarms:

	//Sarm No Powered Warning
	IF NOT Sarm.Inputs.xPowered THEN Sarm.Alarms.xNoPowered := TRUE; END_IF
	
	IF Sarm.Inputs.xError THEN
		Sarm.Alarms.xError := TRUE;
	END_IF
	
	//Saving modbus slave status when comms error raises
	IF EDGEPOS (Sarm.Alarms.xCommsError) THEN
		ModSlaveState := Sarm.Status.Comms.ModSlaveState;
		LastError := Sarm.Status.Comms.LastError;
		LastErrorBlockNum := Sarm.Status.Comms.LastErrorBlockNum;
	END_IF
	
	//Alarms related to comms
	IF Sarm.Status.Comms.xModuleOk THEN
		//Remote
		IF (NOT Sarm.Inputs.Comms.xRemote) AND Sarm.Parameters.xLineInAuto THEN
			Sarm.Alarms.xNotRemote := TRUE;
		END_IF
	END_IF

	//Data write to ancillaries is critical to be updated properly. So just write block is monitored to raise comms alarm
	//Added ancillary first command used to get it ready to check comms also.
	//Read function not considered as the only variable critical for line process is to acknowledge "belt empty" status and in case of module nOk
	//timer "tonEmptyBelt" is executed
	ton_CommsError.IN := NOT Sarm.Status.Comms.xModuleOk AND (NOT Sarm.Orders.xDisableWriteBlock OR Sarm.Commands.xStart);
	ton_CommsError.PT := T#500ms;
	ton_CommsError();
	
	IF ton_CommsError.Q  THEN	
		Sarm.Alarms.xCommsError := TRUE;
	END_IF
	
	//Alarms Summary
	//Critical
	Sarm.Alarms.xCriticalAlarm:=	Sarm.Alarms.xError OR
									Sarm.Alarms.xNoPowered OR
									Sarm.Alarms.xNotRemote OR
									Sarm.Alarms.xCommsError;
	
	//Warning
	//Sarm.Alarms.xWarningAlarm	:=	;
	
	
END_ACTION



ACTION ResetAlarms:
	Sarm.Alarms := AlarmsReseted;
END_ACTION