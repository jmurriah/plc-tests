
PROGRAM _INIT
	NitroState := CURINGNITRO_OFF;	
END_PROGRAM

PROGRAM _CYCLIC

	//References of the program
	dataLed 	ACCESS ADR (gCuringLed[iIndexCuringLed]);
	dataChiller	ACCESS ADR (gChiller[gCuringLed[iIndexCuringLed].Parameters.iChillerIndex]);
	
	dataLed.Status.xCureByStretch := dataLed.Parameters.xCureByStretch;
	dataLed.Status.xOptimizeCuring := dataLed.Parameters.xOptimizeCuring;
	dataLed.Status.xInstalled := dataLed.Parameters.xInstalled;
	dataLed.Status.ChillerState := dataChiller.St.Status;
	
	IF NOT dataLed.Parameters.xInstalled THEN
		ResetAlarms;
		ResetOutputs;
		iIndexCuringLed:= iIndexCuringLed +1;
		RETURN;
	END_IF
	
	//Reset alarms
	IF dataLed.Commands.Reset THEN
		ResetAlarms;
	END_IF
	
	CheckParameters;
	
	StateManager;
	StateNitrogen;

	//////	    CuringByStretch		//////
	//Serial Comms
	xAnyParamChanged.0 := iPreviousWidth <> dataLed.Status.iCuringAreaWidth;
	xAnyParamChanged.1 := iPreviousOffsetRegisterL1 <> dataLed.Status.iCuringAreaOffsetL1;
	xAnyParamChanged.2 := iPreviousOffsetRegisterL2 <> dataLed.Status.iCuringAreaOffsetL2;
	xAnyParamChanged.3 := EDGEPOS(dataLed.Status.xLampsDetected);
	xAnyParamChanged.4 := EDGEPOS(tonLampsVoltageRecovery.Q);
	xBoardPositionChanged := (dataLed.Status.iCuringAreaWidth>=0) AND (xAnyParamChanged > 0);
	
	IF xBoardPositionChanged THEN
		StretchesCalculation; //To execute this action to calculate basic parameters
		EnableLamps;
		
		IF dataLed.Status.xCureByStretch THEN				
			//Calculation of lamps SLM (sections) to be enabled
			IF NOT dataLed.Parameters.xDoubleLine THEN SingleLineCalculation; ELSE DoubleLineCalculation; END_IF
		END_IF
		
		//To save current board position and width values
		MemoBoardParameters;
	END_IF
	
	//To evaluate if detect lamps action must be executed in case curing by stretch is enabled
	IF EDGEPOS(dataLed.Parameters.xCureByStretch) THEN
		//To reset lamp's serial numbers
		FOR iIndexDetectLamps:=1 TO iLampsQuantity DO
			IF (dataLed.Lamp[iIndexDetectLamps].Status.stSerialNumber = '') THEN dataLed.Status.xLampsDetected := FALSE; END_IF
		END_FOR
	END_IF

	DetectLamps;
	IF dataLed.Status.xLampsDetected THEN
		//Curing by stretch
		IF dataLed.Status.xCureByStretch THEN
			//Execute lamp's SLMs config
			ConfigureLamps;
			CheckLampsConfig;
		END_IF

		//Getting useful information from lamps
		IF NOT dataLed.Parameters.xPhysicalTempFeedback THEN
			ReadTemperature;
		END_IF
		
		//ReadUvOnTime;
		
	END_IF

	//Comms management
	CommsManager;
	
	//DELOREAN-1521: To switch on curing subsystems but not active alarms while not enabled
	IF dataLed.Parameters.xEnabled OR xDetectionLampsProcessOn THEN
		Alarms;
	END_IF
	
	//Alarm Sound
	AlarmSound;
	
	//OUTPUTS//
	//Defining setting previous to call action to set intensity
	IF dataLed.Parameters.CuringApplicationType = CURING_APP_WHITE THEN
		rCureBySpeedSlope := rCureBySpeedWhiteSlope;
		rCureBySpeedIntercept := rCureBySpeedWhiteIntercept;
	ELSE
		//[RGP] Pending to consider parameter "Primer" instead of color but till defined, this curing bar will use "Color" information
		rCureBySpeedSlope := rCureBySpeedDefaultSlope;
		rCureBySpeedIntercept := rCureBySpeedDefaultIntercept;
	END_IF
	
	//Setting intensity
	SetLampsIntensity;
	
	
	//Detection state
	dataLed.Status.xLampsDetected := DetectStep = DETECTION_READY;
	
	//Chiller
	dataLed.Signals.Outputs.xRunChiller := dataLed.Commands.RunCuring OR dataLed.Commands.xRunNitrogenFlow;
	
	//Nitrogen
	dataLed.Signals.Outputs.xPowerOnNitrogen := //Manual
												dataLed.Commands.Manual.xNitrogen OR
												//Auto
												dataLed.Commands.xRunNitrogenFlow;
	
	
	//Curing lamp's power supply management
	//DELOREAN-962: QA wants lamps to be powered after some time instead of wait to press reset to remove alarms
	tonPowerOnLamps(IN:=NOT dataLed.Signals.Outputs.xPowerOnLamps, PT:=T#10s);
	IF EDGENEG(dataLed.Status.xCureByStretch) OR (dataLed.Commands.Manual.ResetPSU) OR NOT xPowerOnLamps THEN
		dataLed.Signals.Outputs.xPowerOnLamps := FALSE;
	ELSE
		IF (tonPowerOnLamps.Q) THEN
			dataLed.Signals.Outputs.xPowerOnLamps := TRUE;
		END_IF
	END_IF
	
	
	
	//Copying outputs related to manual commands
	dataLed.Status.ManualCommands.xNitrogen := dataLed.Signals.Outputs.xPowerOnNitrogen;
	
	//Resetting manual commands
	//To reset manual commands when not in manual mode
	IF NOT dataLed.Parameters.Mode.xManual THEN dataLed.Commands.Manual := ResetManCommands; END_IF
	
	//Prepare for the next element
	iIndexCuringLed:= iIndexCuringLed +1;
	
END_PROGRAM


