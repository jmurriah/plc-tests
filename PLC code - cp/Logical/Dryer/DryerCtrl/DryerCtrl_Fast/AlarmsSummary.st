
ACTION AlarmsSummary: 

	gDryer.Al.xAlrDisableGoToProduction := FALSE;
	
	// Safety alarms
	gDryer.AlSummary.xAlrSafetySystemGeneral:= gDryer.Al.xAlrSafetySystemEStop;


	//////////////////
	// General Summary
	//////////////////

	//Stop drying alarms
	iReasonStopDrying.0 := gDryer.Al.Alarm.xAlrBeltOvertorque;
	iReasonStopDrying.1 := gDryer.Al.Alarm.xAlrBeltOverTempFast;
	iReasonStopDrying.2 := gDryer.Al.Alarm.xAlrBeltOverTempSlow;

	gDryer.Al.xAlrStopDrying :=  iReasonStopDrying > 0;
	//Register the reason of the Critical Alarm
	IF gDryer.St.Mode.xAuto AND EDGEPOS(gDryer.Al.xAlrStopDrying) THEN
		gDryer.Al.iReasonStopDrying := iReasonStopDrying;
		LogStopDryingAlarm;
	ELSIF EDGEPOS(gDryer.St.Mode.xAuto AND NOT gDryer.Al.xAlrStopDrying) THEN
		gDryer.Al.iReasonStopDrying := 0;
	END_IF	

	
	//Warnings//
	reasonAnyWarningGen.0 := gDryer.Al.Alarm.xAlarmPlarformInc;
	reasonAnyWarningGen.1 := gDryer.Al.Alarm.xNoActionDangerCollision;
	reasonAnyWarningGen.2 := gDryer.Al.Warning.xBentMedia;
	reasonAnyWarningGen.3 := gDryer.Al.Warning.xMaxMovsBentTile;
	reasonAnyWarningGen.4 := gDryer.Al.Warning.xValidConfiguration;
	reasonAnyWarningGen.5 := gBelt.AlSummary.xAnyWarning;
	reasonAnyWarningGen.6 := gDryer.Al.Warning.xAirBlowerInputSensorError;
	reasonAnyWarningGen.7 := gDryer.Al.Warning.xAirBlowerOutputSensorError;
	reasonAnyWarningGen.8 := gDryer.Al.Warning.xBeltSensorError;
	reasonAnyWarningGen.9 := gDryer.Al.Warning.xBoardInSensorError;
	reasonAnyWarningGen.10 := gDryer.Al.Warning.xBoardOutSensorError;
	reasonAnyWarningGen.11 := gDryer.Al.Warning.xFanBreakersHighLoad;
	reasonAnyWarningGen.12 := gDryer.Al.Warning.xFrontDoorOpened;
	reasonAnyWarningGen.13 := gDryer.Al.Warning.xRearDoorOpened;
	reasonAnyWarningGen.14 := gDryer.Al.Warning.xKeyMantenanceActive;
	reasonAnyWarningGen.15 := gDryer.Al.Warning.xMediaStoppedInside;
	reasonAnyWarningGen.16 := gDryer.Al.Warning.xMountedMediaInside;
	reasonAnyWarningGen.17 := gDryer.Al.Warning.xJamLowCrash;

	gDryer.AlSummary.xAnyWarning:= reasonAnyWarningGen>0;

			
	//Any ALarm//
	gDryer.AlSummary.xAnyAlarm:= gDryer.AlSummary.xAlarmCritical OR gDryer.AlSummary.xAlarmStop;



	//Critial alarms//
	iReasonCritical.0 := gDryer.AlSummary.xAlrSafetySystemGeneral;
	iReasonCritical.1 := gBelt.AlSummary.xAlarmCritical;
	iReasonCritical.2 := gNirAdphos.AlSummary.xAlarmCritical;
	iReasonCritical.3 := gArcLampGew.AlSummary.xAlarmCritical;
	iReasonCritical.4 := gTransVacuum[1].AlSummary.xAlarmCritical;
	
	gDryer.AlSummary.xAlarmCritical:=  iReasonCritical > 0;
	//Register the reason of the Critical Alarm
	IF gDryer.St.Mode.xAuto AND EDGEPOS(gDryer.AlSummary.xAlarmCritical) THEN
		gDryer.AlSummary.iReasonCritical := iReasonCritical;
		LogCriticalAlarm;
	ELSIF EDGEPOS(gDryer.St.Mode.xAuto AND NOT gDryer.AlSummary.xAlarmCritical) THEN
		gDryer.AlSummary.iReasonCritical := 0;
	END_IF
	
	
	//Alarms stop//
	iReasonStopGen.0 := gDryer.Al.Alarm.xMain24Vdc;
	iReasonStopGen.1 := gDryer.Al.Alarm.xAlarmComPcPLC;
	iReasonStopGen.2 := gDryer.Al.Alarm.xAlarmMountedMedia;
	iReasonStopGen.3 := gDryer.Al.Alarm.xAlrBeltOvertorque;
	iReasonStopGen.4 := gDryer.Al.Alarm.xAlrBeltOverTempFast;
	iReasonStopGen.5 := gDryer.Al.Alarm.xAlrBeltOverTempSlow;
	iReasonStopGen.6 := gBelt.AlSummary.xAlarmStop;
	iReasonStopGen.7 := gSimpleBlock[1].AlSummary.xAlarmStop;
	iReasonStopGen.8 := gNirAdphos.AlSummary.xAlarmStop;
	iReasonStopGen.9 := gArcLampGew.AlSummary.xAlarmStop;
	iReasonStopGen.10 := gTransVacuum[1].AlSummary.xAlarmStop;	
	iReasonStopGen.11 := gNirAdphos.Alarms.xAnyJam; //Jam alarms always stop even not enabled
	iReasonStopGen.12 := gArcLampGew.Alarms.xJam; //Jam alarms always stop even not enabled
	iReasonStopGen.13 := gJamDetect[1].AlSummary.xAlarmStop;
	iReasonStopGen.14 := gThicknessCtrl.Alarms.CheckMedia[1] OR gThicknessCtrl.Alarms.CheckMedia[2];
	iReasonStopGen.15 := gDryer.Al.Alarm.xAlrJam;
	iReasonStopGen.16 := NOT gJamDetect[1].Inputs.xJamCrash[1] AND gBelt.states.xRuningBelt;
	iReasonStopGen.17 := NOT gJamDetect[1].Inputs.xJamCrash[2] AND gBelt.states.xRuningBelt;
	iReasonStopGen.18 := NOT gJamDetect[1].Inputs.xJamCrash[3] AND gBelt.states.xRuningBelt;
	iReasonStopGen.19 := NOT gJamDetect[1].Inputs.xJamCrash[4] AND gBelt.states.xRuningBelt;
	
	gDryer.AlSummary.xAlarmStop:= iReasonStopGen > 0;
	//Register the reason of the Alarm
	IF NOT gDryer.St.AutoMode.xStop AND EDGEPOS(gDryer.AlSummary.xAlarmStop) THEN
		gDryer.AlSummary.iReasonStop[0] := iReasonStopGen;
		LogStopAlarm;
	ELSIF EDGEPOS(NOT gDryer.St.AutoMode.xStop AND NOT gDryer.AlSummary.xAlarmStop) THEN
		gDryer.AlSummary.iReasonStop[0] := 0;
	END_IF
	
END_ACTION

