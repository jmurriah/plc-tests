
ACTION LightTower:
	
	IF Line.Status<>LINE_NOT_INITIALIZED THEN
		// White: Line in automatic mode
		Line.Outputs.xWhiteLight:= gMachine.St.Mode.xAuto;
		
		// Blue: Any alarm may be reset
		Line.Outputs.xBlueLight := Line.Alarms.xResetCondition;
		
		// Green: 
		//Light tower's green light is managed by safety controller physical output
		//Management done below is not related to light tower so green light button on HMI panel. 
		IF (Line.Status=LINE_IDLE AND gMachine.parSw.UI.xStartPrintButtonActive AND xNoAlarmsActive) OR (gMachine.St.xRobotReadyToPrint AND Line.Status=LINE_PAUSED) THEN
			Line.Outputs.xGreenLight := gPLC.xBlk_500ms;	
		ELSIF Belt.states.xRuningBelt THEN
			Line.Outputs.xGreenLight := TRUE;
		ELSE
			Line.Outputs.xGreenLight := FALSE;
		END_IF
									
		// Red: Safety related alarm
		Line.Outputs.xRedLight := SafetyController.Alarms.xCriticalAlarm;
		
		// Yellow Blinking: warning
		IF (Line.Alarms.xCriticalAlarm OR Line.Alarms.xStopAlarm) THEN
			Line.Outputs.xYellowLight := gPLC.xBlk_1s;
		// Yellow Solid: warning
		ELSIF Line.Alarms.xWarningAlarm THEN
			Line.Outputs.xYellowLight := TRUE;
		ELSE
			Line.Outputs.xYellowLight := FALSE;
		END_IF
		
		iIndexLights := 1;
		iIndexLightsAux := iNumberOfLights;
		
	ELSE
		InitializingLights;
		
	END_IF
	
		
END_ACTION

ACTION SoundLightTower:
	// Acoustic advise
	//
	// AutoReseteable Alarms sound management
	//arCriticalMachine (xAlarm:= gMachine.AlSummary.xAlarmCritical, xSilence:=gMachine.AutoCmd.xMuteAlarms);
	arCriticalDryer (xAlarm:= Dryer.Alarms.xCriticalAlarm, xSilence:=gMachine.AutoCmd.xMuteAlarms);
	arCriticalStacker (xAlarm:= Stacker.Alarms.xCriticalAlarm, xSilence:=gMachine.AutoCmd.xMuteAlarms);
	arCriticalSafetyFeeder (xAlarm:= SafetyController.Alarms.xAlrFeeder, xSilence:=gMachine.AutoCmd.xMuteAlarms);
	arCriticalSafetyPrimer (xAlarm:= SafetyController.Alarms.xAlrPrimer, xSilence:=gMachine.AutoCmd.xMuteAlarms);
	arCriticalSafetyDryer (xAlarm:= SafetyController.Alarms.xAlrDryer, xSilence:=gMachine.AutoCmd.xMuteAlarms);
	arCriticalSafetyOverVarnish (xAlarm:= SafetyController.Alarms.xAlrOverVarnish, xSilence:=gMachine.AutoCmd.xMuteAlarms);
	arCriticalSafetyStacker (xAlarm:= SafetyController.Alarms.xAlrStacker, xSilence:=gMachine.AutoCmd.xMuteAlarms);
	arCriticalSafetyDoorLock (xAlarm:= SafetyController.Alarms.xAlrPrinterDoorLock, xSilence:=gMachine.AutoCmd.xMuteAlarms);
	arCriticalSafetyLightCurtain (xAlarm:= (SafetyController.Alarms.xAlrPrinterLightCurtain AND NOT gMachine.St.Mode.xZero), xSilence:=gMachine.AutoCmd.xMuteAlarms);
	arCriticalMachineNoPowered (xAlarm:= Line.Alarms.xAlrPrinterNoPowered, xSilence:=gMachine.AutoCmd.xMuteAlarms);
	arCriticalOvervoltage (xAlarm:= Line.Alarms.xAlrOvervoltage, xSilence:=gMachine.AutoCmd.xMuteAlarms);
	arCritical24vdcStartSeqNoPowered (xAlarm:= Line.Alarms.xAlr24VdcStartSeqNoPowered, xSilence:=gMachine.AutoCmd.xMuteAlarms);
	//arCriticalStopButton (xAlarm:= gMachine.In.Buttons.xStop, xSilence:=gMachine.AutoCmd.xMuteAlarms); //To not sound due to issue: NOZOMITWO-1027
	arCriticalSafetySarm (xAlarm:= SafetyController.Alarms.xAlrSarm, xSilence:=gMachine.AutoCmd.xMuteAlarms);

	arStop	(xAlarm:= Line.Alarms.xStopAlarm, xSilence:=gMachine.AutoCmd.xMuteAlarms);
	
	tp_RejectSound.IN:=ThickCtrl.Outputs.xReject;
	tp_RejectSound.PT:=T#1S;
	tp_RejectSound();
	
	iReasonSound.0 := arCriticalMachine.xAlarmSound;
	iReasonSound.1 := arCriticalDryer.xAlarmSound;
	iReasonSound.2 := arCriticalStacker.xAlarmSound;
	iReasonSound.3 := arCriticalSafetyFeeder.xAlarmSound;
	iReasonSound.4 := arCriticalSafetyPrimer.xAlarmSound;
	iReasonSound.5 := arCriticalSafetyDryer.xAlarmSound;
	iReasonSound.6 := arCriticalSafetyStacker.xAlarmSound;
	iReasonSound.7 := arCriticalSafetyDoorLock.xAlarmSound;
	iReasonSound.8 := arCriticalSafetyLightCurtain.xAlarmSound;
	iReasonSound.9 := arCriticalMachineNoPowered.xAlarmSound;	
	iReasonSound.10 := arCriticalOvervoltage.xAlarmSound;
	iReasonSound.11 := arCritical24vdcStartSeqNoPowered.xAlarmSound;
	iReasonSound.12 := arStop.xAlarmSound;
	iReasonSound.13 := tp_RejectSound.Q;
	iReasonSound.14 := arCriticalSafetySarm.xAlarmSound;
		
	// Alarm sound output
	Line.Alarms.xAlarmSound := iReasonSound > 0;
	Line.Outputs.xSound :=  iReasonSound > 0;
		

END_ACTION

ACTION InitializingLights:
		IF iIndexLights<iNumberOfLights THEN
			IF iIndexLightsAux>=iIndexLights THEN
				IF EDGEPOS(gPLC.xBlk_200ms) THEN
					FOR iLights:=iIndexLights+1 TO iNumberOfLights DO
						gArrayLights[iLights]:= FALSE;
					END_FOR
					gArrayLights[iIndexLightsAux]:= TRUE;
					iIndexLightsAux := MAX(0, iIndexLightsAux - 1);
				END_IF
			ELSE
				iIndexLights := iIndexLights + 1;
				iIndexLightsAux := iNumberOfLights;
			END_IF
			
		ELSIF iRepeatTimes<=5 THEN
			IF EDGEPOS(gPLC.xBlk_500ms) THEN
				iRepeatTimes:=iRepeatTimes+1;
				FOR iLights:=1 TO iNumberOfLights DO
					gArrayLights[iLights]:= FALSE;
				END_FOR
				
			ELSIF EDGENEG(gPLC.xBlk_500ms) THEN
				FOR iLights:=1 TO iNumberOfLights DO
					gArrayLights[iLights]:= TRUE;
				END_FOR				
			END_IF
			
		ELSE
			iIndexLights := 1;
			iRepeatTimes := 1;
		END_IF
		
		//Assigning to each color
		Line.Outputs.xWhiteLight 	:= gArrayLights[1];
		Line.Outputs.xBlueLight 	:= gArrayLights[2];
		Line.Outputs.xGreenLight 	:= gArrayLights[3];
		Line.Outputs.xYellowLight 	:= gArrayLights[4];
		Line.Outputs.xRedLight 		:= gArrayLights[5];
END_ACTION