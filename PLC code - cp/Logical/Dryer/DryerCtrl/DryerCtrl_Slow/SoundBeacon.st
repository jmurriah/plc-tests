
ACTION SoundBeacon: 
	// Acoustic advise
	//
	// AutoReseteable Alarms sound management
	arFanBreakers		(xAlarm:= gDryer.Al.Alarm.xFanBreakers, xSilence:=gDryer.AutoCmd.xMuteAlarms);
	arFan24Vdc			(xAlarm:= gDryer.Al.Alarm.xFan24Vdc, xSilence:=gDryer.AutoCmd.xMuteAlarms);
	arMain24Vdc			(xAlarm:= gDryer.Al.Alarm.xMain24Vdc, xSilence:=gDryer.AutoCmd.xMuteAlarms);
	arBentMedia			(xAlarm:= gDryer.Al.Warning.xBentMedia, xSilence:=gDryer.AutoCmd.xMuteAlarms);
	arPDSensorErrorL1	(xAlarm:= gDryer.Al.Alarm.xPDBrokenSensorL1, xSilence:=gDryer.AutoCmd.xMuteAlarms);
	arPDSensorErrorL2	(xAlarm:= gDryer.Al.Alarm.xPDBrokenSensorL2, xSilence:=gDryer.AutoCmd.xMuteAlarms);
	arWrongPhysConf		(xAlarm:= gDryer.Al.Alarm.xAlrWrongPhysConf, xSilence:=gDryer.AutoCmd.xMuteAlarms);
	arAnyJam			(xAlarm:= gDryer.Al.Alarm.xAlrJam, xSilence:=gDryer.AutoCmd.xMuteAlarms);

	//arAnyStopAlarmMuted	(xAlarm:= gDryer.AlSummary.xAnyAlarm AND gDryer.St.StateMode<>PRINTERGEN_ZERO, xSilence:= gDryer.AutoCmd.xMuteAlarms);

	reasonSoundGen.1 := arFanBreakers.xAlarmSound;
	reasonSoundGen.2 := arFan24Vdc.xAlarmSound;
	reasonSoundGen.3 := arMain24Vdc.xAlarmSound;
	reasonSoundGen.4 := arBentMedia.xAlarmSound;
	reasonSoundGen.5 := arAnyStopAlarmMuted.xAlarmSound;
	reasonSoundGen.6 := arPDSensorErrorL1.xAlarmSound;
	reasonSoundGen.7 := arPDSensorErrorL2.xAlarmSound;
	reasonSoundGen.8 := arWrongPhysConf.xAlarmSound;
	reasonSoundGen.9 := arAnyJam.xAlarmSound;
	reasonSoundGen.25 := gBasicDetectMedia.AlSummary.xAlarmSound;
	reasonSoundGen.26 := gBelt.AlSummary.xAlarmSound;
	reasonSoundGen.27 := gSimpleBlock[1].AlSummary.xAlarmSound;
	reasonSoundGen.28 := gTransVacuum[1].AlSummary.xAlarmSound;
	reasonSoundGen.29 := gNirAdphos.AlSummary.xAlarmSound;
	reasonSoundGen.30 := gArcLampGew.AlSummary.xAlarmSound;
	reasonSoundGen.31 := gThicknessCtrl.Alarms.CheckMedia[1] OR gThicknessCtrl.Alarms.CheckMedia[2];

	gDryer.Al.xAlarmSound:= reasonSoundGen > 0;

	// Alarm sound output
	IF 	gDryer.AutoCmd.xMuteAlarms OR gDryer.In.Buttons.xZero THEN
		gDryer.AlSummary.xAlarmSound:=FALSE;
	ELSE	
		gDryer.AlSummary.xAlarmSound:= gDryer.Al.xAlarmSound;
	END_IF;
	
	SoundAtStart;
	
	reasonBuzzer.0 := gDryer.AlSummary.xAlarmSound AND (iCountStartSound >= BEEP_START_COUNTS);
	reasonBuzzer.1 := gBelt.states.State = BELT_PREPARING_START  AND gPLC.xBlk_500ms;
	reasonBuzzer.2 := xStartSound;
	
	gDryer.Out.xBuzzer :=  reasonBuzzer > 0;
	
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
