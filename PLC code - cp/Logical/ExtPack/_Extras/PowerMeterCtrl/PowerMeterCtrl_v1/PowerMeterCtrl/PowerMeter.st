
PROGRAM _CYCLIC
	
	
	
	PowerMeter ACCESS ADR(gPowermeters[iIndexPowerMeter]);
	
	IF NOT PowerMeter.Parameters.xInstalled THEN
		PowerMeter.Alarms := ResetedAlarms;
		RETURN;
	END_IF
	
	AssignDataComms;
	
	Alarms;
	
	//Prepare
	iIndexPowerMeter := iIndexPowerMeter + 1;
	
END_PROGRAM