
ACTION Alarms: 

	
	// Warning Alarm raised when a new BentTile is detected. The signal is kept for 5s
	TP_AlrBentTile.IN:=(gMachine.St.AutoMode.xProdORLab AND EDGEPOS(gThicknessCtrl.status.Heigh.xIncreasedHeigh[1]) AND (NOT xMediaThicknessModified));
	TP_AlrBentTile.PT:= T#5S;
	TP_AlrBentTile();
	gMachine.Al.Warning.xBentTile:=TP_AlrBentTile.Q;
	
	// Copy new thickness value
	IF TP_AlrBentTile.Q OR EDGENEG(gThicknessCtrl.status.Heigh.xIncreasedHeigh[1]) OR EDGEPOS(gMachine.St.AutoMode.xProdORLab)THEN 
		rPrevMediaThickness := gMachine.parSw.Media.rThickness;
	END_IF	

	// Alarm: No bars in Print	
	IF	(NOT gMachine.St.Position.xInPrint AND gMachine.St.AutoMode.xProduction AND
		EDGEPOS(gThicknessCtrl.Outputs.xMediaFiltered) AND (NOT gLine.StatusSummary.xEmptyingBelts)) THEN
		gMachine.Al.Alarm.xAlarmNotInPrintPosition:=TRUE;
	ELSIF gMachine.St.Mode.xZero OR (gMachine.St.Position.xInPrint AND gMachine.St.AutoMode.xProdORLab) THEN // Is it gMachine.St.Position.xInPrint or zero state?
		gMachine.Al.Alarm.xAlarmNotInPrintPosition:=FALSE;
	END_IF
		
											
	//Low bat + Power Fault = Power Off
	IF gMachine.Al.Alarm.xAlarmSAIPowerFault AND (gMachine.In.UPSs[1].xLowBattery OR (gMachine.In.UPSs[2].xLowBattery AND (gMachine.Pt.CT.iNumBlocks>=2))) THEN
		gMachine.Al.Alarm.xAlarmSAIPowerOff:= TRUE;
	END_IF
	
	//24VDC Power Supply for IDS
	IF NOT gMachine.In.x24Vdc THEN gMachine.Al.Alarm.xAlr24Vdc := TRUE; END_IF
	

	//Alarm: Mounted Piece Inide the Machine
	IF (gPhotoCells.Alarms.xMountedTile OR gDing.Alarms.xMountedTile OR gBasicDetectMedia.Alarms.xMountedMedia) THEN
		gMachine.Al.Alarm.xAlarmMountedPiece:= TRUE;
	END_IF

	gMachine.Al.Warning.xMountedMediaInside := gThicknessCtrl.status.MediaPosition.xMountedMediaInside;
	
	//Degasser
	TON_AlrDegasserPressure(IN:=gMachine.Out.xDegasser AND NOT gMachine.In.xDegasserPressure, PT:=T#3S);
	IF TON_AlrDegasserPressure.Q THEN gMachine.Al.Warning.xAlrDegasserPressure:=TRUE; END_IF
	
	
	//Alarm: Broken PD
	IF NOT gThicknessCtrl.parameters.Detection.Array.xLoadMedia THEN CalcPDSensorAlarm; END_IF
	
	//Ding wrong position
	WrongDingPosition;
	
	//Alarm: Sw reports a critical condition to execute printing process
    IF gMachine.parSw.UI.xCriticalCondition THEN
        IF gMachine.Pt.xControlledByLine AND gLine.StatusSummary.xPrinting THEN
            gMachine.Al.Alarm.xSwCriticalCondition := TRUE;
        END_IF
    END_IF

	//Incoherence between sensors array and product detect. DELOREAN-2709
	IF gMachine.St.Position.xInPrint THEN
		IF EDGEPOS(gThicknessCtrl.status.MediaPosition.L1.xDetectionSystemIncoherence) THEN
			gMachine.Al.Warning.xMediaIncoherenceDetectedL1:=TRUE; 
		END_IF
		
		IF gMachine.parSw.Dtp.xDoubleLine AND EDGEPOS(gThicknessCtrl.status.MediaPosition.L2.xDetectionSystemIncoherence) THEN
			gMachine.Al.Warning.xMediaIncoherenceDetectedL2:=TRUE; 
		END_IF
	END_IF

	gMachine.Al.Alarm.xAlrSafetyNotEnabled := NOT gMachine.In.xSafetyEnabled;
	
END_ACTION

ACTION CalcPDSensorAlarm:
	
	//When no sensor is connected, cannot be checked
	IF (gMachine.Pt.PDSignalTpe <> PDCFG_SENSOR AND gMachine.Pt.PDSignalTpe <> PDCFG_SENSOR_AND_CARRIAGE) THEN
		gMachine.Lg.udiPiecesCounterErrorL1 := 0;
		gMachine.Lg.udiPiecesCounterErrorL2 := 0;
		RETURN;
	END_IF

	//Reset counter when belt is stoped or not in printin
	IF NOT gBelt.states.xRuningBelt OR NOT gMachine.St.Position.xInPrint THEN
		gMachine.Lg.udiPiecesCounterErrorL1 := 0;
		gMachine.Lg.udiPiecesCounterErrorL2 := 0;
		RETURN;
	END_IF
	
	//Sensor 1
	xEnabledAlarmPDSensor1 := NOT gMachine.parSw.Dtp.xDoubleLine OR (gMachine.parSw.Dtp.xDoubleLine AND gMachine.parSw.Dtp.iModeLine1 = GC_DTP_RUN AND gMachine.parSw.Dtp.iModeLine2 = GC_DTP_STOP);
	T_AlarmPDL1.IN:= NOT gMachine.Pt.ProductDetect.xDisableBrokenSensor AND xEnabledAlarmPDSensor1 AND NOT gMachine.St.ProductDetect.xProductDetectL1 AND gMachine.St.xMediaDetected;						//If Photocell1 Detect Tile and PD not
	IF gBelt.states.rCurrentSpeed > 0 THEN
		T_AlarmPDL1.PT:= REAL_TO_TIME( 60 * (gMachine.Pt.CT.rDistanceThicknesToPD + 8) / gBelt.states.rCurrentSpeed);		//In a time (depends of belt speed and distance between sensors). Adding 8mm safety
	END_IF
	T_AlarmPDL1();
	IF EDGEPOS(T_AlarmPDL1.Q) THEN gMachine.Lg.udiPiecesCounterErrorL1 := gMachine.Lg.udiPiecesCounterErrorL1 + 1; END_IF	//Increase Error Detect Counter
	
	IF gMachine.Pt.Hw.xDoubleLineAllowed THEN
		//Sensor 2
		xEnabledAlarmPDSensor2 := gMachine.parSw.Dtp.xDoubleLine AND gMachine.parSw.Dtp.iModeLine1 = GC_DTP_STOP AND gMachine.parSw.Dtp.iModeLine2 = GC_DTP_RUN;
		T_AlarmPDL2.IN:= NOT gMachine.Pt.ProductDetect.xDisableBrokenSensor AND xEnabledAlarmPDSensor2 AND NOT xPDSignalSensorL2 AND gMachine.St.xMediaDetected;
		IF gBelt.states.rCurrentSpeed > 0 THEN
			T_AlarmPDL2.PT:= REAL_TO_TIME( 60 * (gMachine.Pt.CT.rDistanceThicknesToPD + 8) / gBelt.states.rCurrentSpeed);		//In a time (depends of belt speed and distance between sensors). Adding 8mm safety
		END_IF
		T_AlarmPDL2();
		IF EDGEPOS(T_AlarmPDL2.Q) THEN gMachine.Lg.udiPiecesCounterErrorL2 := gMachine.Lg.udiPiecesCounterErrorL2 + 1; END_IF
	END_IF
	
//	IF gMachine.Lg.udiPiecesCounterErrorL1 > 10 THEN gMachine.Al.Alarm.xPDBrokenSensorL1:= TRUE; END_IF
//	IF gMachine.Lg.udiPiecesCounterErrorL2 > 10 THEN gMachine.Al.Alarm.xPDBrokenSensorL2:= TRUE; END_IF

END_ACTION

ACTION WrongDingPosition:

	IF NOT gDing.State.xDingInstalled OR NOT gDing.Parameters.xRaiseDigitalIncoherency THEN 
		RETURN;
	END_IF

	//Protect the code of a Zero division
	IF gBelt.states.rCurrentSpeed < 0.1 THEN
		TOF_AlarmDingPosition.IN := FALSE;
		TOF_AlarmDingPosition();
		RETURN;
	END_IF
	
	TOF_AlarmDingPosition.IN := gDing.State.xDingLowPieceDetect;
	IF gBelt.states.rCurrentSpeed > 0 THEN
		TOF_AlarmDingPosition.PT := REAL_TO_TIME( 60 * (gMachine.Pt.CT.rDistanceThicknesToPD + 8) / gBelt.states.rCurrentSpeed);
	END_IF
	TOF_AlarmDingPosition();
		
	xPrintShootingForced := gMachine.Out.xShotLine1 OR gMachine.Out.xShotLine2; 
	IF	NOT TOF_AlarmDingPosition.Q AND NOT xPrintShootingForced AND gBelt.states.xRuningBelt AND 
		gMachine.St.AutoMode.xProdORLab AND EDGEPOS(gMachine.St.ProductDetect.xAnyProductDetectDtpStricted) THEN
		
		gMachine.Al.Alarm.xAlrDingWrongPosition := TRUE; 
	END_IF

END_ACTION

