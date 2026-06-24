
PROGRAM _CYCLIC
	
	SafetyController ACCESS ADR(gSafetyController);
	DataFromSafety ACCESS ADR(gReceivedDataModbSafety);
	
	IF NOT gSafetyController.Parameters.xInstalled THEN
		RETURN;
	END_IF
	
	AssignDataComms;
	
	Alarms;	
	
END_PROGRAM