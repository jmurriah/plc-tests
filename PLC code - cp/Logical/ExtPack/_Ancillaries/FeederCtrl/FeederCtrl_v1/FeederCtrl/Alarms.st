
ACTION Alarms:

	Feeder.Alarms.xNoFeederPresent:= NOT Feeder.Inputs.xFeederPresent;
	
	//IF NO Feeder, define that alarm and exit
	IF Feeder.Alarms.xNoFeederPresent THEN
		ResetAlarms;
		Feeder.Alarms.xNoFeederPresent:=TRUE;
	END_IF
	
	//Feeder No Powered Warning
	IF Feeder.Inputs.xNoPowered THEN Feeder.Alarms.xNoPowered := TRUE; END_IF
		

	Feeder.Alarms.xTrayEmptyL1 := Feeder.Inputs.xTrayEmptyL1;
	Feeder.Alarms.xMediaLowL1 := Feeder.Inputs.xMediaLowL1;
	Feeder.Alarms.xTrayEmptyL2 := Feeder.Inputs.xTrayEmptyL2;
	Feeder.Alarms.xMediaLowL2 := Feeder.Inputs.xMediaLowL2;

	IF Feeder.Inputs.xError THEN
		Feeder.Alarms.xError := TRUE;
	END_IF
	
	tonNotOnline.IN:=NOT Feeder.Inputs.xOnline AND Feeder.Parameters.xLineInAuto;
	tonNotOnline.PT:=T#1s;
	tonNotOnline();
	IF tonNotOnline.Q THEN Feeder.Alarms.xNotOnline := TRUE; END_IF
	
	
	//Saving modbus slave status when comms error raises
	IF EDGEPOS (Feeder.Alarms.xCommsError) THEN
		ModSlaveState := Feeder.Status.Comms.ModSlaveState;
		LastError := Feeder.Status.Comms.LastError;
		LastErrorBlockNum := Feeder.Status.Comms.LastErrorBlockNum;
	END_IF
	
	//Alarms related to comms
	IF Feeder.Status.Comms.xModuleOk THEN
		IF (NOT Feeder.Inputs.Comms.xRemote) AND Feeder.Parameters.xLineInAuto THEN
			Feeder.Alarms.xNotRemote := TRUE;
		END_IF
	END_IF
	
	//Data write to ancillaries is critical to be updated properly. So just write block is monitored to raise comms alarm
	//Added ancillary first command used to get it ready to check comms also.
	ton_CommsError.IN := NOT Feeder.Status.Comms.xModuleOk AND (NOT Feeder.Orders.xDisableWriteBlock OR Feeder.Commands.xPrepare);
	ton_CommsError.PT := T#500ms;
	ton_CommsError();
	
	IF ton_CommsError.Q  THEN	
		Feeder.Alarms.xCommsError := TRUE;
	END_IF
	
	
	//Alarms Summary
	//Critical
	Feeder.Alarms.xCriticalAlarm:=	Feeder.Alarms.xError OR
									Feeder.Alarms.xNotOnline OR
									Feeder.Alarms.xNoPowered OR
									Feeder.Alarms.xNotRemote OR
									Feeder.Alarms.xCommsError;
	
	//Warning
	Feeder.Alarms.xWarningAlarm	:=	Feeder.Alarms.xTrayEmptyL1 OR
									Feeder.Alarms.xMediaLowL1 OR
									Feeder.Alarms.xTrayEmptyL2 OR
									Feeder.Alarms.xMediaLowL2;
	
	
END_ACTION



ACTION ResetAlarms:
	Feeder.Alarms := AlarmsReseted;
END_ACTION