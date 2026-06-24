
ACTION controlMode: 

	
	inks.status.iInkState := LIMIT(1,inks.status.iInkState,13);

	//Just change ReservoirMode when stopped
	IF inks.status.iInkState = INKS_STOPPED THEN
		xReservoirModeActivated:= inks.parameters.xReservoirMode;
	END_IF


	//Control of the different working methods of the ink system:
	inks.status.xEnabledBarToPrint := inks.parSw.xEnabledBarToPrint;
	inks.status.xColorLoadedInJob := inks.parSw.xColorLoadedInJob;
	inks.status.xActTestMode := inks.parSw.xActTestMode;
	inks.status.xActMaintenanceMode := inks.parSw.xActMaintenanceMode;
	
	//MODE 9: STOPPING THE SYSTEM. The mode is used before the system is stopped.
	IF xRunningAuto AND (NOT inks.ordersSw.xStartInks OR inks.AlSummary.xAlarmCritical) THEN
		iInkPreviousState := inks.status.iInkState;
		inks.status.iInkState := INKS_STOPPING;
	END_IF

	
	//MODE1: SYSTEM STOPPED
	//Stop in cleaning minifolds and canlcel order or OverPresure alarm appear
	IF 	((NOT inks.ordersSw.xStartManual OR inks.Al.xAlrOverPressure) AND inks.status.iInkState = INKS_RUNNING_MANUAL) THEN //Stop in any others ink state if any crital alarm appear
		iInkPreviousState := inks.status.iInkState;
		inks.status.iInkState := INKS_STOPPED;
		removeOrders;
	END_IF

	TON_Stopped.IN:= inks.status.iInkState = INKS_STOPPING;
	TON_Stopped.PT:= INT_TO_TIME(inks.parameters.iTimeStopping);
	TON_Stopped();
	
	iTimeStopping:=TIME_TO_INT(TON_Stopped.ET);
	IF TON_Stopped.Q THEN
		iInkPreviousState := inks.status.iInkState;
		inks.status.iInkState := INKS_STOPPED ;	
	END_IF



	
	//MODE3 AND MODE13: INK SYSTEM START. When the system is charged we can start it.
	xPossibleStart:=  inks.status.iInkState = INKS_STOPPED AND 
					(inks.status.Tank.xMinLevel OR inks.status.xActTestMode) AND
					NOT inks.Al.xAlrOverPressure;
	
	r_start_inks(CLK:= inks.ordersSw.xStartInks);
	
	IF xPossibleStart AND r_start_inks.Q THEN
		//Depending on the type of the system, go to priming or not
		IF inks.parameters.Priming.xSystemNeedsPriming THEN
			inks.status.iInkState := INKS_PRIMING;
		ELSE
			inks.status.iInkState := INKS_STARTING;
		END_IF
		iInkPreviousState := inks.status.iInkState;			
	END_IF
	
	//Go to Starting from the Priming state
	IF inks.status.iInkState = INKS_PRIMING AND (inks.status.rMeniscus<-10) THEN	
		inks.status.iInkState := INKS_STARTING;
	END_IF
	
	//If the system is not ready to start, fall down the start command
	IF (r_start_inks.Q AND inks.status.iInkState <> INKS_STARTING) OR inks.status.iInkState=INKS_STOPPED THEN
		inks.ordersSw.xStartInks:=FALSE;
	END_IF
	

	//MODE4: When the system is stabilized we are in the mode4.
	IF 	(inks.status.iInkState = INKS_STARTING AND (xGoToStarted OR xPrimingStabilized) ) OR
		(inks.status.iInkState = INKS_MANUAL_REVERSEFLOW AND EDGENEG(inks.ordersSw.xOrderReverseMan) ) OR
		(inks.status.iInkState = INKS_AUTO_REVERSEFLOW AND NOT inks.commands.xOrderCleaning) OR
		(inks.status.iInkState = INKS_AUTO_REVERSEFLOW AND NOT inks.status.Reverse.xStartOnReverseCapped) THEN
		
			iInkPreviousState := inks.status.iInkState;
			inks.status.iInkState := INKS_STARTED;	
	END_IF


	//MODE 5: MANUAL REVERSE FLOW. When the interface button is pressed, we change the flow direction.
	IF inks.status.iInkState = INKS_STARTED AND EDGEPOS(inks.ordersSw.xOrderReverseMan) THEN
		xPressureReservoirStable:=FALSE;
		iInkPreviousState := inks.status.iInkState;
		inks.status.iInkState := INKS_MANUAL_REVERSEFLOW;
	END_IF
 

	//MODE 6: AUTOMATIC REVERSE FLOW. Is done on printheads cleaning.
	IF inks.commands.xOrderCleaning AND inks.parSw.xOnReverseCleaning THEN 
		inks.status.Reverse.xOnReverseCleaning:=TRUE;
	ELSIF inks.parSw.xOnReverseCapped AND inks.parameters.xBlockInCap THEN
		inks.status.Reverse.xOnReverseCapped:= TRUE;
	ELSE 
		inks.status.Reverse.xOnReverseCleaning:=FALSE;
		inks.status.Reverse.xOnReverseCapped:=FALSE;		
	END_IF
	
	//Reverse flow just works when ink is started
	IF inks.status.iInkState = INKS_STARTED AND ( inks.status.Reverse.xOnReverseCleaning OR (inks.status.Reverse.xOnReverseCapped AND  inks.status.Reverse.xStartOnReverseCapped ) ) THEN
		xPressureReservoirStable:=FALSE;
		iInkPreviousState := inks.status.iInkState;
		inks.status.iInkState := INKS_AUTO_REVERSEFLOW ;		
	END_IF


	//MODE 10: Running Manual
	IF 	inks.status.iInkState = INKS_STOPPED AND (inks.status.Tank.xMinLevel OR  inks.status.xActTestMode) AND
		inks.ordersSw.xStartManual  THEN
			iInkPreviousState := inks.status.iInkState;
			inks.status.iInkState := INKS_RUNNING_MANUAL;
	END_IF

	// Solenid direction management
	//
	IF (inks.status.iInkState = INKS_STOPPED AND inks.status.xInksRunning) OR inks.status.iInkState = INKS_STOPPING  THEN
		inks.status.iDirection := INKSDIR_STOP;
	END_IF

	//When ink flow is direct xInksManifoldsCleaningInReverse is false and everytime that is stopped is restored to false
	//just in case of pareameter, ink flow is reverted or not for cleaning manifolds
	// Pending to update parameter to iInksManifoldsCleaningReverted;
	inks.status.Reverse.xReverseOnManual:= inks.parSw.xReverseOnManual;
	
	IF 	inks.status.iInkState = INKS_PRIMING OR
		inks.status.iInkState = INKS_STARTING OR
		inks.status.iInkState = INKS_STARTED OR
		(inks.status.iInkState = INKS_RUNNING_MANUAL AND NOT inks.status.Reverse.xReverseOnManual ) THEN
		inks.status.iDirection := INKSDIR_DIRECT;
	END_IF

	IF (inks.status.iInkState = INKS_MANUAL_REVERSEFLOW OR inks.status.iInkState = INKS_AUTO_REVERSEFLOW) OR
		(inks.status.iInkState = INKS_RUNNING_MANUAL AND inks.status.Reverse.xReverseOnManual ) THEN 
		inks.status.iDirection := INKSDIR_REVERSE;
	END_IF


	//Defining the system is running in auto mode
	iReasonRunningAuto.0 := inks.status.iInkState = INKS_STARTING;
	iReasonRunningAuto.1 := inks.status.iInkState = INKS_PRIMING;
	iReasonRunningAuto.2 := inks.status.iInkState = INKS_STARTED;
	iReasonRunningAuto.3 := inks.status.iInkState = INKS_MANUAL_REVERSEFLOW;
	iReasonRunningAuto.4 := inks.status.iInkState = INKS_AUTO_REVERSEFLOW;
	xRunningAuto := iReasonRunningAuto > 0;
	
	//Conditions to start de ink system
	iReasonRunning.0 := inks.status.iInkState = INKS_STOPPING;
	iReasonRunning.1 := inks.status.iInkState = INKS_RUNNING_MANUAL;
	inks.status.xInksRunning := xRunningAuto OR iReasonRunning > 0;

	// If running in auto, remove order to run manual
	IF xRunningAuto THEN
		inks.ordersSw.xStartManual := FALSE;
	END_IF
	
	xStateReverseFlow:= inks.status.iInkState = INKS_MANUAL_REVERSEFLOW OR inks.status.iInkState = INKS_AUTO_REVERSEFLOW;
	
	//manual reverse time management
	IF inks.status.iInkState = INKS_STOPPED THEN 
		inks.status.Reverse.xReverseManFinished := TRUE;
	ELSIF inks.ordersSw.xOrderReverseMan THEN
		inks.status.Reverse.xReverseManFinished := FALSE;
	END_IF
	
	inks.status.Reverse.xReverseMan := (inks.status.iInkState = INKS_MANUAL_REVERSEFLOW);

	TON_TimeExecutingReverseMan.IN:= inks.status.iInkState = INKS_MANUAL_REVERSEFLOW;
	TON_TimeExecutingReverseMan.PT:= MAX(inks.parSw.tiReverseManual, T#3s);
	TON_TimeExecutingReverseMan();
	inks.status.tiInReverseManual:=TON_TimeExecutingReverseMan.ET;
	IF TON_TimeExecutingReverseMan.Q THEN		
		// It sets inks.commnads.xOrderReverseMan FALSE because is a latched
		inks.ordersSw.xOrderReverseMan:=FALSE;
		inks.status.Reverse.xReverseManFinished := TRUE;
	END_IF
	

	//Unestable ink system state.
	inks.status.xUnstableInkState := (inks.Al.xAlrDiffVacuum OR inks.Al.xAlrDiffInCtrlTemp) AND inks.status.xInksRunning;


	//Update values for the current control cycle
	//We match the different values of the variable iInkstate with internal variables
	mode1 := inks.status.iInkState = INKS_STOPPED;
	mode3 := inks.status.iInkState = INKS_STARTING;
	mode4 := inks.status.iInkState = INKS_STARTED;
	mode5 := inks.status.iInkState = INKS_MANUAL_REVERSEFLOW;
	mode6 := inks.status.iInkState = INKS_AUTO_REVERSEFLOW;
	mode9 := inks.status.iInkState = INKS_STOPPING;
	mode10:= inks.status.iInkState = INKS_RUNNING_MANUAL;
	mode13:= inks.status.iInkState = INKS_PRIMING;

	//The vacuuum sensor readings are changed if we are in reverse flow.
	TON_ChangeReverse(IN:=mode5 OR mode6, PT:= T#100MS);
	xIAmInReverse:=TON_ChangeReverse.Q;
	
	// xOrderDrip when is cleaning while 50 secs, from start dropping to suction finished
	TOF_IgnoreAlarmsCleaning(IN:= inks.commands.xOrderDrip, PT:= T#50s);
	xIgnoreAlarmsInCleaning:=TOF_IgnoreAlarmsCleaning.Q;

	// When GUI sends Idle reverse function, It sets xOnReverseCapped and then is updated GUI 
	// and started reverse flow OF 60 secs every 30 MIN
	//
	IF inks.parSw.xOnReverseCapped AND NOT TON_OnReverseCappedFinished.Q THEN			
		inks.status.Reverse.xStartOnReverseCappedCycle:=TRUE;
	ELSE
		inks.status.Reverse.xOnReverseCapped:=FALSE;
		inks.status.Reverse.xStartOnReverseCapped:=FALSE;
		inks.status.Reverse.xStartOnReverseCappedCycle:=FALSE;
	END_IF
	// timer of cycles
	TON_OnReverseCappedCycle(IN:=inks.status.Reverse.xStartOnReverseCappedCycle, PT:=T#30M);
	
	IF TON_OnReverseCappedCycle.Q AND
	    NOT xDrippingOrder AND
		(NOT inks.ordersSw.xStartManual) AND
		(NOT inks.ordersSw.xOrderReverseMan) THEN		
		
		inks.status.Reverse.xStartOnReverseCapped:=TRUE;
		inks.status.Reverse.xOnReverseCapped:=TRUE;

	END_IF
	// reverse flow timer management in cap position. Idle reverse function in GUI
	TON_OnReverseCappedFinished(IN:=inks.status.Reverse.xStartOnReverseCapped, PT:=T#60S);
	IF TON_OnReverseCappedFinished.Q THEN	
		//It stops reverse flow and initialize inputs timers
		inks.status.Reverse.xOnReverseCapped:=FALSE;
		inks.status.Reverse.xStartOnReverseCapped:=FALSE;
		inks.status.Reverse.xStartOnReverseCappedCycle:=FALSE;	
		inks.status.Reverse.xOnReverseAuto:=TRUE;
	END_IF
	
	TON_OnStateReverseFlow(IN:=inks.status.Reverse.xOnReverseAuto);
	
	IF TON_OnStateReverseFlow.Q THEN
		inks.status.Reverse.xOnReverseAuto:=FALSE;
	END_IF
	inks.status.iInkStateSw := inkStateValue(inks.status.iInkState);

	IF inks.parameters.xDebugMode THEN RETURN; END_IF
	
	//Information just if debugging
	IF mode1 THEN 	uiMode1Cycles:=uiMode1Cycles+1; END_IF
	IF mode3 THEN 	uiMode3Cycles:=uiMode3Cycles+1; END_IF
	IF mode4 THEN 	uiMode4Cycles:=uiMode4Cycles+1; END_IF
	IF mode5 THEN 	uiMode5Cycles:=uiMode5Cycles+1; END_IF
	IF mode6 THEN 	uiMode6Cycles:=uiMode6Cycles+1; END_IF
	IF mode9 THEN 	uiMode9Cycles:=uiMode9Cycles+1; END_IF
	IF mode10 THEN 	uiMode10Cycles:=uiMode10Cycles+1; END_IF
	IF mode13 THEN 	uiMode13Cycles:=uiMode13Cycles+1; END_IF
	
END_ACTION

ACTION removeOrders:
	inks.ordersSw.xStartManual :=	FALSE;
	inks.ordersSw.xOrderReverseMan := 			FALSE;
END_ACTION