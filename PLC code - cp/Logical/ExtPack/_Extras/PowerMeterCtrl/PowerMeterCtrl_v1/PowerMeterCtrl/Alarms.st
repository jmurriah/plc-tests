
ACTION Alarms:

	//Saving modbus slave status when comms error raises
	IF EDGEPOS (PowerMeter.Alarms.xCommsError) THEN
		ModSlaveState := PowerMeter.Status.Comms.ModSlaveState;
		LastError := PowerMeter.Status.Comms.LastError;
		LastErrorBlockNum := PowerMeter.Status.Comms.LastErrorBlockNum;
	END_IF
	
	//Reset Alarms with an external order to reset
	IF PowerMeter.Commands.xReset THEN
		ResetAlarms;
	END_IF
	
	//Alarms related to comms
	IF NOT PowerMeter.Status.Comms.xModuleOk THEN
		PowerMeter.Alarms.xCommsError := TRUE;
	END_IF
	
END_ACTION



ACTION ResetAlarms:
	PowerMeter.Alarms := ResetedAlarms;
END_ACTION