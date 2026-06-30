
ACTION LineAlarms:

	//////////////////
	// General Alarms
	//////////////////
	
	//Reset Alarms//
	IF gMachine.AutoCmd.xReset THEN
		ResetAlarms;
	END_IF
	
	
	//Critical//
	//Printer Powered
	IF xLinePoweredON AND NOT Line.Inputs.xPrinterPowered THEN 
		Line.Alarms.xAlrPrinterNoPowered := TRUE; 
	END_IF
	
	//Main Supply Overvoltage
	IF NOT Line.Inputs.xOvervoltageProtectionOk THEN 
		Line.Alarms.xAlrOvervoltage := TRUE;
	END_IF
	
	//24VDC Start Sequence Powered
	IF Line.Inputs.x24VdcStartSeqNoPowered THEN 
		Line.Alarms.xAlr24VdcStartSeqNoPowered := TRUE; 
	END_IF
	
	
END_ACTION

ACTION ResetAlarms:
	Line.Alarms := AlarmsReseted;
END_ACTION