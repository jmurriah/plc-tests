ACTION MachineInputs:
	
	// Product Detect. Manage general signal from signal connected to any block

	//Aggregated signals in the machine to clarify reading code
	CASE gMachine.Pt.PDSignalTpe OF
		PDCFG_CARRIAGE:
			// Check proper data assigned
			IF gMachine.In.ProductDetect.pPDCarriageSignalL1 = 0 OR gMachine.In.ProductDetect.pPDCarriageSignalL2 = 0 THEN
				RETURN;
			END_IF
			// Data pointer assignation
			xPDCarriageL1 ACCESS gMachine.In.ProductDetect.pPDCarriageSignalL1;
			xPDCarriageL2 ACCESS gMachine.In.ProductDetect.pPDCarriageSignalL2;
			// Status assignation
			gMachine.St.ProductDetect.xProductDetectL1 := xPDCarriageL1;
			gMachine.St.ProductDetect.xProductDetectL2 := xPDCarriageL2;
		
		PDCFG_SENSOR_AND_CARRIAGE,
		PDCFG_SENSOR:
			// Check proper data assigned
			IF gMachine.In.ProductDetect.pPDSignalSensorL1 = 0 OR ((gMachine.In.ProductDetect.pPDSignalSensorL2 = 0) AND gMachine.Pt.Hw.xDoubleLineAllowed) THEN
				RETURN;
			END_IF
			
			// Data pointer assignation
			xPDSignalSensorL1 ACCESS gMachine.In.ProductDetect.pPDSignalSensorL1;
			IF gMachine.Pt.Hw.xDoubleLineAllowed THEN
				xPDSignalSensorL2 ACCESS gMachine.In.ProductDetect.pPDSignalSensorL2;
			END_IF
						
			IF gThicknessCtrl.parameters.Detection.ProductDetect.xLoadMedia THEN
				gMachine.St.ProductDetect.xProductDetectL1 := gThicknessCtrl.status.Detection.xFilteredProductDetectMediaL1 AND gMachine.St.Position.xInPrint AND gMachine.parSw.Electronics.xRobotReadyL1;
				gMachine.St.ProductDetect.xProductDetectL2 := gThicknessCtrl.status.Detection.xFilteredProductDetectMediaL2 AND gMachine.St.Position.xInPrint AND gMachine.parSw.Electronics.xRobotReadyL2;
			ELSE
				//Status assignation 
				gMachine.St.ProductDetect.xProductDetectL1 := xPDSignalSensorL1 AND gMachine.St.Position.xInPrint AND gMachine.parSw.Electronics.xRobotReadyL1;
				gMachine.St.ProductDetect.xProductDetectL2 := xPDSignalSensorL2 AND gMachine.St.Position.xInPrint AND gMachine.parSw.Electronics.xRobotReadyL2;
			END_IF
			
	END_CASE

	gMachine.St.ProductDetect.xAnyProductDetect := gMachine.St.ProductDetect.xProductDetectL1 OR gMachine.St.ProductDetect.xProductDetectL2;
	gMachine.St.ProductDetect.xAnyProductDetectDtpStricted := gMachine.St.ProductDetect.xProductDetectL1 OR (gMachine.St.ProductDetect.xProductDetectL2 AND gMachine.parSw.Dtp.xDoubleLine);
	
	
	gMachine.St.xMediaDetected := gDing.In.xDingLow OR gPhotoCells.status.xLowPieceDetect;
	
	//Counting edges of Product Detect sensor
	IF EDGEPOS(gMachine.St.ProductDetect.xProductDetectL1) THEN
		diCountProductDetectEdgesL1 := diCountProductDetectEdgesL1 + 1;
	END_IF
	IF EDGEPOS(gMachine.St.ProductDetect.xProductDetectL2) THEN
		diCountProductDetectEdgesL2 := diCountProductDetectEdgesL2 + 1;
	END_IF
	
	//Just for testing. To simulate media in real machine while degbugging with no real media available
	IF (gSimMachine.Commands.Media.xContinuousMediaPresent AND gBelt.states.xRuningBelt) THEN
		xBeltSpeedChanged 	:= rPrevBeltSpeed <> gBelt.states.rCurrentSpeed;
		xFormatChanged 		:= 	rPrevBoardLength <> gMachine.parSw.Media.rLength OR
								rPrevBoardGap <> gMachine.parSw.Media.rGap;
			
		IF (xBeltSpeedChanged OR xFormatChanged) AND (gBelt.states.rCurrentSpeed > gc_rMinSpeedToStart) THEN
			rBeltSpeedMmMs := (gBelt.states.rCurrentSpeed/60);
				
			//Board
			tiBoardTime := REAL_TO_TIME(gMachine.parSw.Media.rLength/rBeltSpeedMmMs);
			tiGapTime := REAL_TO_TIME(gMachine.parSw.Media.rGap/rBeltSpeedMmMs);
	
		END_IF
		rPrevBeltSpeed := gBelt.states.rCurrentSpeed;
		rPrevBoardLength := gMachine.parSw.Media.rLength;
		rPrevBoardGap := gMachine.parSw.Media.rGap;
		rPrevStainLength := gSimMachine.Parameters.rStainLength;
		rPrevStainGap := gSimMachine.Parameters.rStainGap;
			
		//To simulate a media
		BoardsFeedMinGap.tTimeOn := tiBoardTime;
		BoardsFeedMinGap.tTimeOff := tiGapTime;
		BoardsFeedMinGap.xEnable := TRUE;
	ELSE
		BoardsFeedMinGap.xEnable := FALSE;
	END_IF
	BoardsFeedMinGap();
END_ACTION


