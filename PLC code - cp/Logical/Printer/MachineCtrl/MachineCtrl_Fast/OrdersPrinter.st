
ACTION OrdersPrinter:

	StatusBlockDetection;	
	GeneralAutoCommands;
	GeneralAutoParameters;
	ThicknessControl;
	BlockControl;
	TransportVacuum;
	NonCrashControl;
	CuringLedControl;
	JamDetectControl;
	BeltControl;
	SafetyControl;
	nSensorControl;
	AnalogThicknessControl;
	GeneralControl;
	AncillariesControl;
	EdgeHoldDownControl;
	RemoteCtrl;
	
END_ACTION

ACTION StatusBlockDetection: 
	
	////////////////////////////////////////////////////////
	// Inputs by comns are auto commands in printer, not all
	//	from kernel: xMute_GI and xReset_GI
	//  from panel: xReset or validate
	////////////////////////////////////////////////////////
	xInCap       		:= TRUE; 	// When all block are capped printer is capped  (AND)
	xInPrint    		:= TRUE;	// When all blocks are printing then is printing (AND)
	xOrderToCapReceived		:= TRUE;
	xOrderToPrintReceived	:= TRUE;
	xGoingToCap  		:= FALSE;
	xGoingToPrint		:= FALSE;
	xCleaning    		:= FALSE;
	xAlarmToEmpyBelt 	:= FALSE;

	FOR iIndexBlock:=GC_FIRST_BLOCK TO gMachine.Pt.CT.iNumBlocks DO
		IF NOT gBlock[iIndexBlock].Status.Position.xInCap THEN
			xInCap:=FALSE;
		END_IF
		
		IF NOT gBlock[iIndexBlock].Status.Position.xInPrint AND gBlock[iIndexBlock].Status.xEnabledMovements THEN
			xInPrint:=FALSE;
		END_IF
		
		IF gBlock[iIndexBlock].Status.Position.xGoingToCap THEN
			xGoingToCap:=TRUE;
		END_IF
		
		IF NOT (gBlock[iIndexBlock].Status.Position.xGoingToCap OR gBlock[iIndexBlock].Status.Position.xInCap) THEN
			xOrderToCapReceived:=FALSE;
		END_IF
		IF NOT (gBlock[iIndexBlock].Status.Position.xGoingToPrint OR gBlock[iIndexBlock].Status.Position.xInPrint) AND gBlock[iIndexBlock].Status.xEnabledMovements THEN
			xOrderToPrintReceived:=FALSE;
		END_IF

		IF gBlock[iIndexBlock].Status.Position.xGoingToPrint THEN
			xGoingToPrint:=TRUE;
		END_IF

		IF gBlock[iIndexBlock].Status.Position.xCleaning THEN
			xCleaning:=TRUE;
		END_IF
		
		IF gBlock[iIndexBlock].Status.xAlarmToEmptyBelt THEN
			xAlarmToEmpyBelt:=TRUE;
		END_IF

	END_FOR
	
	//Keeping the signal while the block goes through the next state
	tofMachineCleaning.IN:=xCleaning;
	tofMachineCleaning.PT:=t#150ms;
	tofMachineCleaning();

	gMachine.St.Position.xInCap       	:=	xInCap; 	// When one block is capped printer is capped  (OR)
	gMachine.St.Position.xInPrint    	:=	xInPrint;	// When all blocks are printing then is printing (AND)
	gMachine.St.Position.xGoingToCap  	:=	xGoingToCap;
	gMachine.St.Position.xGoingToPrint	:=	xGoingToPrint;
	gMachine.St.Position.xCleaning    	:=	tofMachineCleaning.Q;	
	gMachine.St.Blocks.xBlockAlarmToEmpyBelt 	:= 	xAlarmToEmpyBelt;


	// With these bool are set enPrinterStatesInAuto
	IF gMachine.St.Position.xInCap          THEN enPrinterStatesInAuto:=PRINTER_CAPPED;         END_IF
	IF gMachine.St.Position.xInPrint        THEN enPrinterStatesInAuto:=PRINTER_PRINTING;       END_IF
	IF gMachine.St.Position.xCleaning       THEN enPrinterStatesInAuto:=PRINTER_CLEANING;       END_IF
	IF gMachine.St.Position.xGoingToCap     THEN enPrinterStatesInAuto:=PRINTER_GOING_TO_CAP;   END_IF
	IF gMachine.St.Position.xGoingToPrint	THEN enPrinterStatesInAuto:=PRINTER_GOING_TO_PRINT; END_IF
	
END_ACTION

ACTION GeneralAutoCommands:
	

	/////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////
	//   General auto commads to send block to print or cap from kernel			   //
	/////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////

	// An edge of commandbooledge must go to cap
	iReasonCap.0 := gMachine.commands.xAllToCap AND (NOT gMachine.St.Position.xInCap);
	iReasonCap.1 := EDGEPOS(gMachine.St.Consent.xUpWithNoConsent);
	iReasonCap.2 := EDGEPOS(gMachine.St.AutoMode.xStop);
	iReasonCap.3 := EDGEPOS(gMachine.St.AutoMode.xBypass);
	
	iReasonPrint.0 := EDGEPOS(gMachine.commands.xAllToPrint) AND (NOT gMachine.St.Position.xInPrint) AND (gMachine.St.AutoMode.xProdORLab OR gMachine.Pt.xControlledByLine); // An edge of commandbooledge must go to print, if the machine is not stopped
	iReasonPrint.1 := EDGEPOS (gMachine.St.AutoMode.xProduction) AND NOT gMachine.Pt.xControlledByLine; // An edge of auto run must go to print
	iReasonPrint.2 := gMachine.AutoCmd.xStart AND (NOT gMachine.St.Position.xInPrint) AND gMachine.St.AutoMode.xProduction AND NOT gMachine.Pt.xControlledByLine;
	iReasonPrint.3 := EDGEPOS(gMachine.St.Consent.xConsent) AND gMachine.St.Consent.xUpWithNoConsent AND gMachine.St.AutoMode.xProdORLab;
	iReasonPrint.4 := EDGEPOS (gMachine.St.AutoMode.xJamRecovery); // An edge of auto Jam Recovery must go to print

	IF iReasonCap > 0 THEN
		
		lastReasonCap := iReasonCap;
		gMachine.AutoCmd.xToCap:= TRUE;
		gMachine.AutoCmd.xToPrint:= FALSE;
		iBlockExecutionsOrder := gBlock[1].Status.execTimes;
		
	ELSIF iReasonPrint > 0 THEN

		lastReasonPrint := iReasonPrint;
		gMachine.AutoCmd.xToCap:= FALSE;
		gMachine.AutoCmd.xToPrint:= TRUE;
		iBlockExecutionsOrder := gBlock[1].Status.execTimes;
			
	END_IF	
	

	//Fall down orders when received by the blocks
	IF (xOrderToCapReceived) THEN
		gMachine.AutoCmd.xToCap := FALSE;
		iBlockDelay := gBlock[1].Status.execTimes - iBlockExecutionsOrder;
	END_IF
	IF (xOrderToPrintReceived) THEN
		gMachine.AutoCmd.xToPrint := FALSE;
		iBlockDelay := gBlock[1].Status.execTimes - iBlockExecutionsOrder;
	END_IF
	
	
	//Ready To print summary variables from blocks
	xMachReadyToPrint := TRUE;
	FOR iIndexBlock:=GC_FIRST_BLOCK TO gMachine.Pt.CT.iNumBlocks DO
		IF gBlock[iIndexBlock].Status.xEnabledMovements AND NOT gBlock[iIndexBlock].Status.Position.xReadyToPrint THEN
			xMachReadyToPrint := FALSE;
		END_IF
	END_FOR
			
	
	//When receiving the order to go to print, update the array to avoid going down lower than needed
	IF EDGEPOS(gMachine.AutoCmd.xToPrint) OR EDGEPOS(gMachine.AutoCmd.xToCap) THEN
		gThicknessCtrl.Commands.UpdateAllMatrix:=TRUE;
	END_IF
	
END_ACTION

ACTION GeneralAutoParameters:

	/////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////
	//   General PARAMETERS 													   //
	/////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////
	
	IF gMachine.Pt.MountedMedia.xDynamicMountedMedia THEN
		IF (gMachine.Pt.MountedMedia.Dynamic.rSpeedMaxMounted = gMachine.Pt.MountedMedia.Dynamic.rSpeedMinMounted) THEN
			//To avoid a divition between 0
			rMountedLimit := 20;
		ELSE
			rMountedLimit := gMachine.Pt.MountedMedia.Dynamic.rMaxOverThickMounted -
			(
			(gBelt.states.rCurrentSpeed - gMachine.Pt.MountedMedia.Dynamic.rSpeedMinMounted) * // Partial of the speed
			(gMachine.Pt.MountedMedia.Dynamic.rMaxOverThickMounted - gMachine.Pt.MountedMedia.Dynamic.rMinOverThickMounted)/ //Range of Overthickness
			(gMachine.Pt.MountedMedia.Dynamic.rSpeedMaxMounted - gMachine.Pt.MountedMedia.Dynamic.rSpeedMinMounted) // Range of speed
			);
		END_IF
		gMachine.St.MountedMedia.rOverThicknessToMounted := LIMIT(gMachine.Pt.MountedMedia.Dynamic.rMinOverThickMounted, rMountedLimit, gMachine.Pt.MountedMedia.Dynamic.rMaxOverThickMounted);
	ELSE
		gMachine.St.MountedMedia.rOverThicknessToMounted := gMachine.parSw.Safety.rMountedPieceOverthickness;
	END_IF	
	
END_ACTION

ACTION ThicknessControl:	
	
	////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////
	/////////////   THICKNESS DETECTION	THICKNESS DETECTION        /////////////////
	/////////////   THICKNESS DETECTION	THICKNESS DETECTION        /////////////////
	////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////
	
	RejectLength;
	gThicknessCtrl.parameters.Mode  								:= gMachine.St.Mode;
	gThicknessCtrl.parameters.AutoMode								:= gMachine.St.AutoMode;	
	gThicknessCtrl.parameters.Belt.rBeltSpeed 						:= gBelt.states.rCurrentSpeed;
	gThicknessCtrl.parameters.ContinuousMedia.MediaData.rThickness	:= gMachine.parSw.Media.rThickness;
	gThicknessCtrl.parameters.ContinuousMedia.MediaData.rMargin		:= gMachine.parSw.rMarginPrint;
	gThicknessCtrl.parameters.Detection.ProductDetect.iMediaFilter	:= gMachine.Pt.iMediaFilter;
	gThicknessCtrl.parameters.rMarginSafePrint						:= gMachine.parSw.Safety.rMarginSafePrint;
	gThicknessCtrl.parameters.iDistanceFromArrayToPd				:= TRUNC(gMachine.Pt.CT.rDistanceThicknesToPD);
	IF gPhotoCells.status.xInstalled THEN
		gThicknessCtrl.parameters.xBlockInProperPrintingPosition 	:= gBlock[1].Status.rMotorPosition <= gPhotoCells.status.rOffsetToReject + gMachine.parSw.Media.rThickness;
	ELSIF gDing.State.xDingInstalled THEN
		gThicknessCtrl.parameters.xBlockInProperPrintingPosition 	:= gBlock[1].Status.rMotorPosition <= gDing.Parameters.rOverThicknessToReject + gMachine.parSw.Media.rThickness;
	END_IF
	gThicknessCtrl.parameters.xBlockInPrint							:= gBlock[1].Status.Position.xInPrint;
	gThicknessCtrl.Inputs.xVirtualMedia 							:= gMachine.Out.xShotLine1 OR gMachine.Out.xShotLine2;
	
	gThicknessCtrl.Commands.xErrorRst								:= gMachine.AutoCmd.xReset;
	gThicknessCtrl.Commands.xRushProof 								:= gMachine.commandsSw.xRushProof;
	gThicknessCtrl.Commands.xCameraDefectDetected 					:= gMachine.In.xCameraDefectDetected;
	gThicknessCtrl.Commands.xAllowToSetMountedMediaHeigh 			:= NOT gMachine.Pt.xControlledByLine;
	gThicknessCtrl.Commands.xResetMediaBelow						:= gLine.Status = LINE_PREPARING_PRINT;
	gThicknessCtrl.Commands.xReviewIncoherenceArrayAndPd			:= gPhotoCells.status.xInstalled AND (gMachine.Pt.PDSignalTpe=PDCFG_SENSOR);
	
	gThicknessCtrl.Orders.xDiscardAllMedia							:= gLine.StatusSummary.xEmptyingBelts;
	
	// If need to add extra height to protect the Printheads, send the information to ThicknessCtrl
	tonRaiseBarsInPause.IN := gMachine.Pt.xProtectPHWithStoppedMediaBended AND gMachine.St.AutoMode.xPause AND gThicknessCtrl.status.MediaPosition.xMediaInside;
	tonRaiseBarsInPause.PT := gMachine.Pt.tiTimeToRaiseBars; //t#5m;
	tonRaiseBarsInPause();
	gMachine.St.xProtectBendedWithPause := tonRaiseBarsInPause.Q;
	IF EDGEPOS(gMachine.St.Consent.xUpWithNoConsent OR gMachine.St.xProtectBendedWithPause) AND NOT gTransVacuum[1].Status.xInstalled THEN
		gThicknessCtrl.Commands.xAddSafetyMarginToHeight := TRUE;
	END_IF
	
END_ACTION

ACTION BlockControl:
	
	///////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////
	/////////////   BLOCK BLOCK BLOCK BLOCK BLOCK BLOCK BLOCK      ////////////////////
	/////////////   BLOCK BLOCK BLOCK BLOCK BLOCK BLOCK BLOCK      ////////////////////
	///////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////

	//Up bars by bent tile
	tonDelayToSafetyPos.IN:= gThicknessCtrl.status.MediaPosition.xMediaBelowMachine AND NOT gBelt.states.xRuningBelt AND 
							((gMachine.Pt.xProtectPHWithStoppedMediaBended AND gMachine.St.AutoMode.xProduction) OR (gMachine.Pt.xProtectPHForBlowersRunning AND gTransVacuum[1].Status.State = TRANSVAC_CONTROLLING));
	tonDelayToSafetyPos.PT:= T#1m;
	tonDelayToSafetyPos();
	
	srUpBarsToSafePos.SET1	:= 	EDGEPOS(tonDelayToSafetyPos.Q);
	srUpBarsToSafePos.RESET	:= 	NOT gThicknessCtrl.status.MediaPosition.xMediaBelowMachine  OR
								(EDGEPOS(gMachine.St.Consent.xConsent) OR EDGEPOS(gBelt.commands.xRunBelt));
	srUpBarsToSafePos();
	
	gMachine.AutoCmd.xToSafePosition := srUpBarsToSafePos.Q1;
	
	// Reason Move Bars to PrePrinting Position
	tonProtecPHBlowers.IN :=	gMachine.Pt.xProtectPHForBlowersRunning AND
								NOT gThicknessCtrl.status.MediaPosition.xMediaInside AND 
								NOT gThicknessCtrl.status.MediaPosition.xVirtualMediaInside AND
								(gTransVacuum[1].Status.State = TRANSVAC_CONTROLLING OR gMachine.St.AutoMode.xPause) AND
								gMachine.St.Mode.xAuto AND gMachine.St.Position.xInPrint AND
								NOT gMachine.Pt.xControlledByLine AND
								(NOT gMachine.parSw.Remote.xSendingJob OR NOT gMachine.Pt.xControlledRemotely);
	tonProtecPHBlowers.PT := t#20s;
	tonProtecPHBlowers();
	
	// 1 sec after receiving the SendingJob signal, it is reseted
	tonResetSendingJob.IN := gMachine.parSw.Remote.xSendingJob;
	tonResetSendingJob.PT := t#1s;
	tonResetSendingJob();
	IF tonResetSendingJob.Q THEN 
		gMachine.parSw.Remote.xSendingJob := FALSE;
	END_IF
	
	iReasonForcePreprintingPos.0 := tonProtecPHBlowers.Q;
	iReasonForcePreprintingPos.1 := gLine.Orders.Preprinting;
	iReasonForcePreprintingPos.2 := gMachine.AutoCmd.xToSafePosition;
	iReasonForcePreprintingPos.3 := gLine.StatusSummary.xEmptyingBelts;
	iReasonForcePreprintingPos.4 := gEdgeHoldDown.parSw.xEnable AND NOT gEdgeHoldDown.status.xAdjustedToMedia;
	iReasonForcePreprintingPos.5 := gMachine.St.AutoMode.xJamRecovery;
	iReasonForcePreprintingPos.6 := gThicknessCtrl.status.MediaPosition.xMountedMediaInside;
	iReasonForcePreprintingPos.7 := gLine.StatusSummary.xCleaningBelt;

	// Registering PrePrintingPos
	IF iPrevReasonForcePreprintingPos <> iReasonForcePreprintingPos THEN
		LogPrePrintingPos;
	END_IF
	iPrevReasonForcePreprintingPos := iReasonForcePreprintingPos;
	
	xForcePreprintingPos := (iReasonForcePreprintingPos>0);
		
	FOR iIndexBlock:=GC_FIRST_BLOCK TO gMachine.Pt.CT.iNumBlocks DO

		//NOTE: Sw and Slow information is sent to the Block in MachineSlow >> OrdersPrinterSlow
		
		// It sends blocks to pirnting state because is required by mode active printer
		gBlock[iIndexBlock].commands.StateMode  := gMachine.St.StateMode;
		gBlock[iIndexBlock].commands.Mode  		:= gMachine.St.Mode;
		gBlock[iIndexBlock].commands.AutoMode	:= gMachine.St.AutoMode;
		IF gMachine.AutoCmd.xToCap THEN  gBlock[iIndexBlock].commands.xToCap := TRUE; END_IF //This is to allow individual orders
		IF gMachine.AutoCmd.xToPrint THEN  gBlock[iIndexBlock].commands.xToPrint := TRUE; END_IF //This is to allow individual orders
		gBlock[iIndexBlock].commands.xReset		:= gMachine.AutoCmd.xReset;
		gBlock[iIndexBlock].commands.xMute		:= gMachine.AutoCmd.xMuteAlarms;
		gBlock[iIndexBlock].commands.xCleanStop	:= gMachine.AlSummary.xAlrSafetySystemGeneral;
		gBlock[iIndexBlock].commands.xForcePreprintingPos := xForcePreprintingPos;
		
		gBlock[iIndexBlock].parameters.Motor.rPrintPosition		:= gThicknessCtrl.status.Heigh.rMaxHeigh[iIndexBlock];
		gBlock[iIndexBlock].parameters.xLeftHandMachine			:= gMachine.Pt.xLeftHandMachine;
		gBlock[iIndexBlock].parameters.xRightHandMachine		:= gMachine.Pt.xRightHandMachine;
		gBlock[iIndexBlock].parameters.xMediaBelow				:= NOT gThicknessCtrl.status.Belt.xBeltEmpty;
		gBlock[iIndexBlock].parameters.xPrinterKeyMaintenanceActivated := gSafetyController.Inputs.xPrinterMaintenanceKey AND gSafetyController.Parameters.xInstalled;
				
	END_FOR
	
END_ACTION


ACTION TransportVacuum:
	
	///////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////
	/////////////   TRANSPORT VACUUM   TRANSPORT VACUUM     ///////////////////////////
	/////////////   TRANSPORT VACUUM   TRANSPORT VACUUM     ///////////////////////////
	///////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////
	
	FOR usiIndex:=1 TO gMachine.Pt.CT.iNumTransVacuum BY 1 DO
		OrdersToTransVacuum;
	END_FOR
	
	
END_ACTION

ACTION NonCrashControl:	
	
	///////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////
	///////////   NON CRASH   NON CRASH   NON CRASH   NON CRASH    ////////////////////
	///////////   NON CRASH   NON CRASH   NON CRASH   NON CRASH    ////////////////////
	///////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////
	
	IF gNonCrash[1].Status.xInstalled THEN
		
		gNonCrash[1].Parameters.Mode := gMachine.St.Mode;
		gNonCrash[1].Parameters.AutoMode := gMachine.St.AutoMode;
		
		gNonCrash[1].Parameters.rSpeedSetPoint := gBelt.parameters.rSetPointSpeed;
		
		gNonCrash[1].Commands.xRun := gBelt.states.xRuningBelt;
		gNonCrash[1].Commands.xMute := gMachine.AutoCmd.xMuteAlarms;
		gNonCrash[1].Commands.xReset := gMachine.AutoCmd.xReset;
		
		//Safety Alarm Summary
		gNonCrash[1].Commands.xExternalSafetyStop := gMachine.AlSummary.xAlrSafetySystemGeneral;

	END_IF
	
END_ACTION

ACTION CuringLedControl:
	
	///////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////
	/////////// CURING LED    CURING LED    CURING LED    CURING LED   ////////////////
	/////////// CURING LED    CURING LED    CURING LED    CURING LED   ////////////////
	///////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////
	FOR iIndexCuringBar:=1 TO MAX_LAST_CURING_LED DO
	
		iReasonRunNitrogenFlow.0 := (gBelt.states.rCurrentSpeed>=gCuringLed[iIndexCuringBar].Parameters.rMinCureSpeed) AND 
									(gMachine.St.AutoMode.xProdORLab OR gMachine.St.AutoMode.xJamRecovery) AND 
									NOT gMachine.St.Position.xCleaning;
		iReasonRunNitrogenFlow.1 := (gBelt.states.rCurrentSpeed>=gCuringLed[iIndexCuringBar].Parameters.rMinCureSpeed) AND gLine.StatusSummary.xControlStopping;
		iReasonRunNitrogenFlow.2 := gLine.StatusSummary.xEmptyingBelts;
		iReasonRunNitrogenFlow.3 := gLine.StatusSummary.xPrinting;
		
		IF gCuringLed[iIndexCuringBar].Parameters.xInstalled THEN
			gCuringLed[iIndexCuringBar].Parameters.Mode 			:= gMachine.St.Mode;
			gCuringLed[iIndexCuringBar].Parameters.AutoMode 		:= gMachine.St.AutoMode;
						
			//Evaluating media is in curing led bar position
			xMediaInLedPosition := FALSE;
			IF gCuringLed[iIndexCuringBar].Parameters.CuringApplicationType = CURING_APP_WHITE THEN
				xMediaInLedPosition := (gThicknessCtrl.status.MediaPosition.L1.White.xMediaInLedPosition OR gThicknessCtrl.status.MediaPosition.L2.White.xMediaInLedPosition);
				
			ELSIF gCuringLed[iIndexCuringBar].Parameters.CuringApplicationType = CURING_APP_COLOR THEN
				xMediaInLedPosition := (gThicknessCtrl.status.MediaPosition.L1.Color.xMediaInLedPosition OR gThicknessCtrl.status.MediaPosition.L2.Color.xMediaInLedPosition);
				
			ELSIF gCuringLed[iIndexCuringBar].Parameters.CuringApplicationType = CURING_APP_PRIMER THEN
				xMediaInLedPosition := (gThicknessCtrl.status.MediaPosition.L1.Primer.xMediaInLedPosition OR gThicknessCtrl.status.MediaPosition.L2.Primer.xMediaInLedPosition);
			END_IF
			
			//Defining which curing led bar have to cure always when in printing (related to jam recovery/empty belt processes when only one the several curing led bars have to cure
			IF iIndexCuringBar=gMachine.Pt.Hw.iMaxCuringLedBars THEN
				xCuringDesired[iIndexCuringBar] := gBlock[1].Status.Position.xInPrint;
			ELSE
				xCuringDesired[iIndexCuringBar] := gThicknessCtrl.parameters.xBlockInProperPrintingPosition;
			END_IF
			
			
			//Commands
			gCuringLed[iIndexCuringBar].Commands.PowerOn 				:= NOT gSafetyController.Alarms.xCriticalAlarm;
			gCuringLed[iIndexCuringBar].Commands.Mute 				:= gMachine.AutoCmd.xMuteAlarms;
			gCuringLed[iIndexCuringBar].Commands.Reset 				:= gMachine.AutoCmd.xReset;
				
			IF gCuringLed[iIndexCuringBar].Parameters.xEnabled THEN
				gCuringLed[iIndexCuringBar].Commands.RunCuring 			:= 	xMediaInLedPosition AND 
																			(gBelt.states.rCurrentSpeed>=gCuringLed[1].Parameters.rMinCureSpeed) AND
																			gBelt.states.xRuningBelt AND //This condition seems repeated but just for safety
																			(xCuringDesired[iIndexCuringBar] OR gMachine.St.AutoMode.xJamRecovery) AND
																			gMachine.St.Mode.xAuto; //This condition was required in DELOREAN-442
				
				gCuringLed[iIndexCuringBar].Commands.xDropPower	 		:= gLine.StatusSummary.xEmptyingBelts OR NOT gThicknessCtrl.parameters.xBlockInProperPrintingPosition OR gMachine.St.AutoMode.xJamRecovery;
				gCuringLed[iIndexCuringBar].Commands.xRunNitrogenFlow 	:= (iReasonRunNitrogenFlow>0);
				gCuringLed[iIndexCuringBar].Commands.xUpdateTempValues 	:= gPLC.Internal.Blink_10s.Out;
			END_IF
			
		END_IF
	END_FOR
	
END_ACTION

ACTION JamDetectControl:
	
	/////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////
	/////////////   JAM DETECT	JAM DETECT	JAM DETECT	JAM DETECT	/////////////////
	/////////////   JAM DETECT	JAM DETECT	JAM DETECT	JAM DETECT	/////////////////
	/////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////
	
	IF gMachine.St.iJamDevices > 0 THEN 
		OrdersToJamVibration;
	END_IF
	
	//Wait finish JamTesting to start belt
	xStopBeltJamTesting :=	gMachine.parSw.xJamDetectEnable AND
							gMachine.St.AutoMode.xProduction AND
							(gBlock[1].Status.PositionState = BLOCKP_IN_PRINT OR gBlock[2].Status.PositionState = BLOCKP_IN_PRINT) AND
							(gJamDetect[1].Status = JAMVIB_TESTING OR gJamDetect[2].Status = JAMVIB_TESTING);
	
END_ACTION

ACTION BeltControl:
	
	///////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////
	/////////////   BELT  BELT  BELT  BELT  BELT  BELT  BELT  BELT  ///////////////////
	/////////////   BELT  BELT  BELT  BELT  BELT  BELT  BELT  BELT  ///////////////////
	///////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////	

	IF gMachine.St.Position.xCleaning AND (gMachine.St.xMediaDetected) AND NOT gMachine.St.AutoMode.xBypass THEN
		xStopBeltWhileCleaning:= TRUE;
	ELSIF NOT gMachine.St.Mode.xAuto OR NOT gMachine.St.Position.xCleaning THEN
		xStopBeltWhileCleaning:= FALSE;
	END_IF
	
	srStopBeltNoImage.SET1 := gMachine.Al.Warning.xNotLoadedImage AND NOT gMachine.Pt.xControlledByLine;
	srStopBeltNoImage.RESET := NOT gMachine.St.Mode.xAuto OR NOT gMachine.St.Position.xInPrint OR NOT gMachine.Al.Warning.xNotLoadedImage;
	srStopBeltNoImage();
	
	iReasonStopBeltAuto.0 := gMachine.AlSummary.xAlarmStop AND NOT gMachine.St.AutoMode.xBypass;
	iReasonStopBeltAuto.1 := gMachine.Al.Alarm.xAlarmMountedPiece;
	iReasonStopBeltAuto.2 := xStopBeltWhileCleaning;
	iReasonStopBeltAuto.3 := gMachine.AlSummary.xAlarmStop AND gMachine.Pt.xControlledByLine;
	iReasonStopBeltAuto.4 := xStopBeltJamTesting;
	xSignalsStopBeltAuto:= 	iReasonStopBeltAuto > 0;
							
	xAlarmsStopBeltRun:= 	srStopBeltNoImage.Q1 OR gMachine.Al.Alarm.xAlarmNotInPrintPosition;
	
	//Not stop de belt while the user raises the bars
	IF gMachine.commands.xAllToCap THEN
		xUserRaisesBlocks := TRUE;
	END_IF
	IF NOT gMachine.St.AutoMode.xProduction OR EDGEPOS(gMachine.St.Position.xInPrint) THEN
		xUserRaisesBlocks := FALSE;
	END_IF
	
	IF EDGEPOS(gMachine.St.Consent.xUpWithNoConsent) THEN
		xMachineRaisesBlock := TRUE;
	END_IF
	IF NOT gMachine.St.AutoMode.xProduction OR EDGEPOS(gMachine.St.Position.xInPrint) THEN
		xMachineRaisesBlock := FALSE;
	END_IF	
	
	iReasonOrdersRunBeltProduction.0 := gMachine.St.Position.xInPrint;
	iReasonOrdersRunBeltProduction.1 := (xUserRaisesBlocks OR xMachineRaisesBlock) AND NOT gMachine.Pt.xControlledByLine;
	iReasonOrdersRunBeltProduction.2 := gMachine.St.xBeltRunPrevToClean AND (gMachine.St.Position.xGoingToPrint OR gMachine.St.Position.xCleaning);
	xOrdersRunBeltNormal := iReasonOrdersRunBeltProduction > 0 ;
	
	IF EDGEPOS((gPhotoCells.status.xInPosition) AND gMachine.St.AutoMode.xProdORLab) THEN
		iReasonORunBeltPhoto := TRUE;
	ELSIF NOT gMachine.St.Mode.xAuto OR EDGENEG(gMachine.St.AutoMode.xProdORLab) THEN
		iReasonORunBeltPhoto := FALSE;
	END_IF
	
	xRunBeltNormal:= gMachine.St.AutoMode.xProduction AND
					NOT xAlarmsStopBeltRun AND 
					xOrdersRunBeltNormal AND
					(NOT gPhotoCells.parameters.xInstall OR iReasonORunBeltPhoto);
	
	xRunBeltByLine := (gMachine.Pt.xControlledByLine AND gMachine.commands.xRunBelt AND NOT xAlarmsStopBeltRun);
	
	xRunBeltByPass := gMachine.St.AutoMode.xBypass; //Start bypass with run belt order. Stopped by pause when desired
	
	xRunBeltLab:= gMachine.St.AutoMode.xLaboratory AND NOT xAlarmsStopBeltRun;
	
	xRunBeltToBeCleaned := (gMachine.Pt.Clean.xCleanBeltForUv AND gMachine.commands.xRunBelt AND NOT xAlarmsStopBeltRun);
	
	//Consider PAUSE just with the final order. Not in the 3 previous
	g_xRunBeltOrderAuto	:= (xRunBeltNormal OR xRunBeltByPass OR xRunBeltLab OR xRunBeltByLine OR xRunBeltToBeCleaned) AND NOT xSignalsStopBeltAuto AND ((NOT gMachine.St.AutoMode.xPause AND NOT gMachine.Pt.xControlledByLine) OR gMachine.Pt.xControlledByLine);
	
		
	//Writing belt commands
	gBelt.commands.xMute      	:= gMachine.AutoCmd.xMuteAlarms;
	gBelt.commands.xReset     	:= gMachine.AutoCmd.xReset;
	gBelt.commands.Mode			:= gMachine.St.Mode;
	gBelt.commands.AutoMode		:= gMachine.St.AutoMode;
	gBelt.commands.xRunBelt	  	:= g_xRunBeltOrderAuto OR g_xRunBeltOrderManual;
	gBelt.commands.xJogBelt	  	:= gMachine.St.Mode.xAuto AND (gMachine.St.AutoMode.xStop OR (gMachine.St.AutoMode.xJamRecovery AND gMachine.St.Remote.xReadyToJogInJamRecovery)) AND gTransVacuum[1].Status.Blower.xMoving AND gMachine.In.xRemoteJog;
	gBelt.commands.xUseJogAccDecc := gMachine.St.AutoMode.xJamRecovery;
	gBelt.commands.xUseSoftDeceleration := gMachine.Pt.xControlledByLine AND (gMachine.St.Mode.xManual OR (NOT gMachine.Al.Alarm.xAlarmMountedPiece AND NOT gLine.Alarms.xCriticalAlarm)); //[RGP] Applies only for machine controlled by line at the moment
	
	//Safety Alarm Summary
	gBelt.commands.xExternalSafetyStop := gMachine.AlSummary.xAlrSafetySystemGeneral;	
	
	//Printer gives consent to belt here
	gBelt.commands.xConsentBelt:= 	gMachine.St.AutoMode.xLaboratory OR 
									(NOT gMachine.Pt.xControlledByLine AND gMachine.St.Consent.xConsent AND NOT gMachine.St.Consent.xUpWithNoConsent) OR 
									(gMachine.Pt.xControlledByLine AND NOT gLine.Alarms.xCriticalAlarm);
	
END_ACTION

ACTION SafetyControl:
	
	//Safety
	gSafetyController.Commands.xReset := gMachine.AutoCmd.xReset;

END_ACTION

ACTION nSensorControl:
	
	IF gPhotoCells.status.xInstalled THEN
		tonResetCommandIcla.IN := gMachine.AutoCmd.xReset;
		tonResetCommandIcla.PT := T#2S ;
		tonResetCommandIcla();
		
		//Writing 3 Lasers COMMANDS
		gPhotoCells.commands.xResetMotor			:=	tonResetCommandIcla.Q OR EDGENEG(gMachine.AlSummary.xAlarmCritical); //NOZOMITWO-944: Adding non critical alarm condition to reset motor
		gPhotoCells.commands.xErrorRst				:=	gMachine.AutoCmd.xReset;
		gPhotoCells.commands.xMute					:=	gMachine.AutoCmd.xMuteAlarms;
		gPhotoCells.commands.Mode					:=	gMachine.St.Mode;
		gPhotoCells.commands.AutoMode				:=	gMachine.St.AutoMode;
		gPhotoCells.commands.xCancelAlignmentCheck	:= 	gMachine.St.Position.xGoingToPrint OR NOT gMachine.St.Mode.xAuto OR gLine.StatusSummary.xEmptyingBelts OR gMachine.St.CleaningBelt.xCleaningProcessOnGoing;
		gPhotoCells.commands.xCheckMounted			:= 	(gBelt.states.xRuningBelt OR gBelt.commands.xRunBelt) AND
														(NOT gMachine.St.AutoMode.xBypass OR ((*ByPassConditions>>*) gPhotoCells.parameters.xEnableMountedAlrByPass)) AND
														(NOT gMachine.Pt.xControlledByLine OR ((*LineConditions>>*) NOT gMachine.St.CleaningBelt.xCleaningProcessOnGoing ));
		gPhotoCells.commands.xRecordMaxPosition		:= (gBelt.states.xRuningBelt OR gBelt.commands.xRunBelt);
		gPhotoCells.commands.xMountedMediaInside := gThicknessCtrl.status.MediaPosition.xMountedMediaInside;
		
		//Writing photocells parameters
		gPhotoCells.parameters.rMediaThickness	:=	gThicknessCtrl.status.Heigh.rMediaThickness;
		gPhotoCells.parameters.rMarginPrint	:=	gMachine.parSw.rMarginPrint;
		gPhotoCells.parameters.rPrePrintPosition := gBlock[1].parameters.rPrePrintingPos;
		gPhotoCells.parameters.xHomingEnabled := gTransVacuum[1].Status.xAtSpeed OR NOT gTransVacuum[1].Status.xInstalled;

		
	END_IF
	
END_ACTION

ACTION AnalogThicknessControl:
	
	///////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////
	/////////////   DING   DING   DING   DING   DING   DING   DING  ///////////////////
	/////////////   DING   DING   DING   DING   DING   DING   DING  ///////////////////
	///////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////
	
	IF gDing.State.xDingInstalled THEN
		gDing.Commands.xMute		:= gMachine.AutoCmd.xMuteAlarms;
		gDing.Commands.xErrorRst	:= gMachine.AutoCmd.xReset;
		gDing.Commands.Mode			:= gMachine.St.Mode;
		gDing.Commands.AutoMode		:= gMachine.St.AutoMode;
		gDing.Commands.xMountedMediaInside := gThicknessCtrl.status.MediaPosition.xMountedMediaInside;
		
		gDing.In.xAnyCarriageProductDetect := gMachine.St.ProductDetect.xProductDetectL1 OR gMachine.St.ProductDetect.xProductDetectL2;
		gDing.Parameters.rMediaThickness := gMachine.parSw.Media.rThickness;
		gDing.Parameters.rMarginPrint	:=	gMachine.parSw.rMarginPrint;
		gDing.Parameters.rOverThicknessToMounted := gMachine.St.MountedMedia.rOverThicknessToMounted;
		gDing.Parameters.rMarginSafePrint := gMachine.parSw.Safety.rMarginSafePrint;
	END_IF

END_ACTION

ACTION GeneralControl:
	
	//////////Cooling PC Cabinet///////////
	gMachine.Out.xCoolingPCStart := TRUE; //ALX - For the moment is On avery time, its posible control this but its necesary check in machine
	
	
	//Removing the commands
	gMachine.commands.xAllToCap:=FALSE;
	gMachine.commands.xAllToPrint:=FALSE;
	gMachine.commands.xStop:=FALSE;
	
	//Command to abort job for SW
	IF NOT gMachine.St.xRobotReadyToPrint THEN
		gMachine.St.xAbortJobRequest:=FALSE;
		
	ELSIF gMachine.AlSummary.xAnyAlarm THEN
		gMachine.St.xAbortJobRequest:=TRUE;
	END_IF
	
END_ACTION

ACTION AncillariesControl:
	
	///////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////
	/////////////   ANCILLARIES ANCILLARIES ANCILLARIES ANCILLARIES ///////////////////
	/////////////   ANCILLARIES ANCILLARIES ANCILLARIES ANCILLARIES ///////////////////
	///////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////

	gStacker.Orders.xRejectSheet := gThicknessCtrl.Outputs.xReject;

	
END_ACTION

ACTION OrdersToTransVacuum:

	IF NOT gTransVacuum[usiIndex].Status.xInstalled THEN
		RETURN;
	END_IF
	
	//Avoid memory when not in manual
	IF gMachine.St.StateMode <> PRINTERGEN_MANUAL THEN
		gTransVacuum[usiIndex].OrdersSw.xRunManual := FALSE;
	END_IF
	
	//DELOREAN-2585
	//Service has asked to active vacuum at full power when homing photocell's motor.
	//May be disactivated when homing process has finished or via HMI
	IF EDGEPOS(gPhotoCells.status.xReferencing) THEN
		gTransVacuum[1].OrdersSw.xRunManual := TRUE;
		gTransVacuum[1].parSw.rManSetPoint := 100.0;
	END_IF
	IF EDGEPOS(gPhotoCells.status.xReferenced) THEN
		gTransVacuum[1].OrdersSw.xRunManual := FALSE;
	END_IF
	
	//Applying coefficient to vacuum pressure setpoint depending on line state
	IF gMachine.Pt.xControlledByLine THEN
		IF gLine.StatusSummary.xEmptyingBelts THEN
			rCoef := 1.3;
		ELSIF ((gLine.StatusSummary.xPausing AND gThicknessCtrl.status.Belt.xBeltEmpty) OR gLine.StatusSummary.xCleaning) THEN
			rCoef := 0;
		ELSIF gLine.StatusSummary.xPrinting THEN
			rCoef := 1.0;
		END_IF
	
	ELSE
		rCoef := 1.0;
	END_IF
	
	gTransVacuum[1].Parameters.rVacPressureSetPointPerc := LIMIT(gTransVacuum[1].Parameters.rMinVacPressureSetPointPerc, (gTransVacuum[1].parSw.rVacPressureSetPointPerc*rCoef), 100);
	
	//If needed to send parameters to other TransVacuum
	IF NOT gMachine.Pt.Vacuum.xTransVacuumIndependenParams AND usiIndex>1 THEN
		gTransVacuum[usiIndex].OrdersSw.xRunManual					:= gTransVacuum[1].OrdersSw.xRunManual;
		gTransVacuum[usiIndex].parSw.xActiveOutOfProduction 		:= gTransVacuum[1].parSw.xActiveOutOfProduction;
		gTransVacuum[usiIndex].parSw.rManSetPoint					:= gTransVacuum[1].parSw.rManSetPoint;
		gTransVacuum[usiIndex].Parameters.rStartUpDutyCycle			:= gTransVacuum[1].Parameters.rStartUpDutyCycle;
		gTransVacuum[usiIndex].Parameters.rVacPressureSetPointPerc	:= gTransVacuum[1].Parameters.rVacPressureSetPointPerc;		
	END_IF
	
	gTransVacuum[usiIndex].Commands.xMute := gMachine.AutoCmd.xMuteAlarms;
	IF gMachine.AutoCmd.xReset OR xEdgeSafety THEN
		gTransVacuum[usiIndex].Commands.xReset := TRUE;
	END_IF
	gTransVacuum[usiIndex].Commands.xRunJamRecovery := gMachine.St.AutoMode.xJamRecovery;

	IF EDGE(gMachine.St.Position.xGoingToPrint AND gMachine.St.AutoMode.xProdORLab) THEN
		xStartVacuumWhileGoingDown := TRUE;
	END_IF
	IF gBelt.states.xRuningBelt OR gMachine.St.Position.xGoingToCap OR gMachine.St.Position.xInCap THEN
		xStartVacuumWhileGoingDown := FALSE;
	END_IF
	
	xReasonRunVacuumProduction.0 := gBelt.states.xOrderRuning;
	xReasonRunVacuumProduction.1 := gThicknessCtrl.status.MediaPosition.xMediaInside AND gMachine.St.AutoMode.xProdORLab;
	xReasonRunVacuumProduction.2 := gMachine.Pt.Vacuum.xStartBlowerGoingToPrint AND xStartVacuumWhileGoingDown;
	gTransVacuum[usiIndex].Commands.xRunProduction := xReasonRunVacuumProduction > 0 ;

	//Safety Alarm Summary
	gTransVacuum[usiIndex].Parameters.xExternalSafetyStop := gMachine.AlSummary.xAlrSafetySystemGeneral OR gSafetyController.Alarms.xAlrBlowersEnclosureSwitchOff;
	
	gTransVacuum[usiIndex].Parameters.AutoMode := gMachine.St.AutoMode; 
	gTransVacuum[usiIndex].Parameters.Mode := gMachine.St.Mode;
	gTransVacuum[usiIndex].Parameters.xBeltRunning := gBelt.states.xOrderRuning;
	
	//In remote controlled machines, Commands.xRunByLine is used to allow remote blowers running
	IF gMachine.Pt.xControlledRemotely THEN
		iReasonRunBlowerRemote.0 := gMachine.St.AutoMode.xStop AND gMachine.commands.Remote.xStartBlowers;
		iReasonRunBlowerRemote.1 := gMachine.St.AutoMode.xBypass;
		gTransVacuum[usiIndex].Commands.xRunByRemote := gMachine.St.Mode.xAuto AND iReasonRunBlowerRemote>0;
	END_IF
			
END_ACTION

ACTION EdgeHoldDownControl:
	IF gEdgeHoldDown.status.xInstalled THEN
		//Writing commands
		gEdgeHoldDown.commands.xErrorRst			:= tonResetCommandIcla.Q OR EDGENEG(gMachine.AlSummary.xAlarmCritical); //NOZOMITWO-944: Adding non critical alarm condition to reset motor
		gEdgeHoldDown.commands.xErrorRst			:= gMachine.AutoCmd.xReset;
		gEdgeHoldDown.commands.xMute				:= gMachine.AutoCmd.xMuteAlarms;
		gEdgeHoldDown.commands.Mode					:= gMachine.St.Mode;
		gEdgeHoldDown.commands.AutoMode				:= gMachine.St.AutoMode;
	 		
		//Writing parameters
		gEdgeHoldDown.parameters.rBarsHeighSp 		:= gMachine.parSw.Media.rThickness + gMachine.parSw.rMarginPrint;
		gEdgeHoldDown.parameters.rWidthSp 			:= gMachine.parSw.Media.rWidth;
		gEdgeHoldDown.parameters.rBlockPosition		:= gBlock[1].Status.rMotorPosition;		
		
		gPairedMotors[1].commands.xMute				:= gMachine.AutoCmd.xMuteAlarms;
		gPairedMotors[1].commands.Mode				:=	gMachine.St.Mode;
		gPairedMotors[1].commands.xErrorRst			:=	gMachine.AutoCmd.xReset;
		gPairedMotors[1].commands.xResetMotor		:=	tonResetCommandIcla.Q OR EDGENEG(gMachine.AlSummary.xAlarmCritical);
		
		gPairedMotors[2].commands.xMute				:= gMachine.AutoCmd.xMuteAlarms;
		gPairedMotors[2].commands.Mode				:=	gMachine.St.Mode;
		gPairedMotors[2].commands.xErrorRst			:=	gMachine.AutoCmd.xReset;
		gPairedMotors[2].commands.xResetMotor		:=	tonResetCommandIcla.Q OR EDGENEG(gMachine.AlSummary.xAlarmCritical);
		
	END_IF
	
END_ACTION


ACTION OrdersToJamVibration:

	IF NOT gMachine.parSw.xJamDetectEnable THEN
		FOR	usiIndex:=1 TO gMachine.St.iJamDevices DO gJamDetect[usiIndex].Parameters.xJamEnabled := FALSE; END_FOR
		RETURN;
	END_IF			
		
	FOR iIndexBlock := 1  TO gMachine.Pt.CT.iNumBlocks DO
		
		FOR usiIndex:=1 TO gMachine.St.iJamDevices DO
	 
			//JamDevice in proper block
			IF gJamDetect[usiIndex].Parameters.iBlock = iIndexBlock THEN
				
				//Send common data
				gJamDetect[usiIndex].Parameters.xJamEnabled	:= gMachine.parSw.xJamDetectEnable;
				gJamDetect[usiIndex].Commands.xReset 		:= gMachine.AutoCmd.xReset;
				gJamDetect[usiIndex].Commands.xMuteAlarms	:= gMachine.AutoCmd.xMuteAlarms;
				
				//Send order to work
				IF  gMachine.St.Mode.xAuto AND NOT gBlock[iIndexBlock].commands.xStartToCleanOrder THEN
					
					gJamDetect[usiIndex].Commands.xStart := TRUE;
					
				ELSE
					
					gJamDetect[usiIndex].Commands.xStart := FALSE;
					
				END_IF
				
				//Pause order
				gJamDetect[usiIndex].Commands.xPause :=	gBlock[iIndexBlock].Status.PositionState = BLOCKP_CLEANING OR
														gBlock[iIndexBlock].Status.PositionState = BLOCKP_GOING_TO_PRINT OR
														(gBlock[iIndexBlock].Status.PositionState <> BLOCKP_IN_PRINT AND gJamDetect[usiIndex].Commands.xStart) OR
														(gBlock[iIndexBlock].Status.PositionState = BLOCKP_IN_PRINT AND NOT gBelt.commands.xRunBelt AND NOT gBlock[iIndexBlock].commands.xStartToCleanOrder);
					
			END_IF
			
		END_FOR
	END_FOR
	

END_ACTION

ACTION RejectLength:

	//Calculate the distance of the devices between the Printer and the Stacker
	IF NOT gDryerAnc.Parameters.xInstalled AND NOT gOverVarnish.Parameters.xInstalled THEN
		iDistanceMiddleDevices := 0;
	ELSIF gDryerAnc.Parameters.xInstalled AND NOT gOverVarnish.Parameters.xInstalled THEN
		IF gBelt.states.rCurrentSpeed > 70.0 THEN
			iDistanceMiddleDevices := REAL_TO_INT((gDryerAnc.Parameters.Hw.rDryerLength/10) - (2*(gBelt.states.rCurrentSpeed - 70.0)));
		ELSE
			iDistanceMiddleDevices := REAL_TO_INT(gDryerAnc.Parameters.Hw.rDryerLength/10);
		END_IF
	ELSIF NOT gDryerAnc.Parameters.xInstalled AND gOverVarnish.Parameters.xInstalled THEN
		iDistanceMiddleDevices := REAL_TO_INT(gOverVarnish.Parameters.Hw.rOPVLength/10);
	ELSIF gDryerAnc.Parameters.xInstalled AND gOverVarnish.Parameters.xInstalled THEN
		IF gBelt.states.rCurrentSpeed > 70.0 THEN
			iDistanceMiddleDevices := REAL_TO_INT(((gDryerAnc.Parameters.Hw.rDryerLength + gOverVarnish.Parameters.Hw.rOPVLength)/10) - (2*(gBelt.states.rCurrentSpeed - 70.0)));
		ELSE
			iDistanceMiddleDevices := REAL_TO_INT((gDryerAnc.Parameters.Hw.rDryerLength + gOverVarnish.Parameters.Hw.rOPVLength)/10);
		END_IF
	END_IF
	
	//Define RejectDistance with distance between devices and distance in the Reject
	gThicknessCtrl.parameters.Reject.iRejectDistance := iDistanceMiddleDevices + gStacker.Parameters.Hw.iRejectAdjustmentDistance;
	gThicknessCtrl.parameters.Reject.iHoldRejectDistance := iDistanceMiddleDevices + gStacker.Parameters.Hw.iRejectAdjustmentDistance + gStacker.Parameters.Hw.iDistanceToReject;
	
END_ACTION

ACTION RemoteCtrl:

	IF NOT gMachine.Pt.xControlledRemotely THEN
		RETURN;
	END_IF
	
	tonBeltNotStopped.IN := NOT gMachine.St.Remote.xBeltNotStopped;
	tonBeltNotStopped.PT := T#1s;
	tonBeltNotStopped();
	
	// The signal is always TRUE, and when the belt stops, it is reseted during a second
	IF tonBeltNotStopped.Q THEN
		gMachine.St.Remote.xBeltNotStopped := TRUE;
	END_IF
	IF xBeltMovingPreviousToStop AND EDGENEG(gMachine.St.Mode.xAuto) OR EDGEPOS(gMachine.AlSummary.xAlarmStop OR gMachine.AlSummary.xAlarmCritical) THEN
		gMachine.St.Remote.xBeltNotStopped := FALSE;
	END_IF
	
END_ACTION