
ACTION SoundBeacon: 
	// Acoustic advise
	//
	// AutoReseteable Alarms sound management
	arNotLoadedImage	(xAlarm:= gMachine.Al.Warning.xNotLoadedImage OR gMachine.Al.Alarm.xNotLoadedImage, xSilence:=gMachine.AutoCmd.xMuteAlarms);
	arSAIFault			(xAlarm:= gMachine.Al.Warning.xSAIFault, xSilence:=gMachine.AutoCmd.xMuteAlarms);
	arBentTile			(xAlarm:= gMachine.Al.Warning.xBentTile, xSilence:=gMachine.AutoCmd.xMuteAlarms);
	arPDSensorErrorL1	(xAlarm:= gMachine.Al.Alarm.xPDBrokenSensorL1, xSilence:=gMachine.AutoCmd.xMuteAlarms);
	arPDSensorErrorL2	(xAlarm:= gMachine.Al.Alarm.xPDBrokenSensorL2, xSilence:=gMachine.AutoCmd.xMuteAlarms);
	arNoThicknessSystem	(xAlarm:= gMachine.Al.Alarm.xAlrThicknSystemNotSelected, xSilence:=gMachine.AutoCmd.xMuteAlarms);
	arSAIPowerFault		(xAlarm:= gMachine.Al.Alarm.xAlarmSAIPowerFault, xSilence:= gMachine.AutoCmd.xMuteAlarms);
	arHeaterTankPsu		(xAlarm:= gMachine.Al.Alarm.xHeaterTankPsu, xSilence:= gMachine.AutoCmd.xMuteAlarms);
	arAlrMountedPiece	(xAlarm:= gMachine.Al.Alarm.xAlarmMountedPiece, xSilence:= gMachine.AutoCmd.xMuteAlarms);
	arsWrongDingPos		(xAlarm:= gMachine.Al.Alarm.xAlrDingWrongPosition, xSilence:= gMachine.AutoCmd.xMuteAlarms);
	arsSwCriticalCondition(xAlarm:= gMachine.parSw.UI.xCriticalCondition, xSilence:= gMachine.AutoCmd.xMuteAlarms);
	arCommsPcPlc	(xAlarm:= gMachine.Al.Alarm.xAlarmComPcPLC, xSilence:=gMachine.AutoCmd.xMuteAlarms);
	
	
	//Stopped Media inside intermitent beep
	tpStoppedMediaInsd	(IN := gMachine.Al.Warning.xMediaStoppedInside, PT := T#3s);
	BlnkMediaInside		(xEnable := tpStoppedMediaInsd.Q, tTimeOn := T#100ms, tTimeOff := T#100ms);
	
	//Sound/Beep reasons
	//General
	reasonSoundGen.0 := arNotLoadedImage.xAlarmSound;
	reasonSoundGen.1 := arSAIFault.xAlarmSound;
	reasonSoundGen.2 := arBentTile.xAlarmSound;
	reasonSoundGen.3 := arNoThicknessSystem.xAlarmSound;
	reasonSoundGen.4 := arSAIPowerFault.xAlarmSound;
	reasonSoundGen.5 := arPDSensorErrorL1.xAlarmSound;
	reasonSoundGen.6 := arPDSensorErrorL2.xAlarmSound;
	reasonSoundGen.7 := arHeaterTankPsu.xAlarmSound;
	reasonSoundGen.8 := gBelt.AlSummary.xAlarmSound;
	reasonSoundGen.9 := gBlock[1].AlSummary.xAlarmSound;
	reasonSoundGen.10 := gBlock[2].AlSummary.xAlarmSound;
	reasonSoundGen.11 := gPhotoCells.AlSummary.xAlarmSound;
	reasonSoundGen.12 := gChiller[1].AlSummary.xAlarmSound;
	reasonSoundGen.13 := gChiller[2].AlSummary.xAlarmSound;
	reasonSoundGen.14 := gTransVacuum[1].AlSummary.xAlarmSound;
	reasonSoundGen.15 := gTransVacuum[2].AlSummary.xAlarmSound;
	reasonSoundGen.16 := gNonCrash[1].AlSummary.xAlarmSound;
	reasonSoundGen.17 := gNonCrash[2].AlSummary.xAlarmSound;
	reasonSoundGen.18 := gJamDetect[1].AlSummary.xAlarmSound;
	reasonSoundGen.19 := gJamDetect[2].AlSummary.xAlarmSound;
	reasonSoundGen.20 := gDing.AlSummary.xAlarmSound;
	reasonSoundGen.21 := arAlrMountedPiece.xAlarmSound;
	reasonSoundGen.22 := gCuringLed[iIndexWhiteCuringLedBar].AlSummary.xAlarmSound;
	reasonSoundGen.23 := gCuringLed[iIndexColorCuringLedBar].AlSummary.xAlarmSound;
	reasonSoundGen.24 := gPairedMotors[1].AlSummary.xAlarmSound;
	reasonSoundGen.25 := gPairedMotors[2].AlSummary.xAlarmSound;
	reasonSoundGen.26 := BlnkMediaInside.xOutput;
	reasonSoundGen.27 := arsWrongDingPos.xAlarmSound;
	reasonSoundGen.28 := arsSwCriticalCondition.xAlarmSound;
	
	reasonSoundGen2.0 := arCommsPcPlc.xAlarmSound; 
	reasonSoundGen2.1 := gEdgeHoldDown.AlSummary.xAlarmSound;
	
	//Inks related reasons
	reasonSoundInks.0 := gInks[1].AlSummary.xAlarmSound;
	reasonSoundInks.1 := gInks[2].AlSummary.xAlarmSound;
	reasonSoundInks.2 := gInks[3].AlSummary.xAlarmSound;
	reasonSoundInks.3 := gInks[4].AlSummary.xAlarmSound;
	reasonSoundInks.4 := gInks[5].AlSummary.xAlarmSound;
	reasonSoundInks.5 := gInks[6].AlSummary.xAlarmSound;
	reasonSoundInks.6 := gInks[7].AlSummary.xAlarmSound;
	reasonSoundInks.7 := gInks[8].AlSummary.xAlarmSound;
	reasonSoundInks.8 := gInks[9].AlSummary.xAlarmSound;
	reasonSoundInks.9 := gInks[10].AlSummary.xAlarmSound;
	reasonSoundInks.10 := gInks[11].AlSummary.xAlarmSound;
	reasonSoundInks.11 := gInks[12].AlSummary.xAlarmSound;
	
	gMachine.Al.xAlarmSound:= (reasonSoundGen>0) OR (reasonSoundGen2>0) OR (reasonSoundInks>0);

	// Alarm sound output
	IF 	gMachine.AutoCmd.xMuteAlarms OR
		(gMachine.In.Buttons.xZero AND NOT (reasonSoundInks > 0) AND NOT gBlock[1].Al.xAlrSafetySystemInBlock) THEN
		
		gMachine.AlSummary.xAlarmSound:=FALSE;
	ELSE	
		gMachine.AlSummary.xAlarmSound:= gMachine.Al.xAlarmSound;
	END_IF;
	
	SoundAtStart;
	

	//Buzzer management
	IF (iCountStartSound >= BEEP_START_COUNTS) THEN
		IF gBlock[1].Status.Motor.xBarsHoming OR 
			gBlock[2].Status.Motor.xBarsHoming OR 
			gBlock[1].Status.Icla.xHoming OR 
			gBlock[2].Status.Icla.xHoming OR
			gEdgeHoldDown.status.xReferencing OR
			gPhotoCells.status.xReferencing THEN
			
			gMachine.Out.xBuzzerButtonPanel:=  gPLC.xBlk_1s;
			
		ELSIF gBelt.states.State = BELT_PREPARING_START THEN
			gMachine.Out.xBuzzerButtonPanel:=  gPLC.xBlk_500ms;
			
		ELSE
			gMachine.Out.xBuzzerButtonPanel:=  gMachine.AlSummary.xAlarmSound;
		END_IF
		
	ELSE
		gMachine.Out.xBuzzerButtonPanel:=  xStartSound;
	END_IF
	
END_ACTION


ACTION SoundAtStart: 
	
	//Whit 5, we have 3 beeps at the begining
	IF iCountStartSound >= BEEP_START_COUNTS THEN
		RETURN;
	END_IF
	
	tonStartSound.IN := NOT tonStartSound.Q;
	tonStartSound.PT := t#1s;
	tonStartSound();
	
	IF EDGEPOS(tonStartSound.Q) THEN
		iCountStartSound := iCountStartSound + 1;
	END_IF
	
	xStartSound := (iCountStartSound MOD 2) = 0;
	
END_ACTION

