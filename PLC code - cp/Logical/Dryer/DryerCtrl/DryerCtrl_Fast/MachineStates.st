ACTION MachineStates:
	
	
	// Mute	conditions
	// Impovement in Test:"xRestartAfterPCPLCError": This condition is necessary to remove souns when comnns are restablished

	gDryer.AutoCmd.xStart := EDGEPOS (tonStartButton.Q OR gDryer.In.Sw.xStart_GI);

	tonStop.IN := gDryer.In.Buttons.xStop OR gDryer.In.Sw.xStop_GI;
	tonStop.PT := T#2s;
	tonStop();
	gDryer.AutoCmd.xStop := (tonStop.Q OR EDGEPOS (gDryer.In.Buttons.xStop OR gDryer.In.Sw.xStop_GI)) AND NOT gDryer.St.AutoLocation.xRemote;
	gDryer.AutoCmd.xReset:= gDryer.In.Buttons.xReset OR gDryer.In.Sw.xReset_GI;

	gDryer.AutoCmd.xMuteAlarms:= gDryer.In.Sw.xMute_GI OR gDryer.In.xMute OR gDryer.AutoCmd.xReset;	

	
	(* Manual/Auto/Zero *)
	
	// Automatic Mode	
	iReasonNotEnterAuto.0 := gDryer.AlSummary.xAlarmCritical;
	//iReasonNotEnterAuto.1 := gDryer.Al.Warning.xFrontDoorOpened;
	//iReasonNotEnterAuto.2 := gDryer.Al.Warning.xRearDoorOpened;
	iReasonNotEnterAuto.3 := gSimpleBlock[1].Al.xAlrBarMtrNoRef AND gArcLampGew.Status.xInstalled; //Just not allow entering in auto if ArcLamp is installed
	gDryer.St.xNotAutoPossible := iReasonNotEnterAuto > 0;
	IF gDryer.In.Buttons.xAuto AND gDryer.In.Buttons.xReset AND iReasonNotEnterAuto = 0 THEN
		enPrinterState:=PRINTERGEN_AUTO;
	END_IF
	
	// Manual Mode
	IF gDryer.In.Buttons.xManual AND gDryer.In.Buttons.xReset THEN
		enPrinterState:=PRINTERGEN_MANUAL;
	END_IF
	 			
	// Zero Mode
	iReasonOut.0 := gDryer.In.Buttons.xZero;
	iReasonOut.1 := NOT gDryer.In.Buttons.xAuto AND enPrinterState=PRINTERGEN_AUTO; // It avoids manual state when safety is NOT ready
	iReasonOut.2 := NOT gDryer.In.Buttons.xManual AND enPrinterState=PRINTERGEN_MANUAL; // It avoids manual state when safety is NOT ready
	iReasonOut.3 := gDryer.AlSummary.xAlarmCritical AND enPrinterState=PRINTERGEN_AUTO;
	iReasonOut.4 := gDryer.Al.xAlrSafetySystemEStop;
	IF iReasonOut > 0	THEN
		IF enPrinterState<>PRINTERGEN_ZERO THEN
			LogOutOfAuto;
		END_IF
		enPrinterState:=PRINTERGEN_ZERO;
	END_IF
		
	
	//MachineStates	
	gDryer.St.Mode.xZero	:= enPrinterState = PRINTERGEN_ZERO;
	gDryer.St.Mode.xManual	:= enPrinterState = PRINTERGEN_MANUAL;
	gDryer.St.Mode.xAuto	:= enPrinterState = PRINTERGEN_AUTO;
	// Updated state MANUAL, ZERO OR AUTO
	// This state is used on block, gbelt
	gDryer.St.StateMode:=enPrinterState;

	
	rsRunBeltOrderManual.SET   := gDryer.AutoCmd.xStart;
	rsRunBeltOrderManual.RESET1:= 	gDryer.St.AutoMode.xPause OR
									gDryer.AutoCmd.xStop OR
									gDryer.Al.xAlrSafetySystemEStop OR
									gDryer.Al.Alarm.xAlrJam OR
									NOT gDryer.St.Mode.xManual OR
									gDryer.Al.Alarm.xAlarmMountedMedia;
	
	rsRunBeltOrderManual();	
	g_xRunBeltOrderManual:=rsRunBeltOrderManual.Q1;	
	
	CASE enPrinterState OF
		
		PRINTERGEN_ZERO:
			WhileNotInAuto;
			
		PRINTERGEN_MANUAL:
			WhileNotInAuto;
		
		PRINTERGEN_AUTO:

			//Restore previous status
			IF gDryer.AutoCmd.iAutoMode=AUTO_NOT_VALID THEN
				gDryer.St.LocationControl := AutoLocationPrevious;
			END_IF
			
			IF EDGEPOS(gDryer.commands.xToLocal) THEN
				gDryer.commands.xToLocal:=FALSE;
				gDryer.St.LocationControl := MACHLOC_LOCAL;
			ELSIF EDGEPOS(gDryer.commands.xToRemote) THEN
				gDryer.commands.xToRemote:=FALSE;
				gDryer.St.LocationControl := MACHLOC_REMOTE;		
			END_IF
			
			// Normal Cmd	
			IF NOT gDryer.AlSummary.xAlarmStop AND NOT gDryer.Al.xAlrDisableGoToProduction AND
				// In lab mode doesnt go to production,is just starting belt	
				( (gDryer.AutoCmd.xStart AND gDryer.AutoCmd.iAutoMode<>AUTO_BYPASS) OR gDryer.In.Sw.xToNormal_GI OR gDryer.St.AutoLocation.xRemote) THEN

				gDryer.AutoCmd.iAutoMode:=AUTO_PRODUCTION;
			END_IF
			
			
			//BYPASS
			IF gDryer.In.Sw.xToByPass_GI OR
				(EDGENEG(gDryer.In.xStart) AND NOT tonStartButton.Q AND (gDryer.AutoCmd.iAutoMode=AUTO_STOP) ) THEN
				
				gDryer.AutoCmd.iAutoMode:=AUTO_BYPASS;
			END_IF
			
			
			// STOP 
			iReasonStop.0 := gDryer.AutoCmd.xStop;
			iReasonStop.1 := gDryer.AutoCmd.iAutoMode=AUTO_NOT_VALID;
			iReasonStop.2 := gDryer.AutoCmd.iAutoMode<>AUTO_BYPASS AND gDryer.AlSummary.xAlarmStop;
			IF iReasonStop > 0 THEN
				//Register last reason to Stop
				IF (gDryer.AutoCmd.iAutoMode<>AUTO_STOP) THEN iLastReasonStop := iReasonStop; END_IF
				gDryer.AutoCmd.iAutoMode:=AUTO_STOP;
			END_IF

	END_CASE

	//Define the individual bits for each state
	gDryer.St.AutoMode.xProduction	:= gDryer.AutoCmd.iAutoMode = AUTO_PRODUCTION;
	gDryer.St.AutoMode.xBypass		:= gDryer.AutoCmd.iAutoMode = AUTO_BYPASS;
	//gDryer.St.AutoMode.xLaboratory	:= gDryer.AutoCmd.iAutoMode = AUTO_LABORATORY;
	gDryer.St.AutoMode.xStop			:= gDryer.AutoCmd.iAutoMode = AUTO_STOP;
	gDryer.St.AutoMode.xProdORLab 	:= gDryer.St.AutoMode.xProduction OR gDryer.St.AutoMode.xLaboratory;
	gDryer.St.AutoMode.xProdORByPass 	:= gDryer.St.AutoMode.xProduction OR gDryer.St.AutoMode.xBypass;
	
	
	// State: Pause
	iReasonSetPause.0 := gDryer.In.Sw.xPause_GI;
	iReasonSetPause.1 := EDGEPOS(gDryer.St.AutoMode.xLaboratory);
	iReasonSetPause.2 := EDGEPOS(gDryer.St.Mode.xAuto) ;
	iReasonSetPause.3 := (EDGEPOS(gDryer.In.xStart) AND gBelt.states.xRuningBelt);
	srPauseMachine.SET:= iReasonSetPause > 0;
	
	iReasonResetPause.0 := EDGEPOS(gDryer.St.AutoMode.xBypass);
	iReasonResetPause.1 := EDGEPOS(gDryer.St.AutoMode.xProduction);
	iReasonResetPause.2 := gDryer.AutoCmd.xStart;
	iReasonResetPause.3 := (gDryer.St.AutoMode.xPause AND EDGEPOS(gDryer.In.xStart));
	iReasonResetPause.4 := gDryer.St.Mode.xZero;
	iReasonResetPause.5 := gDryer.St.AutoMode.xStop;
	srPauseMachine.RESET1:= iReasonResetPause > 0;
	
	srPauseMachine();
	gDryer.St.AutoMode.xPause := srPauseMachine.Q1;

	
	//Machine state to SW, is it used on SW? Or iBlockState?
	CASE gDryer.AutoCmd.iAutoMode OF
		AUTO_PRODUCTION:     gDryer.St.iAutoModeSW:= 1;
		AUTO_BYPASS:         gDryer.St.iAutoModeSW:= 2;
		AUTO_LABORATORY:     gDryer.St.iAutoModeSW:= 3;
		AUTO_STOP:           gDryer.St.iAutoModeSW:= 0;
	END_CASE	

	tonStartButton(IN:= gDryer.In.xStart, PT:= T#1s);	
	
	ton_ZeroMode(IN:= gDryer.St.Mode.xZero, PT:= T#100ms);
	
	gDryer.St.AutoLocation.xLocal := gDryer.St.LocationControl = MACHLOC_LOCAL;
	gDryer.St.AutoLocation.xLocalORManual := gDryer.St.LocationControl <> MACHLOC_REMOTE;
	gDryer.St.AutoLocation.xRemote := gDryer.St.LocationControl = MACHLOC_REMOTE;
	
	IF gDryer.St.AutoLocation.xRemote THEN
		DryerParams ACCESS ADR(gDryerRemoteData.Parameters);
		DryerSignalsAuto ACCESS ADR(gDryerRemoteData);
	ELSE
		DryerParams ACCESS ADR(gDryerLocalParams);
		DryerSignalsAuto ACCESS ADR(gDryerLocalSignals);
	END_IF
	
	IF EDGE(gDryer.St.AutoLocation.xRemote) THEN
		gDryerLocalSignals := gDryerLocalSignalsReseted;
		StoredParamsToWork;
	END_IF
	
	IF gDryer.St.AutoLocation.xRemote THEN
		StoredParamsToWork;
	ELSE
		WorkParamsToStored;
	END_IF
	
	//Assign to remote data local parameters without Sw interface
	gDryerRemoteData.Parameters.Media.rMargin := gDryerLocalParams.Media.rMargin;
	gDryerRemoteData.Parameters.Safety.rMaxBeltSpeedSetPoint := gDryerLocalParams.Safety.rMaxBeltSpeedSetPoint;
	
END_ACTION


ACTION WhileNotInAuto:
	
	//Store the first time previous Auto Location
	IF gDryer.AutoCmd.iAutoMode<>AUTO_NOT_VALID THEN
		AutoLocationPrevious := gDryer.St.LocationControl;
		gDryer.St.LocationControl := AutoLocationReseted;
	END_IF
	
	gDryer.AutoCmd.iAutoMode:=AUTO_NOT_VALID;

END_ACTION


ACTION StoredParamsToWork:
	gDryer.Pt.SW := DryerParams;
END_ACTION

ACTION WorkParamsToStored:
	DryerParams := gDryer.Pt.SW;
END_ACTION
