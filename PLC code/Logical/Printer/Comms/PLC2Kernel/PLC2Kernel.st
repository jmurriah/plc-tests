
PROGRAM _CYCLIC

	IF NOT xStarted THEN
		xStarted:=TRUE;
		RETURN;
	END_IF
	
	//If in Simulation and running without Kernel, do not execute communications
	IF gMachine.St.HwData.Family = FAMILY_BRAUTOMATIONRUNTIME AND (NOT gSimMachine.Parameters.xRunWithKernel OR gMachine.Pt.CommsType=NoCommsType)  THEN
		RETURN;
	END_IF

	//Manual cleaning the RegisterArray
	IF (gMachine.Pt.CommsType=Type_ModbusTcp) AND (xClenanCommsArray OR gMachine.AutoCmd.xCleanModbus) THEN
		FOR iIndexCommsArray:=0 TO 8999 DO
			HoldingRegister[iIndexCommsArray]:=0;
		END_FOR;
		xClenanCommsArray:=FALSE;
		gMachine.AutoCmd.xCleanModbus := FALSE;
	END_IF
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// COMS   COMS   COMS   COMS   COMS   COMS   COMS   COMS   COMS   COMS   COMS   COMS   COMS   COMS   COMS   COMS
	// COMS   COMS   COMS   COMS   COMS   COMS   COMS   COMS   COMS   COMS   COMS   COMS   COMS   COMS   COMS   COMS
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	//AlarmKernelPLCComms;
	
	IF gMachine.Pt.CommsType=Type_ModbusTcp THEN
		PLC2Kernel_AutoCode;	
	END_IF
	
	WriteSerialName;
	
END_PROGRAM
