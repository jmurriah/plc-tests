
ACTION OrdersPrinter: 
	
	////////////////////////////////////////////////////////
	// Inputs by comns are auto commands in printer, not all
	//	from kernel: xMute_GI and xReset_GI
	//  from panel: xReset or validate
	////////////////////////////////////////////////////////
	
	gDryer.St.Position.xInCap := gSimpleBlock[1].Status.Position.xInCap;
	gDryer.St.Position.xInPrint := gSimpleBlock[1].Status.Position.xInPrint;
	gDryer.St.Position.xGoingToCap := gSimpleBlock[1].Status.Position.xGoingToCap;
	gDryer.St.Position.xGoingToPrint := gSimpleBlock[1].Status.Position.xGoingToPrint;
	xOrderToCapReceived	:= gSimpleBlock[1].Status.Position.xInCap OR gSimpleBlock[1].Status.Position.xGoingToCap;
	xOrderToPrintReceived := gSimpleBlock[1].Status.Position.xInPrint OR gSimpleBlock[1].Status.Position.xGoingToPrint;


	// With these bool are set enPrinterStatesInAuto
	//
	IF gDryer.St.Position.xInCap		THEN enPrinterStatesInAuto:=PRINTER_CAPPED;         END_IF
	IF gDryer.St.Position.xInPrint		THEN enPrinterStatesInAuto:=PRINTER_PRINTING;       END_IF
	IF gDryer.St.Position.xGoingToCap	THEN enPrinterStatesInAuto:=PRINTER_GOING_TO_CAP;   END_IF
	IF gDryer.St.Position.xGoingToPrint	THEN enPrinterStatesInAuto:=PRINTER_GOING_TO_PRINT; END_IF
	

	/////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////
	//   General auto commads to send block to print or cap from kernel			   //
	/////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////

	// An edge of commandbooledge must go to cap
	iReasonCap.0 := gDryer.commands.xAllToCap AND (NOT gDryer.St.Position.xInCap);
	iReasonCap.1 := EDGEPOS(gDryer.St.AutoMode.xStop);
	iReasonCap.2 := EDGEPOS(gDryer.St.AutoMode.xBypass);
	
	iReasonPrint.0 := EDGEPOS(gDryer.commands.xAllToPrint) AND (NOT gDryer.St.Position.xInPrint) AND gDryer.St.AutoMode.xProdORLab ; // An edge of commandbooledge must go to print, if the machine is not stopped
	iReasonPrint.1 := EDGEPOS (gDryer.St.AutoMode.xProduction); // An edge of auto run must go to print
	iReasonPrint.2 := gDryer.AutoCmd.xStart AND (NOT gDryer.St.Position.xInPrint) AND gDryer.St.AutoMode.xProduction; // Printer is Production, block was send to cap and then pause. It recovery to print when press play or start from gui
	
	IF  iReasonCap > 0 THEN
		
		lastReasonCap := iReasonCap;
		gDryer.AutoCmd.xToCap:= TRUE;
		gDryer.AutoCmd.xToPrint:= FALSE;
		iBlockExecutionsOrder := gSimpleBlock[1].Status.execTimes;
		
		// An edge of commandbooledge must go to print, if the machine is not stopped
	ELSIF iReasonPrint > 0 THEN

		lastReasonPrint := iReasonPrint;
		gDryer.AutoCmd.xToCap:= FALSE;
		gDryer.AutoCmd.xToPrint:= TRUE;
		iBlockExecutionsOrder := gSimpleBlock[1].Status.execTimes;
			
	END_IF	
	
	//Fall down orders when received by the blocks
	IF EDGEPOS(xOrderToCapReceived) THEN
		gDryer.AutoCmd.xToCap := FALSE;
		iBlockDelay := gSimpleBlock[1].Status.execTimes - iBlockExecutionsOrder;
	END_IF
	IF EDGEPOS(xOrderToPrintReceived) THEN
		gDryer.AutoCmd.xToPrint := FALSE;
		iBlockDelay := gSimpleBlock[1].Status.execTimes - iBlockExecutionsOrder;
	END_IF
	
	//When receiving the order to go to print, update the array to avoid going down lower than needed
	IF EDGEPOS(gDryer.AutoCmd.xToPrint) OR EDGEPOS(gDryer.AutoCmd.xToCap) THEN
		gThicknessCtrl.Commands.UpdateAllMatrix:=TRUE;
	END_IF
	
	
	////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////
	/////////////   THICKNESS DETECTION	THICKNESS DETECTION        /////////////////
	/////////////   THICKNESS DETECTION	THICKNESS DETECTION        /////////////////
	////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////
	
	gThicknessCtrl.parameters.Belt.rBeltSpeed 				:= gBelt.states.rCurrentSpeed;
	gThicknessCtrl.parameters.Belt.rMinBeltSpeedToStart		:= gc_rMinSpeedToStart;
	gThicknessCtrl.parameters.ContinuousMedia.MediaData.rThickness := gDryer.Pt.SW.Media.rThickness;
	gThicknessCtrl.parameters.ContinuousMedia.MediaData.rMargin := gDryer.Pt.SW.Media.rMargin;
	gThicknessCtrl.parameters.AutoMode 	:= gDryer.St.AutoMode;
	
	gThicknessCtrl.parameters.Dry.rSubstratePowerReduction := gDryer.Pt.SW.rSubstratePowerReduction;
	
	gThicknessCtrl.Commands.xErrorRst := gDryer.AutoCmd.xReset;

	gBasicDetectMedia.Parameters.rDesiredHeigh := gDryer.Pt.SW.Media.rThickness + gDryer.Pt.SW.Media.rMargin; 
	gBasicDetectMedia.Parameters.xBeltMoving := gBelt.states.xRuningBelt;
	gBasicDetectMedia.Commands.StateMode  := gDryer.St.StateMode;
	gBasicDetectMedia.Commands.AutoMode 	:= gDryer.St.AutoMode;
	gBasicDetectMedia.Commands.xReset		:= gDryer.AutoCmd.xReset;
	gBasicDetectMedia.Commands.xMute		:= gDryer.AutoCmd.xMuteAlarms;
	
	///////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////
	/////////////   BLOCK BLOCK BLOCK BLOCK BLOCK BLOCK BLOCK      ////////////////////
	/////////////   BLOCK BLOCK BLOCK BLOCK BLOCK BLOCK BLOCK      ////////////////////
	///////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////
	xEdgeStop := EDGEPOS(gDryer.In.Buttons.xStop);
	FOR iIndexBlock:=GC_FIRST_BLOCK TO gDryer.Pt.CT.iNumBlocks DO
	
		// It sends blocks to printing state because is required by mode active printer
		gSimpleBlock[iIndexBlock].commands.Mode  		:= gDryer.St.Mode;
		gSimpleBlock[iIndexBlock].commands.StateMode 	:= gDryer.St.StateMode;
		gSimpleBlock[iIndexBlock].commands.AutoMode		:= gDryer.St.AutoMode;
		gSimpleBlock[iIndexBlock].commands.xToCap		:= gDryer.AutoCmd.xToCap;
		//Avoid going arclamp to print if not enabled
		gSimpleBlock[iIndexBlock].commands.xToPrint		:= gDryer.AutoCmd.xToPrint AND gArcLampGew.Status.xEnabledArcLamp;
		gSimpleBlock[iIndexBlock].commands.xReset		:= gDryer.AutoCmd.xReset;
		gSimpleBlock[iIndexBlock].commands.xMute		:= gDryer.AutoCmd.xMuteAlarms;
		IF xEdgeStop THEN 
			gSimpleBlock[iIndexBlock].commands.xBarHomeOrder := FALSE;
		END_IF
		
		gSimpleBlock[iIndexBlock].parameters.Motor.rPrintPosition	:= gThicknessCtrl.status.Heigh.rMaxHeigh[iIndexBlock];
		gSimpleBlock[iIndexBlock].parameters.xLeftHandMachine		:= gDryer.Pt.xLeftHandMachine;
		gSimpleBlock[iIndexBlock].parameters.xRightHandMachine		:= gDryer.Pt.xRightHandMachine;

	END_FOR
	
	
	///////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////
	/////////////   BELT  BELT  BELT  BELT  BELT  BELT  BELT  BELT  ///////////////////
	/////////////   BELT  BELT  BELT  BELT  BELT  BELT  BELT  BELT  ///////////////////
	///////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////
	
	//Writing belt commands
	gBelt.commands.xMute      	:= gDryer.AutoCmd.xMuteAlarms;
	gBelt.commands.xReset     	:= gDryer.AutoCmd.xReset;
	gBelt.commands.Mode 		:= gDryer.St.Mode;
	gBelt.commands.AutoMode		:= gDryer.St.AutoMode;
	gBelt.commands.xRunBelt	  	:= g_xRunBeltOrderAuto OR g_xRunBeltOrderManual;
	
	
	///////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////
	/////////////   TRANSPORT VACUUM   TRANSPORT VACUUM     ///////////////////////////
	/////////////   TRANSPORT VACUUM   TRANSPORT VACUUM     ///////////////////////////
	///////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////
	
	//Conditions to keep blowers running when dryer is not drying
	iReasonKeepBlowersOn.0 := gDryer.Al.Alarm.xAlrJam;
	iReasonKeepBlowersOn.1 := gBasicDetectMedia.Alarms.xMountedMedia;
	iReasonKeepBlowersOn.2 := gThicknessCtrl.status.MediaPosition.xMediaInside;
	iReasonKeepBlowersOn.3 := gThicknessCtrl.Alarms.CheckMedia[1] OR gThicknessCtrl.Alarms.CheckMedia[2];
		
	IF EDGENEG(gDryer.St.DryerState = DRYERMACH_DRYING) AND gDryer.St.DryerState <> DRYERMACH_STOPPING_DRYING AND iReasonKeepBlowersOn > 0 THEN
		xKeepBlowersOn := TRUE;
	ELSIF gDryer.St.DryerState  = DRYERMACH_PREPARING OR (NOT gThicknessCtrl.status.MediaPosition.xMediaInside AND NOT (gThicknessCtrl.Alarms.CheckMedia[1] OR gThicknessCtrl.Alarms.CheckMedia[2]))OR gDryer.In.Sw.xStopBlowers_GI OR gDryer.In.Buttons.xStopBlowers THEN
		xKeepBlowersOn := FALSE;
	END_IF
	gDryer.Out.xKeepSafetyNIR := xKeepBlowersOn;
	
	FOR usiIndex:=1 TO gDryer.Pt.CT.iNumTransVacuum BY 1 DO
		OrdersToTransVacuum;
	END_FOR
	
	
	//////////////////////////////////////////////////////////////
	//	AUTO MODE:	Order g_xRunBeltOrderAuto previous Start
	//////////////////////////////////////////////////////////////	

	IF gDryer.St.Position.xCleaning AND (gDryer.St.xMediaDetected) AND NOT gDryer.St.AutoMode.xBypass THEN
		xStopBeltWhileCleaning:= TRUE;
	ELSIF NOT gDryer.St.Mode.xAuto OR NOT gDryer.St.Position.xCleaning THEN
		xStopBeltWhileCleaning:= FALSE;
	END_IF;
	
	xSignalsStopBeltAuto:= 	(gDryer.AlSummary.xAlarmStop AND NOT gDryer.St.AutoMode.xBypass) OR
							gDryer.Al.Alarm.xAlarmMountedMedia OR
							xStopBeltWhileCleaning;
							
	xAlarmsStopBeltRun:=  gDryer.AlSummary.xAlrSafetySystemGeneral;

	//Not stop de belt while the user raises the bars
	IF gDryer.commands.xAllToCap THEN
		xUserRaisesBlocks := TRUE;
	END_IF
	IF NOT gDryer.St.AutoMode.xProduction OR EDGEPOS(gDryer.St.Position.xInPrint) THEN
		xUserRaisesBlocks := FALSE;
	END_IF
	
	
	xRunBeltNormal:= gDryer.St.AutoMode.xProduction AND NOT xAlarmsStopBeltRun AND xOrdersRunBeltProduction;
	
	xRunBeltByPass := gDryer.St.AutoMode.xBypass; //Start bypass with run belt order. Stopped by pause when desired
	
	xRunBeltLab:= gDryer.St.AutoMode.xLaboratory AND NOT xAlarmsStopBeltRun;
	
	//Consider PAUSE just with the final order. Not in the 3 previous
	g_xRunBeltOrderAuto	:= ( xRunBeltNormal OR xRunBeltByPass OR xRunBeltLab ) AND NOT xSignalsStopBeltAuto AND NOT gDryer.St.AutoMode.xPause;
	
	//Printer gives consent to belt here
	gBelt.commands.xConsentBelt:=gDryer.St.xConsent OR gDryer.St.AutoMode.xLaboratory;
	
	
	///////////////////////////////////////////////////////////////////////////////////
	/////////////   ArcLamp ArcLamp ArcLamp ArcLamp ArcLamp ArcLamp ///////////////////
	/////////////   ArcLamp ArcLamp ArcLamp ArcLamp ArcLamp ArcLamp ///////////////////
	///////////////////////////////////////////////////////////////////////////////////
	
	gArcLampGew.Parameters.xEnableArcLamp := gDryer.Pt.SW.xEnableArcLamp;
	
	gArcLampGew.Parameters.StateMode := gDryer.St.StateMode;
	gArcLampGew.Parameters.AutoMode := gDryer.St.AutoMode;
	gArcLampGew.Parameters.rBeltSpeed := gBelt.states.rCurrentSpeed;
	gArcLampGew.Parameters.xBeltRunning := gBelt.states.xRuningBelt;
	
	gArcLampGew.Commands.xMute := gDryer.AutoCmd.xMuteAlarms;
	gArcLampGew.Commands.xReset := gDryer.AutoCmd.xReset;
	gArcLampGew.Commands.xExternalSafetyStop := gDryer.Al.Alarm.xAlrJam;
	gArcLampGew.Commands.xMediaInside := gThicknessCtrl.status.MediaPosition.xMediaInside;
	
	// THE COMMANDS HAVE BEEN MOVED TO THE MACHINE STATUS ITSELF

	
	///////////////////////////////////////////////////////////////////////////////////
	/////////////   NIR NIR NIR NIR NIR NIR NIR NIR NIR NIR NIR NIR ///////////////////
	/////////////   NIR NIR NIR NIR NIR NIR NIR NIR NIR NIR NIR NIR ///////////////////
	///////////////////////////////////////////////////////////////////////////////////
	
	gNirAdphos.Parameters.xEnableNir := gDryer.Pt.SW.xEnableNir;
	gNirAdphos.Parameters.DDC.xEnableDDC := gDryer.Pt.SW.xEnableDDC AND NOT gDryer.Pt.xLocalDisableDDC;
	
	gNirAdphos.Parameters.StateMode := gDryer.St.StateMode;
	gNirAdphos.Parameters.AutoMode := gDryer.St.AutoMode;
	
	//NOZDRYER-467
	IF gDryer.St.AutoLocation.xRemote AND gDryer.Pt.xEnableDryDocWidth THEN
		IF gDryer.Pt.SW.xDoubleLine THEN
			gNirAdphos.Parameters.MediaWidth := REAL_TO_INT( MIN( 	2* MAX(gDryer.Pt.SW.Media.rWidth + gDryer.Pt.SW.Media.rCrossOffset,
																			gDryer.Pt.SW.Media.rDocWidth + gDryer.Pt.SW.Media.rDocCrossOffset),
																			//gDryer.Pt.SW.Document.rWidth + gDryer.Pt.SW.Document.rOffsetL2), //There is no Line2. Big refactoring if needed
																		1400.0));
		ELSE
			gNirAdphos.Parameters.MediaWidth := REAL_TO_INT( MIN( 	2* MAX(gDryer.Pt.SW.Media.rWidth + gDryer.Pt.SW.Media.rCrossOffset,
																			gDryer.Pt.SW.Media.rDocWidth + gDryer.Pt.SW.Media.rDocCrossOffset),
																		1400.0));
		END_IF
	ELSE
		gNirAdphos.Parameters.MediaWidth := REAL_TO_INT(gDryer.Pt.SW.Media.rWidth);
		
	END_IF
	
	gNirAdphos.Parameters.rBeltSpeed := gBelt.states.rCurrentSpeed;
	gNirAdphos.Parameters.xBeltRunning := gBelt.states.xRuningBelt;
	gNirAdphos.Parameters.xLineEmptyingBelt := DryerSignalsAuto.Parameters.xLineEmptyingBelt AND gDryer.St.AutoLocation.xRemote;
	gNirAdphos.Parameters.iExtraDryingWidh := ABS(REAL_TO_INT(gThicknessCtrl.parameters.Dry.rDryExtend * 2)); // Neeed to multiply by two to consider both sides
	
	gNirAdphos.Commands.xMute := gDryer.AutoCmd.xMuteAlarms;
	gNirAdphos.Commands.xReset := gDryer.AutoCmd.xReset;
	gNirAdphos.Commands.xExternalSafetyStop := gDryer.Al.Alarm.xAlrJam;
	gNirAdphos.Commands.xMediaInside := gThicknessCtrl.status.MediaPosition.xMediaInside;
	
	gNirAdphos.Orders.xCheckJam := gBelt.states.xRuningBelt;
	
	IF gDryer.St.iJamDevices > 0 THEN
		//Jam
		gJamDetect[1].Commands.xReset 		:= gDryer.AutoCmd.xReset;
		gJamDetect[1].Commands.xMuteAlarms	:= gDryer.AutoCmd.xMuteAlarms;
		gJamDetect[1].Commands.xStart 		:= gDryer.St.StateMode <> PRINTERGEN_ZERO;
		gJamDetect[1].Commands.xPause		:= NOT gBelt.states.xRuningBelt;
	END_IF
	
		
	
	///////////////////////////////////////////////////////////////////////////////////
	//////////Cooling PC Cabinet///////////
	gDryer.Out.xCoolingPCStart := TRUE; //ALX - For the moment is On avery time, its posible control this but its necesary check in machine
	
	
	//Removing the commands
	gDryer.commands.xAllToCap:=FALSE;
	gDryer.commands.xAllToPrint:=FALSE;
	
END_ACTION

ACTION OrdersToTransVacuum:

	IF NOT gTransVacuum[usiIndex].Status.xInstalled THEN
		RETURN;
	END_IF
	
	//Avoid memory when not in manual
	IF gDryer.St.StateMode <> PRINTERGEN_MANUAL THEN
		gTransVacuum[usiIndex].OrdersSw.xRunManual := FALSE;
	END_IF
	
	
	//If needed to send parameters to other TransVacuum
	IF NOT gDryer.Pt.xTransVacuumIndependenParams AND usiIndex>1 THEN
		gTransVacuum[usiIndex].OrdersSw.xRunManual					:= gTransVacuum[1].OrdersSw.xRunManual;
		gTransVacuum[usiIndex].parSw.xActiveOutOfProduction 		:= gTransVacuum[1].parSw.xActiveOutOfProduction;
		gTransVacuum[usiIndex].parSw.rManSetPoint				:= gTransVacuum[1].parSw.rManSetPoint;
		gTransVacuum[usiIndex].Parameters.rStartUpDutyCycle			:= gTransVacuum[1].Parameters.rStartUpDutyCycle;
		gTransVacuum[usiIndex].parSw.rVacPressureSetPointPerc	:= gTransVacuum[1].parSw.rVacPressureSetPointPerc;		
	END_IF
	
	gTransVacuum[usiIndex].Commands.xMute := gDryer.AutoCmd.xMuteAlarms;
	gTransVacuum[usiIndex].Commands.xReset := gDryer.AutoCmd.xReset;
	
	gTransVacuum[usiIndex].Parameters.AutoMode := gDryer.St.AutoMode;
	IF NOT xKeepBlowersOn THEN
		gTransVacuum[usiIndex].Parameters.Mode := gDryer.St.Mode;
	END_IF
			
	gTransVacuum[usiIndex].Commands.xRunProduction := (gBelt.states.xOrderRuning OR gThicknessCtrl.status.MediaPosition.xMediaInside OR gDryer.St.DryerState = DRYERMACH_PREPARINGEMPTYBELT) AND NOT xKeepBlowersOn;
	gTransVacuum[usiIndex].Commands.xRunMaxDutyCycle := xKeepBlowersOn;
			
END_ACTION