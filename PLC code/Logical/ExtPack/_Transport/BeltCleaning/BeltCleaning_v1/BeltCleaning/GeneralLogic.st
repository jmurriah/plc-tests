
ACTION GeneralLogic: 
	
	//Cleaning Belt by time. When cleaning, the time is reseted
	IF dataBeltClean.ParSw.xEnabledByTime AND dataBeltClean.Status.State = BCLEAN_ENABLED AND dataBeltClean.Parameters.Mode.xAuto THEN
		xEdge1sec := EDGEPOS(gPLC.xBlk_1s);
		IF dataBeltClean.Parameters.xBeltRunning AND xEdge1sec THEN
			iTimeElapsed := iTimeElapsed + 1;
		END_IF
		IF iTimeElapsed > dataBeltClean.ParSw.iTimeToClean  THEN
			dataBeltClean.Status.xCleanReqByTime := TRUE;
		END_IF
		dataBeltClean.Status.iTimeToClean := dataBeltClean.ParSw.iTimeToClean - iTimeElapsed;
	END_IF
	
	
	// Tiles counter
	IF dataBeltClean.ParSw.xEnabledByPieces AND dataBeltClean.Status.State = BCLEAN_ENABLED AND dataBeltClean.Parameters.Mode.xAuto THEN
		IF EDGEPOS (dataBeltClean.Inputs.xEnteringMedia) THEN
			iPieces := iPieces + 1;
		END_IF
		
		IF iPieces >= dataBeltClean.ParSw.iPiecesToClean THEN
			dataBeltClean.Status.xCleanReqByPieces := TRUE;
		END_IF
		dataBeltClean.Status.iPiecesToClean := dataBeltClean.ParSw.iPiecesToClean - iPieces;
	END_IF	
	
	// Request activation
	dataBeltClean.Status.xCleanForced := dataBeltClean.CommandsSw.xClean;
	
	
	//ResetCountersAndTimers
	IF dataBeltClean.CommandsSw.xResetCounters AND dataBeltClean.Status.State = BCLEAN_DISABLED THEN
		ResetCountersAndTimers;
	END_IF
	
	//Sw request timer
	ton_SwCleanRequest.IN := dataBeltClean.Status.State = BCLEAN_WAITING_SW_CONF;
	ton_SwCleanRequest.PT := T#120s;
	ton_SwCleanRequest();
	
	//Waiting request to clean accepted
	ton_WaitingToCleanState.IN := dataBeltClean.Status.State = BCLEAN_WAITING_TO_CLEAN;
	ton_WaitingToCleanState.PT := T#5m;
	ton_WaitingToCleanState();
	
	//State timers
	ton_Cleaning.IN := dataBeltClean.Status.State = BCLEAN_CLEANING;
	ton_Cleaning.PT :=dataBeltClean.ParSw.tiCleaning;
	ton_Cleaning();
	
	ton_Drying.IN := dataBeltClean.Status.State = BCLEAN_DRYING;
	ton_Drying.PT := dataBeltClean.ParSw.tiDrying;
	ton_Drying();
	
	
	//Delay falling the tray to be sure no water is poured inside the machine
	tofCleaningSystemRise.IN:= dataBeltClean.Status.State = BCLEAN_CLEANING;
	tofCleaningSystemRise.PT:=T#200MS;
	tofCleaningSystemRise();
	
	
	//Delay pneumatic pump to avoid pouring water inside the machine
	tonCleanBeltPump.IN:= dataBeltClean.Status.State = BCLEAN_CLEANING;
	tonCleanBeltPump.PT:=T#900ms;
	tonCleanBeltPump();
	
	

END_ACTION


ACTION ResetCountersAndTimers:
	
	dataBeltClean.Status.iTimeToClean := 0;
	iTimeElapsed := 0;
	dataBeltClean.Status.iPiecesToClean := 0;
	iPieces := 0;
	dataBeltClean.Status.xCleanReqByPieces := FALSE;
	dataBeltClean.Status.xCleanReqByTime := FALSE;
	dataBeltClean.Status.xCleanForced := FALSE;
	
END_ACTION
