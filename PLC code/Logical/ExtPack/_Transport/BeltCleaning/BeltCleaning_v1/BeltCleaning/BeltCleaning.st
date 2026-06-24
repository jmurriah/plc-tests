
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	
	//NOZOMITWO-1912
	
	dataBeltClean ACCESS ADR (gBeltClean);
	
	IF NOT dataBeltClean.Parameters.xInstalled THEN
		dataBeltClean.Outputs := ResetOutputs;
		dataBeltClean.Status.State := BCLEAN_NOT_INSTALLED;
		dataBeltClean.Alarm := ResetAlarms;
		dataBeltClean.AlSummary := ResetAlSummary;
		RETURN;		
	END_IF
	
	Alarms;
	AlarmsSummary;
	GeneralLogic;
	
	CASE dataBeltClean.Status.State OF
		BCLEAN_NOT_INSTALLED:
			IF dataBeltClean.Parameters.xInstalled THEN
				dataBeltClean.Status.State := BCLEAN_DISABLED;
			END_IF
		
		BCLEAN_FAULT:
			IF NOT dataBeltClean.AlSummary.xAnyAlarm THEN
				dataBeltClean.Status.State := BCLEAN_DISABLED;
			END_IF
		
		BCLEAN_DISABLED:
			IF dataBeltClean.ParSw.xEnabledByPieces OR dataBeltClean.ParSw.xEnabledByTime THEN
				dataBeltClean.Status.State := BCLEAN_ENABLED;
			ELSIF dataBeltClean.Status.xCleanForced THEN
				dataBeltClean.Status.State := BCLEAN_WAITING_TO_CLEAN;	
			END_IF
		
		BCLEAN_ENABLED:
			IF dataBeltClean.Status.xCleanReqByTime OR dataBeltClean.Status.xCleanReqByPieces THEN
				dataBeltClean.Status.State := BCLEAN_WAITING_SW_CONF;
			ELSIF dataBeltClean.Status.xCleanForced THEN
				dataBeltClean.Status.State := BCLEAN_WAITING_TO_CLEAN;
			ELSIF NOT dataBeltClean.ParSw.xEnabledByPieces AND NOT dataBeltClean.ParSw.xEnabledByTime THEN
				dataBeltClean.Status.State := BCLEAN_DISABLED;
			END_IF
			
		BCLEAN_WAITING_SW_CONF:
			IF dataBeltClean.CommandsSw.xAcceptRequest OR ton_SwCleanRequest.Q THEN
				dataBeltClean.Status.State := BCLEAN_WAITING_TO_CLEAN;
			ELSIF dataBeltClean.CommandsSw.xRefuseRequest THEN
				ResetCountersAndTimers;
				dataBeltClean.Status.State := BCLEAN_DISABLED;
			END_IF
		
		BCLEAN_WAITING_TO_CLEAN:
			IF dataBeltClean.Commands.xAcceptRequest AND dataBeltClean.Parameters.xBeltEmpty THEN
				ResetCountersAndTimers;
				dataBeltClean.Status.State := BCLEAN_CLEANING;
			END_IF
		
		BCLEAN_CLEANING:
			IF ton_Cleaning.Q THEN
				dataBeltClean.Status.State := BCLEAN_DRYING;
			END_IF
		
		BCLEAN_DRYING:
			IF ton_Drying.Q THEN
				dataBeltClean.Status.State := BCLEAN_DISABLED;
			END_IF

	END_CASE
	
	dataBeltClean.Status.xCleanRequested := dataBeltClean.Status.State = BCLEAN_WAITING_TO_CLEAN;
	dataBeltClean.Status.xCleanRequestedSw := dataBeltClean.Status.State = BCLEAN_WAITING_SW_CONF;
	dataBeltClean.Status.xCleaning := dataBeltClean.Status.State = BCLEAN_CLEANING OR dataBeltClean.Status.State = BCLEAN_DRYING;
	
	IF dataBeltClean.Parameters.Mode.xZero THEN
		dataBeltClean.Status.State := BCLEAN_DISABLED;
	ELSIF dataBeltClean.AlSummary.xAlarmStop THEN
		dataBeltClean.Status.State := BCLEAN_FAULT;
	END_IF
	
	Outputs;
	
	dataBeltClean.Commands := ResetCommands;
	dataBeltClean.CommandsSw := ResetCommandsSw;
	
END_PROGRAM
