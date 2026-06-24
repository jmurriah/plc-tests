
ACTION WriteSerialName:
	
	strSerialName ACCESS ADR(HoldingRegister[SERIAL_NAME_STATUS_ADR]);
	strSerialName := gMachine.St.HwData.SerialNumber;

END_ACTION
