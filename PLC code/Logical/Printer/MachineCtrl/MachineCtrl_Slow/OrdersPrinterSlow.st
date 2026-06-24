
ACTION OrdersPrinterSlow: 

	// GENERAL MACHINE 
	gMachine.St.Consent.xLackOfConsent := gBelt.states.State = BELT_NOT_CONSENT; //With run order but without consent
	
	///////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////
	/////////////   BLOCK BLOCK BLOCK BLOCK BLOCK BLOCK BLOCK      ////////////////////
	/////////////   BLOCK BLOCK BLOCK BLOCK BLOCK BLOCK BLOCK      ////////////////////
	///////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////

	FOR iIndexBlock:=GC_FIRST_BLOCK TO gMachine.Pt.CT.iNumBlocks DO
		// Double Line		
		gBlock[iIndexBlock].Out.xEnableDobleShot:= gMachine.parSw.Dtp.xDoubleLine;

		// Vertical motor
		IF gMachine.Pt.xDynamicPrePrintingPos THEN
			IF NOT gEdgeHoldDown.status.xEnabled THEN
				IF gPhotoCells.status.xInstalled THEN
					gBlock[iIndexBlock].parameters.rPrePrintingPos := gThicknessCtrl.status.Heigh.rMediaThickness + gPhotoCells.status.rOffsetToMounted;
				ELSIF gDing.State.xDingInstalled THEN
					gBlock[iIndexBlock].parameters.rPrePrintingPos := gThicknessCtrl.status.Heigh.rMediaThickness  + gDing.Parameters.rOverThicknessToMounted;
				END_IF
			ELSE
				gBlock[iIndexBlock].parameters.rPrePrintingPos := gEdgeHoldDown.status.rBlockPrePrintingPosition; 
			END_IF
		END_IF
		
		// Clean Motor
		gBlock[iIndexBlock].parameters.Icla.iCleanMotorSpeedBwd:=gMachine.parSw.Clean.iCleanMotorSpeedBwd;
		gBlock[iIndexBlock].parameters.Icla.iCleanMotorSpeedFwd:=gMachine.parSw.Clean.iCleanMotorSpeedFwd;
		
		//Icla action
		gBlock[iIndexBlock].parameters.Icla.rMinPrintHeadPos	:= gMachine.Pt.rMinPrintHeadPos;
		gBlock[iIndexBlock].parameters.Icla.rLastHeadPosition	:= LIMIT(gMachine.Pt.rMinPrintHeadPos, gMachine.parSw.rLastHeadPosition, gMachine.Pt.rMaxPrintHeadPos);
		gBlock[iIndexBlock].parameters.Icla.rFirstHeadPosition	:= LIMIT(gMachine.Pt.rMinPrintHeadPos, gMachine.parSw.rFirstHeadPosition, gBlock[iIndexBlock].parameters.Icla.rLastHeadPosition);
		
		//Icla movement
		gBlock[iIndexBlock].parameters.Icla.rPositionCleanMotorFwd	:= gBlock[iIndexBlock].parameters.Icla.rLastHeadPosition;
	
		gBlock[iIndexBlock].parameters.uiCleaningType 			:= INT_TO_USINT(gMachine.parSw.Clean.iCleaningType);

	END_FOR	

	//ANALOG THICKNESS CONTROL
	gDing.Parameters.rMachineMinTicknessMedia := gMachine.Pt.CT.rMinTicknessMedia;
	gDing.Parameters.rMountedMediaLevelInBypassMode := gMachine.Pt.CT.rMountedMediaLevelInBypassMode;
	gDing.Parameters.xSimulationMode := gMachine.Pt.ConfigNameID = GC_CONFIG_SIMTEST_ID;
	
	//THICKNESS DETECTION
	gThicknessCtrl.parameters.Belt.rMinBeltSpeedToStart 	:= gc_rMinSpeedToStart;
	gThicknessCtrl.parameters.Cure.White.xEnabled			:= gCuringLed[iIndexWhiteCuringLedBar].Parameters.xInstalled; // Enable can be changed dynamically and tracking is needed always is installed
	gThicknessCtrl.parameters.Cure.White.iStartWindow		:= MAX(gCuringLed[iIndexWhiteCuringLedBar].Parameters.iCuringPosition - gCuringLed[iIndexWhiteCuringLedBar].parSw.iPreCuringOffset, 0); //If not limited, considered the negative as maximum and do not cure
	gThicknessCtrl.parameters.Cure.White.iEndWindow			:= gCuringLed[iIndexWhiteCuringLedBar].Parameters.iCuringPosition + (gCuringLed[iIndexWhiteCuringLedBar].Parameters.iCuringWindow/10) + gCuringLed[1].parSw.iPostCuringOffset;
	gThicknessCtrl.parameters.Cure.Color.xEnabled			:= gCuringLed[iIndexColorCuringLedBar].Parameters.xInstalled; // Enable can be changed dynamically and tracking is needed always is installed
	gThicknessCtrl.parameters.Cure.Color.iStartWindow		:= MAX(gCuringLed[iIndexColorCuringLedBar].Parameters.iCuringPosition - gCuringLed[iIndexColorCuringLedBar].parSw.iPreCuringOffset, 0); //If not limited, considered the negative as maximum and do not cure
	gThicknessCtrl.parameters.Cure.Color.iEndWindow			:= gCuringLed[iIndexColorCuringLedBar].Parameters.iCuringPosition + (gCuringLed[iIndexColorCuringLedBar].Parameters.iCuringWindow/10) + gCuringLed[iIndexColorCuringLedBar].parSw.iPostCuringOffset;
	gThicknessCtrl.parameters.Cure.Primer.xEnabled			:= gCuringLed[iIndexPrimerCuringLedBar].Parameters.xInstalled; // Enable can be changed dynamically and tracking is needed always is installed
	gThicknessCtrl.parameters.Cure.Primer.iStartWindow		:= MAX(gCuringLed[iIndexPrimerCuringLedBar].Parameters.iCuringPosition - gCuringLed[iIndexPrimerCuringLedBar].parSw.iPreCuringOffset, 0); //If not limited, considered the negative as maximum and do not cure
	gThicknessCtrl.parameters.Cure.Primer.iEndWindow		:= gCuringLed[iIndexPrimerCuringLedBar].Parameters.iCuringPosition + (gCuringLed[iIndexPrimerCuringLedBar].Parameters.iCuringWindow/10) + gCuringLed[iIndexColorCuringLedBar].parSw.iPostCuringOffset;
	
	gThicknessCtrl.parameters.Cure.xEnableTracking			:= gMachine.Pt.Hw.iMaxCuringLedBars>0;

	// Till now just considering Line 1
	gThicknessCtrl.parameters.ContinuousMedia.MediaData.iLine := 1;
	gThicknessCtrl.parameters.ContinuousMedia.MediaData.rThickness := gMachine.parSw.Media.rThickness;
	gThicknessCtrl.parameters.ContinuousMedia.MediaData.rWidth := gMachine.parSw.Media.rWidth;
	gThicknessCtrl.parameters.ContinuousMedia.MediaData.rLength := gMachine.parSw.Media.rLength;
	gThicknessCtrl.parameters.ContinuousMedia.MediaData.rCrossOffset := gMachine.parSw.Media.rOffsetRegisterL1;
	IF gMachine.Pt.ConfigNameID<> GC_CONFIG_SIMTEST_ID THEN
		gThicknessCtrl.parameters.ContinuousMedia.MediaData.xHasWhite := gMachine.St.White.xEnableToPrint;
		gThicknessCtrl.parameters.ContinuousMedia.MediaData.xHasClear := gMachine.St.Clear.xEnableToPrint;
	ELSE
		gThicknessCtrl.parameters.ContinuousMedia.MediaData.xHasWhite := gCuringLed[iIndexWhiteCuringLedBar].Parameters.xInstalled;
		gThicknessCtrl.parameters.ContinuousMedia.MediaData.xHasClear := gCuringLed[iIndexPrimerCuringLedBar].Parameters.xInstalled;
	END_IF
	gThicknessCtrl.parameters.ContinuousMedia.MediaData.rDocWidth := gMachine.parSw.Document.rWidth;
	gThicknessCtrl.parameters.ContinuousMedia.MediaData.rDocLength := gMachine.parSw.Document.rLength;
	gThicknessCtrl.parameters.ContinuousMedia.MediaData.rDocCrossOffset := gMachine.parSw.Document.rOffsetL1;

	gThicknessCtrl.parameters.xDoubleLine := gMachine.parSw.Dtp.xDoubleLine;
	gThicknessCtrl.parameters.Detection.Array.xEnableSensorIncoherAlarm := gPhotoCells.status.xTrustPhotocellASignal;

	
	CASE gStacker.Status.StackerType OF
		//Full stacker requires to set reject order (digital output) when boards "tail" is just about to exit printer's belt
		STACKERTY_FULL_S,
		STACKERTY_UNDEFINED:
			gThicknessCtrl.parameters.Reject.RejectBoardEdge := REJECT_REAR;
			
		//Bundle stacker requires to set reject order (digital output) when boards "head" is just about to exit printer's belt
		STACKERTY_BUNDLE_S:
			gThicknessCtrl.parameters.Reject.RejectBoardEdge := REJECT_FRONT;
	END_CASE


	
	//CURING LAMPS
	FOR iIndexCuringLed:=1 TO MAX_LAST_CURING_LED DO
		
		IF gMachine.Pt.Cure.xForceMaxWidth THEN
			gCuringLed[iIndexCuringLed].Parameters.iMediaWidth 		:= gMachine.Pt.Hw.iWidth;
			gCuringLed[iIndexCuringLed].Parameters.iDocumentWidth 	:= gMachine.Pt.Hw.iWidth;
			gCuringLed[iIndexCuringLed].Parameters.iMediaOffsetL1 	:= (-1) * gMachine.Pt.Hw.iWidth / 2;
			gCuringLed[iIndexCuringLed].Parameters.iDocumentOffsetL1:= gCuringLed[iIndexCuringLed].Parameters.iMediaOffsetL1;
			gCuringLed[iIndexCuringLed].Parameters.iMediaOffsetL2 	:= gCuringLed[iIndexCuringLed].Parameters.iMediaOffsetL1;
			gCuringLed[iIndexCuringLed].Parameters.iDocumentOffsetL2:= gCuringLed[iIndexCuringLed].Parameters.iMediaOffsetL1;
		ELSE
			gCuringLed[iIndexCuringLed].Parameters.iMediaWidth 		:= REAL_TO_UINT(gMachine.parSw.Media.rWidth);
			gCuringLed[iIndexCuringLed].Parameters.iDocumentWidth 	:= REAL_TO_UINT(gMachine.parSw.Document.rWidth);
			gCuringLed[iIndexCuringLed].Parameters.iMediaOffsetL1 	:= REAL_TO_INT(gMachine.parSw.Media.rOffsetRegisterL1);
			gCuringLed[iIndexCuringLed].Parameters.iDocumentOffsetL1:= REAL_TO_INT(gMachine.parSw.Document.rOffsetL1);
			gCuringLed[iIndexCuringLed].Parameters.iMediaOffsetL2 	:= REAL_TO_INT(gMachine.parSw.Media.rOffsetRegisterL2);
			gCuringLed[iIndexCuringLed].Parameters.iDocumentOffsetL2:= REAL_TO_INT(gMachine.parSw.Document.rOffsetL2);
		END_IF

		gCuringLed[iIndexCuringLed].Parameters.xDoubleLine 		:= gMachine.parSw.Dtp.xDoubleLine AND gMachine.Pt.Hw.xDoubleLineAllowed;
		
		gCuringLed[iIndexCuringLed].Parameters.rBeltCurrentSpeed:= gBelt.states.rCurrentSpeed;
		gCuringLed[iIndexCuringLed].Parameters.Mode 			:= gMachine.St.Mode;
		gCuringLed[iIndexCuringLed].Parameters.xCureBySpeed		:= gMachine.parSw.Curing.xCureBySpeed;
		gCuringLed[iIndexCuringLed].Parameters.xCureByStretch	:= gMachine.parSw.Curing.xCureByStretch AND gMachine.Pt.Cure.xCuringByStretchAllowed;
		gCuringLed[iIndexCuringLed].Parameters.xOptimizeCuring	:= gMachine.parSw.Curing.xOptimizeCuring OR gEdgeHoldDown.status.xEnabled;;
		gCuringLed[iIndexCuringLed].Parameters.xSimulationMode	:=  gMachine.Pt.ConfigNameID = GC_CONFIG_SIMTEST_ID;
		
		//Setting max curing variables depending on EdgeHoldDown
		IF  gEdgeHoldDown.status.xEnabled THEN
			gCuringLed[iIndexCuringLed].Parameters.iMaxCuringAreaWidth := REAL_TO_UINT(gMachine.parSw.Media.rWidth-2*gEdgeHoldDown.parSw.iOverlap-2*gCuringLed[iIndexCuringLed].Parameters.iSlmWidth);
			gCuringLed[iIndexCuringLed].Parameters.iMaxCuringAreaOffsetL1 := REAL_TO_INT(gCuringLed[iIndexCuringLed].Parameters.iMaxCuringAreaWidth/2)*(-1);
			gCuringLed[iIndexCuringLed].Parameters.iMaxCuringAreaOffsetL2 := REAL_TO_INT(gCuringLed[iIndexCuringLed].Parameters.iMaxCuringAreaWidth/2);	
		ELSE
			gCuringLed[iIndexCuringLed].Parameters.iMaxCuringAreaWidth := gMachine.Pt.Hw.iWidth;
			gCuringLed[iIndexCuringLed].Parameters.iMaxCuringAreaOffsetL1 := REAL_TO_INT(gMachine.Pt.Hw.iWidth/2)*(-1);
			gCuringLed[iIndexCuringLed].Parameters.iMaxCuringAreaOffsetL2 := REAL_TO_INT(gMachine.Pt.Hw.iWidth/2);
		END_IF
		
	END_FOR
	
	IF gMachine.St.White.xEnableToPrint THEN
		gCuringLed[iIndexWhiteCuringLedBar].Parameters.xEnabled := TRUE;
	ELSIF gThicknessCtrl.status.Belt.xBeltEmpty THEN
		gCuringLed[iIndexWhiteCuringLedBar].Parameters.xEnabled := FALSE;
	END_IF
	
	IF gMachine.Pt.CT.iNumCuringLeds = 1 OR gMachine.St.Color.xEnableToPrint THEN
		gCuringLed[iIndexColorCuringLedBar].Parameters.xEnabled := TRUE;
	ELSIF gThicknessCtrl.status.Belt.xBeltEmpty THEN
		gCuringLed[iIndexColorCuringLedBar].Parameters.xEnabled := FALSE;
	END_IF

	IF gMachine.St.Clear.xEnableToPrint THEN
		gCuringLed[iIndexPrimerCuringLedBar].Parameters.xEnabled := TRUE;
	ELSIF gThicknessCtrl.status.Belt.xBeltEmpty THEN
		gCuringLed[iIndexPrimerCuringLedBar].Parameters.xEnabled := FALSE;
	END_IF

	
	
	IF NOT gMachine.Pt.xControlledByLine THEN
		gMachine.Pt.Media.iMaxMediaWidth := gMachine.Pt.Hw.iWidth;
		gMachine.Pt.Media.iMaxMediaLength := gMachine.parSw.Hw.iMaxMediaLength;
		gMachine.Pt.Media.iMinMediaWidth := 300;
		gMachine.Pt.Media.iMinMediaLength := 300;
		gMachine.Pt.Media.rMaxMediaThickness := gMachine.Pt.CT.rMaxTicknessMedia;
		gMachine.Pt.Media.rMinMediaThickness := gMachine.Pt.CT.rMinTicknessMedia;
	END_IF
	
	// Printer remotelly controlled
	IF EDGENEG(gMachine.St.AutoMode.xStop) OR EDGENEG(gMachine.St.Mode.xAuto) OR gMachine.St.Mode.xZero THEN
		//To avoid start blowers when returning to Auto.Stop
		gMachine.commands.Remote.xStartBlowers := FALSE;
	END_IF
	
	
	
	
	//CHILLER
	IF iIndexChillersSlow=0 OR iIndexChillersSlow> gMachine.Pt.Hw.iMaxNumChillers THEN
		iIndexChillersSlow:=1;
	END_IF
	
	IF gChiller[iIndexChillersSlow].Parameters.xInstalled THEN
		xRunChiller := FALSE;
		//Review printheads conditions to run its chiller
		FOR iIndexInks:=1 TO MAX_LAST_INK DO
			IF gInks[iIndexInks].parameters.PrintheadsChiller.iIndex = iIndexChillersSlow THEN
				IF gInks[iIndexInks].signals.out.xOutPowPrintHead THEN
					xRunChiller := TRUE;
				END_IF
			END_IF
		END_FOR
		
		//Review inks conditions to run its chiller
		FOR iIndexInks:=1 TO MAX_LAST_INK DO
			IF gInks[iIndexInks].parameters.InksChiller.iIndex = iIndexChillersSlow THEN
				IF gInks[iIndexInks].status.xInksRunning THEN
					xRunChiller := TRUE;
				END_IF
			END_IF
		END_FOR
		
		//Review curing led bars conditions to run its chiller
		FOR iIndexCuringLed:=1 TO MAX_LAST_CURING_LED DO
			IF gCuringLed[iIndexCuringLed].Parameters.iChillerIndex = iIndexChillersSlow THEN
				IF gCuringLed[iIndexCuringLed].Signals.Outputs.xRunChiller THEN
					xRunChiller := TRUE;
				END_IF
			END_IF
		END_FOR
		
		gChiller[iIndexChillersSlow].Orders.xRun := xRunChiller;
		
	END_IF
	
	iIndexChillersSlow:=iIndexChillersSlow+1;
	
	//Antistatic device
	gMachine.Out.xAntiStaticPOn := gMachine.St.Position.xInPrint;
	
	//Commands
	FOR iIndex:=1 TO gMachine.Pt.Hw.iMaxNumChillers DO
		gChiller[iIndex].commands.xMute	:= gMachine.AutoCmd.xMuteAlarms;
		gChiller[iIndex].commands.xReset		:= gMachine.AutoCmd.xReset;
	END_FOR
	
	
	//Powermeters
	FOR iIndex:=1 TO gMachine.Pt.Hw.iMaxNumPowerMeters DO
		IF gPowermeters[iIndex].Parameters.xInstalled THEN
			gPowermeters[iIndex].Commands.xMute	:= gMachine.AutoCmd.xMuteAlarms;
			gPowermeters[iIndex].Commands.xReset:= gMachine.AutoCmd.xReset;
		END_IF
	END_FOR
	
	
END_ACTION
