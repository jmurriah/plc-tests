ACTION MachineInputs:
	
	
	ProductDetectSignals;
	
	//Probe -200C +500C. Range 700C
	gDryer.St.Temp.rBelt := ((INT_TO_REAL(gDryer.In.Temp.iBeltRaw)* 520.0)/32767.0)-20.0;
	gDryer.St.Temp.rBoardIn := ((INT_TO_REAL(gDryer.In.Temp.iBoardInRaw)* 520.0)/32767.0)-20.0;
	gDryer.St.Temp.rBoardOut := ((INT_TO_REAL(gDryer.In.Temp.iBoardOutRaw)* 520.0)/32767.0)-20.0;
	
	gDryer.St.Temp.rAirBlowerInput := ((INT_TO_REAL(gDryer.In.Temp.iAirBlowerInputRaw)* 250.0)/32767.0)-50.0;
	gDryer.St.Temp.rAirBlowerOutput := ((INT_TO_REAL(gDryer.In.Temp.iAirBlowerOutputRaw)* 250.0)/32767.0)-50.0;

END_ACTION

ACTION ProductDetectSignals:

	IF gDryer.In.ProductDetect.pPDSignalSensorL1 = 0 OR gDryer.In.ProductDetect.pPDSignalSensorL2 = 0 THEN
		RETURN;
	END_IF
	
	//Aggregated signals in the machine to clarify reading code
	xPDCarriageSignalL1 ACCESS gDryer.In.ProductDetect.pPDSignalSensorL1;
	xPDCarriageSignalL2 ACCESS gDryer.In.ProductDetect.pPDSignalSensorL2;
	
	gDryer.St.xProductDetectL1 := xPDCarriageSignalL1;
	gDryer.St.xProductDetectL2 := xPDCarriageSignalL2;

	gDryer.St.xAnyProductDetect := gDryer.St.xProductDetectL1 OR gDryer.St.xProductDetectL2;
	
	gDryer.St.xMediaDetected := gBasicDetectMedia.Status.xMediaPresent;

END_ACTION
