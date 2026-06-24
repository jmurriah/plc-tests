ACTION GeneralMachineData:
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// BELT PARAMS      BELT PARAMS      BELT PARAMS      BELT PARAMS      BELT PARAMS      BELT PARAMS      BELT PARAMS
	// BELT PARAMS      BELT PARAMS      BELT PARAMS      BELT PARAMS      BELT PARAMS      BELT PARAMS      BELT PARAMS
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// Cleaning Belt limits cannot be lower than 1
	// Cleaning Belt parameters. Clean Belt disabled/enabled after delay
	iSPTilesToCleanBelt		:= MAX (gMachine.parSw.CleanBelt.iSPTilesToCleanBelt, MIN_TILES_FOR_CLEANING_BELT);
	iSPTilesToCleanBeltTop	:= MAX (gMachine.parSw.CleanBeltTop.iSPTilesToCleanBelt, MIN_TILES_FOR_CLEANING_BELT_TOP);
	
	////////// Belt Limits //////////////////////////////////	
	//[RGP] Sending speed setpoint to gBelt. Not assigned directly from SW so maybe in the future SpeedSetpoint need to be used outside BeltPackage/BeltManager.
	//As done in previous lines by limiting maximum belt speed. //Not been able to have a Zero value in the SetPointSpeed
	gMachine.parSw.Safety.rMaxBeltSpeedSetPoint := MAX(gMachine.parSw.Safety.rMaxBeltSpeedSetPoint, 20); //At least a minimum value of 20.0m/min as max value
	
	
	//Belt speed definition
	IF gLine.StatusSummary.xEmptyingBelts THEN
		gBelt.parameters.rSetPointSpeed := MIN(gMachine.Pt.rBeltSpeedWhileEmptyBelt, gMachine.parSw.rBeltSpeedSetPoint);
		
	ELSIF gMachine.St.CleaningBelt.xCleaningProcessOnGoing THEN
		gBelt.parameters.rSetPointSpeed := INT_TO_REAL(gMachine.parSw.CleanBelt.iBeltSpeed);
	
	ELSIF (gLine.Status <> LINE_CONTROLLED_STOP AND gLine.Status <> LINE_CLEANINGPH AND gLine.Status <> LINE_STARTING_CLEANINGPH) OR NOT gMachine.Pt.xControlledByLine THEN
		gBelt.parameters.rSetPointSpeed := gMachine.parSw.rBeltSpeedSetPoint;
	END_IF
	
	// It gets belt direction following if machine configuration is left or right
	gBelt.parameters.Direction:= NOT gMachine.parSw.xMachineDirection;
	
	//Appling physical limitations
	IF NOT gMachine.Pt.xControlledByLine THEN
		gBelt.parameters.rMaxSpeed := gBelt.states.Hw.rMaxSpeed;
		gMachine.St.xDoubleLineAllowed := gMachine.Pt.Hw.xDoubleLineAllowed AND NOT gEdgeHoldDown.status.xEnabled;
		
	ELSE
		gBelt.parameters.rMaxSpeed := MIN(gBelt.states.Hw.rMaxSpeed, gLine.Parameters.Hw.rMaxSpeed);
		gMachine.St.xDoubleLineAllowed := gMachine.Pt.Hw.xDoubleLineAllowed AND gLine.Parameters.Hw.xDoubleLineAllowed AND NOT gEdgeHoldDown.status.xEnabled;
	END_IF
		
	

	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// BLOCK
	////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	xAnyBlockToPrint:=FALSE;
	FOR iIndexBlock:=1 TO gMachine.Pt.CT.iNumBlocks DO
		// It is used by ModeActive	implemented on printer
		IF gBlock[iIndexBlock].parSw.xEnableToPrint THEN
			xAnyBlockToPrint:=TRUE;
		END_IF
	END_FOR
	gMachine.St.Blocks.xAnyBlockToPrint:=xAnyBlockToPrint;
	
	///////////
	//White
	///////////
	IF gMachine.St.White.xInstalled THEN
		//Defining white bar index depending on machine direction. White is always first mechanically installed print bar
		IF gMachine.parSw.xMachineDirection THEN
			iWhiteBarMechanicalPosition := gBlock[1].parameters.Inks.iMaxMachinePrintBars;
		ELSE
			iWhiteBarMechanicalPosition := 1;
		END_IF
		
		IF NOT gMachine.St.White.xDebugMode THEN
			gMachine.St.White.xEnableToPrint := gInks[iWhiteBarMapping].status.xColorLoadedInJob;
		END_IF
	ELSE
		gMachine.St.White.xEnableToPrint := FALSE;
	END_IF
	
	///////////
	//Clear
	///////////
	IF gMachine.St.Clear.xInstalled THEN
		//Defining Primer bar index depending on machine direction. Primer is always first mechanically installed print bar
		IF gMachine.parSw.xMachineDirection THEN
			iPrimerBarMechanicalPosition := 3;
		ELSE
			iPrimerBarMechanicalPosition := 8;
		END_IF
		
		IF NOT gMachine.St.Clear.xDebugMode THEN
			gMachine.St.Clear.xEnableToPrint := gInks[iPrimerBarMapping].status.xColorLoadedInJob;
		END_IF
		
	ELSE
		gMachine.St.Clear.xEnableToPrint := FALSE;
	END_IF
	
	///////////
	//Color
	///////////
	IF NOT gMachine.St.Color.xDebugMode THEN
		//DELOREAN-3427: In case no color bar is loaded in job, curing led bar type CURING_APP_COLOR wont be activated
		xColorBarEnabledToPrint:=FALSE;
		FOR iIndexInks:=1 TO MAX_LAST_INK DO
			IF iIndexInks<>iWhiteBarMapping AND iIndexInks<>iPrimerBarMapping THEN
				IF gInks[iIndexInks].status.xColorLoadedInJob THEN
					xColorBarEnabledToPrint:=TRUE;
					EXIT;
				END_IF
			END_IF
		END_FOR
		gMachine.St.Color.xEnableToPrint := xColorBarEnabledToPrint;
	END_IF
	
	
	//CUBE-1197: due to this issue, protecting curing process by enabling curingled bar in case there is only one curing led bar. 
	IF gMachine.Pt.Hw.iMaxCuringLedBars=1 THEN
		gMachine.St.Color.xEnableToPrint:=iIndexColorCuringLedBar=1;
		gMachine.St.Clear.xEnableToPrint :=iIndexPrimerCuringLedBar=1; //Pending to change the name of "iIndexPrimerCuringLedBar" by "iIndexClearCuringLedBar"
		xWhiteBarEnabledToPrint:=iIndexWhiteCuringLedBar=1;
	END_IF
		
	////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// INKS >>>>> SLOW FOR		SLOW FOR		SLOW FOR		SLOW FOR		SLOW FOR		
	////////////////////////////////////////////////////////////////////////////////////////////////////////////

	// Reset the index if the index is not valid. Just for protection. Never should enter here
	IF iIndexInksSlow = 0 OR iIndexInksSlow > MAX_LAST_INK THEN
		StartValuesForInksSlowFor;
		iIndexInksSlow := 1;
	END_IF
	
	IF gInks[iIndexInksSlow].status.xInksRunning THEN
		xAnyInkBarStarted := TRUE;
		IF rMaxStartedTempSetPoint < gInks[iIndexInksSlow].parSw.Temp.rSetPointTemp THEN
			rMaxStartedTempSetPoint := gInks[iIndexInksSlow].parSw.Temp.rSetPointTemp;
		END_IF
		IF rMaxStartedInkTemp < gInks[iIndexInksSlow].status.Temp.rTemp THEN
			rMaxStartedInkTemp:= gInks[iIndexInksSlow].status.Temp.rTemp;
		END_IF
		IF rMinStartedTempSetPoint > gInks[iIndexInksSlow].parSw.Temp.rSetPointTemp THEN
			rMinStartedTempSetPoint := gInks[iIndexInksSlow].parSw.Temp.rSetPointTemp;
		END_IF
		IF rMinStartedInkTemp > gInks[iIndexInksSlow].status.Temp.rTemp THEN
			rMinStartedInkTemp:= gInks[iIndexInksSlow].status.Temp.rTemp;
		END_IF
		
		//Any Tank Enabled
		IF gInks[iIndexInksSlow].status.xInkAndPreheatingRunning THEN
			xAnyTankHeaterEnabled:= TRUE;
		END_IF
		
		//Any bar printhead enabled
		IF gInks[iIndexInksSlow].signals.out.xOutPowPrintHead THEN
			xAnyPrintheadsPowered:= TRUE;
		END_IF
		
		//Depending on white bar mechanical position and if its enabled to print by electronics, status variable is set.
		//Cannot assume that gInks[1] will be the white bar so there is a case were white is physically installed but not defined in printer UI (disabled), gInks[1] then would be the following print bar assembled
		IF gInks[iIndexInksSlow].parSw.Config.iMappingBar = iWhiteBarMechanicalPosition THEN
			iWhiteBarMapping := iIndexInksSlow;
		ELSIF gInks[iIndexInksSlow].parSw.Config.iMappingBar = iPrimerBarMechanicalPosition THEN
			iPrimerBarMapping := iIndexInksSlow;
		END_IF
		
		IF gInks[iIndexInksSlow].parameters.InksChiller.iIndex > 0 AND gInks[iIndexInksSlow].parameters.InksChiller.iIndex < MAX_LAST_CHILLER THEN // Adding safety in the assignation
			gInks[iIndexInksSlow].parameters.InksChiller.Status := gChiller[gInks[iIndexInksSlow].parameters.InksChiller.iIndex].St.Status;
		END_IF
		
	END_IF
	
	IF gInks[iIndexInksSlow].parameters.PrintheadsChiller.iIndex > 0 AND gInks[iIndexInksSlow].parameters.PrintheadsChiller.iIndex < MAX_LAST_CHILLER THEN //Adding safety in the assignation
		gInks[iIndexInksSlow].parameters.PrintheadsChiller.Status := gChiller[gInks[iIndexInksSlow].parameters.PrintheadsChiller.iIndex].St.Status;
	END_IF
	
	iIndexInksSlow := iIndexInksSlow + 1;
	
	//If there is no logical bar with the mapping of the physical position, reset the outputs
	IF iIndexInksSlow > MAX_LAST_INK THEN
		
		//Assign data calculated to Machine Data
		gMachine.St.Inks.xAnyStarted := xAnyInkBarStarted;
		gMachine.St.Inks.rMaxTempSetPoint := rMaxStartedTempSetPoint;
		gMachine.St.Inks.rMinTempSetPoint := rMinStartedTempSetPoint;
		gMachine.St.Inks.rMaxTemp := rMaxStartedInkTemp;
		gMachine.St.Inks.rMinTemp := rMinStartedInkTemp;
		
		gMachine.St.Blocks.xAnyTankHeaterEnabled:= xAnyTankHeaterEnabled;
		gMachine.St.Blocks.xAnyPrintheadPowered:= xAnyPrintheadsPowered;
		
		StartValuesForInksSlowFor;
		iIndexInksSlow := 1;
	END_IF
	
	
	// Jetting Gap limits
	gMachine.parSw.rMarginPrint:= LIMIT(gMachine.Pt.CT.rMinMarginPrinting,gMachine.parSw.rMarginPrint,gMachine.Pt.CT.rMaxMarginPrinting);

	// Piece Tickness	
	gMachine.parSw.Media.rThickness:= LIMIT(gMachine.Pt.CT.rMinTicknessMedia,gMachine.parSw.Media.rThickness,gMachine.Pt.CT.rMaxTicknessMedia);

	// Mounted Tile	
	gMachine.parSw.Safety.rMountedPieceOverthickness:= LIMIT(gMachine.Pt.CT.rMinMountedPieceOverThick,gMachine.parSw.Safety.rMountedPieceOverthickness,gMachine.Pt.CT.rMaxMountedPieceOverThick);

	// Cleaning by pieces	
	gMachine.parSw.Clean.iPiecesNumberToCleanL1:= MAX (gMachine.parSw.Clean.iPiecesNumberToCleanL1, GC_MIN_PIECES_TO_CLEAN);
	gMachine.parSw.Clean.iPiecesNumberToCleanL2:= MAX (gMachine.parSw.Clean.iPiecesNumberToCleanL2, GC_MIN_PIECES_TO_CLEAN);
	

	// Counters of shots printed by PD or by simulation
	//Counting out of any FOR. Makes no sense
	IF EDGEPOS (gMachine.St.ProductDetect.xProductDetectL1) THEN 
		gMachine.Lg.udiPiecesCounterL1:= gMachine.Lg.udiPiecesCounterL1 + 1;
	END_IF

	IF EDGEPOS (gMachine.St.ProductDetect.xProductDetectL2) THEN
		gMachine.Lg.udiPiecesCounterL2:= gMachine.Lg.udiPiecesCounterL2 + 1;
	END_IF	
	
	gMachine.St.xWorkingAsPBF := gMachine.parSw.Electronics.xIsPBF;
	
	//When entering in Working as PBF, modify diPiecesCounterStrobe to keep the same quantity of differences
	IF EDGEPOS(gMachine.St.xWorkingAsPBF) THEN
		gMachine.Lg.diPiecesCounterStrobe := gMachine.Lg.udiPiecesCounterL1 - gMachine.Lg.iDiffPiecesStrobeProductDetect;
	END_IF
	
	//Count strobes when Bit8 (strobe) is actived
	IF EDGEPOS(gMachine.In.iRelieve1>=256) AND gMachine.St.xWorkingAsPBF THEN
		gMachine.Lg.diPiecesCounterStrobe:= gMachine.Lg.diPiecesCounterStrobe + 1;
		gMachine.Out.iRelief1 := gMachine.In.iRelieve1;
	END_IF
	
	//Remove Relief output after time enough for the kernel to read it
	tofKeepReliefSignal.IN := EDGEPOS(gMachine.In.iRelieve1>=256) AND gMachine.St.xWorkingAsPBF;
	tofKeepReliefSignal.PT := t#900ms;
	tofKeepReliefSignal();
	IF NOT tofKeepReliefSignal.Q THEN
		gMachine.Out.iRelief1 := 0;	
	END_IF
	
	//If Reset the counter, assign the value of Strobes to the value of PD
	IF gMachine.commands.xResetStrobePdDiff THEN
		gMachine.Lg.diPiecesCounterStrobe := gMachine.Lg.udiPiecesCounterL1;
		gMachine.Lg.iDiffPiecesStrobeProductDetect := 0;
		gMachine.commands.xResetStrobePdDiff := FALSE;
	END_IF
	IF EDGEPOS(gMachine.Lg.udiPiecesCounterL1 = 0) THEN
		gMachine.Lg.diPiecesCounterStrobe := - gMachine.Lg.iDiffPiecesStrobeProductDetect;
	END_IF
	
	//Define the diff counter. Updated just when receive a media in Product detect
	IF gMachine.St.xWorkingAsPBF AND EDGEPOS (gMachine.St.ProductDetect.xProductDetectL1) THEN
		gMachine.Lg.iDiffPiecesStrobeProductDetect := DINT_TO_INT(gMachine.Lg.udiPiecesCounterL1 - gMachine.Lg.diPiecesCounterStrobe);
	END_IF
	
	// Machine conversions
	gMachine.Lg.udiDifCounters:=ABS(UDINT_TO_INT(gMachine.Lg.udiPiecesCounterL1-gDing.State.diLgLowPieceCounter));
	
	//Enable degasser 
	gMachine.Out.xDegasser:= gMachine.parSw.xDegasser AND NOT gMachine.Al.Warning.xAlrDegasserPressure;

	//Safety
	gSafetyController.Parameters.xSimulationMode := gMachine.Pt.ConfigNameID = GC_CONFIG_SIMTEST_ID;

	
	//Define a transmision data to do the first calculations and be receptive to next calculations	
	DriveUnit.TransmissionData.TransmissionType := TRANS_LINEAL_PERIMETER;
	DriveUnit.TransmissionData.LinealPerimeter.PulsesPerTurn := GC_UNITS_BY_REV_DRIVE;
	DriveUnit.TransmissionData.LinealPerimeter.GearBox := 10.0;
	DriveUnit.TransmissionData.LinealPerimeter.Perimeter := 500.0;
	
	IF gThicknessCtrl.status.Belt.rBeltPositionMmInit<>rBeltPositionMmInitCopy THEN
		//Logger
		//Calculation of position when mounted media alarm is raised
		DriveUnit.pulsesDevice := gThicknessCtrl.status.Belt.rBeltPositionMmInit;
		DriveUnit.Calculation := CALC_POS_MM;
		DriveUnit();
		rBeltPositionMmInit := DriveUnit.PositionDevice;
		
		//Calculation of position when mounted media alarm is raised
		DriveUnit.PulsesSpeedDevice := gThicknessCtrl.status.Belt.rBeltSpeed;
		DriveUnit.Calculation := CALC_SPEED_MMIN;
		DriveUnit();
		rBeltSpeedInit := ABS(DriveUnit.SpeedMminDevice);
		
		rBeltPositionMmInitCopy := gThicknessCtrl.status.Belt.rBeltPositionMmInit;
	END_IF
	
	IF gThicknessCtrl.status.Belt.rBeltPositionMmFinal<>rBeltPositionMmFinalCopy THEN
		//Calculation of position when belt stops
		DriveUnit.pulsesDevice := gThicknessCtrl.status.Belt.rBeltPositionMmFinal;
		DriveUnit.Calculation := CALC_POS_MM;
		DriveUnit();
		rBeltPositionMmFinal := DriveUnit.PositionDevice;
				
		rBeltPositionMmFinalCopy := gThicknessCtrl.status.Belt.rBeltPositionMmFinal;
	END_IF
	
	rBeltDistanceTravelledMm := rBeltPositionMmFinal - rBeltPositionMmInit;
	IF rBeltDistanceTravelledMm<>rBeltDistanceTravelledMmCopy THEN
		//Logging distance run by belt from mounted media event to be stopped
		LogBeltDistanceTravelledWhenMountedMedia;
		
		rBeltDistanceTravelledMmCopy := rBeltDistanceTravelledMm;
	END_IF
	
	
END_ACTION

ACTION StartValuesForInksSlowFor:
	xAnyInkBarStarted := FALSE;
	rMaxStartedTempSetPoint := 0.0; //To be sure to be decreased
	rMaxStartedInkTemp := 0.0; //To be sure to be decreased
	rMinStartedTempSetPoint := 100.0; //To be sure to be decreased
	rMinStartedInkTemp := 100.0; //To be sure to be decreased
	xAnyTankHeaterEnabled := FALSE;
	xAnyPrintheadsPowered := FALSE;
END_ACTION
