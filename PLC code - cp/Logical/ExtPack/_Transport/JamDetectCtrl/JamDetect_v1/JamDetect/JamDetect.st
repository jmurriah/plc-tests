
PROGRAM _CYCLIC
	
	JamDetect ACCESS ADR(gJamDetect[iIndexJam]);
	 
	IF NOT JamDetect.Parameters.xJamEnabled THEN
		JamDetect.Alarms := AlarmsReseted;
		JamDetect.Commands := CommandsReseted;
		
		JamDetect.Status := JAMVIB_NOT_INSTALLED;
		xTestFinished := FALSE;
		
		iIndexJam := iIndexJam + 1;
		RETURN;
	END_IF
	
	(***RESET ALARMS***)
	IF JamDetect.Commands.xReset THEN
		JamDetect.Alarms := AlarmsReseted;
		JamDetect.AlSummary.xAlarmStop := FALSE;
	END_IF
	
	JamDetectCtrl;
	JamAlarmsSound;
	
	iIndexJam := iIndexJam + 1;
	
END_PROGRAM