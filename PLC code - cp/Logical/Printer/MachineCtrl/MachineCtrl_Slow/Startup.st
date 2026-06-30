
ACTION Startup: 

	IF NOT gMachine.Pt.xAllowAutoStartUp OR NOT gMachine.parSw.xAutoStartEnabled THEN
		gMachine.St.StartUp.Status := STRUP_DISABLED;
		enStartUpStatus :=  STRUP_DISABLED;
		gMachine.St.StartUp.xReadyToAuto := TRUE;
		RETURN;
	END_IF
	
	IF (EDGENEG(gMachine.In.xSafetyEnabled) OR EDGENEG(gMachine.In.Buttons.xAuto)) AND 
		(enStartUpStatus <> STRUP_CANCELLED OR  enStartUpStatus <> STRUP_READY OR enStartUpStatus <> STRUP_NOT_STARTED) THEN
			enStartUpStatus := STRUP_ERROR;
	END_IF
	
	CASE enStartUpStatus OF
		STRUP_DISABLED:
			IF gMachine.Pt.xAllowAutoStartUp AND gMachine.parSw.xAutoStartEnabled THEN
				enStartUpStatus := STRUP_NOT_STARTED;
			END_IF
			
		STRUP_NOT_STARTED:
			gMachine.St.StartUp.xReadyToAuto := FALSE;
			IF gMachine.St.Mode.xStartUp THEN
				//Sending a reset command to remove motor's error.
				//So when pressing reset to launch start up process (enPrinterState = PRINTERGEN_STARTUP when "EDGENEG(tofToAutoAfterEnableSafety.Q)")
				//safety relays are activated and STO restored to motor but a second reset is required in order to get those motor status ready to go
				IF gBlock[1].Status.Icla.xInError OR gBlock[1].Al.xAnyVerticalDriveAlarm THEN
					//To review how to send a reset order instead of using commandsSw reset
					gMachine.commandsSw.xReset_GI := TRUE;
				END_IF
				enStartUpStatus := STRUP_RESETTING_MOTORS;
			END_IF
			
		STRUP_RESETTING_MOTORS:
			gMachine.commandsSw.xReset_GI := FALSE;
			enStartUpStatus := STRUP_HOME_ICLA_ORDER;
			
			
		STRUP_HOME_ICLA_ORDER:
			gBlock[1].commands.xIclaHomeOrder := TRUE;
			IF gBlock[1].Status.Icla.xHoming THEN
				enStartUpStatus := STRUP_HOMING_ICLA;
			END_IF
			
		STRUP_HOMING_ICLA:
			IF gBlock[1].Status.Icla.xHomed THEN
				gBlock[1].commands.Manual.xManTrayOut := TRUE;
				enStartUpStatus := STRUP_MOVING_TRAY_OUT;
			END_IF
			
			IF gBlock[1].Status.Icla.xInError THEN
				enStartUpStatus := STRUP_ERROR;
			END_IF

		STRUP_MOVING_TRAY_OUT:
			IF gBlock[1].In.xTrayOut THEN
				gBlock[1].commands.xBarHomeOrder := TRUE;
				enStartUpStatus := STRUP_HOMING_BLOCK;
			END_IF

		STRUP_HOMING_BLOCK:
			//Once the block has been homed, with STARTUP the block is considered in AUTO
			IF gBlock[1].Status.Motor.xBarsHomed AND gBlock[1].Status.BlockState = BLOCK_AUTO THEN
				gBlock[1].commands.xToCap := TRUE;
				enStartUpStatus := STRUP_BLOCK_GOING_TO_CAP;
			END_IF
			
			IF gBlock[1].Al.xAlrReferenceIncoherence OR gBlock[1].Al.xAnyVerticalDriveAlarm THEN
				enStartUpStatus := STRUP_ERROR;
			END_IF
				
		STRUP_BLOCK_GOING_TO_CAP:
			IF gBlock[1].Status.Position.xInCap THEN
				gBlock[1].commands.Manual.xManTrayIn := TRUE;
				enStartUpStatus := STRUP_STARTING_INKS;
			END_IF
			
		STRUP_STARTING_INKS:
			// Start inks
			FOR iIndexStartUp := 1 TO gBlock[1].parameters.Inks.iMaxMachinePrintBars DO
				IF gInks[iIndexStartUp].parSw.Config.iMappingBar > 0 THEN
//					gInks[iIndexStartUp].parSw.Temp.rSetPointTemp := gInks[iIndexStartUp].parameters.parBar.Default.rTemp ;
//					gInks[iIndexStartUp].parSw.NegPump.rSetPointMeniscus := gInks[iIndexStartUp].parameters.parBar.StartUp.rMeniscus ;
//					gInks[iIndexStartUp].parSw.PosPump.rSetPoint := gInks[iIndexStartUp].parameters.parBar.StartUp.rPositive ;
					
					gInks[iIndexStartUp].parameters.StartUp.xActive := TRUE;
					gInks[iIndexStartUp].ordersSw.xStartInks := TRUE;
				END_IF
			END_FOR
			enStartUpStatus := STRUP_WAIT_INKS_STARTED;
			
			
		STRUP_WAIT_INKS_STARTED:
			tonStartingInks.IN := TRUE;
			tonStartingInks.PT := t#3s;
			tonStartingInks();
			IF tonStartingInks.Q THEN
				tonStartingInks(IN := FALSE); //Resetting timer
				enStartUpStatus := STRUP_REVIEWING_INKS;
			END_IF
			
		STRUP_REVIEWING_INKS:
			xStartUpAnyBarNotStable := FALSE; iIndexStartUp := 0;
			xStartUpAnyBarUnstable := FALSE;
			xInksStoppedWhileStartUp := FALSE;
			FOR iIndexStartUp := 1 TO gBlock[1].parameters.Inks.iMaxMachinePrintBars DO
				ReviewStartUpStatusInkIndex;
			END_FOR
			
			// If everyone is stable, go next step
			IF NOT xStartUpAnyBarNotStable THEN
				enStartUpStatus := STRUP_POWER_UP_PRINTHEADS;
			END_IF
			
			// If some bar is really unstable, cancel the startup
			IF xStartUpAnyBarUnstable AND xInksStoppedWhileStartUp THEN
				enStartUpStatus := STRUP_ERROR;				
			END_IF
			
		STRUP_POWER_UP_PRINTHEADS:
			// Tutn on electronics
			FOR iIndexStartUp := 1 TO gBlock[1].parameters.Inks.iMaxMachinePrintBars DO
				IF gInks[iIndexStartUp].parSw.Config.iMappingBar > 0 THEN
					gInks[iIndexStartUp].ordersSw.xPowPrintHead := TRUE;
				END_IF
			END_FOR
			enStartUpStatus := STRUP_REVIEWING_PRINTHEADS;

		STRUP_REVIEWING_PRINTHEADS:
			xStartUpAnyBarNotPowered := FALSE;
			FOR iIndexStartUp := 1 TO gBlock[1].parameters.Inks.iMaxMachinePrintBars DO
				// Reviewing if the cards are turned on
				IF gInks[iIndexStartUp].parSw.Config.iMappingBar > 0 THEN
					IF NOT gInks[iIndexStartUp].signals.out.xOutPowPrintHead THEN
						xStartUpAnyBarNotPowered := TRUE;
					END_IF
				END_IF
			END_FOR
			
			IF NOT xStartUpAnyBarNotPowered THEN
				enStartUpStatus := STRUP_READY;
			END_IF
			
		STRUP_ERROR,
		STRUP_READY,			
		STRUP_CANCELLED:
			gMachine.St.StartUp.xReadyToAuto := TRUE;
		
			// Assure in case of error or cancelled, the startup process in the inks is stopped
			FOR iIndexStartUp := 1 TO gBlock[1].parameters.Inks.iMaxMachinePrintBars DO
				gInks[iIndexStartUp].parameters.StartUp.xActive := FALSE;
			END_FOR

	END_CASE
	
	// Those are the states where cancel is blocked because make no sense
	xPosibleCancel.0 := enStartUpStatus = STRUP_ERROR;
	xPosibleCancel.1 := enStartUpStatus = STRUP_READY;
	xPosibleCancel.2 := enStartUpStatus = STRUP_CANCELLED;
	xPosibleCancel.3 := enStartUpStatus = STRUP_DISABLED;
		
	IF gMachine.commandsSw.xCancelStartUp AND xPosibleCancel = 0 THEN
		// Canceling homing icla if cancelled while homing
		IF enStartUpStatus = STRUP_HOMING_ICLA THEN
			gBlock[1].commands.xIclaHomeOrderInterrupt := TRUE;
		END_IF
		// Canceling homing bar if cancelled while homing
		IF enStartUpStatus = STRUP_HOMING_BLOCK THEN
			gBlock[1].commands.xBarHomeOrder := FALSE;
		END_IF
		enStartUpStatus := STRUP_CANCELLED;
	END_IF
	
	gMachine.St.StartUp.Status := enStartUpStatus;
	gMachine.St.StartUp.xInProgress := 	enStartUpStatus <> STRUP_DISABLED AND
										enStartUpStatus <> STRUP_NOT_STARTED AND
										enStartUpStatus <> STRUP_ERROR AND
										enStartUpStatus <> STRUP_READY AND
										enStartUpStatus <> STRUP_CANCELLED AND
										enStartUpStatus <> STRUP_DISABLED;
	
		
END_ACTION

ACTION ReviewStartUpStatusInkIndex: 

	// If the bar cannot be started, do not consider it
	IF gInks[iIndexStartUp].parSw.Config.iMappingBar <= 0 THEN
		RETURN;
	END_IF
	
	// Running each inks system timer
	
	
	IF gInks[iIndexStartUp].status.AutoStartUp.xCancelled THEN
		// If detected a long unstability, change the set point to avoid stopping or dripping and raise the signal to go to error
		xStartUpAnyBarUnstable := TRUE;
	END_IF
	
	// Reviewing if the system is stable
	IF NOT gInks[iIndexStartUp].status.AutoStartUp.xStarted OR gInks[iIndexStartUp].Al.xAlrDiffInCtrlTemp OR gInks[iIndexStartUp].Al.xAlrDiffVacuum THEN
		xStartUpAnyBarNotStable := TRUE;
		iIndexBarNotStable := iIndexStartUp;
		UnstabInkStartUp[iIndexStartUp] := TRUE;
	ELSE
		UnstabInkStartUp[iIndexStartUp] := FALSE;
	END_IF
	
	IF NOT gInks[iIndexStartUp].status.xInksRunning THEN
		xInksStoppedWhileStartUp := TRUE;
	END_IF
	
END_ACTION
