
ACTION Alarms:

	Stacker.Alarms.xNoStackerPresent:= NOT Stacker.Inputs.xStackerPresent;
	
	//Related to physical inputs
	//If no Stacker, define that alarm and exit
	IF Stacker.Alarms.xNoStackerPresent THEN
		ResetAlarms;
		Stacker.Alarms.xNoStackerPresent:=TRUE;
	END_IF
	
	//No Powered
	IF Stacker.Inputs.xNoPowered THEN Stacker.Alarms.xNoPowered := TRUE; END_IF

	//Error
	IF Stacker.Inputs.xError THEN
		Stacker.Alarms.xError := TRUE;
	END_IF
	
	//Stacker not running (DELOREAN-1969)
	IF xBeltsAreStopped THEN Stacker.Alarms.xBeltsStopped := TRUE; END_IF
	
	
	//Saving modbus slave status when comms error raises
	IF EDGEPOS (Stacker.Alarms.xCommsError) THEN
		ModSlaveState := Stacker.Status.Comms.ModSlaveState;
		LastError := Stacker.Status.Comms.LastError;
		LastErrorBlockNum := Stacker.Status.Comms.LastErrorBlockNum;
	END_IF
	
	//Alarms related to comms
	IF Stacker.Status.Comms.xModuleOk THEN
		IF (NOT Stacker.Inputs.Comms.xRemote) AND Stacker.Parameters.xLineInAuto THEN
			Stacker.Alarms.xNotRemote := TRUE;
		END_IF
	END_IF
	
	
	//Data write to ancillaries is critical to be updated properly. So just write block is monitored to raise comms alarm
	//Added ancillary first command used to get it ready to check comms also.
	//Read function not considered as the only variable critical for line process is to acknowledge "belt empty" status and in case of module nOk
	//timer "tonEmptyBelt" is executed
	ton_CommsError.IN := NOT Stacker.Status.Comms.xModuleOk AND (NOT Stacker.Orders.xDisableWriteBlock OR Stacker.Commands.xPrepare);
	ton_CommsError.PT := T#500ms;
	ton_CommsError();
	
	IF ton_CommsError.Q  THEN	
		Stacker.Alarms.xCommsError := TRUE;
	END_IF
	
	
	//General
	IF (Stacker.Orders.xRejectSheet OR Stacker.Orders.xHoldReject) AND NOT Stacker.Inputs.Comms.xRejectAvailable THEN
		Stacker.Alarms.xRejectNoAvailable := TRUE;
	END_IF
	
	
	
	//Alarms Summary
	//Critical	
	Stacker.Alarms.xCriticalAlarm:= 	Stacker.Alarms.xError OR
										Stacker.Alarms.xNoPowered OR
										Stacker.Alarms.xNotRemote OR
										Stacker.Alarms.xBeltsStopped OR
										Stacker.Alarms.xCommsError;
	//Warning
	Stacker.Alarms.xWarningAlarm	:=	Stacker.Alarms.xRejectNoAvailable;
	
END_ACTION



ACTION ResetAlarms:
	Stacker.Alarms := AlarmsReseted;
END_ACTION