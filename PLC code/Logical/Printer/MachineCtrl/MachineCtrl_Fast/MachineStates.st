ACTION MachineStates:
	
	
	// Mute	conditions
	// Impovement in Test:"xRestartAfterPCPLCError": This condition is necessary to remove souns when comnns are restablished

	iReasonAutoCmdStart.0 := gMachine.commandsSw.xStart_GI;
	iReasonAutoCmdStart.1 := tonStartButton.Q AND NOT gMachine.Pt.xDisableStartHoldingGreenButton;
	
	gMachine.AutoCmd.xStart := EDGEPOS( iReasonAutoCmdStart > 0);
	
	IF EDGEPOS(gMachine.AutoCmd.xStart) THEN
		LogAutoStart;
	END_IF
	
	iReasonAutoCmdStop.0 := gMachine.In.Buttons.xStop;
	iReasonAutoCmdStop.1 := gMachine.commandsSw.xStop_GI;
	iReasonAutoCmdStop.2 := gMachine.commandsSw.xToStop_GI;

	IF (NOT gMachine.Pt.xControlledByLine) OR (gLine.Status = LINE_STOPPED) THEN
		gMachine.AutoCmd.xStop  := EDGEPOS(iReasonAutoCmdStop>0);
	ELSE
		gMachine.AutoCmd.xStop  := gMachine.commands.xStop; //Command sent by Line
	END_IF

	IF EDGEPOS(gMachine.AutoCmd.xStop) THEN
		LogAutoStop;
	END_IF
	
	tofResetAfterEnableSafety(IN:=EDGEPOS(gSafetyController.Outputs.xEnablePrinter1) AND gMachine.Pt.xControlledRemotely, PT:=T#500ms);
	tofToAutoAfterEnableSafety(IN:=EDGEPOS(gMachine.In.xSafetyEnabled), PT:=T#1000ms);
	tofResetFromUI(IN:=gMachine.commandsSw.xReset_GI, PT:=T#100ms);

	gMachine.AutoCmd.xReset:= gMachine.In.Buttons.xReset OR tofResetAfterEnableSafety.Q OR gMachine.commandsSw.xReset_GI;
	
	gMachine.AutoCmd.xMuteAlarms:= 	gMachine.commandsSw.xMute_GI OR gMachine.In.Buttons.xMute OR gMachine.AutoCmd.xReset;	

	IF EDGEPOS(gMachine.commandsSw.xCleanBelt) THEN
		gMachine.AutoCmd.xCleanBelt := TRUE;
	ELSIF gMachine.St.CleaningBelt.xCleaningProcessOnGoing OR (gMachine.St.CleaningBelt.enState = CLN_BELT_ERROR) THEN
		gMachine.AutoCmd.xCleanBelt := FALSE;
	END_IF
	
	
	(* Manual/Auto/Zero *)
	
	// Automatic Mode	
	IF  gMachine.In.Buttons.xAuto AND gMachine.St.StartUp.xReadyToAuto AND
		(gMachine.In.Buttons.xReset OR (gMachine.Pt.xControlledRemotely AND (EDGENEG(tofResetFromUI.Q) OR EDGENEG(tofToAutoAfterEnableSafety.Q)))) AND 
		NOT gMachine.AlSummary.xAlarmCritical THEN
		        enPrinterState:=PRINTERGEN_AUTO;
	END_IF
	
	IF enPrinterState = PRINTERGEN_STARTUP AND EDGEPOS(gMachine.St.StartUp.xReadyToAuto) AND 
		NOT gMachine.AlSummary.xAlarmCritical THEN
				enPrinterState:=PRINTERGEN_AUTO;
	END_IF
	
	// StartUp Mode	
	IF  gMachine.In.Buttons.xAuto AND gMachine.St.StartUp.Status = STRUP_NOT_STARTED AND 
		EDGENEG(tofToAutoAfterEnableSafety.Q) THEN
				enPrinterState:=PRINTERGEN_STARTUP;	
	END_IF
	
	
	
	
	// Manual Mode
	IF	gMachine.In.Buttons.xManual AND gMachine.In.Buttons.xReset THEN
		enPrinterState:=PRINTERGEN_MANUAL;
	END_IF
	 			
	// Zero Mode
	iReasonOut.0 := gMachine.In.Buttons.xZero;
	iReasonOut.1 := NOT gMachine.In.Buttons.xAuto AND NOT gMachine.In.Buttons.xManual; // It avoids manual state when safety is NOT ready
	iReasonOut.2 := gMachine.AlSummary.xAlarmCritical AND gMachine.St.Mode.xAuto;
	iReasonOut.3 := (gMachine.Al.xAlrSafetySystemEStop OR gSafetyController.Alarms.xAlrPrinterEStops) AND gMachine.St.Mode.xManual; //Going out of Manual just for Safety alarms. https://jira.efi.com/browse/CUBE-906
	
	IF 	iReasonOut > 0	THEN
		IF enPrinterState<>PRINTERGEN_ZERO THEN
			LogOutOfAuto;
		END_IF
		enPrinterState:=PRINTERGEN_ZERO;
	END_IF
		
	
	//MachineStates	
	gMachine.St.Mode.xZero		:= enPrinterState = PRINTERGEN_ZERO;
	gMachine.St.Mode.xManual	:= enPrinterState = PRINTERGEN_MANUAL;
	gMachine.St.Mode.xAuto		:= enPrinterState = PRINTERGEN_AUTO;
	gMachine.St.Mode.xStartUp	:= enPrinterState = PRINTERGEN_STARTUP;
	
	// Updated state MANUAL, ZERO OR AUTO
	// This state is used on block, gbelt
	gMachine.St.StateMode:=enPrinterState;

	
	rsRunBeltOrderManual.SET   := 	gMachine.AutoCmd.xStart;
	rsRunBeltOrderManual.RESET1:= 	gMachine.St.AutoMode.xPause OR 
									gMachine.AutoCmd.xStop OR 
									gMachine.Al.xAlrSafetySystemEStop OR
									(gLine.Alarms.xCriticalAlarm AND gMachine.Pt.xControlledByLine) OR
									gBelt.AlSummary.xAlarmCritical OR
									gBelt.AlSummary.xAlarmStop OR
									NOT gMachine.St.Mode.xManual;
	rsRunBeltOrderManual();	
	g_xRunBeltOrderManual:=rsRunBeltOrderManual.Q1;	
	
	CASE enPrinterState OF
		
		PRINTERGEN_ZERO:
			gMachine.AutoCmd.iAutoMode:=AUTO_NOT_VALID;
			
		PRINTERGEN_MANUAL:
			gMachine.AutoCmd.iAutoMode:=AUTO_NOT_VALID;
			
		
			//
		PRINTERGEN_AUTO:

			// Normal Cmd	
			IF 	NOT gMachine.AlSummary.xAlarmStop AND NOT gMachine.Al.xAlrDisableGoToProduction AND
				// In lab mode doesnt go to production,is just starting belt	
				((gMachine.AutoCmd.xStart AND NOT (gMachine.AutoCmd.iAutoMode=AUTO_BYPASS OR gMachine.AutoCmd.iAutoMode=AUTO_LABORATORY) AND NOT gMachine.Pt.xControlledByLine) OR
				(gMachine.commandsSw.xToNormal_GI AND gMachine.St.Blocks.xAnyBlockToPrint)) THEN

					IF gMachine.AutoCmd.iAutoMode<>AUTO_PRODUCTION THEN
						LogAutoInProduction;
					END_IF
					gMachine.AutoCmd.iAutoMode:=AUTO_PRODUCTION;

			END_IF
			
			
			//BYPASS
			IF  gMachine.commandsSw.xToByPass_GI OR
				(EDGENEG(gMachine.In.Buttons.xStart) AND NOT tonStartButton.Q AND (gMachine.AutoCmd.iAutoMode=AUTO_STOP) AND NOT gMachine.Pt.xControlledByLine) OR 
				EDGEPOS( gMachine.parSw.Dtp.xDoubleLine AND
	            		gMachine.parSw.Dtp.iModeLine1=GC_DTP_BYPASS AND
						gMachine.parSw.Dtp.iModeLine2=GC_DTP_BYPASS) THEN
				
				IF gMachine.AutoCmd.iAutoMode<>AUTO_BYPASS THEN
					LogAutoInByPass;
				END_IF
				gMachine.AutoCmd.iAutoMode:=AUTO_BYPASS;

			END_IF
			
			
			// JAM RECOVERY
			IF  gMachine.commandsSw.xToJamRecovery AND gMachine.Pt.xAllowJamRecovery THEN

				IF gMachine.AutoCmd.iAutoMode<>AUTO_JAMRECOVERY THEN
					LogAutoInJamRecovery;
				END_IF
				gMachine.AutoCmd.iAutoMode:=AUTO_JAMRECOVERY;
			
			END_IF
			
			
			// Laboratory **Conditioins before status OK
			IF  gMachine.commandsSw.xToLaboratory_GI AND gMachine.Pt.xAllowLaboratory THEN
				gMachine.AutoCmd.iAutoMode:=AUTO_LABORATORY;
			END_IF

			// STOP 
			iReasonAutoStop.0 := gMachine.AutoCmd.xStop;																						//Stop signal
			iReasonAutoStop.1 := gMachine.AutoCmd.iAutoMode = AUTO_NOT_VALID;																	//Stop by invalid automode
			iReasonAutoStop.2 := gMachine.AutoCmd.iAutoMode <> AUTO_BYPASS AND gMachine.AlSummary.xAlarmStop;									//Stop witohou ByPass with any stop alarm
			iReasonAutoStop.3 := gMachine.AutoCmd.iAutoMode = AUTO_BYPASS AND (gDing.AlSummary.xAlarmStop OR gPhotoCells.AlSummary.xAlarmStop);	//Stop in ByPass with thicknes sensor alarms
			iReasonAutoStop.4 := gMachine.AutoCmd.iAutoMode = AUTO_BYPASS AND																	//Stop in ByPass with TRansVacum stop alarm
								 (gTransVacuum[1].parSw.xActiveOutOfProduction AND gTransVacuum[1].AlSummary.xAlarmStop) OR 
								 (gTransVacuum[2].parSw.xActiveOutOfProduction AND gTransVacuum[2].AlSummary.xAlarmStop);
			
			iReasonAutoStop.5 := gMachine.AutoCmd.iAutoMode = AUTO_BYPASS AND																	//Stop in ByPass with non reference vertical motor alarm
								 (   (gBlock[1].Al.xAlrBarMtrNoRef AND (NOT gBlock[1].In.xTrayIn OR NOT gBlock[1].In.xIclaSensor)) OR
								 (gBlock[2].Al.xAlrBarMtrNoRef AND (NOT gBlock[2].In.xTrayIn OR NOT gBlock[2].In.xIclaSensor))   );
			
			iReasonAutoStop.6 := ton_JamRecoveryIdle.Q;
			
			IF  iReasonAutoStop > 0 THEN
				IF gMachine.AutoCmd.iAutoMode<>AUTO_STOP THEN
					iReasonAutoStop_Trigger := iReasonAutoStop;
					iReasonAutoCmdStop_Trigger := iReasonAutoCmdStop;
					LogAutoInStop;
				END_IF	
				gMachine.AutoCmd.iAutoMode:=AUTO_STOP;
			END_IF

	END_CASE

	//Define the individual bits for each state
	gMachine.St.AutoMode.xProduction	:= gMachine.AutoCmd.iAutoMode = AUTO_PRODUCTION;
	gMachine.St.AutoMode.xBypass		:= gMachine.AutoCmd.iAutoMode = AUTO_BYPASS;
	gMachine.St.AutoMode.xLaboratory	:= gMachine.AutoCmd.iAutoMode = AUTO_LABORATORY;
	gMachine.St.AutoMode.xStop			:= gMachine.AutoCmd.iAutoMode = AUTO_STOP;
	gMachine.St.AutoMode.xJamRecovery	:= gMachine.AutoCmd.iAutoMode = AUTO_JAMRECOVERY;
	gMachine.St.AutoMode.xProdORLab 	:= gMachine.St.AutoMode.xProduction OR gMachine.St.AutoMode.xLaboratory;
	gMachine.St.AutoMode.xProdORByPass 	:= gMachine.St.AutoMode.xProduction OR gMachine.St.AutoMode.xBypass;
	
	
	// State: Pause
	iReasonSetPause.0 := gMachine.commandsSw.xPause_GI;
	iReasonSetPause.1 := EDGEPOS(gMachine.St.AutoMode.xLaboratory);
	iReasonSetPause.2 := EDGEPOS(gMachine.St.Mode.xAuto);
	iReasonSetPause.3 := EDGEPOS(gMachine.In.Buttons.xStart) AND gBelt.states.xRuningBelt;
	srPauseMachine.SET:= iReasonSetPause > 0;
	
	iReasonResetPause.0 := EDGEPOS(gMachine.St.AutoMode.xBypass);
	iReasonResetPause.1 := EDGEPOS(gMachine.St.AutoMode.xProduction) AND NOT gMachine.Pt.xControlledByLine;
	iReasonResetPause.2 := gMachine.AutoCmd.xStart;
	iReasonResetPause.3 := gMachine.St.AutoMode.xPause AND EDGEPOS(gMachine.In.Buttons.xStart);
	iReasonResetPause.4 := gMachine.St.Mode.xZero;
	iReasonResetPause.5 := gMachine.St.AutoMode.xStop;
	srPauseMachine.RESET1:= iReasonResetPause > 0;
	srPauseMachine();
	gMachine.St.AutoMode.xPause         := srPauseMachine.Q1;

	IF EDGEPOS(gMachine.St.AutoMode.xPause) THEN
		iLastReasonSetPause := iReasonSetPause;
	ELSIF EDGENEG(gMachine.St.AutoMode.xPause) THEN
		iLastReasonResetPause := iReasonResetPause;
	END_IF		
	
	//Machine state to SW, is it used on SW? Or iBlockState?
	CASE gMachine.AutoCmd.iAutoMode OF
		AUTO_PRODUCTION:     gMachine.St.iAutoModeSW:= 1;
		AUTO_BYPASS:         gMachine.St.iAutoModeSW:= 2;
		AUTO_LABORATORY:     gMachine.St.iAutoModeSW:= 3;
		AUTO_JAMRECOVERY:    gMachine.St.iAutoModeSW:= 4;
		AUTO_STOP:           gMachine.St.iAutoModeSW:= 0;
	END_CASE	

	tonStartButton(IN:= gMachine.In.Buttons.xStart, PT:= T#1s);	
	
	ton_ZeroMode(IN:= gMachine.St.Mode.xZero, PT:= T#100ms);
	
	ton_JamRecoveryIdle.IN := gMachine.St.AutoMode.xJamRecovery AND NOT gBelt.states.xRuningBelt;
	ton_JamRecoveryIdle.PT := T#10m;
	ton_JamRecoveryIdle();
	
END_ACTION


