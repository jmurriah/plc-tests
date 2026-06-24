PROGRAM _INIT
    
	RTInfo_0(enable :=TRUE );
	rPeriode:= UDINT_TO_REAL (RTInfo_0.cycle_time)/1000;  // Cycle time in microseconds
	
	//It is not controlled here rCycleFast to be here at this position, but if here is 0 is because the configuration is wrong
	gThicknessCtrl.Internal.rCycleSlow := rPeriode;
	gThicknessCtrl.Internal.rFastValues := gThicknessCtrl.Internal.rCycleSlow / gThicknessCtrl.Internal.rCycleFast;
	gThicknessCtrl.Internal.iFastValues := REAL_TO_UINT(gThicknessCtrl.Internal.rFastValues);
	
	// Moved here to assign internal arrays during initialization. Not needed aftewards in execution because just exists one instance of this program
	dataHeigh ACCESS ADR(gThicknessCtrl);
	
	MediaTrackingInsideL1 ACCESS ADR(dataHeigh.status.MediaPosition.L1.InsideMedia);
	MediaTrackingInsideL2 ACCESS ADR(dataHeigh.status.MediaPosition.L2.InsideMedia);
	
	//Assigning pointers here. Te position of the entering element is always the first one
	EnteringMediaL1 ACCESS ADR(MediaTrackingInsideL1[0]);
	EnteringMediaL2 ACCESS ADR(MediaTrackingInsideL2[0]);
	
	// iHeightArray initialization
	FOR iIndex := 0 TO iMAXHEIGHTARRAY DO
		iHeightArray[iIndex] := 1000; // 100.0 mm as initial value to avoid going to 0 height if the belt has not been moved
	END_FOR;
	
	EnergyTest.Energy.iPower[0,1] := EnergyTest.Energy.iPower[0,1];
	
	dataHeigh.Internal.pMediaTracking := ADR(xMediaTracking);
	dataHeigh.Internal.pDistanceWorkEmptyBelt := ADR(iDistanceWorkEmptyBelt);
	
END_PROGRAM
	
PROGRAM _CYCLIC
	
	// Assignation of """dataHeigh ACCESS ADR(gThicknessCtrl);""" is done in _INIT code
	
	//Limitation of the parameter
	CheckLimits;
	
	// Receive information of Media through OpcUa Method
	StackMethods;
	
	//Reset Alarms
	IF dataHeigh.Commands.xErrorRst THEN
		dataHeigh.Alarms := stAlarmsReseted;
		dataHeigh.AlSummary := stAlarmsSummaryReseted;
	END_IF
	
	//Thickness device is ready to detect media
	dataHeigh.status.DetectionSystem.xInPosition := (gDing.State.xDingInstalled OR gPhotoCells.status.xInPosition);
	
	// Adding the alarms to the mounted media consideration here, we gain 1 cycle in the machine fast to react
	xMountedMedia := gPhotoCells.status.xMountedMediaDetected OR gDing.State.xMountedMediaDetected OR
				gPhotoCells.Alarms.xMountedTile OR gPhotoCells.Alarms.xMountedTile OR gBasicDetectMedia.Alarms.xMountedMedia;
	
	// Update the value of the Height in the array if commanded
	IF dataHeigh.Commands.xAddSafetyMarginToHeight AND NOT xAddedSafetyMarginToHeight AND dataHeigh.status.MediaPosition.xMediaInside THEN
		iSafetyMarginToHeight := REAL_TO_UINT(dataHeigh.parameters.rSafetyMarginToHeight*100);
		FOR iIndexArray := 1 TO iTotalBlocksLengh DO
			//Apply heigh values to all the positions. Just if the value is lower
			iHeightArray[iIndexArray] := iHeightArray[iIndexArray] + iSafetyMarginToHeight;
		END_FOR
		xAddedSafetyMarginToHeight := TRUE;
	END_IF

	IF dataHeigh.Commands.UpdateAllMatrix OR dataHeigh.Commands.xAddSafetyMarginToHeight THEN
		ResetMaxHeigh;
		FOR iIndexArray := iTotalBlocksLengh TO 1 BY -1 DO
			//Apply heigh values to all the positions. Just if the value is lower
			iHeightArray[iIndexArray]:= MAX(iHeightArray[iIndexArray], iMediaHeight);
			AssignMaxHeighIndex;
		END_FOR
	END_IF
	

	IF (dataHeigh.parameters.Belt.rBeltSpeed >= rMinBeltSpeedToStart) THEN
		
		// Avoid multiple activation of xAddSafetyMarginToHeight if stopped
		xAddedSafetyMarginToHeight := FALSE;

		//Here we add the accumulated mm in the belt. Calculating the distance in ¿¿¿mm??? from speed (m/min x10) and the time in micros
		rAccumAdvBelt:= rAccumAdvBelt + dataHeigh.parameters.Belt.rBeltSpeed * rPeriode / 60;
		
		//Detect the quantity of positions the array must be moved
		iPositionsToRunArray := TRUNC(rAccumAdvBelt/MM_PERPOSITION_IN_ARRAY);
		
		//Just readjust if the advance has been more than a position
		IF iPositionsToRunArray >0 THEN
		
			//Recalculate the remaining Belt advance for the next execution
			rAccumAdvBelt := rAccumAdvBelt - iPositionsToRunArray * MM_PERPOSITION_IN_ARRAY;
	
			//Reduce the value in the distances vars
			SubstracDistances;
			
			// ------------------------------------------------------------------
			// RUN and REVIEW the arrays moving the values and filling the begining
			RunHeightArray;

			//Run over "Media" and "ValidMedia" matrixs if configured
			RunMediaArray;
			
			IF dataHeigh.parameters.Reject.xRejectTracking THEN
				RunRejectArray;
				ReviewRejectActivation; 
			END_IF
			
			IF dataHeigh.parameters.Cure.xEnableTracking OR dataHeigh.parameters.Cure.xEnableMediaTracking THEN
				RunCureArray;
				ReviewCuringActivation;
			END_IF
			
			IF dataHeigh.parameters.Dry.xEnableMediaTracking THEN
				ReviewDryActivation;
			END_IF
			
			LoadDistancesBeltRunning;
			
			IF NOT dataHeigh.parameters.AutoMode.xJamRecovery THEN
				AlarmsCheckMedia;
			END_IF
			
		END_IF
		
		BoardsBelowBlockManagement;
		
	ELSE
		// RESETTING OUTPUTS IF BELT STOPPED
		dataHeigh.status.Belt.iBeltTurns := 0;
		// Reject outputs
		dataHeigh.Outputs.xHoldReject:=FALSE;
		xHoldReject:=FALSE;
		
		// Curing outputs
		dataHeigh.status.MediaPosition.L1.White.xMediaInLedPosition := FALSE;
		dataHeigh.status.MediaPosition.L1.Color.xMediaInLedPosition := FALSE;
		dataHeigh.status.MediaPosition.L1.Primer.xMediaInLedPosition := FALSE;
		dataHeigh.status.MediaPosition.L1.xDetectionSystemIncoherence := FALSE;
		dataHeigh.status.MediaPosition.L2.White.xMediaInLedPosition := FALSE;
		dataHeigh.status.MediaPosition.L2.Color.xMediaInLedPosition := FALSE;
		dataHeigh.status.MediaPosition.L2.Primer.xMediaInLedPosition := FALSE;
		dataHeigh.status.MediaPosition.L2.xDetectionSystemIncoherence := FALSE;

	END_IF		
	
	// Resetting the BaordsFromStart when starting the belt
	IF EDGEPOS(dataHeigh.parameters.Belt.rBeltSpeed >= rMinBeltSpeedToStart) THEN
		dataHeigh.status.Detection.iBoardsFromStartL1 := 0;
		dataHeigh.status.Detection.iBoardsFromStartL2 := 0;
	END_IF
	
	LoadDistancesAlways;
	
	Alarms;
	
	AlarmSounds;
	
	AlarmsSummary;
	
	
	ReviewDryManual;
	
	//Reset counter if force
	IF dataHeigh.Commands.xResetMediaBelow THEN
		iBoardsBelowBlockL1:=0;
		iBoardsBelowBlockL2:=0;
		dataHeigh.status.Reject.iBoardsRejected := 0;
	END_IF
	IF EDGEPOS(dataHeigh.parameters.xBlockInProperPrintingPosition) THEN
		//dataHeigh.status.Reject.iBoardsRejected := 0;
		AddMediaTrackingEvents(diTotalCmBelt, END_REJECTING_ALL, ADR(TrackingEventsArray));
	END_IF
	IF EDGENEG(dataHeigh.parameters.xBlockInProperPrintingPosition) THEN
		AddMediaTrackingEvents(diTotalCmBelt, START_REJECTING_ALL, ADR(TrackingEventsArray));
	END_IF
	
	
	//TBD how reset will be activated
	tonResetRushProofCounterTimer.IN := dataHeigh.Commands.xErrorRst;
	tonResetRushProofCounterTimer.PT := T#5s;
	tonResetRushProofCounterTimer();
	xResetRejectRushProofCounter := tonResetRushProofCounterTimer.Q;
	IF xResetRejectRushProofCounter THEN 
		iRushProofCounter:=0;
	END_IF 

	
	// Empty belt state	
	dataHeigh.status.Belt.xBeltEmpty:=iDistanceWorkEmptyBelt = 0;
	dataHeigh.status.MediaPosition.xMediaInside:=iDistanceMediaInside > 0;
	dataHeigh.status.MediaPosition.xTrackingEmpty := iDistanceTrackingEmpty = 0;
	dataHeigh.status.MediaPosition.xVirtualMediaInside:=iDistanceVirtualMediaInside > 0;
	dataHeigh.status.MediaPosition.xMediaToRejectInside := iDistanceMediaToRejectInside > 0;
	
	iReasonMediaBelow.0 := iDistanceMediaInside > 0;
	iReasonMediaBelow.1 := iDistanceVirtualMediaInside > 0;
	IF iReasonMediaBelow > 0 THEN
		dataHeigh.status.MediaPosition.xMediaBelowMachine:=TRUE;
	ELSIF NOT dataHeigh.status.MediaPosition.xMediaInside THEN
		dataHeigh.status.MediaPosition.xMediaBelowMachine:=FALSE;
	END_IF

	
	//If this value is higher than 0 is because still the belt has not been empty after a mounted alarm
	dataHeigh.status.MediaPosition.xMountedMediaInside 	:= iDistanceMountPieceOut>0;
	
	//To know when there is media at the end of printer's belt. Useful info for devices located afterwards (as Dryer)
	dataHeigh.status.MediaPosition.xMediaAtPrinterExit := xMediaTracking[dataHeigh.parameters.Belt.iDistanceEmptyBeltIni + 1] > 0;

	//Convert the internal value to the status value for beeing used in the printer
	LoadSectionsInformation;
	
	//Enabling PD signal to the carriage boards
	//Setting when PD signal positive edge and block is not at safe position or going back down printing position.
	dataHeigh.Outputs.xEnableMediaSignalToCb := dataHeigh.parameters.xBlockInProperPrintingPosition;
	
	//Media present in warp sensor position
	//Loading data
	dataHeigh.status.MediaPosition.xMediaInWarpSensorPosition := xFilteredAnalogSensorMedia OR xFilteredArraySensorMedia OR xFilteredBasicDetectionMedia;
	
	dataHeigh.status.xNewMediaStackEnabled := dataHeigh.parameters.Detection.xEnabledStack OR dataHeigh.parameters.Dry.xDryStack;
	dataHeigh.status.xMediaTrackingEnabled := dataHeigh.status.xNewMediaStackEnabled OR dataHeigh.parameters.Cure.xEnableMediaTracking OR dataHeigh.parameters.Dry.xEnableMediaTracking;
	
	// Define the MediaThickness margin to allow use it from outside
	IF NOT dataHeigh.status.xNewMediaStackEnabled THEN
		dataHeigh.status.Heigh.rMediaThicknessMargin := EnteringMediaContinuous.Media.rThickness + EnteringMediaContinuous.Media.rMargin;
		dataHeigh.status.Heigh.rMediaThickness 		 := EnteringMediaContinuous.Media.rThickness;
	ELSE
		rMediaThicknessMargin := 0;
		rMediaThickness := 0;
		IF MediaTracking_iTotalInsideL1 > 0 THEN // = ] := NewMediaStackL1[0];
			rMediaThicknessMargin := EnteringMediaL1.Media.rThickness + EnteringMediaL1.Media.rMargin;
			rMediaThickness := EnteringMediaL1.Media.rThickness;
		ELSE
			rMediaThicknessMargin := NewMediaStackL1[0].Media.rThickness + NewMediaStackL1[0].Media.rMargin;
			rMediaThickness := NewMediaStackL1[0].Media.rThickness;
		END_IF
		IF MediaTracking_iTotalInsideL2 > 0 THEN
			rMediaThicknessMargin := MAX(rMediaThicknessMargin, EnteringMediaL2.Media.rThickness + EnteringMediaL2.Media.rMargin);
			rMediaThickness := MAX(rMediaThickness, EnteringMediaL2.Media.rThickness + EnteringMediaL2.Media.rMargin);
		ELSE
			rMediaThicknessMargin := MAX(rMediaThicknessMargin, NewMediaStackL2[0].Media.rThickness + NewMediaStackL2[0].Media.rMargin);
			rMediaThickness := MAX(rMediaThickness, NewMediaStackL2[0].Media.rThickness + NewMediaStackL2[0].Media.rMargin);
		END_IF
		
		dataHeigh.status.Heigh.rMediaThicknessMargin := rMediaThicknessMargin;
		dataHeigh.status.Heigh.rMediaThickness := rMediaThickness;
	END_IF
	
	IF EDGEPOS(dataHeigh.status.MediaPosition.xMediaToRejectInside) THEN
		dataHeigh.status.Reject.iTimesInRejection := dataHeigh.status.Reject.iTimesInRejection + 1;
		dataHeigh.status.Reject.iTimesInRejectionToday := dataHeigh.status.Reject.iTimesInRejectionToday + 1;
	ELSIF EDGENEG(dataHeigh.status.MediaPosition.xMediaToRejectInside) THEN
		LogRejectingEnded;
	END_IF
	IF EDGEPOS(dataHeigh.parameters.AutoMode.xProduction) THEN // Changing to resetting when going into producion, to allow reading the value after stop
		dataHeigh.status.Reject.iTimesInRejection := 0;
	END_IF
	IF (tiTimeOfDay.hour = 0 AND tiTimeOfDay.hour = 0 AND tiTimeOfDay.minute = 0 AND tiTimeOfDay.second = 0) THEN
		dataHeigh.status.Reject.iTimesInRejectionToday := 0;		
	END_IF
	
	// Getting time of the day
	GetTOD.enable := TRUE;
	GetTOD.pDTStructure := ADR(tiTimeOfDay);
	GetTOD();
	
	dataHeigh.Commands := CommandsReseted;
	xExitingMediaL1 := FALSE;
	xExitingMediaL2 := FALSE;
	
END_PROGRAM