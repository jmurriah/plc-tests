
PROGRAM _CYCLIC

	//If in Simulation and running without Kernel, do not execute communications
	IF gMachine.St.HwData.Family = FAMILY_BRAUTOMATIONRUNTIME AND (NOT gSimMachine.Parameters.xRunWithKernel OR gMachine.Pt.CommsType=NoCommsType)  THEN
		RETURN;
	END_IF
	
	IF gMachine.Pt.CommsType=Type_ModbusTcp THEN
		Kernel2PLC_AutoCode;	
	END_IF
		
	ReadSerialName;
	
END_PROGRAM
