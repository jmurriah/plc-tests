
ACTION ReadSerialName:
	
	strSerialName ACCESS ADR(HoldingRegister[SERIAL_NAME_ASSIGNATION_ADR]);
    
	IF brsstrlen(ADR(gMachine.St.HwData.SerialNumber)) <= 4 AND  brsstrlen(ADR(strSerialName)) > 0 THEN
		gMachine.commands.SerialNumber.SerialNumber := strSerialName;
		IF EDGEPOS(HoldingRegister[SERIAL_NAME_TRIGGER_ADR]>0) THEN
			gMachine.commands.SerialNumber.xExecute := TRUE;
			HoldingRegister[SERIAL_NAME_TRIGGER_ADR] := 0;
		END_IF
	END_IF
	
END_ACTION
