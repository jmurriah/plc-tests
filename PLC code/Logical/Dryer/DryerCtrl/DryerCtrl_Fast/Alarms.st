
ACTION Alarms: 

	// SAFETY
	IF NOT gDryer.In.Safety.xEStopFrontOK THEN gDryer.Al.Alarm.Safety.xEStopFront := TRUE; END_IF
	IF NOT gDryer.In.Safety.xEStopRearOK THEN gDryer.Al.Alarm.Safety.xEStopRear := TRUE; END_IF
	//IF NOT gDryer.In.Safety.xRemoteEStopOK THEN gDryer.Al.Alarm.Safety.xRemoteEStop := TRUE; END_IF  //TODO: Remove when working

	IF NOT gDryer.In.Safety.xMovementsEnabled THEN gDryer.Al.Warning.xNotEnabledMovement := TRUE; END_IF
	
	IF NOT gDryer.In.Safety.xClosedFrontInput OR NOT gDryer.In.Safety.xClosedFrontOutput THEN
		gDryer.Al.Warning.xFrontDoorOpened := TRUE;
	END_IF
	IF NOT gDryer.In.Safety.xClosedRearInput OR NOT gDryer.In.Safety.xClosedRearOutput THEN
		gDryer.Al.Warning.xRearDoorOpened := TRUE;
	END_IF
	
	iReasonSafetyEStop.0 := gDryer.Al.Alarm.Safety.xEStopFront;
	iReasonSafetyEStop.1 := gDryer.Al.Alarm.Safety.xEStopRear;
	iReasonSafetyEStop.2 := gDryer.Al.Alarm.Safety.xRemoteEStop;
	gDryer.Al.xAlrSafetySystemEStop := iReasonSafetyEStop>0;
	
	// Warning Alarm raised when a new BentTile is detected. The signal is kept for 5s
	tpAlrBentMedia.IN:=(gDryer.St.AutoMode.xProdORLab) AND EDGEPOS(gThicknessCtrl.status.Heigh.xIncreasedHeigh[1]);
	tpAlrBentMedia.PT:= T#5S;
	tpAlrBentMedia();
	gDryer.Al.Warning.xBentMedia:=tpAlrBentMedia.Q;		
	
	//Count all the increase of heigh of the blocks as bent media
	IF EDGEPOS (tpAlrBentMedia.IN) THEN
		gDryer.Lg.udiBentTilesCounter:= gDryer.Lg.udiBentTilesCounter+1;
	END_IF	

	
	//24VDC Power Supply for IDS
	IF NOT gDryer.In.xMain24VdcOK THEN gDryer.Al.Alarm.xMain24Vdc := TRUE; END_IF
	IF NOT gDryer.In.xFan24VdcOK THEN gDryer.Al.Alarm.xFan24Vdc := TRUE; END_IF
	IF NOT gDryer.In.xFanBreakersOK THEN gDryer.Al.Alarm.xFanBreakers := TRUE; END_IF
	IF gDryer.In.xFanBreakersWarning THEN gDryer.Al.Warning.xFanBreakersHighLoad := TRUE; END_IF
		
	
	// Alarm: xUpNotConsent
	gDryer.Al.Alarm.xUpNotConsent:= gDryer.St.AutoMode.xProduction AND
									NOT gDryer.St.xConsent;

	
	//Alarm: Mounted Piece Inide the Machine
	gDryer.Al.Alarm.xAlarmMountedMedia := gBasicDetectMedia.Alarms.xMountedMedia;
	gDryer.Al.Warning.xMountedMediaInside := gThicknessCtrl.status.MediaPosition.xMountedMediaInside;
	
	//Jam alarms
	iReasonJam.0 := gJamDetect[1].AlSummary.xAlarmStop;
	iReasonJam.1 := gArcLampGew.Alarms.xJam;
	iReasonJam.2 := gNirAdphos.Alarms.xAnyJam;
	iReasonJam.3 := gJamDetect[1].Alarms.xAlrJamCrash[1];
	iReasonJam.4 := gJamDetect[1].Alarms.xAlrJamCrash[2];
	iReasonJam.5 := gJamDetect[1].Alarms.xAlrJamCrash[3];
	iReasonJam.6 := gJamDetect[1].Alarms.xAlrJamCrash[4];
	//iReasonJam.7 := gThicknessCtrl.Alarms.CheckMedia[1] OR gThicknessCtrl.Alarms.CheckMedia[2];
	IF iReasonJam>0 THEN
		gDryer.Al.Alarm.xAlrJam := TRUE;
	END_IF
	
	IF gDryer.In.xOpenDoorsKey THEN
		gDryer.Al.Warning.xKeyMantenanceActive := TRUE;
	END_IF
		
	//Alarm: Broken PD
	CalcPDSensorAlarm;
	
END_ACTION

ACTION CalcPDSensorAlarm:
	
	//When no sensor is connected, cannot be checked
	IF (gDryer.Pt.PDSignalTpe <> PDCFG_SENSOR AND gDryer.Pt.PDSignalTpe <> PDCFG_SENSOR_AND_CARRIAGE) THEN
		gDryer.Lg.udiPiecesCounterErrorL1 := 0;
		gDryer.Lg.udiPiecesCounterErrorL2 := 0;
		RETURN;
	END_IF

	//Reset counter when belt is stoped or not in printin
	IF NOT gBelt.states.xRuningBelt OR NOT gDryer.St.Position.xInPrint THEN
		gDryer.Lg.udiPiecesCounterErrorL1 := 0;
		gDryer.Lg.udiPiecesCounterErrorL2 := 0;
		RETURN;
	END_IF
	
//	//Sensor 1
//	xEnabledAlarmPDSensor1 := NOT gDryer.Pt.SW.Dtp.xDoubleLine OR (gDryer.Pt.SW.Dtp.xDoubleLine AND gDryer.Pt.SW.Dtp.iModeLine1 = GC_DTP_RUN AND gDryer.Pt.SW.Dtp.iModeLine2 = GC_DTP_STOP);
//	T_AlarmPDL1.IN:= xEnabledAlarmPDSensor1 AND NOT gDryer.In.ProductDetect.xPDSignalSensorL1 AND gDryer.St.xMediaDetected;						//If Photocell1 Detect Tile and PD not
//	T_AlarmPDL1.PT:= REAL_TO_TIME( 60 * (gDryer.Pt.CT.rDistanceThicknesToPD + 8) / gBelt.states.rCurrentSpeed);		//In a time (depends of belt speed and distance between sensors). Adding 8mm safety
//	T_AlarmPDL1();
//	IF EDGEPOS(T_AlarmPDL1.Q) THEN gDryer.Lg.udiPiecesCounterErrorL1 := gDryer.Lg.udiPiecesCounterErrorL1 + 1; END_IF	//Increase Error Detect Counter
//	
//	//Sensor 2
//	xEnabledAlarmPDSensor2 := gDryer.Pt.SW.Dtp.xDoubleLine AND gDryer.Pt.SW.Dtp.iModeLine1 = GC_DTP_STOP AND gDryer.Pt.SW.Dtp.iModeLine2 = GC_DTP_RUN;
//	T_AlarmPDL2.IN:= xEnabledAlarmPDSensor2 AND NOT gDryer.In.ProductDetect.xPDSignalSensorL2 AND gDryer.St.xMediaDetected;
//	T_AlarmPDL2.PT:= REAL_TO_TIME( 60 * (gDryer.Pt.CT.rDistanceThicknesToPD + 8) / gBelt.states.rCurrentSpeed);		//In a time (depends of belt speed and distance between sensors). Adding 8mm safety
//	T_AlarmPDL2();
//	IF EDGEPOS(T_AlarmPDL2.Q) THEN gDryer.Lg.udiPiecesCounterErrorL2 := gDryer.Lg.udiPiecesCounterErrorL2 + 1; END_IF
	
	IF gDryer.Lg.udiPiecesCounterErrorL1 > 10 THEN gDryer.Al.Alarm.xPDBrokenSensorL1:= TRUE; END_IF
	IF gDryer.Lg.udiPiecesCounterErrorL2 > 10 THEN gDryer.Al.Alarm.xPDBrokenSensorL2:= TRUE; END_IF

END_ACTION

