
ACTION AlarmsSummary: 

	gMachine.Al.xAlrDisableGoToProduction := FALSE;
	
	IF gMachine.Pt.CT.iNumBlocks = 1 THEN
		gMachine.Al.xAlrSafetySystemEStop:=	gBlock[1].Al.xAlrEmergencyStop;
	ELSIF gMachine.Pt.CT.iNumBlocks = 2 THEN
		gMachine.Al.xAlrSafetySystemEStop:= gBlock[1].Al.xAlrEmergencyStop OR gBlock[2].Al.xAlrEmergencyStop; 
	END_IF
	
	iReasonSafetySystemGeneral.0 := gMachine.Al.xAlrSafetySystemEStop;
	iReasonSafetySystemGeneral.1 := gBlock[1].AlSummary.xAlrSafetySystemGeneral AND gBlock[1].parSw.xEnableToMovements;
	iReasonSafetySystemGeneral.2 := gBlock[2].AlSummary.xAlrSafetySystemGeneral AND gBlock[2].parSw.xEnableToMovements;
	iReasonSafetySystemGeneral.3 := gMachine.Al.Alarm.xAlrSafetyNotEnabled;
	gMachine.AlSummary.xAlrSafetySystemGeneral:= iReasonSafetySystemGeneral > 0;
	
	iReasonSafetyCutAir.0 := gBlock[1].AlSummary.xAlrSafetyCutAir AND gBlock[1].parSw.xEnableToMovements;
	iReasonSafetyCutAir.1 := gBlock[2].AlSummary.xAlrSafetyCutAir AND gBlock[2].parSw.xEnableToMovements;
	gMachine.AlSummary.xAlrSafetyCutAir:= iReasonSafetyCutAir > 0;



	//////////////////
	// General Summary
	//////////////////


	//Silvia: any general warning+any block warning+any inks warning+any photocell warning.
	//Warnings//
	reasonAnyWarningGen.0 := gMachine.Al.Warning.xNotLoadedImage;
	reasonAnyWarningGen.1 := gMachine.Al.Alarm.xAlarmPlarformInc;
	reasonAnyWarningGen.2 := gMachine.Al.Alarm.xNoActionDangerCollision;
	reasonAnyWarningGen.3 := gMachine.Al.Warning.xBentTile;
	reasonAnyWarningGen.4 := gMachine.Al.Warning.xMaxMovsBentTile;
	reasonAnyWarningGen.5 := gMachine.Al.Alarm.xAlarmNotInPrintPosition;
	reasonAnyWarningGen.6 := gMachine.Al.Warning.xExternalCleanActive;
	reasonAnyWarningGen.7 := gMachine.Al.Warning.xSAIFault;
	reasonAnyWarningGen.8 := gMachine.Al.Warning.xSAIBypass;
	reasonAnyWarningGen.9 := gMachine.Al.Warning.xSAILowBat;
	reasonAnyWarningGen.10 := gMachine.Al.Warning.xValidConfiguration;
	reasonAnyWarningGen.11 := gBelt.AlSummary.xAnyWarning;
	reasonAnyWarningGen.12 := gBlock[1].AlSummary.xAnyWarning;
	reasonAnyWarningGen.13 := gBlock[2].AlSummary.xAnyWarning;
	reasonAnyWarningGen.14 := gPhotoCells.AlSummary.xAnyWarning;
	reasonAnyWarningGen.15 := gMachine.Al.Warning.xPCCabineSensAlrm;
	reasonAnyWarningGen.16 := gCuringLed[iIndexWhiteCuringLedBar].AlSummary.xAnyWarning;
	reasonAnyWarningGen.17 := gCuringLed[iIndexColorCuringLedBar].AlSummary.xAnyWarning;
	reasonAnyWarningGen.18 := gTransVacuum[1].AlSummary.xAnyWarning;
	reasonAnyWarningGen.19 := gTransVacuum[2].AlSummary.xAnyWarning;
	reasonAnyWarningGen.20 := gMachine.parSw.UI.xWarningCondition;
	reasonAnyWarningGen.21 := gMachine.Al.Warning.xNoCleaningModeEnabled;
	reasonAnyWarningGen.22 := gMachine.Al.Warning.xMediaIncoherenceDetectedL1;
	reasonAnyWarningGen.23 := gMachine.Al.Warning.xMediaIncoherenceDetectedL2;
	reasonAnyWarningGen.24 := gMachine.Al.Warning.xAlrHoopersSoftStarterFault;
	reasonAnyWarningGen.25 := gMachine.Al.Warning.xOvervoltage;
	reasonAnyWarningGen.25 := gBeltClean.AlSummary.xAnyAlarm;
	reasonAnyWarningGen.26 := gMachine.Al.Warning.xIonAntiStatic;
	reasonAnyWarningGen.27 := gMachine.Al.Warning.xErrorAntiStatic;
	reasonAnyWarningGen.28 := gMachine.Al.Warning.xWasteInkTankMaxLevelReached;
	
	
	reasonAnyWarningInks.0 := gInks[1].AlSummary.xAnyWarning;
	reasonAnyWarningInks.1 := gInks[2].AlSummary.xAnyWarning;
	reasonAnyWarningInks.2 := gInks[3].AlSummary.xAnyWarning;
	reasonAnyWarningInks.3 := gInks[4].AlSummary.xAnyWarning;
	reasonAnyWarningInks.4 := gInks[5].AlSummary.xAnyWarning;
	reasonAnyWarningInks.5 := gInks[6].AlSummary.xAnyWarning;
	reasonAnyWarningInks.6 := gInks[7].AlSummary.xAnyWarning;
	reasonAnyWarningInks.7 := gInks[8].AlSummary.xAnyWarning;
	reasonAnyWarningInks.8 := gInks[9].AlSummary.xAnyWarning;
	reasonAnyWarningInks.9 := gInks[10].AlSummary.xAnyWarning;
	reasonAnyWarningInks.10 := gInks[11].AlSummary.xAnyWarning;
	reasonAnyWarningInks.11 := gInks[12].AlSummary.xAnyWarning;
	
	gMachine.AlSummary.xAnyWarning:= reasonAnyWarningGen>0 OR reasonAnyWarningInks>0;

			
	//Any ALarm//
	gMachine.AlSummary.xAnyAlarm:= 	gMachine.AlSummary.xAlarmCritical OR
									gMachine.AlSummary.xAlarmStop;



	//Critial alarms//
	iReasonCritical.0 := gMachine.AlSummary.xAlrSafetySystemGeneral;
	iReasonCritical.1 := gMachine.Al.Alarm.xAlarmSAIPowerOff;
	iReasonCritical.2 := gBelt.AlSummary.xAlarmCritical;
	iReasonCritical.3 := gBlock[1].AlSummary.xAlarmCritical;
	iReasonCritical.4 := gBlock[2].AlSummary.xAlarmCritical;
	iReasonCritical.5 := gMachine.Al.Alarm.xAlrWrongPhysConf;
	iReasonCritical.6 := gMachine.Al.Alarm.xNoPowered;
	
	gMachine.AlSummary.CurrentReasonCritical := iReasonCritical;
	
	gMachine.AlSummary.xAlarmCritical:=  iReasonCritical > 0;
	//Register the reason of the Critical Alarm
	IF gMachine.St.Mode.xAuto AND EDGEPOS(gMachine.AlSummary.xAlarmCritical) THEN
		gMachine.AlSummary.iReasonCritical := iReasonCritical;
		LogCriticalAlarm;
	ELSIF EDGEPOS(gMachine.St.Mode.xAuto AND NOT gMachine.AlSummary.xAlarmCritical) THEN
		gMachine.AlSummary.iReasonCritical := 0;
	END_IF
	
	//Alarms stop//
	//Inks
	iReasonStopInks.0 := gInks[1].AlSummary.xAlarmStop;
	iReasonStopInks.1 := gInks[2].AlSummary.xAlarmStop;
	iReasonStopInks.2 := gInks[3].AlSummary.xAlarmStop;
	iReasonStopInks.3 := gInks[4].AlSummary.xAlarmStop;
	iReasonStopInks.4 := gInks[5].AlSummary.xAlarmStop;
	iReasonStopInks.5 := gInks[6].AlSummary.xAlarmStop;
	iReasonStopInks.6 := gInks[7].AlSummary.xAlarmStop;
	iReasonStopInks.7 := gInks[8].AlSummary.xAlarmStop;
	iReasonStopInks.8 := gInks[9].AlSummary.xAlarmStop;
	iReasonStopInks.9 := gInks[10].AlSummary.xAlarmStop;
	iReasonStopInks.10 := gInks[11].AlSummary.xAlarmStop;
	iReasonStopInks.11 := gInks[12].AlSummary.xAlarmStop;
	
	//General 1
	iReasonStopGen.0 := gMachine.Al.Alarm.xAlarmAir1;
	iReasonStopGen.1 := gMachine.Al.Alarm.xAlarmComPcPLC;
	iReasonStopGen.2 := gMachine.Al.Alarm.xAlarmEnableWithoutBarsOn;
	iReasonStopGen.3 := gMachine.Al.Alarm.xAlarmMountedPiece;
	iReasonStopGen.4 := gMachine.Al.Alarm.xAlarmSAIPowerFault;
	iReasonStopGen.5 := gMachine.Al.xAlrSafetySystemEStop;
	iReasonStopGen.6 := gMachine.Al.Alarm.xAlrThicknSystemNotSelected;
	iReasonStopGen.7 := gBlock[1].AlSummary.xAlarmStop;
	iReasonStopGen.8 := gBlock[2].AlSummary.xAlarmStop;
	iReasonStopGen.9 := gBelt.AlSummary.xAlarmStop;
	iReasonStopGen.10 := gDing.AlSummary.xAlarmStop;
	iReasonStopGen.11 := gPhotoCells.AlSummary.xAlarmStop;
	iReasonStopGen.12 := gTransVacuum[1].AlSummary.xAlarmStop;
	iReasonStopGen.13 := gTransVacuum[2].AlSummary.xAlarmStop;
	iReasonStopGen.14 := gMachine.Al.Alarm.xPDBrokenSensorL1;
	iReasonStopGen.15 := gMachine.Al.Alarm.xPDBrokenSensorL2;
	iReasonStopGen.16 := gJamDetect[1].AlSummary.xAlarmStop;
	iReasonStopGen.17 := gJamDetect[2].AlSummary.xAlarmStop;
	iReasonStopGen.18 := gNonCrash[1].AlSummary.xAlarmStop;
	iReasonStopGen.19 := gNonCrash[2].AlSummary.xAlarmStop;
	iReasonStopGen.20 := gMachine.Al.Alarm.xAlr24Vdc;
	//When printer is controlled by line, we consider curing led lamps errors in LineCtrl to execute a ControlledStop, but when printer is running by its own, must stop inmediately
	iReasonStopGen.21 := (gCuringLed[iIndexWhiteCuringLedBar].AlSummary.xAlarmStop OR gCuringLed[iIndexWhiteCuringLedBar].AlSummary.xAlarmCritical) AND NOT gMachine.Pt.xControlledByLine;
	iReasonStopGen.22 := (gCuringLed[iIndexColorCuringLedBar].AlSummary.xAlarmStop OR gCuringLed[iIndexColorCuringLedBar].AlSummary.xAlarmCritical) AND NOT gMachine.Pt.xControlledByLine;
	iReasonStopGen.23 := gMachine.Al.Alarm.xAlrDingWrongPosition;
	iReasonStopGen.24 := gMachine.Al.Alarm.xSwCriticalCondition;
	iReasonStopGen.25 := gJamDetect[3].AlSummary.xAlarmStop;
	iReasonStopGen.26 := gMachine.Al.Alarm.xNotLoadedImage;
	iReasonStopGen.27 := gThicknessCtrl.AlSummary.xAlarmStop;
	iReasonStopGen.28 := gMachine.Al.Alarm.xAlrThickOutLimits;
	iReasonStopGen.29 := gMachine.Al.Alarm.xAlrLengthOutLimits;
	iReasonStopGen.30 := gMachine.Al.Alarm.xAlrWidthOutLimits;
	
	gMachine.AlSummary.CurrentReasonStop[0] := iReasonStopInks;
	gMachine.AlSummary.CurrentReasonStop[1] := iReasonStopGen;
	
	gMachine.AlSummary.xAlarmStop:= iReasonStopGen > 0 OR iReasonStopInks > 0;
	//Register the reason of the Alarm
	IF NOT gMachine.St.AutoMode.xStop AND EDGEPOS(gMachine.AlSummary.xAlarmStop) THEN
		gMachine.AlSummary.iReasonStop[0] := iReasonStopInks;
		gMachine.AlSummary.iReasonStop[1] := iReasonStopGen;
		LogStopAlarm;
	ELSIF EDGEPOS(NOT gMachine.St.AutoMode.xStop AND NOT gMachine.AlSummary.xAlarmStop) THEN
		gMachine.AlSummary.iReasonStop[0] := 0;
		gMachine.AlSummary.iReasonStop[1] := 0;
	END_IF

END_ACTION

